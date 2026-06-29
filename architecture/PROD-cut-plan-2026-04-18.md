# PROD Cut Plan — D-architecture + TT 2.0

**Author:** Quinn
**Date:** 2026-04-18 drafted · updated 2026-04-19 per Toby 14:10Z directive · updated 2026-04-20 Fulton (Venues_AutoMaster v1.28.0 merged, CALBEAF-118 deployed, corpus expansion applied)
**Status:** DRAFT — plan only. No PROD operations authorized; all work stays TEST-only per Toby hard rail until explicit reauth.
**Scope:** Two initiatives currently TEST-live awaiting PROD promotion. This plan covers the coordinated path for both.

> **JIRA numbering note:** Team colloquial "CALBEAF-117" = JIRA CALBEAF-115 (event.masteredCityId denorm). AIDI's corpus-expansion = JIRA CALBEAF-116. Both conventions surface in hub traffic; this plan uses JIRA numbers with colloquial in parens where helpful.

---

## Scope — two initiatives, one coordinated PROD cut

**Initiative A: D-architecture rollout + data-enrichment family**

Core D-architecture (CALBEAF-110, COMPLETE on TEST 2026-04-18):
- `Events_BulkEnrich` endpoint (Azure Functions) ✓
- `DQ_PeriodicChecker` Tier-2 timer function ✓
- `enrichmentStatus` schema field + composite index on events collection ✓
- Phase 6 Events_Create/Update wire-in (inline classifier for CRUD path) ✓
- Backfill pass (`runDataQualityBackfill.js`) ✓ — 5,950 events, 100% coverage
- Porter loader refactor — RETRACTED 2026-04-19 (superseded by CALBEAF-115 pipeline denorm per D-arch boundary)
- Reference: `bulk-enrich-endpoint-spec.md` v1.5, `enrichment-architecture-decision-2026-04-18.md`

Data-enrichment family (added 2026-04-19 per Toby "country 100%, FTP then FTData"):
- **CALBEAF-113** (country venue-chain priority-4) ✓ DONE — +369 event country fills, +6.4pp
- **CALBEAF-114 step 1** (venue-mastering P1 HIGH bucket) ✓ DONE — 61 venues mastered, +68 event country, +1.1pp
- **CALBEAF-114 Path 1 v1.1** (P1 tie-break + P4 15km+state+city) — RATIFIED 2026-04-19; Fulton implements → dry-run → AIDI Q1=C → `--apply`. Expected +15-25pp venue coverage unlock.
- **CALBEAF-115** JIRA (colloquially "117"): event.masteredCityId denorm from venue-chain, `ENRICHMENT_SPEC_VERSION 1.2.0` ✓ DONE — +427 events, 17.3%→24.8%, 2 flagged conflict-review
- **CALBEAF-116** JIRA (corpus-expansion proposal-generator per AIDI v1.0 spec) — RATIFIED 2026-04-19; Fulton implements tool (never-writes) → human review loop (Toby/Dash) → approved masteredcities inserted → CALBEAF-114 re-run. Combined auto yield target ~60-80% of 1,072 un-mastered.
- **SAS-FTPNTD top-5 orgs** ✓ DONE — 10 masters / 301 events / 37% yield (v1.0 22% + v1.2 outlier-tolerance +15pp)
- **series-detection package v1.0 → v1.2** ✓ DONE — v1.1 DST fix, v1.2 gap-axis outlier tolerance. v1.3 DST-calendar-day-split deferred pending concrete tz source.

TEST state as of 2026-04-19T15:00Z: event.masteredCityId 24.8% · event.masteredCountryName 24.6% · 5,738 events at enrichmentStatus=complete · series consolidation done except ~360 v1.3-DST residuals.

