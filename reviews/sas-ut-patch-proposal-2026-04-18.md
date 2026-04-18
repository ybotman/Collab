# UT Series-as-Singletons Patch Proposal — TEST dry-run design

**Date:** 2026-04-18
**Author:** Fulton (calendar-be-af)
**Initiative:** Series-as-Singletons FTPNTD Remediation, Phase 2, UT as first target
**Governance gate:** AIDI Q1=C per-org review; Quinn step-8 clearance; Toby reauth for TEST apply (novel-op Tier-2 per Quinn 2026-04-18)

---

## Scope

Convert UT's 55 non-recurring same-title events into 6 recurring masters. All are historical — this is cleanup, not forward-dated insert. Original singletons preserved with `replacedByMaster: <masterId>` audit flag per AIDI standing rule.

**PROD stay-out applies.** This proposal is for TEST patch only. PROD application requires fresh Toby reauth.

---

## Per-series analysis + RRULE proposal

For each series (≥3 same-title events), I've analyzed the observed weekday + time + gap pattern to infer a candidate RRULE. Per AIDI's "never-invent-RRULE" rule, ambiguous cases get flagged REVIEW rather than auto-converted.

### Series 1 — "UT – Beginner – Learn Argentine Tango! – drop in to any Tuesday or Thursday at 7:30pm"

| Property | Value |
|---|---|
| Count | 17 events |
| Span | 56 days (2025-05-01 → 2025-06-26) |
| Weekday | Tuesday (8) + Thursday (9) |
| Time | 23:30 UTC (7:30pm EDT) — 17/17 consistent |
| Median gap | 5 days |
| Category | Class |
| forBeginners | true |
| Proposed RRULE | `FREQ=WEEKLY;BYDAY=TU,TH` |
| DTSTART | 2025-05-01 23:30 UTC |
| UNTIL | (none — open-ended; if series ended, Toby can cap later) |
| Confidence | **HIGH** — title self-describes "Tuesday or Thursday at 7:30pm" + observed pattern matches |

### Series 2 — "UT Learn Tango In One Summer!"

| Property | Value |
|---|---|
| Count | 10 events |
| Span | 49 days (2025-07-07 → 2025-08-25) |
| Weekday | Monday (8) + Fri (1) + Sat (1) |
| Time | Mixed — 23:30 UTC (8), 19:00 (1), 23:00 (1) |
| Median gap | 7 days |
| Category | Class |
| forBeginners | (was false; re-classified via CALBEAF-110) |
| Proposed RRULE | `FREQ=WEEKLY;BYDAY=MO` for 8 Monday events |
| DTSTART | 2025-07-07 23:30 UTC |
| UNTIL | 2025-08-25 23:30 UTC (explicit per observed data) |
| Confidence | **REVIEW-FLAGGED** — 2 outlier events (Fri + Sat) at different times don't fit the weekly-Monday pattern. Likely "field trips" (per title: one is labeled "Practica Field Trip", one "Milonga Field Trip"). These should stay as 2 separate singletons linked to the series, not fold into the Monday master. AIDI call. |

### Series 3 — "UT – Advanced Level – Elevating Technique, Connection, and Expression – couples only only"

| Property | Value |
|---|---|
| Count | 9 events |
| Span | 56 days (2025-05-03 → 2025-06-28) |
| Weekday | Saturday (9/9) |
| Time | 21:00 UTC (5:00pm EDT) — 9/9 consistent |
| Median gap | 7 days |
| Category | Class |
| forBeginners | false |
| Proposed RRULE | `FREQ=WEEKLY;BYDAY=SA` |
| DTSTART | 2025-05-03 21:00 UTC |
| UNTIL | 2025-06-28 (explicit — 9 weeks) |
| Confidence | **HIGH** — clean weekly Saturday pattern |

### Series 4 — "Short Sequences – enrich your vocabulary with 52 sequences every year"

| Property | Value |
|---|---|
| Count | 8 events |
| Span | 49 days (2025-05-06 → 2025-06-24) |
| Weekday | Tuesday (8/8) |
| Time | 23:30 UTC — 8/8 consistent |
| Median gap | 7 days |
| Category | Other |
| Proposed RRULE | `FREQ=WEEKLY;BYDAY=TU` |
| DTSTART | 2025-05-06 23:30 UTC |
| UNTIL | 2025-06-24 (explicit — 8 weeks) |
| Confidence | **HIGH** — clean weekly |
| Note | Title claims "52 sequences every year" — intended annual program, but observed only 8 weeks. Reflecting data, not aspiration. |

