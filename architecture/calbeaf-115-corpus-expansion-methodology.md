# CALBEAF-115 Masteredcity Corpus Expansion Methodology

**Version:** v1.0
**Author:** AIDI
**Purpose:** Define human-gated methodology for proposing new `masteredcities` docs from un-mastered venue clusters, enabling CALBEAF-114 Path 1 to resolve previously-unreachable venues
**Scope:** TEST-only per Toby preapproval 2026-04-19T08:34Z (Option 2); PROD stay-out hard rail applies
**Governance standing:** never-invent-venue rule, FTD scope-guard, Q1=C dry-run gate on proposal generator, HUMAN review for every insert

---

## Why this exists

CALBEAF-114 dry-run surfaced the hard corpus ceiling: 300 of 1,072 un-mastered venues are >50 km from ANY masteredcity. These cannot be resolved via geospatial+text matching at any threshold because the TARGET doesn't exist in the `masteredcities` collection.

The fix is corpus expansion. Key governance principle: **NEVER auto-create masteredcity docs from venue data alone.** Human review gates every insertion. Tool produces proposals; human decides.

---

## Methodology

### Input

Un-mastered venues where nearest masteredcity is >50 km (CALBEAF-114 hard max from methodology §5 guard #1). Approximately 300 venues from current TEST corpus.

### Clustering

Group input venues by proposed-city signature:

**Clustering key:** `normalize(venue.cityText) + "|" + normalize(venue.stateText) + "|" + geo-grid-cell(venue.geolocation, 10km)`

Where:
- `normalize()`: lowercase, trim, strip punctuation, collapse whitespace
- `geo-grid-cell(loc, 10km)`: quantize lat/lng to a 10km grid cell (rough geographic clustering)

**Rationale:** venues sharing cityText + stateText + rough-geographic-proximity likely represent the same real city. Each cluster = one candidate masteredcity proposal.

### Proposal generation per cluster

For each cluster, emit:

```json
{
  "proposalId": "<uuid>",
  "proposedCityName": "<normalized from majority venue.cityText>",
  "proposedStateText": "<majority venue.stateText>",
  "proposedCountryText": "<majority venue.countryText>",
  "proposedGeoCentroid": [lng, lat],
  "venueClusterSize": <N>,
  "eventCountInCluster": <sum of events attached to cluster's venues>,
  "sampleVenues": [
    { "venueId", "venueName", "venueCityText", "venueStateText", "venueGeo" }
  ],
  "confidence": "high" | "medium" | "low",
  "reviewReason": "<if low-confidence: why>"
}
```

**Confidence rules:**
- **HIGH:** ≥3 venues in cluster, ALL share cityText + stateText after normalization, geo-centroid < 5km from any venue
- **MEDIUM:** 2+ venues with consistent cityText, or 1+ venue with unambiguous cityText+stateText
- **LOW:** 1 venue or inconsistent text — LOW confidence proposals go to REVIEW with flag for manual verification

### Never-invent guards

1. **No auto-insert.** Proposals are OUTPUT artifacts. Human (Toby or Dash) reviews, approves per-proposal, inserts via mongosh or existing admin path.

2. **No fabricated city names.** Proposed city name derives from majority venue.cityText per cluster. If venues disagree on cityText, proposal routes to LOW with reviewReason = "cityText inconsistent across cluster."

3. **No cross-state clusters.** If cluster spans multiple stateText values, split into sub-clusters by stateText before emission. Never propose a masteredcity that spans multiple states in its member venues.

4. **Preserve existing masteredcities.** Tool queries `masteredcities` collection first; skip any cluster whose proposed (cityName, stateText) already exists. Don't propose duplicates.

5. **International caution.** If cluster's majority countryText is non-US, require ALL cluster members to agree on country. If any disagreement, route to REVIEW. US-skewed corpus means international proposals should be conservative.

6. **Single-venue clusters REVIEW only.** 1-venue clusters don't get HIGH confidence. Single-venue proposals are legitimate but warrant human eyeball — one data point is thin evidence for a new masteredcity.

### Output artifact

`Collab/reviews/calbeaf-115-proposals-<date>.{json,md}`:

```
{
  "meta": { version, timestamp, sourceVenueCount, clustersGenerated },
  "proposals": [...],
  "summary": {
    "highConfidence": <N>,
    "mediumConfidence": <N>,
    "lowConfidence": <N>,
    "byState": { "MA": <N>, "CA": <N>, ... },
    "byCountry": { "US": <N>, "AR": <N>, ... }
  }
}
```

Markdown companion provides reviewer-friendly per-proposal rendering with sample venues and confidence reasoning.

---

## Governance chain

1. **Fulton implements proposal-generator tool** `runMasteredCityProposalGenerator.js` per this spec. Dry-run default; no writes at all (tool is proposal-only, never --apply).
2. **AIDI Q1=C spot-check** on 20-row sample (5 HIGH / 10 MEDIUM / 5 LOW). Verify clustering sanity, cityText-normalization correctness, never-invent guards honored.
3. **Quinn clearance** on proposal-generator output shape.
4. **Toby/Dash human review** of proposal output. Per-proposal approval/rejection.
5. **Approved proposals inserted into `masteredcities` collection** via admin-gated mechanism (mongosh, direct Mongo, or future CalOps if CALBEAF-115 later warrants). **NOT by the tool.**
6. **Post-insertion:** re-run CALBEAF-114 Path 1 dry-run. Previously-REVIEW venues now resolvable to newly-approved masteredcities. New Q1=C → --apply cycle closes the loop.

---

## Expected yield

**Cluster estimate (from 300 input venues):**
- Large metro areas: maybe 50-100 clusters (multiple venues in same proposed city)
- Single-venue rural/international: maybe 50-150 clusters (1 venue = 1 low-confidence proposal)

**Proposals: ~100-250 total**, distributed HIGH/MEDIUM/LOW per confidence rules.

**Human review load:** ~100-250 per-proposal decisions. At ~1 min per proposal = 2-4 hours of human review time, not all at once.

**Post-approval yield:** every approved masteredcity unlocks resolution for 1-N venues. Expected ~250-400 venues resolvable after approvals (assuming ~60-80% approval rate on proposed clusters).

Combined with CALBEAF-114 Path 1 v1.1: total auto yield after corpus expansion could reach ~60-80% as Toby's original goal.

---

## FTD scope-guard for proposal tool

- **Tool NEVER writes to `masteredcities` collection.** Read-only cluster analysis + proposal emission.
- **Tool NEVER writes to `venues` collection.** CALBEAF-114 handles venue assignment after corpus expansion.
- **Only outputs are artifacts** (JSON + MD files in Collab/reviews/).

---

## Interaction with other initiatives

- **CALBEAF-114:** complementary. CALBEAF-115 expands the corpus that CALBEAF-114's Path 1 queries against. Approved masteredcities unblock additional venue assignments.
- **CALBEAF-117:** downstream. CALBEAF-117's event.masteredCityId denorm depends on venue.masteredCityId being set, which depends on CALBEAF-114's coverage, which depends on CALBEAF-115's corpus.
- **CALBEAF-113:** completed. CALBEAF-115 eventually drives country coverage from ~24% toward the honest ceiling once masteredcity-chain completes.

---

## PROD stay-out

Unchanged. TEST-only. Approved masteredcity insertions on TEST are scoped to TangoTiempoTest. PROD masteredcity inserts require separate Toby reauth per hard rail.

---

## Success criteria

1. Proposal generator runs cleanly on the 300 far-venues (0 tool errors)
2. ≥60% of proposals reach HIGH or MEDIUM confidence (low-confidence <40% = tool working per spec)
3. Human review approves ≥60% of HIGH+MEDIUM proposals (false-positive rate acceptable)
4. Post-insertion CALBEAF-114 re-run auto-resolves ≥200 additional venues
5. Combined CALBEAF-114+115 auto yield: ≥60% of original 1,072 un-mastered
6. Honest-yield-framing maintained — no "100%" claims

---

## Not in scope for v1

- CalOps admin UI for proposal review (per Toby scope-reduction 2026-04-19 05:44Z)
- Automated geocoding-service lookups for proposed city verification
- Venue-name-based clustering (text is thin signal without geo)
- Historical-tz determination for approved masteredcities (that's v1.3 DST work, separate)
