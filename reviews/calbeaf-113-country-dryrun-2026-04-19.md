# CALBEAF-113 Country 100% Dry-Run — AIDI Q1=C Review

**Date:** 2026-04-19T04:46Z
**Environment:** TEST only (MongoDB Atlas TangoTiempoTest)
**Author:** Fulton (calendar-be-af)
**Authorization:** Toby 2026-04-19T01:44Z "A" (Option A, TEST-first)
**Artifact:** `calbeaf-113-country-dryrun-2026-04-19.json`

## Summary

| Metric | Value |
|---|---|
| Events processed | 5,743 |
| Would change | 369 (6.4%) |
| Pipeline errors | 0 |
| Overwrites of already-set country | **0** (preserve gate verified) |
| masteredCountryId fills | 369 |
| masteredCountryName fills | 54 |
| specVersion | ENRICHMENT_SPEC_VERSION = 1.1.0 |

**Note on ID vs Name count divergence (369 vs 54):** 315 events already had masteredCountryName populated (likely "United States") with masteredCountryId = null — partial-fill data state. Priority-4 venue-chain sets both unconditionally; the 54 name-flips represent cases where name was also null. 315 name-writes were no-ops (already equal to chain-derived value). No name overwrites observed across 30 sample diffs.

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

**`tests/enrichment.pipeline.test.js`:** 113/113 passing. Two existing tests updated for priority-1-preserves behavior. One new test: `"CALBEAF-113 Priority 4 venue-chain fallback → country resolved from venue.masteredCityId"`.

## Governance Checks (for Q1=C)

1. **Never-invent posture:** Events with no venueID AND no city/region stay `null`. The 369 flips ALL have venueID → venue.masteredCityId resolving upstream.
2. **No-overwrite:** Priority 1 (preserve already-set country) was exercised; 30 sample diffs all show `before: null`.
3. **SpecVersion logged:** Yes, `ENRICHMENT_SPEC_VERSION` exported and ready for pipeline-drift detection.
4. **Sample spot-check (30 rows):** All resolve to `"United States"` (ObjectId `6751f57e2e74d97609e7dca0`) via venue-chain. Category mix: Milonga (16), Class (8), Practica (2), Festival/Trip/Workshop (remainder of 30).

## Per-Category Breakdown

| Category | Total | Changed | % |
|---|---|---|---|
| OTHER | 68 | 68 | 100% |
| Milonga | 2,862 | 198 | 6.9% |
| Trip | 9 | 4 | 44.4% |
| Marathon | 11 | 3 | 27.3% |
| UNKNOWN | 40 | 10 | 25% |
| Class | 406 | 21 | 5.2% |
| Workshop | 120 | 4 | 3.3% |
| Festival | 33 | 2 | 6.1% |
| Practica | 2,163 | 59 | 2.7% |
| (unchanged categories omitted) |

OTHER 100% change is notable — all 68 are events without proper categorization that also lack region/city denorm. Venue-chain resolves them cleanly.

## Requested

AIDI Q1=C review to verify:
- (a) sample-diff derivations look sound (venue-chain walks correctly)
- (b) no fabrication risk — venue-chain → `null` when venue lookup misses
- (c) preserve-gate verified in samples
- (d) 54 name-flip / 315 name-noop split is acceptable (or request additional verification)

Upon Q1=C ✅ → Quinn clearance → Fulton `--apply` on TEST (same command, `--apply` flag).

## PROD Stay-Out

Unchanged. Code ships to PROD via eventual P-A. Data backfill naturally achieves 100% on PROD via P-B per Quinn's folded plan.

---
**Ping targets:** AIDI (Q1=C review), Quinn (clearance gate), Number2 (Toby milestone visibility)
