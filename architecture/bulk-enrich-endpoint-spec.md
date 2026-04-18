# BE-AF Bulk-Enrich Endpoint — Design Spec

**Status:** v1.5 — §7 service-to-service auth (Porter) section added per Quinn arbitration 2026-04-18
**Author:** Fulton (calendar-be-af)
**Date:** 2026-04-18
**Convergence ref:** Quinn's "Architecture LOCKED: D" message 2026-04-18
**Decision record:** `Collab/architecture/enrichment-architecture-decision-2026-04-18.md`
**Vote:** 5/5 — Fulton, Harvey, Porter, Booker, AIDI
**Source spec:** `Collab/architecture/beginner-class-classification-spec.md` (v3, signed off)
**Ticket:** **CALBEAF-110** (https://hdtsllc.atlassian.net/browse/CALBEAF-110) — single ticket per Quinn (endpoint + Tier-2 + schema + metrics; do NOT split)

---

## 🚧 PROD STAY-OUT — HARD RAIL

Toby 2026-04-18 (relayed via Porter): **"don't load this stuff to PROD. to be clear — stay out of PROD."**

**Standing order for the entire D-architecture rollout:**
- All work lands **DEVL → TEST only**
- NO PROD deploys of calendar-be-af code for this initiative
- NO PROD loads from Porter (PROD-LOAD-APPID-1 phrase gate remains in force)
- NO PROD schema migrations — `enrichmentStatus` field + index land on TEST only
- NO PROD backfill — dry-run + `--apply` are TEST-scope; AIDI Q1=C dry-run gate applies to TEST
- Backout path = revert TEST, never touch PROD
- Reauthorization required from Toby explicitly (escalation: Quinn → number2 → Toby)

This supersedes any "DEVL→TEST→PROD standard branch strategy" framing in earlier sign-off notes. PROD is fenced off until explicitly reauthorized.

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
| Country denorm (AUTHORITATIVE — Toby 2026-04-18 clarification via Number2) | `masteredCountryId`, `masteredCountryName` | `masteredRegionId` chain. **BE-AF is now sole authority for country resolution; intake-side country derivation (Harvey from feed config) is REMOVED — BE-AF computes for ALL events regardless of source.** |
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
- Query — uses BOTH `enrichmentStatus` AND field-nullity (Quinn clarification: status answers "why", nullity answers "what's missing"):
  ```js
  events.find({
    appId: '1',
    updatedAt: { $gte: new Date(Date.now() - 24 * 3600 * 1000) },  // last 24h (Quinn lean)
    $or: [
      { enrichmentStatus: { $ne: 'complete' } },
      { forBeginners: null },
      { beginnerFriendly: null },
      { travelWorthy: null },
      { masteredCountryId: null }
    ]
  }).limit(200)
  ```
  24h lookback (not 4h) covers realistic outage shapes — overnight Azure incidents, weekend deploys, multi-hour issues. Scan cost bounded by `limit 200`.

  **TODO (post-v1):** `appId: '1'` is hardcoded for Tango-only launch. When HJ/NTTT/etc. opt in to enrichment, change to `appId: { $in: [...allActiveNiches] }`. Per Porter sign-off — flagged to prevent silent bug.
- For each row: call `runDataQualityPipeline(event, db)` (no `forceRecompute`)
- Update with computed fields + flip `enrichmentStatus` to `"complete"` if successful
- Bulk update via `bulkWrite` ops array (one op per event)
- Emit metrics (AIDI must-have #1 — degraded-mode rate visibility):
  - `dq_checker.events_scanned`
  - `dq_checker.events_enriched`
  - `dq_checker.events_still_failing`
  - `dq_checker.degraded_mode_rate` — % of recent inserts that hit `pending` status (i.e., Porter degraded-mode fallback rate)
  - `dq_checker.duration_ms`

**SHIP-GATE:** Tier-2 ships in v1, NOT a follow-up. Single JIRA ticket covers endpoint + Tier-2 + schema + metrics. Per AIDI must-have #1 — without Tier-2, degraded-mode insertions sit invisibly and rot.

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

States (AIDI 2026-04-18 governance call: 3 states; `deferred` dropped — no distinct producer in v1, additive later if real transient-retry case emerges):
- `"complete"` — runDataQualityPipeline ran successfully, all in-scope fields populated (or correctly null)
- `"pending"` — inserted by Porter degraded-mode fallback; awaiting Tier-2 pickup
- `"failed"` — pipeline ran but returned `needs_review` (validation/data-shape failure) OR partial-failure case from §3; needs human review or schema fix

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
- Same `firebaseAuth` middleware as Events_Create/Update — validates Firebase ID token via Bearer header
- Porter authenticates via Firebase service account (Quinn arbitration 2026-04-18, Option 2 LOCKED)
- No rate-limiting on Porter (trusted internal caller)
- External callers: no public access (endpoint internal-only)

### Service-to-service auth for Porter (Quinn arbitration 2026-04-18)

**Pattern:** Firebase service account JSON → custom token → exchange for ID token → Bearer header to BE-AF.

**Why service account, not manual token mint:**
- Firebase ID tokens expire at 1h; manual mint+drop doesn't scale
- Service account = standard Firebase pattern for service-to-service auth
- Rotation-friendly; no human-in-loop for token refresh

**Lane placement:**
- **Fulton owns:** minting the TEST Firebase service account (`service-porter@tangotiempo-257ff.iam.gserviceaccount.com`); managing credential lifecycle; rotation policy
- **Porter consumes:** via env var `PORTER_SA_KEY_PATH` pointing at a local JSON file. Programmatic flow:
  1. Load SA JSON via `admin.credential.cert(saJson)`
  2. Mint custom token: `admin.auth().createCustomToken('service-porter')`
  3. Exchange for ID token via Identity Toolkit REST: `POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=<WEB_API_KEY>`
  4. Cache ID token; refresh 5 min before 1h expiry
- **Credential transfer:** out-of-band ONLY. Never via hub (no secrets in hub channel). Local file drop at a path Porter can read (e.g., `~/.credentials/service-porter-test.json`, `chmod 600`); path communicated via hub (path is not a secret), file content never transmitted electronically to other personas.

**Service account scope (TEST only):**
- Identity: `service-porter@tangotiempo-257ff.iam.gserviceaccount.com`
- Firebase project: `tangotiempo-257ff` (TangoTiempoTest)
- Required IAM roles: NONE (custom token minting works for any service account in the project; the Admin SDK call uses the SA's identity, not its IAM permissions)
- CAN do: authenticate to BE-AF bulk-enrich endpoint via custom token → ID token flow
- CANNOT do: anything outside Firebase Auth (no Firestore, no Storage, no Realtime DB roles granted)
- PROD-scoped credential: explicitly NOT part of v1 work per PROD STAY-OUT

**Rotation guidance:**
- TEST credential: rotate every 90 days (manual)
- Compromise response: revoke key in Firebase Console → IAM → Service Accounts → Keys; mint new key; deliver to Porter out-of-band; Porter updates `PORTER_SA_KEY_PATH`
- No automated rotation in v1 (defer to ops maturity later)

**v2 if external consumers appear:**
- Per-tenant rate limit (e.g., 10 batches/minute per token)
- API-key-based auth as alternative to Firebase
- Automated key rotation via secrets manager

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
- Connection timeout (>30s) — matches BE-AF server-side Azure Functions timeout. Porter `DEGRADED_TIMEOUT_MS=30000`.
- Network error (DNS, refused, etc.)

**NOT triggers (per Porter sign-off — fail loud, don't silently fall through):**
- HTTP 4xx errors (malformed payload, oversized batch, auth failure) — Porter surfaces error for operator fix, does NOT degrade-mode insert. 4xx is caller's bug, not a BE-AF outage.

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

## Open questions — RESOLVED

1. **`enrichmentStatus` enum** — RESOLVED: **3 states** per AIDI 2026-04-18 governance call. `deferred` dropped (no v1 producer path, additive later if a real transient-retry case emerges). Quinn confirmed alignment.
2. **Tier-2 lookback window** — Quinn: **24h**, not 4h. Limit 200 bounds scan cost; 24h covers overnight outages. Updated.
3. **Force-recompute trigger** — Quinn: **manual, AIDI-gated** via `scripts/runDataQualityBackfill.js --force-recompute`. Same Q1=C sign-off as backfill apply. Never scheduled.
4. **Stale flag cleanup** — Quinn: nothing known on coordination side. Schema PR will grep for leftover refs.
5. **Function location** — Quinn lean: `src/utils/enrichment.js` (function does more than DQ — classification, denorm, venue resolution, DQ warnings). Renaming local draft from `dataQuality.js` to `enrichment.js`.

---

## Implementation phases (Fulton's plan)

| Phase | Deliverable | Gate |
|---|---|---|
| 1 | `runDataQualityPipeline` lib (current local draft) — finalize, unit tests against canonical fixture | Quinn lock ✓ |
| 2 | Bulk-enrich endpoint (Events_BulkEnrich.js) | Spec sign-off ✓ |
| 3 | `enrichmentStatus` schema field + index migration (TEST only) | Spec sign-off ✓ |
| 4 | Tier-2 DQ_PeriodicChecker function (ships v1 per AIDI must-have #1) | Endpoint live on TEST |
| 5 | Backfill script (dry-run + apply gates) — **FULL-HISTORY SCAN** (not 24h-bounded; per AIDI migration nudge — overwrites existing rows defaulted to `complete` if classification missing) | AIDI Q1=C review |
| 6 | Wire Events_Create/Update to call lib in-process (replace existing classifyAndEnrichEvent) | Endpoint stable on TEST |
| 7 | Deploy DEVL → **TEST, STOP** (per Toby PROD STAY-OUT 2026-04-18). NO PROD until explicit reauthorization. | Standard CR for DEVL→TEST only |

---

## Locked contracts (do not weaken in future optimization)

**A. Per-event response payload IS the Harvey write-back contract.** The bulk-enrich response must include the full enriched event document per row (`event: {...enriched}` in §1's response schema), not just status/error. Porter relays this back to Harvey's SQLite so Harvey's intake corpus stays in sync with Mongo's enrichment. **Future optimizations that shrink the response payload to status-only will silently break Harvey's reconciliation — coordinate with Harvey before any such change.**

**B. Porter writes `enrichmentStatus="failed"` events back to Harvey's SQLite.** Per §3 partial-failure: events that come back with `status: needs_review` are inserted to Mongo with `enrichmentStatus="failed"`. Porter ALSO write-backs the failed-status to Harvey's intake row (so Harvey's dashboards see "this row was rejected at BE-AF"). Locked into Porter's spec; flagged here so it inherits cleanly.

## What this spec does NOT cover

- Porter's refactor (insertOne → bulk-enrich call). Porter's plate; Quinn coordinates. (Porter approved spec 2026-04-18; Porter branch `porter/bulk-enrich-integration` planned.)
- Harvey/Booker's intake-side classification responsibilities — locked in Quinn's contract (this doc is BE-AF-side only).
- Sarah's UI category gate (TIEMPO-405) — orthogonal, unaffected by D vs C.
- TIEMPO/CALOPS frontend changes for `enrichmentStatus` display — out of scope; coordinator can route if frontends want to show "pending" state.

---

## Sign-offs

| Persona | Concern | Status |
|---|---|---|
| Quinn | Architecture coherence + cross-team coordination | ✅ APPROVED 2026-04-18 |
| Porter | Endpoint contract, batch size, degraded-mode triggers, observability batch_id | ✅ APPROVED 2026-04-18 (3 minor notes folded — 4xx exclusion, 24h lookback, niche TODO) |
| AIDI | Governance: Tier-2 ships v1, dry-run gate, never-guess-venue, per-event status, enum naming, degraded-mode metric | ✅ APPROVED 2026-04-18 (3-state enum call; Phase 5 full-history scan nudge; §3/§6 contradiction noted — fixed in v1.3) |
| Harvey / Booker | (No new asks — locked at intake-side per Quinn's contract) | ✅ Implicit (covered in convergence) |

Once AIDI signs off (or revises the 4-state enum + any other governance points), open single CALBEAF JIRA ticket per Quinn's clarification (endpoint + Tier-2 + schema + metrics — DO NOT split) and begin Phase 1.

— Fulton