**TEST state as of 2026-04-20 (post Venues_AutoMaster + CALBEAF-118 + corpus expansion + batch re-run):** venue masteredCityId **84%** (1,272/1,518) · venue masteredCountryId **89%** (1,358/1,518) · event masteredCityId 88.6% · event masteredCountryId 88.7% · masteredcities chain 100% (215/215) · MANUAL venues: 158 → **93** (−65 resolved by new cities) · 13 bad-coord venues in CALBEAF-131 (AIDI Tier-1/Tier-2 repair pending)

**Initiative B: TT 2.0 UX redesign bundle (Sarah)** — 36 PRs merged to TEST under TIEMPO-408 umbrella; current TEST head 2026-04-18 23:22Z:
- TIEMPO-401 `beginnerFriendly` checkbox ✓
- TIEMPO-402 mode toggle + `/explore` stub ✓ (path-first fix 2026-04-19)
- TIEMPO-404 Explore @visx timeline ✓ (Explore pass 2: cat/country filters rework, AI-Found prominence, Leaflet world-map view toggle, month scrubber)
- TIEMPO-406 Beginner stub ✓ (superseded by 408 T2)
- TIEMPO-407 calendar day-cell sort + AI modal + Boston radius ✓
- TIEMPO-408 T1 chrome (BrandMark + CityPill + 2-row SiteMenuBar + modern ModeToggle) ✓
- TIEMPO-408 T2 Beginner organizer-grouped + location-scoped + 30d window (reduced from 60d) ✓
- TIEMPO-408 subtitle copy fix ✓ (2026-04-18 01:56Z — "practicas" dropped per Thread 1 eligibility)
- TIEMPO-409 SeriesDetectionHint on event-create form ✓ (SAS-FTPNTD Layer 2)
- Recurring-master expansion via shared `utils/nextInstance.js` w/ `rrule.between()` ✓
- Card-click → `/calendar?event=X` auto-open detail modal ✓
- **Provisional `forBeginners` CRUD toggle ✓ shipped ahead of bulk-enrich endpoint per Toby explicit override 2026-04-17** (strict client-side gate Class/Workshop/DayWorkshop/Festival; "we can backout if needed" posture). Arbiter note: violates original "no UI toggle before server rejection" constraint but was explicit Toby override; will reconcile with TIEMPO-405 formal ship when bulk-enrich endpoint firms.

**NOT in this cut** (stays TEST or later):
- TIEMPO-405 formal `forBeginners` CRUD toggle — 2.1 bundle, follows 2.0 PROD (provisional version above is placeholder)
- Phase 5 follow-up `--force-recompute` with rule refinement + Option A preserve-gate — can run before OR after PROD cut depending on timing
- CALBEAF-114 Path 1 v1.1 + CALBEAF-116 proposal-generator — ratified 2026-04-19, Fulton implementing; dry-run + apply land on TEST before PROD cut
- v1.3 series-detection DST-calendar-day-split — parked pending concrete tz source
- UT miscategorization sub-initiative — parked (AIDI plate, deferred post-PROD-reauth timeline)
- Thread 5 organizer-unknown attribution — longer-clock sub-initiative, not v1

---

## Pre-PROD readiness criteria ("good point" = all true)

**Initiative A — core D-architecture:**
- [x] Phase 6 Events.js inline wire-in: Fulton shipped + tested on TEST ✓ 2026-04-18 17:31Z (v1.27.1)
- [~] Porter loader refactor: **RETRACTED** 2026-04-19 — superseded by CALBEAF-115 pipeline-side denorm per D-architecture boundary
- [ ] Booker DB migration: committed + run against TEST DB (unblocked, awaits Booker branch/commit)
- [x] Phase 5 backfill on TEST: 5,950 events, 100% coverage ✓ 2026-04-18 14:02Z
- [ ] Live end-to-end on TEST: Harvey scrape → Booker intake → Mongo insert → BE-AF enrichment inline → Sarah UI reads enriched fields (smoke test matrix)
- [ ] Phase 5 follow-up `--force-recompute` (rule refinement + Option A) OR explicit deferral decision — **queued, awaits Toby auth**
- [ ] TEST soak window: ≥ 3 clean days (no pipeline errors, degraded-mode rate < 1%, Tier-2 recoveries trending to zero)
- [ ] AIDI Q1=C dry-run review of PROD backfill (separate from TEST backfill review)

