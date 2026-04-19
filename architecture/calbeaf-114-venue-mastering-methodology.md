# CALBEAF-114 Venue-Mastering Methodology Spec

**Date:** 2026-04-19
**Author:** AIDI
**Purpose:** Define deterministic, never-invent-governed methodology for assigning `venue.masteredCityId` to 1,072 un-mastered venues in TangoTiempoTest
**Input data-shape:** `Collab/reviews/calbeaf-114-data-shape-2026-04-19.{json,md}` (Fulton 2026-04-19T05:36Z)
**Scope:** TEST-only per Toby preapproval 2026-04-19T05:20Z; PROD stay-out hard rail applies
**Governance standing:** never-guess-venue rule, FTD scope-guard, Q1=C dry-run gate

---

## Why this spec exists before code

CALBEAF-113's "100% coverage" framing error surfaced because thresholds were proposed before distribution data existed. This spec inverts that: data-shape first (Fulton 05:36Z), methodology second, thresholds grounded in actual distribution, honest automation ceiling stated upfront.

---

## Priority chain

Applied in strict order per venue. First matching priority wins. Ambiguity at any tier routes to REVIEW rather than lower tier.

### Priority 1 — HIGH confidence: geo-nearest + cityText agrees

**Conditions (ALL required):**
- Venue `geolocation` populated (100% of un-mastered have this)
- Nearest masteredcity (2dsphere `$near` on `venue.geolocation`) is within **5 km**
- Venue `cityText` populated AND normalizes-equal to matched city's `cityName`
  - Normalization: lowercase, trim, strip punctuation, collapse whitespace
  - Match: exact after normalization, OR cityText is a substring of cityName (handles "New York" ⊂ "New York City"), OR cityName is substring of cityText (handles "NYC" situations — reversed)
- No OTHER masteredcity within 5 km with a different cityName (otherwise tie → REVIEW)

**Action:** auto-assign `masteredCityId` to the matched city. HIGH confidence.

### Priority 2 — MEDIUM confidence: geo-nearest + stateText agrees

**Conditions (ALL required):**
- Venue `geolocation` populated
- Nearest masteredcity within **5 km** (same threshold as P1)
- Venue `cityText` is EMPTY, absent, or fails normalization match
- Venue `stateText` populated AND matches the state/division of the matched city (via masteredDivisionId → masteredDivision → stateCode)
- Exactly ONE candidate within 5 km (no ties)

**Action:** auto-assign `masteredCityId`. MEDIUM confidence. Log `confidence: "medium-geo-state"` field on the venue for auditability.

### Priority 3 — MEDIUM confidence: cityText + stateText exact match when geo is imprecise

**Conditions (ALL required):**
- Venue `cityText` populated AND normalizes-equal to exactly ONE masteredcity's `cityName`
- Venue `stateText` populated AND matches that city's state
- Optional: if `geolocation` is available, the matched city's location must be within **25 km** of venue geolocation (sanity check — name+state agree but geo is wildly off = REVIEW)

**Action:** auto-assign `masteredCityId`. MEDIUM confidence. Log `confidence: "medium-name-state"`.

### REVIEW bucket — manual resolution required

Any venue not matching P1, P2, or P3 routes to REVIEW. Specifically:

