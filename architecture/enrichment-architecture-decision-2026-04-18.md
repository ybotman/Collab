# Enrichment + DQ Architecture Decision

**Date:** 2026-04-18
**Arbiter:** Quinn (cross-project coordinator)
**Participants:** Fulton (BE-AF), Harvey (intake), Booker (intake), Porter (Mongo loader), AIDI (governance)
**Status:** LOCKED. Endpoint design spec owner = Fulton (EOW draft target).
**Supersedes:** Shared-lib (Option C) approach ratified earlier 2026-04-18 and Q4=C re-vote. The v3 classifier ruleset is unchanged; only its placement-in-architecture changes.
**Related:** `beginner-class-classification-spec.md` (unchanged v3 ruleset; short addendum to land at top, written by AIDI, pointing here).

---

## Decision

**Option D — BE-AF bulk-enrich endpoint.**

`POST /api/events/bulk-enrich` owned by calendar-be-af is the single source of truth for enrichment + data-quality. Porter sends batches (50–200 typical, 500 ceiling); BE-AF runs `runDataQualityPipeline` in-process per event; returns per-event enriched payload + status; Porter bulk-inserts Mongo.

Vote: 5/5 (Fulton, Harvey, Porter, Booker, AIDI). No dissent.

## Why (vs Option C shared-lib)

1. **Drift-via-lib-version-skew is a permanent tax.** C required three intake consumers + BE-AF to stay pinned in lock-step with a versioned lib + fixture-CI. One bad pin = silent divergence.
2. **Scope elasticity.** Classification is one DQ concern; travelWorthy, country denorm, venue matching are others; more will arrive. Under D, adding a DQ check is a BE-AF deploy. Under C, it's three consumer redeploys + version sync.
3. **Centralization without round-trip cost.** Toby's framing: "centralized-is-better, but my brain keeps reaching for local because of back-and-forth." Bulk endpoint resolves the tension — one HTTP call per batch, not per event.
4. **Single operational truth.** No lib-version ≠ runtime-version ambiguity; the running BE-AF deploy IS the ruleset.

## The intake-vs-BE-AF split (architecture contract)

### Local at intake (Harvey + Booker SQLite)

- **Category classification** (`classifyCanonical`) — drives intake-side operational gating: skip-filters, dashboard queries, prep-handoff filtering. Harvey's `skip_class_only`, Booker's `skipped_non_target`. SQLite IS a query surface for intake observability; this stays.
- **Field parsing where raw source text lives:** venue-name + street-address parsing (Harvey from LOCATION field). ~~Country from feed config~~ — REMOVED per Toby 2026-04-18T04:10Z: country is centralized at BE-AF, not distributed at intake (see below).
- **Geocoding** (Nominatim lat/lng, rate-limited, cache local to Booker SQLite).
- **Booker operational-vs-publication split:** Booker keeps local category classification (operational gating for non-TT niches). Booker DROPS local computation of `forBeginners`, `beginnerFriendly`, `travelWorthy` — those become BE-AF's job.

### BE-AF at bulk-enrich (authoritative, publication-facing)