**Initiative A — data-enrichment family (added 2026-04-19):**
- [x] CALBEAF-113 country venue-chain priority-4 ✓ DONE (+369 events)
- [x] CALBEAF-114 step 1 (P1 HIGH bucket) ✓ DONE (61 venues)
- [x] CALBEAF-116 Venues_AutoMaster Phase 1+1b ✓ DONE v1.28.0 — merged TEST+DEVL (supersedes plan's "CALBEAF-114 Path 1 v1.1")
- [x] CALBEAF-118 Europe chain-fix A1(d) ✓ DONE — deployed TEST; PUT hook fixed same branch
- [x] CALBEAF-115 JIRA ("117" colloquial) event.masteredCityId denorm ✓ DONE (+427 events)
- [x] Corpus expansion 2026-04-20 — 12 cities inserted TEST; batch re-run complete
- [x] CALBEAF-131 Tier-1 geo-patch APPLIED TEST — Scilla [15.72, 38.25] + Restaurant Harmonia [21.23, 45.75] coords corrected (two-source SQLite confirmation); Harmonia masteredCountryId=Romania resolved; Scilla+Timișoara city corpus-gap deferred to CALBEAF-128 (post-A1+A2 per AIDI)
- [x] SAS-FTPNTD top-5 orgs ✓ DONE (301 events / 37% yield)
- [~] Final TEST coverage numbers — venue masteredCityId **84%** · masteredCountryId **89%** · event masteredCityId 88.6% · event masteredCountryId 88.7%. CALBEAF-131 Tier-1 patched. Remaining MANUAL ~93 venues; corpus-gap cities deferred to CALBEAF-128.

**Initiative B (TT 2.0):**
- [x] All 36 TIEMPO-408 PRs merged to TEST ✓ (head 2026-04-18 23:22Z)
- [x] TIEMPO-408 subtitle copy fix landed ✓
- [ ] Toby 2.0.0 visual acceptance on TEST
- [ ] No open regressions against existing 1.22.x behavior
- [ ] `version` bumped to 2.0.0 in TT package.json (currently 1.22.24)
- [ ] Arbiter decision on provisional-forBeginners-toggle reconciliation with formal TIEMPO-405 (Quinn to decide: keep provisional as 405a, or retire when endpoint-gated 405 formally ships)

**Cross-initiative:**
- [ ] D-architecture populates TT-visible fields BEFORE TT 2.0 renders them (ordering below)
- [ ] Rollback plans validated for both (dry-run rollback on TEST)
- [ ] PROD service account + credentials minted (new from TEST; fenced from TEST)
- [ ] Toby explicit PROD reauth (hard rail currently fenced)
- [ ] Number2 telegram channel open for Toby during cut (emergency path)

---

## Ordering — D-architecture FIRST, then 2.0 on top

**Rationale:** TT 2.0 Beginner/Explore tabs surface data from D-architecture fields (`forBeginners`, `beginnerFriendly`, `travelWorthy`). If 2.0 ships before D-architecture populates those fields on PROD, Beginner tab looks empty / Explore timeline has no travel-worthy events. Backwards = bad UX.

**Recommended sequence:**
1. D-architecture PROD (BE-AF endpoint, schema, Tier-2, Phase 6, backfill)
2. Validation window: 24h soak on PROD with D-architecture fully populating events
3. TT 2.0 PROD (Sarah's bundle, consuming the now-populated fields)
4. TIEMPO-405 as 2.1 follow-up (organizer `forBeginners` toggle) — weeks later

Alternative (higher-risk, not recommended): same-day coordinated push. Only do this if Toby prefers a "single big reveal" and accepts the 24h-without-validation risk.

---

## Initiative A — D-architecture PROD path (step-by-step)

### A.1 — PROD Mongo schema migration
- **What:** Add `enrichmentStatus` field (enum: `complete|pending|failed`) + composite index `{appId, enrichmentStatus, updatedAt}` to `events` collection on PROD Mongo cluster.
- **Duration:** ~5 sec per 10k events; PROD is larger than TEST's 6,351 — estimate ≤ 30 sec for 50k-100k rows.
- **Risk:** LOW-MEDIUM. Additive only; index build briefly locks collection. Same profile as TEST migration which completed in 4.8s.
- **Rollback:** drop index + drop field. ~1 min.
- **Gate:** Toby explicit reauth.

### A.2 — PROD Azure Functions deploy
- **What:** Deploy `Events_BulkEnrich.js` + `DQ_PeriodicChecker.js` + updated `Events_Create.js` / `Events_Update.js` (Phase 6 inline wire-in) to `calendarbeaf-prod` Azure Functions app.
- **Duration:** ~5-10 min (includes `az config-zip` full bundle per the known `func` CLI issue).
- **Risk:** MEDIUM. Touches existing Events_Create/Update which is live user-facing code. `func` CLI issue resurfaces = need `az config-zip` (documented fix already in Fulton's runbook).
- **Rollback:** Azure Functions slot-swap back to previous deployment, ~2 min.
- **Gate:** Toby explicit reauth + successful A.1 first.

### A.3 — PROD service-porter credential
- **What:** New Firebase service account `service-porter@tangotiempo-prod.iam.gserviceaccount.com` (or whatever the PROD Firebase project is). JSON key delivered OOB to Porter's runtime environment.
- **Duration:** ~5 min (Firebase console).
- **Risk:** LOW. Credential provisioning.
- **Rollback:** disable service account in Firebase console.
- **Gate:** clarify which Firebase project PROD BE-AF uses — same `tangotiempo-257ff` or different? Check with Fulton pre-cut.

### A.4 — Porter PROD deploy
- **What:** Porter's refactored `load-from-harvey.ts` + `load-from-booker.ts` merged to main. Porter runs on cron/manual invocation; next run after merge picks up new code.
- **Duration:** deploy itself is instant; first run ~5-30 min depending on batch size.
- **Risk:** MEDIUM. First PROD run hits PROD BE-AF endpoint with real events. Degraded-mode fallback catches any BE-AF flakiness.
- **Rollback:** revert Porter commit; next run uses old code.
- **Gate:** Toby explicit reauth + successful A.1, A.2, A.3 + TEST soak ≥ 3 days.

### A.5 — PROD backfill (`--force-recompute` or `--apply`)
- **What:** Run `scripts/runDataQualityBackfill.js` over PROD Mongo events. Populates `forBeginners` / `beginnerFriendly` / `travelWorthy` / country / venue fields on ALL existing PROD events.
- **Duration:** ~5-15 min for typical PROD size (extrapolating from TEST's 4839ms for 6,351 events).
- **Risk:** MEDIUM-HIGH. Touches every PROD event's publication-facing flags. Dry-run → AIDI review → Toby personal review gates all apply.
- **Sequence:** dry-run first (NO writes) → package diff for Toby → Toby explicit go → `--apply`.
- **Rollback:** non-trivial. Mongo backup restore OR re-run with inverse operation. Field-level rollback requires custom script. Best mitigation: get dry-run right.
- **Gate:** AIDI Q1=C review + Toby personal review + Toby explicit `--apply` authorization. Same protocol as today's TEST backfill, but a NEW gate for PROD.

### A.6 — PROD monitoring activation
- **What:** Application Insights metrics `bulk_enrich.*` + `dq_checker.*` activated on PROD. Degraded-mode alert threshold set (e.g., > 5% = page).
- **Duration:** config-only, ~10 min.
- **Risk:** LOW. Observability-only.
- **Gate:** concurrent with A.2.

---

## Initiative B — TT 2.0 PROD path (step-by-step)

### B.1 — Version bump + final polish verify
- **What:** Bump `tangotiempo.com/package.json` version 1.22.x → 2.0.0. Final visual QA on TEST.
- **Duration:** ~15 min.
- **Risk:** LOW.
- **Gate:** Toby 2.0.0 visual acceptance on TEST.

### B.2 — Vercel PROD deploy
- **What:** Merge TT main to PROD branch. Vercel auto-deploys to `tangotiempo.com` production.
- **Duration:** ~5 min (Next.js build + deploy).
- **Risk:** MEDIUM. User-facing frontend. Incorrect env var or config = partial outage.
- **Rollback:** Vercel instant-rollback to previous deployment, < 1 min.
- **Gate:** Toby explicit PROD reauth + A.1-A.6 complete + 24h PROD soak on D-architecture.

### B.3 — Post-deploy validation
- **What:** Smoke test matrix — Local tab / Beginner tab / Explore tab all render correctly with D-architecture-populated fields. City switching works. Organizer-grouped Beginner list populated.
- **Duration:** ~15 min manual QA.
- **Gate:** concurrent with B.2.

---

## Risks matrix

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| PROD Azure deploy hits `func` CLI blip | MEDIUM | Endpoint briefly 404 | Use `az config-zip` per runbook; ~3 min recovery |
| PROD Mongo index build locks heavy queries | LOW | Brief read latency | Background index option; off-peak window |
| PROD backfill flips many events incorrectly | MEDIUM | User-facing misclassification | Dry-run + AIDI review + Toby review; `*Override` fields preserved |
| Porter degraded-mode rate high after PROD cut | LOW | Unenriched events accumulate | Tier-2 checker picks them up; monitor `bulk_enrich.error_rate` |
| TT 2.0 ships before D-architecture populates fields | — | Beginner tab empty | Ordering constraint: D-arch A.1-A.6 done + 24h soak BEFORE B.1-B.3 |
| Rollback needed after PROD cut | LOW | Brief downtime | Per-step rollback plans above; Vercel instant-rollback for TT |
| User org has existing `forBeginners=true` values wrongly set | LOW | One-off UX glitch | Same Practilonga-style edge case; `--force-recompute` in follow-up |
| Hard rail re-imposed mid-cut (Toby changes mind) | LOW | Cut aborted | Stop at current step, validate state, plan recovery |

---

## Rollback plans (summary)

| Component | Rollback | Duration |
|---|---|---|
| PROD schema migration (A.1) | Drop field + drop index | ~1 min |
| PROD Azure Functions deploy (A.2) | Slot-swap to previous deployment | ~2 min |
| PROD service account (A.3) | Disable in Firebase console | instant |
| Porter refactor (A.4) | Revert commit; next run uses old code | ~5 min |
| PROD backfill (A.5) | Mongo backup restore OR inverse-run script | 1-4 hours |
| TT 2.0 Vercel deploy (B.2) | Vercel instant-rollback | < 1 min |

**Combined-rollback scenario:** if everything needs undoing, order is B.2 → A.5 → A.4 → A.2 → A.1. ~2 hours worst case.

---

## Gate structure (Toby decision points)

| Gate | What Toby authorizes |
|---|---|
| **G0 — Readiness** | All "Pre-PROD readiness criteria" checkboxes satisfied; good-point achieved |
| **G1 — D-arch PROD cut** | A.1 → A.6 sequence authorized; hard rail lifted for D-architecture initiative |
| **G2 — PROD backfill `--apply`** | A.5 dry-run reviewed + authorized (same protocol as today's TEST backfill) |
| **G3 — TT 2.0 PROD cut** | B.1 → B.3 sequence authorized after 24h soak |
| **G4 — TIEMPO-405 PROD cut (2.1)** | Weeks later; separate decision |

---

## Coordination & communication during the cut

- **Live channel:** hub messaging + Number2 Telegram relay for Toby oversight if AFK
- **Cut window:** off-peak (low user traffic — early morning or late night)
- **Announce:** `broadcast` at cut start, per-step transition, completion
- **Incident protocol:** any failure → pause at failed step, assess, ping Toby via Number2, rollback-or-proceed decision explicit
- **SHOFF/memory discipline:** Quinn writes SHOFF before cut + after cut + on any mid-cut pause (cross-session durability)
- **Post-cut retrospective:** capture lessons within 24h (schema hiccups, deploy blips, UX catches)

---

## Estimated timeline (updated 2026-04-19)

Core D-architecture + Phase 6 CRUD wire-in + Phase 5 backfill already on TEST. Porter refactor retracted. Remaining gating shifts to data-enrichment family completion + TEST soak.

| Phase | Duration | Earliest date |
|---|---|---|
| CALBEAF-114 Path 1 v1.1 impl + dry-run + Q1=C + `--apply` | 1-2 days | 2026-04-19 – 2026-04-21 |
| CALBEAF-116 proposal-generator impl + dry-run + human review | 3-5 days | 2026-04-22 – 2026-04-27 (human review load ~2-4h over multiple sessions) |
| CALBEAF-114 re-run post-corpus-expansion | 0.5 day | 2026-04-28 – 2026-04-29 |
| Booker DB migration + e2e smoke | 1-2 days | 2026-04-28 – 2026-04-30 |
| Phase 5-followup `--force-recompute` (if authorized) | 0.5 day | Anywhere in above window |
| TEST soak window | 3-5 days | 2026-05-01 – 2026-05-06 |
| PROD backfill dry-run + AIDI + Toby review | 1 day | 2026-05-05 – 2026-05-07 |
| **Earliest PROD cut window** | 1 day | **2026-05-06 – 2026-05-08** |

Adjust ±2-3 days for Toby availability, human-review throughput on CALBEAF-116 proposals (main new variable), regressions found in TEST soak, or rule-refinement iterations. Previous plan's 2026-05-02/05 target slides ~4 days for CALBEAF-114+116 completion.

---

## Open items Toby still needs to answer (not blocking TEST, will matter for PROD)

1. **Rule refinement:** Marathon / Encuentro / Trip / Other / Performance category gate behavior (same as Practica-softened or keep strict both-false). Your locked rule handles Festival/Marathon/Encuentro explicitly; Trip/Other/Performance inherit by pattern but worth confirming.
2. **TIEMPO-405 Festival UI eligibility:** classifier no longer auto-sets Festival to forBeginners, but does the UI toggle stay eligible for Festival (Denver organizer-override path)? My read: yes, keep eligible.
3. **TIEMPO-405 provisional reconciliation:** Sarah shipped strict-client-side-gate provisional toggle 2026-04-17 per your explicit override. Quinn to decide arbiter path: keep provisional as TIEMPO-405a shipped, formalize TIEMPO-405 as endpoint-gated 405b later; OR retire provisional when endpoint lands and formal 405 ships. Leaning keep-provisional-as-405a — user value now, backout already understood.
4. **PROD Firebase project:** same `tangotiempo-257ff` (which is currently serving TEST?) or separate PROD project? Affects A.3 service account scoping.
5. **Backfill on PROD deferred or included:** run `--apply` on PROD as part of G2, or defer and let organic traffic + Tier-2 slowly enrich as events update? Recommendation: include — one-shot populates faster than organic.
6. **Coverage expectations for PROD framing:** honest numbers only per CALBEAF-113 lesson. Post-114+116 on TEST we'll capture event.masteredCityId % and event.country % — those become the Toby-facing PROD cut headline numbers, not aspirational targets.
7. **CALBEAF-116 human review load:** ~100-250 per-proposal decisions for Toby/Dash. Can be batched across sessions. Worth confirming preferred cadence (single marathon session vs drip over days).

---

## This plan document's role

This is a **draft** — treated as a working plan while the team iterates on TEST. Updated at each readiness-criterion checkbox completion. Final version becomes the runbook for cut day.

**Quinn maintains this doc at every phase transition.** Team can view/propose changes via hub.

PROD stay-out remains in force. No operation in this plan runs without Toby explicit reauthorization at the gate it's tied to.

— Quinn

---

## 2026-04-19 update summary (for quick scan)

**What changed in this revision:**
- Initiative A scope expanded to include data-enrichment family: CALBEAF-113 ✓, CALBEAF-114 step 1 ✓, CALBEAF-114 Path 1 v1.1 (ratified, pending impl), CALBEAF-115 (JIRA "117" colloquial) ✓, CALBEAF-116 (ratified, pending impl), SAS-FTPNTD top-5 ✓, series-detection v1.0–v1.2 ✓
- Porter loader refactor RETRACTED (D-arch boundary — CALBEAF-115 pipeline denorm owns it)
- Initiative B: 36 TIEMPO-408 PRs merged to TEST; subtitle fix ✓; provisional forBeginners toggle shipped per Toby 2026-04-17 override
- TEST state: event.masteredCityId 24.8% · event.masteredCountryName 24.6% · 5,738 events enrichmentStatus=complete
- Timeline: PROD cut earliest slides from 2026-05-02 to 2026-05-06 due to CALBEAF-114+116 completion sequence
- Open items list added: TIEMPO-405 provisional reconciliation, coverage framing, CALBEAF-116 human-review cadence

**What's unchanged:** PROD hard rail, ordering (D-arch-first → TT-2.0-after), gate structure (G0–G4), rollback plans, risks matrix, all G1–G4 authorization language.

---

## 2026-04-20 update (Fulton — calendar-be-af)

**Completed since 2026-04-19:**
- CALBEAF-116 Venues_AutoMaster v1.28.0 → TEST+DEVL merged (80% venues, 88.6% events masteredCityId)
- CALBEAF-118 Europe chain-fix + PUT hook fix → **v1.28.1 TEST+DEVL** (sandbox→DEVL→TEST; corpus expansion baked in)
- 9 dimensional tickets filed (CALBEAF-118 through CALBEAF-130); AIDI 5 B-series parallel
- Corpus expansion: 8 countries + 11 regions + 11 divisions + 12 cities inserted TEST; Budapest/Oslo rewired
- AutoMaster batch --apply: 256 candidates resolved; final venue masteredCityId **84%** · masteredCountryId **89%**

**CALBEAF-131 Tier-1 DONE (2026-04-20T03:29Z):**
- Scilla [698a5229...]: Charleston placeholder → [15.7214026, 38.2485823] Scilla IT ✅ (Booker id=58, two-source); masteredCityId/CountryId null-cleared → corpus-gap-review (Scilla IT not in corpus — CALBEAF-128 scope)
- Restaurant Harmonia [698a522b...]: NYC placeholder → [21.2257474, 45.7538355] Timișoara RO ✅ (fb-conditioner id=51 + booker id=51, two-source); masteredCountryId=Romania resolved; city corpus-gap → CALBEAF-128
- Corpus additions for Timișoara + Scilla deferred to CALBEAF-128 (post-A1+A2 per AIDI — Italy chain needs A1 first)

**Not blocking PROD:**
- Remaining 93 MANUAL venues are corpus-gap-review, not bad-coord — expected residual until CALBEAF-128 expands corpus
- CALBEAF-128 (B1-European expansion) BLOCKED on CALBEAF-118 (A1) + CALBEAF-119 (A2); those are TEST-only now

**PROD stay-out absolute.** No PROD ops until Toby explicit G1 auth.

— Fulton, 2026-04-20 (updated ~03:35Z)
