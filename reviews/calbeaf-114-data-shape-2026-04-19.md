# CALBEAF-114 Venue Data-Shape Summary — AIDI Methodology Input

**Date:** 2026-04-19T05:36Z
**Environment:** TangoTiempoTest (appId=1)
**Author:** Fulton (calendar-be-af)
**Purpose:** Data distribution input for AIDI's venue-mastering methodology spec
**Artifact:** `calbeaf-114-data-shape-2026-04-19.json`

## Key Corrections vs Earlier Estimates

- Total TangoTiempoTest venues: **1,518** (NOT 4,402 — prior estimate conflated "distinct venueIDs in events" with "venue documents"; most venueID strings in events map to same-or-fewer venue docs)
- Un-mastered venues: **1,072 (70.6%)** — down from earlier 4,402 estimate, still the data-quality problem at venue scale
- Mastered venues: 446 (29.4%)

## Un-Mastered Venue Field Population (N=1,072)

| Field | Populated | Note |
|---|---|---|
| `geolocation` (lat+lng) | **1,072 (100.0%)** | Every un-mastered venue has geo ✓ |
| `name` | 1,072 (100.0%) | ✓ |
| `countryText` | 1,072 (100.0%) | Unlinked text field |
| `cityText` | 938 (87.5%) | Unlinked text field |
| `stateText` | 764 (71.3%) | Unlinked text field |
| `address` | **0 (0.0%)** | ⚠️ No address field populated anywhere |

**Key insight:** Un-mastered venues all have geolocation + name + country text. The `address` field is never populated — methodology cannot rely on it. City/state text available on 71-88% (signal cross-check possible for majority).

## Mastered-Cities Corpus (N=215)

| Field | Populated | Notes |
|---|---|---|
| `cityName` | 215 (100%) | Always present |
| `location` (GeoJSON Point) | 212 (98.6%) | lat+lng for 98.6% |
| `masteredDivisionId` | 215 (100%) | Chain link to division → region → country |
| `cityCode` | 136 (63.3%) | Short code |

**Index:** `location_2dsphere` ✓ — **geospatial radius queries supported**.

**Sample city doc:**
```json
{
  "_id": "6751f58a5db435dd8005e475",
  "cityCode": "ALBNY",
  "cityName": "Albany",
  "location": { "type": "Point", "coordinates": [-73.7562, 42.6526] },
  "masteredDivisionId": "6751f58a5db435dd8005e461"
}
```

## Venue Collection Indexes

- `_id_` + `geolocation_2dsphere` (un-mastered venues have the 2dsphere-queryable geo)

## Critical Methodology Implications

1. **Geospatial-first approach is viable:** Both collections have 2dsphere indexes. `$near` / `$geoWithin` queries from venue.geolocation to masteredcities.location are supported.
2. **Address-matching NOT viable:** 0% address population on un-mastered venues.
3. **Text cross-check available for majority:** 87.5% have cityText (allows name-equality-or-near-match confirmation against `cityName` of geo-matched city).
4. **Country chain already linked:** masteredcities → masteredDivisionId → masteredDivisions → masteredRegionId → masteredRegions → masteredCountryId. CALBEAF-113 priority-4 code uses this chain.
5. **Only 215 cities in corpus:** scale is modest; brute-force geo-nearest-neighbor per venue is feasible (~1,072 × log(215) comparisons).

## Sample 20 Rows

See `calbeaf-114-data-shape-2026-04-19.json` fields `sample20.easy10` (cityText+stateText+geo populated) and `sample20.hard10` (missing cityText or stateText).

Spot-observations:
- Hard sample includes international venues (e.g. venues with `country: "US"` vs non-US) and quirky cityText values (e.g. `city: "nowhere"`).
- Easy sample shows typical shape: name + city + state + country text + geolocation (but no address field).

## Handoff to AIDI

Distribution data ready. Methodology spec can now proceed with realistic thresholds:
- Priority 1: geo-nearest-neighbor within Xkm to a masteredcity + cityText match
- Priority 2: geo-nearest-neighbor within Xkm to a masteredcity + stateText match
- Priority 3: geo-nearest-neighbor within Xkm (stricter threshold) without text
- Manual review: ambiguous (multiple candidates within threshold, or no candidate within outer bound)

X values + automation-ceiling claim are AIDI's call based on distribution.

## PROD Stay-Out

Unchanged.