### Series 5 — "UT – Open Level – CHE TANGO! – Saturday Afternoon Practica at ULTIMATE TANGO"

| Property | Value |
|---|---|
| Count | 8 events |
| Span | 49 days (2025-05-03 → 2025-06-21) |
| Weekday | Saturday (8/8) |
| Time | 19:00 UTC (3:00pm EDT) — 8/8 consistent |
| Median gap | 7 days |
| Category | Practica |
| Proposed RRULE | `FREQ=WEEKLY;BYDAY=SA` |
| DTSTART | 2025-05-03 19:00 UTC |
| UNTIL | 2025-06-21 |
| Confidence | **HIGH** — clean weekly |

### Series 6 — "UT – Open Level – I Had the Heart – One-of-a-kind tango experience with Oliver Kolker"

| Property | Value |
|---|---|
| Count | 3 events |
| Span | 2 days (2025-05-02 → 2025-05-04) |
| Weekday | Fri + Sat + Sun |
| Time | 15:30 UTC (×2) + 23:30 UTC (×1) |
| Median gap | 1 day |
| Category | Milonga |
| Proposed | **REVIEW — DO NOT auto-convert** |
| Reasoning | 3 events in 2 days with different weekdays and times = weekend workshop, not a recurring series. Classification as "series-as-singletons" is a false positive of the ≥3-same-title heuristic. Leave as 3 separate events. |
| AIDI rule applies | "never-invent-RRULE when ambiguous" |

---

## Summary

| Series | Count | Action | Confidence |
|---|---|---|---|
| 1. UT – Beginner – Tue/Thu 7:30pm | 17 | Convert → 1 master | HIGH |
| 2. UT Learn Tango In One Summer | 10 | Convert 8 Mondays → 1 master; leave 2 field-trip outliers | REVIEW (AIDI call on outliers) |
| 3. UT – Advanced Level – Elevating | 9 | Convert → 1 master | HIGH |
| 4. Short Sequences | 8 | Convert → 1 master | HIGH |
| 5. UT – Open Level – CHE TANGO! Saturday | 8 | Convert → 1 master | HIGH |
| 6. UT – Open Level – I Had the Heart (Kolker) | 3 | **NO-OP** (false positive; 2-day workshop) | LEAVE AS SINGLETONS |
| **Net** | **55** | **5 masters created + 50 singletons flagged replaced + 5 leftover originals** (2 field-trip singletons + 3 Kolker workshop) | |

## Dry-run plan (pending Harvey package extraction + shared detectPotentialSeries helper)

1. Build `calendar-be-af/scripts/runSeriesAsSingletonsPatch.js --org=UT --dry-run`
2. Tool outputs: proposed master docs + proposed singleton-update `$set: { replacedByMaster: <id> }` ops + REVIEW-flagged groups
3. Package diff report identical to Phase 5 dry-run format for AIDI Q1=C review
4. On AIDI ✅ + Quinn clearance + Toby explicit reauth (novel-op Tier-2 via Number2), run `--apply`

## Implementation dependencies

- Harvey's extraction of `ai-discovered/packages/series-detection/` (in flight, ~01:20Z ETA)
- Per Quinn's 23:24Z arbitration: `file:../../ai-discovered/packages/series-detection` npm install in calendar-be-af/
- AIDI sync-protocol for rule changes in the package

## What this does NOT change

- Classifier fields (forBeginners, beginnerFriendly, travelWorthy) unaffected — already correctly classified in Phase 5
- Non-UT organizers — this is UT-only; TSB / Practica Spark / Tango Sueño / Boston Sunday Practica come after as sequential per-org reviews
- PROD — TEST-only; PROD patch held pending Toby reauth

---

*Ready for AIDI Q1=C review of the RRULE-inference proposals. Per Quinn's sequence: UT first establishes the pattern; subsequent top-5 orgs follow Tier-1 once this is validated.*

— Fulton