- Classification flags: `forBeginners`, `beginnerFriendly` (v3 ruleset, Collab fixture validates).
- `travelWorthy` (consolidates BE-AF's current half-coverage).
- Venue MATCHING (parsed address → MongoDB `venueID`, `venueGeolocation`, `venueCityName`, `venueTimezone`) — only BE-AF has Mongo access.
- Country resolution when intake left it null.
- Override field initialization (3 `_Override` nulls).
- Date sanity + required-field presence (warn-only).

### Principle

> Local = derive what's cheaply derivable from the source at the point the source text lives.
> BE-AF = all cross-data-store reconciliation + all publication flags that FE/campaigns rely on.

### Harvey write-back loop (unlocked by batching)

Porter's bulk-enrich response includes per-event enriched values. Porter writes-back to Harvey's SQLite (`category_first`, `skip_reason`, etc.) during the load loop. One batch POST → Mongo insert → SQLite sync-back in one pass. Harvey's pre-tag = fast path (scrape time); Porter's write-back = authoritative path (corrects drift at load time). Replaces the originally-proposed reconciliation script.

## Contracts + governance

### Fixture-as-contract

`Collab/fixtures/beginner-class-gold-set.json` validates BOTH Harvey's local category classifier AND BE-AF's enrichment. Drift caught by CI on either repo. Do not fork.

### AIDI's four must-haves (governance)

1. **Tier-2 periodic checker ships WITH v1.** Not a follow-up. Same JIRA ticket as the endpoint. Without Tier-2, Porter's degraded-mode fallback becomes a silent data-quality hole.
2. **Per-event status in bulk response.** `{index, success, event | error}` model. Porter splits ok-enriched vs failed-with-needs-review.
3. **Dry-run gate for v1 backfill.** AIDI + Fulton review dry-run output before `--apply`. Separate one-shot script (`scripts/runDataQualityBackfill.js`) calls the same pipeline.
4. **Never-guess-venue rule.** Unresolved venue → schema null + flag. No fallback invention. Standing AIDI policy; codified here as D's scope grows.

### Degraded-mode story

- Trigger: BE-AF timeout or 5xx on bulk-enrich POST.
- Fallback: Porter inserts raw events with `enrichmentStatus: "pending"` (indexed), no enrichment.
- Recovery: Tier-2 checker (30-min timer) finds pending/null-field rows, calls `runDataQualityPipeline` in-process, updates.
- Observability: degraded-mode rate surfaced as metric (Fulton open-spec item). AIDI monitors as BE-AF health signal.

### Porter refactor scope (5–8 working days, per Porter)

- `insertOne` per row → build enriched-batch → `POST /events/bulk-enrich` → bulk-insert successes + raw-with-`needs_review` for failures.
- HTTP client with retry + timeout + degraded-mode fallback.
- SQLite sync-back from per-event enriched payload (Harvey write-back loop).
- Shared refactor across `load-from-harvey.ts` + `load-from-booker.ts` (most code shared).
- `validateEventForLoad` classifier check retired (redundant); P11/P13 observability canaries kept.

## Downstream ripples

- **Sarah (TIEMPO-405):** UI `forBeginners` toggle gate dependency flips from "shared lib lands" to "bulk-enrich endpoint lands." Same timing shape. TIEMPO-408 `/beginner` subtitle copy patch is independent.
- **Booker CALAI cleanup:** CALAI-XXX stays (remove group-context fallback, essential regardless). CALAI-YYY deferred → contributes to BE-AF pipeline. CALAI-ZZZ dropped. Net: 3 PRs → 1 PR.
- **Harvey reconciliation:** scoped as post-v1 follow-up (AIDI owns ticketing). Not v1-blocking now that write-back loop replaces it.
- **Spec v3 addendum:** AIDI writes 5-line addendum at top of `beginner-class-classification-spec.md` pointing at this doc. Rules unchanged under D.
- **Organizer override flow under D:** unchanged. `forBeginnersOverride` toggle via TT/HJ UI is a regular Events_Update → runs `runDataQualityPipeline` inline → Stage 5 override wins. No special handling.

## Deferred

- Shared-lib location decision (obsolete under D).
- Thread 5 (organizer-unknown attribution for discovered events): sub-initiative on longer clock. `discoveredOrganizer: false → true` is birth-time only, never a downgrade of resolved organizer (AIDI invariant).
- v2 DQ checks: image URL validation, organizer existence/active check, `isDiscovered`/`discoveredFirstDate` consistency, multi-day repeat enforcement.

## Deployment scope — HARD RAIL (Toby, 2026-04-18)

**PROD IS FENCED OFF for this entire initiative until Toby explicitly reauthorizes.**

Toby direct quote: *"don't load this stuff to PROD. to be clear — stay out of PROD."*

- All work lands **DEVL → TEST only**. No PROD deploys. No PROD loads. No PROD schema migrations. No PROD backfill.
- Backout path = revert TEST, never touch PROD.
- Porter `PROD-LOAD-APPID-1` phrase gate remains in force.
- AIDI governance: dry-run review gate (Q1=C) narrows to TEST-scope backfill only; AIDI will NOT sign off any PROD backfill regardless of dry-run outcome until Toby reauth via Number2 path.
- Number2 registered the stay-out at the Telegram gateway — will refuse any PROD-touch request and escalate to Quinn.
- Escalation for genuine need-to-test-in-PROD: persona → Quinn → Number2 → Toby for explicit reauth.

This supersedes the "standard DEVL→TEST→PROD branch strategy" framing. Endpoint spec Phase 7 and all per-persona rollout docs inherit this constraint.

## Schema authority — Harvey owns SQLite column sweep

Arbitration 2026-04-18: Porter does NOT run `ALTER TABLE` on harvester-owned site DBs. Instead:

1. Porter sends Harvey the full column list + types + defaults for the bulk-enrich write-back contract (enrichment_status, for_beginners, beginner_friendly, travel_worthy, last_enriched_at, plus venue/country resolution fields and any others write-back touches).
2. Harvey adds them to `harvester/lib/site-migration.ts::ensureCanonicalSchema` in one commit.
3. Harvey runs one-shot migration over ~40 site DBs + booker DB.
4. Porter's refactor becomes pure INSERT/UPDATE — no ALTER responsibility on harvester-owned DBs.

**Rationale:** preserves Harvey's single-schema-authority invariant; prevents the "two authorities" drift that would emerge if Porter also did ALTERs; cheaper total (1-2hr vs per-DB sweep); respects code-boundary lane convention (Porter does not edit harvester/ directly).

## Next steps

1. **Fulton** — draft endpoint + Tier-2 design spec doc by EOW 2026-04-18. Team reviews asynchronously. *[Done — v1.2 at Collab/architecture/bulk-enrich-endpoint-spec.md, AIDI approved 2026-04-18.]*
2. **AIDI** — write spec-v3 addendum pointing at this doc (this file is the stable path).
3. **Quinn** — update `project_beginner_classification.md` memory; ping Sarah with the architecture flip (minor impact on TIEMPO-405 dependency wording); hold convergence-patrol until endpoint spec returns for team review. *[Done 2026-04-18.]*
4. **Post spec-lock** — new JIRA ticket for endpoint + Tier-2 (single ticket, per AIDI must-have #1). *[**CALBEAF-110** opened 2026-04-18 — https://hdtsllc.atlassian.net/browse/CALBEAF-110 — Story, High priority, "Bulk-enrich endpoint and Tier-2 periodic checker (Option D enrichment architecture)"; Porter opens sibling ticket in his own project.]*

## Sign-off board (2026-04-18)

| Persona | Status |
|---|---|
| Quinn | ✅ sign-off on synthesis + spec v1.2 |
| AIDI | ✅ sign-off on spec v1.2; 3-state enum call (`complete`/`pending`/`failed`, drop `deferred`); §3/§6 contradiction flagged for schema PR; Phase 5 backfill = full-history scan |
| Porter | ✅ sign-off on spec v1.2; 3 non-blocker notes folded into v1.2 (4xx≠degraded, 24h lookback, appId TODO) |
| Fulton | ✅ author |
| Harvey | ✅ implicit (no new asks; owns SQLite schema sweep per arbitration above) |
| Booker | ✅ implicit (no new asks; CALAI scope shrink ack'd) |

Phase 1 UNBLOCKED. Fulton → CALBEAF-XXX + `enrichment.js` finalize. Harvey → site-migration.ts column add + one-shot. Porter → column list to Harvey + bulk-enrich-client scaffolding (parallel).
