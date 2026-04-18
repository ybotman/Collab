# CALBEAF-110 Phase 5 Backfill Dry-Run — Review Package for Toby

**Date:** 2026-04-18 13:07Z
**Target:** TangoTiempoTest (TEST DB)
**Mode:** DRY-RUN (no writes)
**Spec:** Collab/architecture/bulk-enrich-endpoint-spec.md (v1.5)
**JIRA:** CALBEAF-110
**Authorization gate:** Toby personal go/no-go required before `--apply` (Number2 message 12:54Z)

---

## Headline

**6,350 of 6,351 events would change** (99.98%)

Zero pipeline errors. Safety assessment clean. One row would NOT change — flagged below as the edge case worth your attention.

---

## Why so many changes?

This is the **first** pipeline run. Pre-existing TEST events mostly have no classification values set (`forBeginners=null`, `beginnerFriendly=null`, `travelWorthy=null`). The earlier migration set `enrichmentStatus='complete'` on all rows but did NOT compute the actual flag values — that's what this backfill does. So basically every row gets at least one new value populated.

This is not a regression or a corruption — it's the intended first-run computation.

---

## Per-field change counts

| Field | Events Changed | Notes |
|---|---|---|
| `forBeginners` | 6,350 | Mostly `null → false` (category-gate forces false for non-eligible categories) |
| `beginnerFriendly` | 2,664 | Same dynamic — forced false for ineligible categories |
| `travelWorthy` | 2,485 | Computed via duration + category exclusion rule |
| `masteredCountryId` | 0 | Already set on all rows by prior migration |
| `masteredCountryName` | 0 | Same |
| `venueGeolocation` | 0 | Already populated on all rows |
| `venueCityName` | 0 | Same |
| `venueTimezone` | 0 | Same |
| `enrichmentStatus` | 0 | Just set to `complete` by Phase 3 migration |

---

## Per-category breakdown (changed / total)

| Category | Changed | Total | % | Why |
|---|---|---|---|---|
| Milonga | 3,962 | 3,962 | 100% | All forced `forBeginners=false` (category gate) |
| Practica | 2,038 | 2,038 | 100% | All forced `forBeginners=false` |
| Class | 50 | 51 | 98% | Classifier runs on these — see Class samples below |
| Workshop | 172 | 172 | 100% | Eligible category, classifier runs |
| Festival | 29 | 29 | 100% | Eligible category, classifier runs |
| Marathon | 8 | 8 | 100% | Multi-day, ineligible for forBeginners → false |
| Trip | 7 | 7 | 100% | Multi-day, ineligible → false |
| OTHER | 62 | 62 | 100% | Misc, ineligible → false |
| Performance | 2 | 2 | 100% | Ineligible → false |
| MARATHON / WEEKEND / Encuentro / UNKNOWN | misc | misc | — | Ineligible → false |

**Eligible categories** (where the classifier actually runs the text rules): `Class`, `Workshop`, `DayWorkshop`, `Festival`. All others get `forBeginners=false` via category gate.

---

## ⚠️ The 1 unchanged row (your likely first question)

**Event:** `686e9ca90ac53b960835be39`
**Title:** "Practilonga Caminito (Class all levels)"
**Category:** Class

**Pre-existing values:**
- `forBeginners: true`
- `beginnerFriendly: false`  ← **invariant violation** (superset rule says forBeg=true ⇒ friendly=true)
- `travelWorthy: false`
- `enrichmentStatus: complete`
- All overrides null (no organizer ever set anything)

**What the pipeline would do:** Skip — preserves both existing values per the "only fire when undefined" gate.

**What the v3 ruleset says SHOULD happen:** Title "Class all levels" matches §1c mixed-level rule → `forBeginners=false, beginnerFriendly=true`.

**Why pipeline skips:** Current pipeline gate is "if forBeginners or beginnerFriendly is already set (true OR false), preserve." Designed to protect organizer choices, but those are protected by the separate `*Override` fields. The actual-field preservation is over-protective — preserves stale/wrong machine-computed values from earlier runs.

**This is the GENERAL question** (see below).

---

## Sample diffs — Class events (where classification matters most)

| Title | Before fb/bf | After fb/bf | Classifier reasoning |
|---|---|---|---|
| 3rd Annual Denver Does Tango: A Free **Beginner** Tango Festival | null/false | **true/true** | "Beginner" + "Festival" hits §1c positive |
| Noches de Tango | null/false | false/false | No signal, default false |
| INT/ADV CLASSES, TangoAffair | null/false | false/false | "INT/ADV" hits §1a negative |
| Ladies' Technique with Vania Rey | null/false | false/false | "Ladies Technique" hits §1a negative |
| THURSDAY Tango Class with Srini and Lola | null/false | false/false | No signal, default false |
| Gaby Mataloni workshop 1, 2 | null/false | false/false | No beginner signal |
| ABANO Terme&TAnGO… alle Terme con il TAnGO!! | null/false | false/false | No signal (Italian title, no IT-language hit) |
| **Practilonga Caminito (Class all levels)** | **true/false** | **true/false** | SKIPPED (see edge case above) |
| Special pre-milonga workshop | null/false | false/false | No beginner signal |
| Casual Milonga "Mariposa" | null/false | false/false | No signal (mistitled as Class probably) |