- **Geo > 5 km from any masteredcity:** no spatial anchor for auto-assignment
- **Geo within 5 km of MULTIPLE candidate cities** with no cityText/stateText disambiguator
- **cityText/stateText contradicts nearest-geo candidate** (different cityName at distance, no clear winner)
- **cityText matches multiple masteredcities** across different states with no stateText disambiguator ("Springfield" — 5+ states)
- **Venue in a city not present in masteredcities corpus** — international venues, small towns, rural venues
- **All text fields empty** (edge case; shouldn't happen per data-shape, but guarded)

**Routing (scope-reduced per Toby 05:44Z):** REVIEW venues flagged on venue doc as `masteringStatus: "review"`. Tool emits a query-list output (CSV / JSON list) for AIDI+Toby eyeball — expected ~150-250 rows, manageable at this scale. **No CalOps admin panel required for v1** — volume is bounded and low-frequency. Manual assignment via mongosh or ad-hoc script when reviewed. Tool does NOT write masteredCityId for REVIEW venues.

---

## Never-invent guards (hard rules)

These override any priority match:

1. **Hard maximum 50 km.** No auto-assignment if nearest masteredcity exceeds 50 km from venue, regardless of other signals. Prevents distant-phantom assignments.

2. **No-overwrite of existing masteredCityId.** Venues already mastered (446 of 1,518) are OUT OF SCOPE. FTD scope-guard. The tool operates only on venues with `masteredCityId: null` / absent.

3. **cityText contradicts geo = REVIEW, never pick one.** If nearest-geo is "Boston MA" but cityText is "Cambridge" (different city adjacent geographically), the mismatch is a data-quality signal. Don't silently pick.

4. **Multi-candidate ties require disambiguator.** Two+ masteredcities within the same radius without a deterministic text disambiguator → REVIEW. Algorithm never arbitrarily picks.

5. **International fallback limited.** 3.3% of masteredcities have countryText populated. For international venues (countryText ≠ US), require stricter geo threshold (**2 km**) due to reduced corpus coverage and higher false-positive risk.

6. **No fabrication of masteredcity docs.** If a venue's cityText names a city NOT in the masteredcities collection, REVIEW — do not auto-create a new masteredcity doc. Creating new mastered records is a separate initiative (needs admin-gated workflow), not this patch.

---

## Automation ceiling — HONEST framing (pending dry-run)

Estimated distribution bounds based on data-shape signals:

**Optimistic upper bound (HIGH + MEDIUM total):** ~75-85% of 1,072 venues auto-resolvable
- 87.5% have cityText (P1 candidate pool)
- 71.3% have stateText (P2 or P3 candidate pool)
- 100% have geolocation (P1/P2 spatial anchor)
- Major US tango cities likely dominate — corpus-match probability is high

**Pessimistic lower bound:** ~50-60% if many venues are in cities not in the 215-city corpus, or if cityText normalization yields many mismatches (e.g., "NYC" vs "New York City" — will fuzzy match catch this?).

**Manual-review residual:** 15-50% of 1,072 = 160-536 venues flagged for CalOps assignment. Dash's admin panel needs to handle at least this volume.

**Coverage language to use with Toby:** "Automated tier reaches X% of un-mastered venues (Y% of total venue corpus). Remaining Z% flagged for manual review in CalOps panel. Once all tiers complete, next `--force-recompute` on events unlocks N country-denorm fills toward the 99.8% goal."

Do NOT promise "100% automated" — repeats CALBEAF-113 narrative error. Do NOT promise 99.8% coverage solely from this patch — that requires both automated + manual tiers to complete.

---

## Implementation contract (for Fulton)

**Tool scope:** `calendar-be-af/scripts/runVenueMasteringPatch.js` (analogous to `runSeriesAsSingletonsPatch.js`)

**Mode:** dry-run default. `--apply` flag gated behind AIDI Q1=C + Quinn clearance (standard chain).

**Required outputs per venue:**
```
{
  venueId, venueName, venueGeolocation, venueCityText, venueStateText,
  proposal: {
    action: "AUTO_HIGH" | "AUTO_MEDIUM_GEOSTATE" | "AUTO_MEDIUM_NAMESTATE" | "REVIEW",
    matchedCityId?: ObjectId,
    matchedCityName?: string,
    matchedCityDistanceKm?: number,
    confidence: "high" | "medium-geo-state" | "medium-name-state" | "review",
    reviewReason?: string
  }
}
```

**Aggregated output:**
- Total venues processed
- Per-priority counts (P1 HIGH / P2 MEDIUM / P3 MEDIUM / REVIEW)
- Review-reason distribution
- Sample 30 rows across each bucket (10 HIGH, 10 MEDIUM combined, 10 REVIEW) for AIDI Q1=C spot-check
- `VENUE_MASTERING_SPEC_VERSION` const (new, separate from SERIES_DETECTION_SPEC_VERSION)

**Schema change required:**
```js
venue.masteringStatus: {
  type: String,
  enum: ["mastered", "review", "unmastered"],
  default: "unmastered"
}
venue.masteringConfidence: {
  type: String,
  enum: ["high", "medium-geo-state", "medium-name-state", "review", null],
  default: null
}
```

**--apply semantics:**
- Only AUTO_HIGH and AUTO_MEDIUM_* actions write `masteredCityId`
- REVIEW actions write `masteringStatus: "review"` (and `masteredCityId` stays null)
- `masteringConfidence` written on all auto-writes for audit trail
- 0 deletions, 0 overwrites of existing mastered venues (FTD scope-guard)

---

## Rollback

Same 2-query pattern as CALBEAF-113:
```js
// Unset masteredCityId on patch-derived assignments
db.venues.updateMany(
  { masteringConfidence: { $in: ["high", "medium-geo-state", "medium-name-state"] } },
  { $unset: { masteredCityId: "", masteringStatus: "", masteringConfidence: "" } }
)
```

~10 min recovery. Standard posture.

---

## Q1=C review protocol

Upon dry-run delivery:
- Sample 30 rows spot-check (10 HIGH, 10 MEDIUM, 10 REVIEW)
- Verify geo-distances match `$near` output
- Verify cityText/stateText normalization is not silently discarding signal
- Verify REVIEW-reason distribution is sensible (not dominated by one oddity)
- Verify 0 already-mastered venues touched (FTD scope-guard honored)
- Verify VENUE_MASTERING_SPEC_VERSION logged
- Check automation ceiling actuals vs estimate — if <50% auto, HOLD and surface to Toby for product decision (scope reduction or methodology relaxation)

---

## Interaction with other initiatives

- **SAS-FTPNTD:** independent. SAS works on events collection; CALBEAF-114 works on venues collection.
- **UT miscategorization (Addition 2):** independent. Category issues are orthogonal to venue-mastering.
- **CALBEAF-113:** complementary. Once CALBEAF-114 auto+manual tiers complete, re-running CALBEAF-113's `--force-recompute` auto-resolves country on events whose venues were newly mastered. No new code required for that step (priority-4 chain already in place per series-detection@1.0.0).

---

## PROD stay-out

Unchanged. TEST-only. PROD application requires separate Toby reauth per hard rail.

---

## Next steps

1. Quinn ratifies methodology (1-2 line review)
2. Fulton implements `runVenueMasteringPatch.js` per implementation contract above
3. Fulton dry-run → produces artifact + sample
4. AIDI Q1=C review per protocol
5. Quinn clearance
6. Fulton `--apply` on TEST
7. Post-apply: re-run CALBEAF-113 `--force-recompute` → auto-resolve country on newly-mastered-venue events
8. Milestone ping to Number2 → Toby with honest automation-ceiling numbers
