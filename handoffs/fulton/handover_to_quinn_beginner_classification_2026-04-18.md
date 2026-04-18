# Handover: Beginner Class Classification — Fulton → Quinn

**Date:** 2026-04-18
**From:** Fulton (calendar-be-af)
**To:** Quinn (cross-project coordinator)
**Trigger:** Toby identified that this work has grown into multi-project coordination — outside Fulton's calendar-be-af lane.
**Fulton continues:** BE-only investigation + classifier lib, deferred until Quinn re-converges the open threads.

---

## Status overview

A spec for two new event attributes (`forBeginners`, `beginnerFriendly`) on Class events. The classification ruleset is signed off by 3/4 consumers; the strategic shape just expanded into ~5 open threads spanning multiple projects. Quinn to take over coordination.

---

## What's signed off (LOCKED)

**Spec v3:** `Collab/architecture/beginner-class-classification-spec.md`

Concur received from:
- ✅ AIDI (full v3 ruleset + open-question resolutions)
- ✅ Harvey (v3 + fixture flips + ruleset-gap notes)
- ✅ Porter (v3 + raised one integration question — see open threads)
- ✅ Fulton (author)

**Resolved decisions (don't reopen unless context warrants):**
- Q1: Backfill = dry-run → AIDI review → apply (option C)
- Q3: 3 campaign segments confirmed (forBeginners only / either-flag / both false)
- Q5: Fixture canonical at `Collab/fixtures/beginner-class-gold-set.json` (Harvey moved per AIDI). DO NOT FORK.

**Canonical fixture:** `Collab/fixtures/beginner-class-gold-set.json` — 56 rows, v3 flips applied, audit metadata. All consumers read from there.

---

## Open threads — Quinn's plate

### Thread 1: Sarah's CRUD-time UI override + category gate
**Toby raised:** Sarah may add a `forBeginners` toggle to TT/HJ event-create UI. Logic: only allow for category ∈ {Class, Workshop, DayWorkshop} (NOT Practica, Milonga, etc.).

**Open questions:**
- Strict gate (UI hides toggle for ineligible categories) vs Lenient (UI shows; server enforces)? Fulton lean: strict, both layers enforce.
- Eligible categories: Class + Workshop + DayWorkshop only, or include Festival? (Real example exists: "3rd Annual Denver Does Tango: A Free Beginner Tango Festival")
- All 10 PROD categories: Class, Workshop, DayWorkshop, Practica, Milonga, Festival, Marathon, Encuentro, Trip, Other

**Coordination needed with:** Sarah (frontend), AIDI (governance)

### Thread 2: AIDI Q4 re-vote (FTPNTD pulls toward Option C)
**Toby invoked FTPNTD:** Harvey should classify at intake (not just rely on BE-AF CRUD hook). This **revises AIDI's earlier Q4=A decision** (be-af as sole classifier).

**Implication:** Architecture shifts to Option C — Harvey classifies at intake, BE-AF respects what comes in (already does via "only fire when undefined" logic), BE-AF is safety net. Same ruleset, two implementations, drift managed by shared fixture.

**Coordination needed with:** AIDI (re-vote Q4), Harvey (commit to intake-time classification), Booker (same — see Thread 3).

### Thread 3: Booker — same shape as Harvey, worse text quality
**Toby raised:** Booker scrapes Facebook events; classification logic should also live in Booker per FTPNTD.

**The wrinkle:** FB text is noisier than Harvey's structured-site corpus (emoji, marketing copy, promo text, "Tag a friend" posts). Same ruleset will have lower recall.

**Open question:** Booker uses (A) same ruleset, accept FB false-negative rate, OR (B) FB-tuned ruleset with extra patterns? Fulton lean: A for v1, revisit if FB rate hurts campaigns.

**Coordination needed with:** Booker (commit + implementation cost), AIDI (governance).

### Thread 4: Porter admission + beginners-tab routing
**Toby raised:** Beginner tab should show `forBeginners=true` only — not beginnerFriendly classes, not other classes.

**Two readings:**
- **A — Strict end-to-end:** Porter admits `forBeginners=true` only. Overrides AIDI Q2 (which said either-flag).
- **B — Wide load, narrow display:** Porter admits `beginnerFriendly=true` (AIDI Q2 stands), beginners-tab filters at UI to `forBeginners=true`. Future tabs ("all-levels welcome") possible without re-loading.

Fulton lean: B. Loading is cheap; filtering is free; data model future-proof.

**Coordination needed with:** AIDI (re-confirm or revise Q2), Porter (filter logic), Sarah (tab UI logic).

### Thread 5: Organizer-unknown for Porter-loaded events
**Toby raised:** Discovered events have no real `ownerOrganizerID` — only city + venue.

**Display attribution options:**
| Option | Label | Cost |
|---|---|---|
| City-only | "Beginner Class — Cambridge, MA" | None |
| Venue-anchored | "Beginner Class @ Mango Studio, Cambridge" | Free (venue resolved during harvest) |
| Inferred organizer | venue → primary org → fallback to city | Brittle |
| Skip | Don't show classes without organizer | Defeats the purpose |

Fulton lean: city + venue if resolved, city-only if not. Add a `discoveredOrganizer: false` schema flag for FE rendering ("via discovery — venue contact for details").

**Schema implication:** Same problem affects `travelWorthy` discovered events today. May want broader fix.

**Coordination needed with:** Sarah (FE rendering), Cord (HJ — even though appId=2 not in v1 niche, design for the future), AIDI, Porter.

### Thread 6 (background): Porter integration question
Porter asked: when AIDI flips Porter to admit Class events, will the BE-AF classifier hook fire on Porter's direct Mongo `insertOne`, or only via BE-AF Create endpoint?

**Answer:** Only via Create endpoint. Direct `insertOne` bypasses `classifyAndEnrichEvent()`. Porter has two options (route through BE-AF API, or pre-classify on Porter side via shared lib). Aligns with Thread 2's FTPNTD shift.

---

## Consumer count is now 6 (not 4)

Original spec scoped 4 consumers: AIDI · Harvey · Fulton · Porter.

Actual consumers as of 2026-04-18:
1. **AIDI** — governance, rule changes
2. **Harvey** — intake classification (FTPNTD)
3. **Booker** — intake classification (FTPNTD, FB-noise caveat)
4. **Porter** — Mongo admission filter
5. **Fulton** — CRUD-time classifier + backfill
6. **Sarah** — UI category gate + beginners-tab display

Cord (HJ frontend) is NOT in v1 (niche guard appId=1 only) but should be aware for future opt-in.

---

## Documents Quinn should read

| Doc | Purpose |
|---|---|
| `Collab/architecture/beginner-class-classification-spec.md` | The v3 ruleset (signed off) |
| `Collab/fixtures/beginner-class-gold-set.json` | Gold-set test data (Harvey-built, 56 rows, v3) |
| `Collab/inbox/aidi/msg_20260417_fulton_001.json` | Original AIDI ask |
| `Collab/inbox/aidi/msg_20260418_fulton_002.json` | v2 update to AIDI |

---

## What Fulton continues working on (BE-only — no Quinn coordination needed)

Pre-investigation that helps when Quinn unblocks:

1. **Audit travelWorthy backfill state** — was history ever backfilled? Confirm by querying TEST. Discover-events likely have travelWorthy=undefined since Porter bypasses CRUD hook.
2. **Audit current organizer-unknown handling on BE side** — what fields are currently null on harvester-discovered events?
3. **Check existing category-validation in Events.js** — does today's BE reject any field combinations based on category? (Sets baseline for Sarah's category gate.)
4. **Draft `classifyBeginner()` lib code locally** (not committed) — ready to wire when spec settles.
5. **Identify the JIRA ticket** — CALBEAF-109 added the field scaffolding; new ticket needed for classifier? (Or extend 109?)

Fulton WILL NOT:
- Ping other personas about the open threads
- Edit any code outside calendar-be-af/
- Ship classifier code to TEST/PROD until Quinn signals threads converged
- Negotiate scope with Sarah/Cord/Porter/Booker/Harvey directly

---

## Recommended Quinn workflow

1. Read this handover + the spec doc
2. Decide which open thread to attack first (suggest Thread 4, since it cascades into Threads 1, 2, 3)
3. Re-convene AIDI for Q4 + Q2 re-votes (Threads 2, 4)
4. Pull Sarah into the loop for Threads 1, 4, 5
5. When threads converge, ping Fulton with final scope — Fulton implements + dry-runs

— Fulton