---

## Sample diffs — non-Class events (category-gate forces false)

| Title | Category | Before fb | After fb | Why |
|---|---|---|---|---|
| Milonga @ Alberto's | Milonga | null | false | Category gate |
| Che! Milonga | Milonga | null | false | Category gate |
| La Milonga Genesis | Milonga | null | false | Category gate |
| Tango Fundamentals & Practica Che! with Ramada & Elaine | Practica | **true** | **false** | **Category-gate correction** — Practicas can't be beginner-targeted (was wrongly set true) |
| La Vista Wednesday Practica | Practica | null | false | Category gate |
| El Boliche Milonga | Milonga | null | false | Category gate |
| TangoConca Vals Workshop | Workshop | null | false | Eligible category but no beginner signal in title |
| Project NFT Neolonga | Milonga | null | false | Category gate |

---

## Safety assessment

| Check | Status |
|---|---|
| Total events scanned | 6,351 |
| Pipeline errors | **0** |
| Override values preserved | ✓ All `*Override` fields stay null (no organizer has set anything yet) |
| Category gate enforced | ✓ Practica/Milonga/etc. forced to false |
| Niche guard enforced | ✓ All scanned events are appId=1 (Tango); no other appIds touched |
| Country denorm preserved | ✓ Already-set values not changed (0 country-field changes) |
| Venue resolution preserved | ✓ Already-set values not changed (0 venue-field changes) |
| `enrichmentStatus` preserved | ✓ Stays `complete` for all rows |
| PROD touched | ✗ NO — DRY-RUN is read-only. PROD STAY-OUT in force throughout. |

---

## What `--apply` would do

For each of the 6,350 changing rows:
- `bulkWrite` with `$set` of changed fields only
- ~3–5 minute estimated runtime (bulk batch flushes every 200 rows)
- No rows deleted, no rows added
- Reversible by re-running pipeline with corrected rules + `--force-recompute`

---

## ⚠️ The general question this surfaces

The Practilonga Caminito case (the 1 unchanged row) reveals a **design tension** in the pipeline that's worth explicit decision before `--apply`:

**Current behavior:** Pipeline preserves ANY pre-existing value on `forBeginners`/`beginnerFriendly`/`travelWorthy` (only computes when null/undefined). Designed to protect organizer choices.

**Problem:** Pre-existing values from earlier code runs (or imports) are indistinguishable from organizer choices in the DB. The `*Override` fields ARE the breadcrumb that says "an organizer touched this," but the pipeline doesn't use them to decide what to preserve. Result: stale/wrong machine-computed values stay forever.

**Three options:**

| Option | Behavior | Pro | Con |
|---|---|---|---|
| **A — Always recompute, override wins** | Actual fields = classifier output unless `*Override` is set. First run cleans everything; steady state preserves organizer choices via override. | Idempotent. Self-healing. Simple model. | Slightly more writes per pipeline call. |
| **B — Preserve actual fields, enforce invariants** | Current behavior, but ALWAYS apply superset rule (forBeg=true ⇒ friendly=true). Catches the Practilonga case but not other inconsistencies. | Minimal change. | Doesn't handle stale rule changes. Half-fix. |
| **C — Status quo + targeted `--force-recompute` flag** | Current behavior. Run `--force-recompute` after rule changes or to clean up. Manual, explicit. | No surprise behavior changes. | Operational burden. Doesn't fix on its own. |

**Fulton lean:** **A** — the override fields already handle "organizer choice protection," so the actual-field preservation is over-protective and creates bugs like Practilonga. Switching to A is a small code change to `runDataQualityPipeline` and one re-run of dry-run to verify.

**Path forward options:**

1. **Run `--apply` now with current pipeline** (option C semantics). 6,350 rows updated. The 1 Practilonga row stays inconsistent. Address with a follow-up `--force-recompute` pass after we fix the design.

2. **Hold `--apply`, switch pipeline to option A**, re-run dry-run, then apply. Adds ~10 min. Catches the 1 anomaly + makes the system self-healing for future rule changes.

3. **Hold everything**, schedule a design discussion on options A/B/C with AIDI.

---

## Coordination chain (where we are)

1. ✅ Fulton dry-run completed (this document)
2. ⏳ AIDI Q1=C governance review (standing gate)
3. ⏳ **Toby personal review** (this document)
4. ⏳ Toby explicit go → `--apply`

**`--apply` is HELD** until Toby explicit authorization. Not auto-running even after AIDI signs off.

---

## Files referenced

- Full diff JSON: `/tmp/calbeaf-110-backfill-dryrun.json` (TEST machine, ~3MB)
- Backfill script: `scripts/runDataQualityBackfill.js`
- Pipeline lib: `src/utils/enrichment.js`
- Spec: `Collab/architecture/bulk-enrich-endpoint-spec.md` (v1.5)
- Canonical fixture: `Collab/fixtures/beginner-class-gold-set.json` (56 rows, 100% pass)

---

— Fulton (CALBEAF-110 Phase 5 dry-run)
