# BE-AF Bulk-Enrich Endpoint — Design Spec

**Status:** Draft v1 — for async team review
**Author:** Fulton (calendar-be-af)
**Date:** 2026-04-18
**Convergence ref:** Quinn's "Architecture LOCKED: D" message 2026-04-18
**Vote:** 5/5 — Fulton, Harvey, Porter, Booker, AIDI
**Source spec:** `Collab/architecture/beginner-class-classification-spec.md` (v3, signed off)
**Ticket:** TBD (new CALBEAF-XXX — will open after spec review)

---

## 1. Endpoint contract

```
POST /api/events/bulk-enrich
```

**Auth:** Same as existing BE-AF mutation surface (Firebase token, role ≥ RegionalAdmin OR internal service token). Porter is the sole external consumer in v1; BE-AF Events_Create/Update calls the underlying function in-process and skips HTTP.

**Request body:**
```json
{
  "batchId": "porter-20260418-031200-7a3b",
  "options": {
    "dryRun": false,
    "forceRecompute": false
  },
  "events": [
    { /* full event document, pre-insert */ },
    { /* ... */ }
  ]
}
```

- `batchId`: caller-supplied correlation ID. Echoed in response, propagated to logs/metrics. Used by Tier-2 periodic checker when picking up degraded rows. Format: `{caller}-{ts}-{rand}`.
- `options.dryRun`: when `true`, returns proposed-vs-current diff per event without persistence. Used for AIDI+Fulton review gate before backfill `--apply`.
- `options.forceRecompute`: when `true`, ignores existing `forBeginners`/`beginnerFriendly`/`travelWorthy` and recomputes. Default `false` (override-aware "only fire when undefined" gate). Used for rule-change re-classification runs.
- `events[]`: array of complete event documents (Porter's pre-insert payloads). No partial updates.

**Limits:**
- Soft target: 50–200 events per batch (Porter's natural batch size)
- Hard ceiling: **500 events per request**
- Above 500: HTTP 413 Payload Too Large; caller paginates

**Response 200 OK (sync):**
```json
{
  "batchId": "porter-20260418-031200-7a3b",
  "enrichedCount": 487,
  "failedCount": 13,
  "durationMs": 412,
  "events": [
    {
      "index": 0,
      "status": "enriched",
      "event": { /* enriched doc */ },
      "report": {
        "actions": [
          { "field": "forBeginners", "source": "classifier", "value": true },
          { "field": "travelWorthy", "source": "computed", "value": false },
          { "field": "masteredCountryId", "source": "computed", "value": "..." }
        ]
      }
    },
    {
      "index": 1,
      "status": "needs_review",
      "event": { /* original event with enrichmentStatus="failed" */ },
      "error": "validation: missing categoryFirstId",
      "report": { "actions": [], "skipped": [...] }
    }
  ]
}
```

Per-event `status` values: `"enriched"` | `"needs_review"` | `"skipped_already_enriched"`.

---

## 2. Sync vs async

**Sync.** Pipeline is regex + a handful of cached DB lookups (categories, regions, venues — LRU per-request). Expected p95 < 1s for 500 events. 30s function timeout gives 60× headroom.

Async (job-id + poll) is overkill for v1 and adds state to manage. Revisit if:
- Batch ceiling needs to grow above 1000
- Venue matching adds external geocoding calls (currently DB-only)
- Backfill mode wants progress streaming

---

## 3. Partial-failure handling

**Never all-or-nothing.** 207-style mixed-success: HTTP 200 with per-event status array.

Whole-batch failure (HTTP 4xx/5xx, no body):
- Auth failure
- Malformed JSON / payload too large
- BE-AF infrastructure failure (DB unavailable)

Per-event failure (HTTP 200 with `status: "needs_review"`):
- Missing required field (appId, title, categoryFirstId)
- Date sanity violation (endDate < startDate, duration > 7d)
- Venue ID present but not resolvable
- Classifier exception (regex bomb, unexpected input shape)

**Caller contract (Porter):**
- Read response; `enriched` events go to bulk insert
- `needs_review` events go to bulk insert WITH `enrichmentStatus="failed"` flag (NOT skipped — visibility matters per Booker's "don't weaponize FB noise into pipeline blockage")
- Error counts above threshold (e.g., >10%) → page operator

---

## 4. runDataQualityPipeline scope (v1)

The single function called by both the bulk endpoint and BE-AF's Events_Create/Update.

**In-scope (v1):**
| Stage | Field(s) | Source |
|---|---|---|
| Niche guard | (gate) | `appId === '1'` |
| Beginner classification | `forBeginners`, `beginnerFriendly` | `classifyBeginner(title, desc)` + category gate (`Class`+`Workshop`+`DayWorkshop`+`Festival`) |
| TravelWorthy | `travelWorthy` | duration + category exclusion |
| Country denorm | `masteredCountryId`, `masteredCountryName` | `masteredRegionId` chain |
| Venue resolution | `venueGeolocation`, `venueCityName`, `venueTimezone` | `venueID` lookup |
| Override field init | `*Override` fields | `null` if undefined |
| Date sanity | (warn-only) | `endDate >= startDate`, `duration <= 7d` |
| Required field presence | (warn-only) | `appId`, `title`, `ownerOrganizerID`, `startDate`, `endDate` |

**Always-applied (regardless of stage):**
- Override resolution (`*Override` wins over computed)
- Superset (`forBeginners=true ⇒ beginnerFriendly=true`)
- Niche guard (skip classifier for non-Tango appIds)
- Category gate (force `forBeginners=false`, `beginnerFriendly=false` for ineligible categories)

**Out of scope (v2+):**
- Image URL / Cloudflare existence check (too slow for bulk)
- Organizer existence/active validation
- isDiscovered / discoveredFirstDate consistency
- Multi-day repeat enforcement (already in Events.js via TIEMPO-362; leave in place)
- Advanced text NLP (Spanish/Italian beginner-class phrases beyond current prophylactic regex)

---

## 5. Tier-2 periodic checker design

**Purpose under D:** Degraded-mode safety net. Catches rows that bypassed bulk-enrich (Porter fallback, external writes, rule-change re-classification).

**Implementation:**
- New Azure Function: `DQ_PeriodicChecker.js`
- Trigger: timer, every **30 minutes** (Porter's "≤hourly" tolerance, with headroom)
- Query (indexed):
  ```js
  events.find({
    appId: '1',
    enrichmentStatus: { $in: ['pending', 'failed'] },
    updatedAt: { $gte: new Date(Date.now() - 4 * 3600 * 1000) }  // last 4h
  }).limit(200)
  ```
- For each row: call `runDataQualityPipeline(event, db)` (no `forceRecompute`)
- Update with computed fields + flip `enrichmentStatus` to `"complete"` if successful
- Bulk update via `bulkWrite` ops array (one op per event)
- Emit metrics:
  - `dq_checker.events_scanned`
  - `dq_checker.events_enriched`
  - `dq_checker.events_still_failing`
  - `dq_checker.duration_ms`

**Steady state:** `events_enriched` should trend to ~0 once D ships and Porter goes through bulk-enrich primary path. Sustained non-zero = degraded-mode rate worth investigating.

**Backfill mode** is separate one-shot script (`scripts/runDataQualityBackfill.js`) calling the same `runDataQualityPipeline`, dry-run gated, AIDI Q1=C governance.

---

## 6. Schema changes

**New field on `events`:**
```js
enrichmentStatus: {
  type: String,
  enum: ['complete', 'pending', 'failed'],
  default: 'pending',  // for new inserts pre-enrichment
  index: true          // composite index w/ appId + updatedAt
}
```

States:
- `"complete"` — runDataQualityPipeline ran successfully, all in-scope fields populated (or correctly null)
- `"pending"` — inserted by Porter degraded-mode fallback; awaiting Tier-2 pickup
- `"failed"` — pipeline ran but returned `needs_review` (validation/data-shape failure); needs human review or schema fix

**Indexes:**
```js
{ appId: 1, enrichmentStatus: 1, updatedAt: -1 }  // Tier-2 query
```

**Migration:**
- New field defaults to `"complete"` on existing populated rows (assume backfill catches gaps)
- Backfill script sets `"complete"` after successful enrichment, `"failed"` if validation issue
- No data loss; additive only

---

## 7. Auth / rate-limiting

**v1:**
- Same Firebase token + role-check as Events_Create/Update
- Porter uses an internal service-token role (`ServicePorter`) — bypasses normal user-RBAC
- No rate-limiting on Porter (trusted internal caller)
- External callers: no public access (endpoint internal-only)

**v2 if external consumers appear:**
- Per-tenant rate limit (e.g., 10 batches/minute per token)
- API-key-based auth as alternative to Firebase

---

## 8. Dry-run mechanics

`POST /api/events/bulk-enrich` with `options.dryRun=true`:
- Function runs full pipeline in-memory
- NO writes to DB
- Response includes per-event `report.actions` showing what WOULD change
- Response field `dryRun: true` echoed in result
- Used by:
  - AIDI+Fulton review gate before backfill `--apply`
  - Porter for "what would this batch produce?" sanity checks
  - Spec rule changes — run TEST corpus dry-run, eyeball deltas, then ship

**Backfill script wraps the endpoint:**
- `node scripts/runDataQualityBackfill.js --dry-run` — calls bulk-enrich with `dryRun=true`, prints summary + diff to stdout
- `node scripts/runDataQualityBackfill.js --apply` — calls without dryRun; requires AIDI sign-off comment in commit history

---

## 9. Porter degraded-mode contract

**Triggers (Porter switches to degraded fallback):**
- HTTP 5xx from BE-AF
- Connection timeout (>10s)
- Network error (DNS, refused, etc.)

**Degraded path:**
- Porter reverts to raw `insertOne`/bulk insert
- Sets `enrichmentStatus: "pending"` on every degraded-mode insert
- Logs the batchId + the trigger reason
- Continues processing — does NOT fail the load

**Recovery:**
- Tier-2 periodic checker (30 min) picks up `enrichmentStatus: "pending"` rows
- Runs `runDataQualityPipeline` in-process (no API call)
- Flips `enrichmentStatus` to `"complete"` (or `"failed"` if validation)

**Observability:**
- Porter logs degraded-mode rate per batch
- BE-AF Application Insights metric: `bulk_enrich.error_rate` (alert at >5%)
- Tier-2 metric: `dq_checker.degraded_recoveries` (events that came in pending and got fixed)

---

## 10. Observability — batch_id propagation

| Hop | Source | Logs |
|---|---|---|
| Porter intake | Porter generates `batchId` | `porter.batch_start` with batchId, source, count |
| Bulk-enrich call | Porter → BE-AF | Porter logs request; BE-AF logs receipt with same batchId |
| BE-AF processing | per-event | `bulk_enrich.event_processed` with batchId, event idx, status |
| Porter insert | post-response | `porter.batch_complete` with batchId, enriched_count, needs_review_count |
| Tier-2 pickup | when degraded rows handled | `dq_checker.batch_recovery` with batchId, recovered_count |

`updateProcessReason` field on each event holds the trail (e.g., `"bulk_enrich_v1:porter-20260418-031200-7a3b"`).

**Metrics to publish (Application Insights):**
- `bulk_enrich.requests_total`
- `bulk_enrich.batch_size_p50/p95`
- `bulk_enrich.duration_ms_p50/p95`
- `bulk_enrich.events_enriched`
- `bulk_enrich.events_failed`
- `bulk_enrich.error_rate` (5xx / total)
- `dq_checker.run_count`
- `dq_checker.recoveries_per_run`

---

## Open questions for team

1. **`enrichmentStatus` field naming** — proposed values `complete`/`pending`/`failed`. AIDI: any objection or preferred enum?
2. **Tier-2 lookback window** — 4h proposed. If Porter degraded-mode is rare (expected), 24h might be safer. Porter: thoughts on what window catches realistic outages?
3. **Force-recompute trigger** — for rule changes, who calls the bulk-enrich with `forceRecompute=true`? Manual script run by AIDI? Scheduled? (Lean: manual, AIDI-gated.)
4. **Deletion of stale `enrichmentDeferred` flag** — if anyone is using a similar pre-existing flag, please flag for cleanup.
5. **`runDataQualityPipeline` location** — `src/utils/dataQuality.js` (current draft) or somewhere more discoverable like `src/lib/enrichment.js`? Naming bikeshed; not blocking.

---

## Implementation phases (Fulton's plan)

| Phase | Deliverable | Gate |
|---|---|---|
| 1 | `runDataQualityPipeline` lib (current local draft) — finalize, unit tests against canonical fixture | Quinn lock |
| 2 | Bulk-enrich endpoint (Events_BulkEnrich.js) | Spec sign-off |
| 3 | `enrichmentStatus` schema field + index migration | Spec sign-off |
| 4 | Tier-2 DQ_PeriodicChecker function | Endpoint live on TEST |
| 5 | Backfill script (dry-run + apply gates) | AIDI Q1=C review |
| 6 | Wire Events_Create/Update to call lib in-process (replace existing classifyAndEnrichEvent) | Endpoint stable on TEST |
| 7 | Deploy DEVL → TEST → PROD per branch strategy | Standard CR |

---

## What this spec does NOT cover

- Porter's refactor (insertOne → bulk-enrich call). Porter's plate; Quinn coordinates.
- Harvey/Booker's intake-side classification responsibilities — locked in Quinn's contract (this doc is BE-AF-side only).
- Sarah's UI category gate (TIEMPO-405) — orthogonal, unaffected by D vs C.
- TIEMPO/CALOPS frontend changes for `enrichmentStatus` display — out of scope; coordinator can route if frontends want to show "pending" state.

---

## Sign-offs needed

| Persona | Concern |
|---|---|
| Quinn | Architecture coherence + cross-team coordination |
| AIDI | Governance items: Tier-2 ships v1, dry-run gate, never-guess-venue rule, per-event status |
| Porter | Endpoint contract, batch size, degraded-mode trigger conditions, observability batch_id propagation |
| Harvey / Booker | (No new asks — locked at intake-side per Quinn's contract) |

Reply via hub. Will iterate on this doc until sign-off. Once locked, open new CALBEAF JIRA ticket and begin Phase 1.

— Fulton
