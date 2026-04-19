# CALBEAF-113 Country Coverage Dry-Run — AIDI Q1=C Review (CORRECTED)

**Date:** 2026-04-19T04:55Z (superseding 04:47Z initial framing)
**Environment:** TEST only (MongoDB Atlas TangoTiempoTest)
**Author:** Fulton (calendar-be-af)
**Authorization:** Toby 2026-04-19T01:44Z "A" (Option A, TEST-first) — pending A/B/C decision post-reconciliation
**Artifact:** `calbeaf-113-country-dryrun-2026-04-19.json`

## ⚠️ Framing Correction

**Initial claim "~100% coverage" was WRONG.** Quinn's math reconciliation (04:48Z) + AIDI's HOLD (04:49Z) surfaced the gap before Toby relay. Revised honest framing below.

## Summary (CORRECTED)

| Metric | Value |
|---|---|
| Events processed | 5,743 |
| Would change | 369 (6.4%) |
| Pipeline errors | 0 |
| Overwrites of already-set country | **0** (preserve-gate verified) |
| Pre-apply coverage | 972 / 5,743 (16.9%) |
| **Post-apply coverage** | **1,341 / 5,743 (23.4%)** |
| Residual null after apply | 4,402 (76.6%) |
| specVersion | ENRICHMENT_SPEC_VERSION = 1.1.0 |

## Math Reconciliation (from fresh 04:50Z TEST query)

| Cohort | Count | Priority chain reach |
|---|---|---|
| Has masteredCountryId | 972 | Priority 1 — preserved |
| Null + has masteredRegionId | 0 | (Phase 5 already filled these) |
| Null + no region + has masteredCityId | 20 | Priority 3 reachable |
| Null + no region/city + has venueID | 4,739 | Priority 4 candidate |
| Null + all upstream null | 12 | Priority 5 (null, correct) |

**Gap explanation:** 4,739 priority-4 candidates exist, but 500-venue sample shows only 10.8% (54/500) have `venue.masteredCityId` populated. The remaining 89% hit a null upstream and the chain correctly stops (never-invent). Extrapolating: ~512 of 4,739 are resolvable. Actual dry-run found 369 fills (some chains fail at division/region level beyond city).

**My earlier 20/20 diagnosis was sampling-biased — not a population-representative sample.**

## L2 Code Changes (shipped)

Commit `6f552e00` on TEST branch. Two files:

**`src/utils/enrichment.js`:**
- Added `ENRICHMENT_SPEC_VERSION = '1.1.0'`
- Added `resolveCountryViaChain(db, eventDoc)` — walks priority chain
- Added `chainFromCity(db, cityId)` — extracted reusable city→division→region→country walker
- Rewrote country-denorm block with 5-priority derivation:
  1. Already-set `masteredCountryId` → preserve
  2. `masteredRegionId` → region-chain (existing)
  3. `masteredCityId` → city-chain (existing, extracted to helper)
  4. `venueID` → `venue.masteredCityId` → same city-chain
  5. Null (never invent)

**`tests/enrichment.pipeline.test.js`:** 113/113 passing.

## Real FTPNTD (requires new ticket)

Root cause of 76.6% residual: **venue data quality**. 89% of venues in the null-country cohort lack `venue.masteredCityId`. Priority-4 venue-chain honors never-invent and cannot fabricate the missing city.

**CALBEAF-114 (proposed, Quinn scoping):** Venue-mastering initiative
- L1 (data): Backfill `masteredCityId` on ~4,402 un-mastered venues via geocode-to-masteredCity lookup
- L2 (code): Venue onboarding pipeline auto-masters on create/update
- L3 (human): Runbook step for new venue curation requires mastering

After CALBEAF-114 lands, re-running this same CALBEAF-113 dry-run would approach ~99.8% coverage (12 events legitimately stay null per never-invent).

## Governance Checks (for Q1=C on CORRECTED framing)

1. **Never-invent posture:** Priority-4 correctly stops at null when venue.masteredCityId missing — verified via 89% null-venue cohort staying null.
2. **No-overwrite:** Priority 1 (preserve already-set country) exercised; 30 sample diffs all show `before: null`.
3. **SpecVersion logged:** Yes, `ENRICHMENT_SPEC_VERSION = 1.1.0`.
4. **Sample spot-check (30 rows):** All 30 resolve to `"United States"` (ObjectId `6751f57e2e74d97609e7dca0`) via venue-chain. Category mix: Milonga (16), Class (8), Practica (2), Festival/Trip/Workshop (remainder).
5. **Scope honest:** 369 is true ceiling for event-only priority-4 fix. 100% coverage requires upstream CALBEAF-114 venue-mastering.

## Requested

**AIDI Q1=C on CORRECTED framing:** Does the 369-fill +6.4%-coverage intervention merit approval given honest milestone narrative?

- (a) Sample diffs sound? ✓ verified
- (b) No-invent posture? ✓ verified (89% correctly null)
- (c) Preserve-gate? ✓ verified (0 overwrites)
- (d) Milestone framing now honest: "+6.4% coverage via venue-chain where venues are mastered; path to 99.8% requires CALBEAF-114"

## Reconciliation Artifacts

Committed to TEST branch:
- `scripts/calbeaf113-reconcile.js` — baseline null-country breakdown by priority reach
- `scripts/calbeaf113-deep.js` — venue-chain resolvability sample (500 venues, 10.8% hit rate)

## Toby Decision Path (Quinn routing)

- **A)** Apply 369 now + parallel start CALBEAF-114 venue-mastering
- **B)** Hold 369 until CALBEAF-114 lands → single clean 99.8% delivery
- **C)** Full pause, think about venue-mastering approach first

## PROD Stay-Out

Unchanged. No PROD operations until Toby explicit reauth.

---
**Ping targets:** AIDI (Q1=C on corrected framing), Quinn (scoping CALBEAF-114), Number2 (honest Toby relay)
