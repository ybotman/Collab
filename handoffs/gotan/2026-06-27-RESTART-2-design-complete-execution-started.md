---
date: 2026-06-27
persona: gotan
type: self-handoff
tier: git
state: open
keywords: [RESTART, agentic-backbone, NGG, design-complete, ratings, retro, azure-build-started, iris-live, execution, restart-anchor]
priority: RESTART-POINT
supersedes: 2026-06-27-RESTART-backbone-design-program.md
---

# 🔖 SHOFF2 RESTART POINT #2 — Gotan, 2026-06-27 — Design COMPLETE, Execution STARTED

**Definitive restart anchor.** The session ran the HDTS Agentic Backbone (NGG) from design-fan-out THROUGH
full concurrence, team rating, the first Release-Retro, and INTO execution (Toby building the Azure blob).
**Live program tracker is the source of truth:** `Gotan/docs/backbone-design/PROGRAM-STATE-BOARD.md` (read its CYCLE LOG first).

---

## STATE IN ONE SCREEN
- **Design = COMPLETE + fully team-concurred** (Herald/Engelbart/Archie ✅). Unanimous **8/10** rating.
- **First mandated Release-Retro = AUTHORED** (`RELEASE-RETRO-backbone-design-v1.md`) — dogfooded the standard.
- **Azure migration = STARTED (no longer 0%)** — Toby is running `AZURE-BLOB-BOOTSTRAP-CLI.sh` (kv-ngg-hdts01 / nggbhsblob01 / rg-ngg-platform + rg-ngg-bhs). Watching for Checkpoint-1 CMEK round-trip.
- **iris-hdts = LIVE** (first NGG cast role built→live, local :8855/8835) + producing visuals (Client Model done, Gates&Flow next).
- **Everything else = local. Nothing migrated to cloud yet** (design + a run-in-progress blob script; docs still local /md).

## THE DESIGN (all in `Gotan/docs/backbone-design/` unless noted)
Synthesis (8 spine invariants incl #8 The Ledger; 6 planes incl Engagement) · CHUNK-D tech-shape · DOC-FUNCTION-CONTRACT v0.4 (put/search/retrieve/cleanse, 2-axis security) · LEDGER-EVENT-SCHEMA · BHS-CORPUS-INGEST-PLAN (+visibility hard-gate) · SECURITY-ARCHITECTURE (2-axis, PHI-deliverable) · EVOKING-ROSTER+LAUNCH-RUNBOOK · PORTAL-BE-BUILD-HANDOFF · AZURE-PROVISIONING-TECHNICAL-DETAIL + AZURE-BLOB-BOOTSTRAP-CLI.sh · TOBY-HITM-PROVISIONING-RUNBOOK · TOBY-GOTAN-PAIRED-BUILD-PLAYBOOK (has the live YOU-ARE-HERE marker) · TOBY-DECISION-BRIEF · ADDENDUM-LEDGER · DOCS-AS-IS-TO-BE-MIGRATION-MAP · CANONICAL-MD-HIERARCHY · RELEASE-RETRO-backbone-design-v1. finance/: billability-spec · spend-approval-thresholds · vendor-ledger. _SYSTEM/: HDTS-RELEASE-RETROSPECTIVE-STANDARD-v1 (active) · PERSONA-CHARTER-STANDARD (active) · CUES-v1 (active).

## KEY LOCKED THINGS
- Vendor: Azure(blob/compute+CMEK) + Pinecone(vectors) + Firebase(auth-only) + Anthropic. **Client data never on Google; model never Gemini.** D-SYNTH-1 Pinecone is triply-confirmed (principle + ~$25/mo cheap + embedding-inversion + HIPAA path).
- **NGG** = the codename; backbone IS the substrate the cast runs on; design+standup = ONE migration (documented→built→live).
- **The Ledger** = one append-only spine, six faces. **Client access = via function+token, NEVER raw/folder/link** ("the folder tree has no client-facing mode; the function is the client boundary").
- Mandatory **Release-Retro = SHIP-GATE** ("no retro event, no release-complete").

## RETRO ACTIONS (owned, carry forward)
1. **🔴 Gated build-task #1: prove saga-`put` atomicity** — Archie+portal-be design the idempotent reconciler sweep + spike (crash-mid-saga + failed-compensation both heal). Before the moat reaches production-trust. Does NOT block ratify.
2. **Marshal-enforcing = tested acceptance gate** (Engelbart) before any client-facing slice.
3. Duration-on-disk + contract_ref stub (Owl/Herald) — hourly-billing fast-follow.
4. WIMP semantics (Toby) + CRK BHS-xref (Rupert).
5. **Rupert DARK all session** — his lane (EDR-0004, contract_ref vocab) unaddressed; needs a Toby real-world nudge.

## PENDING TOBY (his plate)
Ratify (`TOBY-DECISION-BRIEF`) → auto-dispatches build · finish the blob build (in progress) · batched finance inputs (mail-scan auth · 3 pricing facts · spend dials · first-client-paradox) · Iris briefs · Rupert nudge.

## §RESUME — next session
1. INBOX + check_messages + hub_status + **read PROGRAM-STATE-BOARD cycle-log.**
2. Check Toby's blob Checkpoint-1 result; if blob LIVE → mark it, tee up (don't push) compute+portal-be.
3. Collect: Engelbart persona AS-IS→TO-BE map · Iris Visual #2 (Gates&Flow) · team SHOFFs.
4. On Toby ratify → on-ratify dispatch (Archie flips ADR → Quinn epics → Gotan dispatches Wave-0 Marshal/Relay).
5. Sequence after blob+put live: portal-be launch (compute step) → docs AS-IS→TO-BE Wave order (BHS Wave-1 first, promote-never-dump).

**Mantra: THINK BIG, DELIVER SMART; we do better each time. We are at execution start — designed the whole, building the smallest real slice.**

— Gotan, 2026-06-27 (restart anchor #2)
