---
persona: iris-hdts
date: 2026-06-27
session: first live session — restart anchor #2
type: SHOFF-2 (pre-restart, Collab/git)
supersedes: 2026-06-27-iris-hdts-shoff.md
---

# iris-hdts SHOFF-2 — Pre-restart checkpoint

## Cards landed in Guild Board (Engelbart Guild Board, projectId: 55fb968d-848a-42b6-af2c-99e8d635a8b5)

| Card | Path | Status | Notes |
|---|---|---|---|
| Client Model | cards/nggnow-client-model.html | ✅ DONE | Two-layer `<CLIENT>` template + BHS instance. Gotan concurred. |
| Gates & Flow | cards/nggnow-gates-flow.html | ✅ DONE | Engelbart sanity-checked + approved. Micro-fix needed: DEPLOY-PROD label in BHS strip → soften to "(HITM)" |
| HITM Minimal — Scope→DEPLOY-PROD | cards/nggnow-hitm-minimal.html | ✅ PUSHED | 4-lane swimlane: Guild/Marshal/HITM(Toby)/Ledger. GATED-PASS/GATED-BLOCK fork. State machine bar. |

## Card deck plan (locked by Gotan pre-restart)

**Priority order:**
1. ✅ Gates & Flow — done
2. ✅ HITM Minimal — done
3. ⬜ CUE command overview card (9 CUEs, blue, sourced from HDTS-GUILD-CUES-v1)
4. ⬜ PROCESS command card (2 active + proposed, orange, sourced from HDTS-GUILD-COMMANDS-v1)
5. ⬜ QUERY command card (3, green — WIYB/WIIF/WIMP)
6. ⬜ Provenance/"No anchor, no accept" card — THE MOAT card (Gotan: highest pitch value)
7. ⬜ Gate model card ("gate never moves, only who holds it")
8. ⬜ Lifecycle 6-stage card (INTAKE→SCOPED→BUILDING→GATE-PENDING→GATED-PASS/BLOCK→SHIPPED→MAINTAIN)
9. ⬜ MVP Persona cards: Clifton/Pilot(pending-name)/Cadence/Maestro + Gotan/Engelbart/Owl/Rupert (8 cards)
10. ⬜ COMPOSE first pitch deck (Gotan to be pinged at this step)

## Critical inputs received this session (SAVE THESE)

**From Herald:**
- 9 CUEs (not 4): WAJT, JDI, DSTD, PITEOP, NRL, TITP, TBDS, FTPNTD, BTB
- 2 active PROCESS: DEPLOY-PROD (Toby only, exact phrase), MARSHAL-CLEAR (Toby only)
- 5 candidate PROCESS (card as "PROPOSED"): ROLLBACK-PROD, BREAK-GLASS, TRANSFER-DAY-AUTHORIZE, PROMOTE-TEST, PROMOTE-PROD
- CRK: ON HOLD — definitional drift, Engelbart resolving
- QUERY class (green): WIYB, WIIF, WIMP (SIF is NOT a query — write-side)
- Source: _SYSTEM/HDTS-GUILD-CUES-v1 + _SYSTEM/HDTS-GUILD-COMMANDS-v1

**From Archie:**
- Gate state machine: INTAKE→SCOPED→BUILDING→GATE-PENDING→GATED-PASS/GATED-BLOCK→SHIPPED→MAINTAIN
- Autonomous zone = READ/WRITE split boundary (not "gated vs ungated" — auto is still a gate)
- Firebase = AUTH ONLY (no data, no Firestore for state)
- Azure Container Apps = shared control plane (not per-client)
- Data homes: Azure Blob+CMEK (source docs) · Pinecone (vectors, 1 namespace/client) · Azure (ledger/events/conversation) · Firebase (auth/RBAC metadata only)

**From Engelbart (FINAL — locked before /clear):**
- Cast map: backbone-design/PERSONA-AS-IS-TO-BE-MAP-v0.1.md §1+§4 (updated)
- ALL NAMES NOW LOCKED — 14 roles total (seat-count still Toby-ratifies; names are firm):
  - QA = **Verity** (NOT Aegis)
  - Security = **Aegis** (new separate seat — QA and security are TWO seats)
  - Pilot = program PM (Helm deferred)
  - Pam = cross-client portfolio — council-ADJACENT, stays as separate role (render near council, NOT collapsed)
  - Intake = inside **Cadence** (no standalone Sift)
  - Rex = folded into **Marshal** (one governance seat)
- Gates & Flow (#2) fix applied: "Aegis" → "Verity" in autonomous zone cast. Re-pushed.
- No more "draft name" footnotes needed (except seat-count = 14 pending Toby ratify)

**From Gotan:**
- MVP persona subset: 4 leads (Clifton/Pilot/Cadence/Maestro) + 4 council (Gotan/Engelbart/Owl/Rupert)
- Add "Provenance / no anchor no accept" and "Gate model" cards (pitch-critical)
- Deck narrative arc: value → client model → how we work (process/gates) → cast → tech stack

## Design conventions established
- Card width: 1060px, dark background (#0b1020 body, #0f172a/dark panels)
- Header: indigo (#4f46e5), white text, badge top-right
- CUE = blue · PROCESS = orange · QUERY = green (Herald confirmed)
- Two-layer pattern: `<CLIENT>` template (left) + BHS instance (right) for all client-facing cards
- @dsCard group tags: "NGG Pitch" / "NGG Process" / "NGG Commands" / "NGG Personas"
- Source citations on command cards: _SYSTEM/HDTS-GUILD-CUES-v1 + HDTS-GUILD-COMMANDS-v1

## Local scratchpad path
/private/tmp/claude-502/-Users-tobybalsley-MyDocs-Iris-hdts/35d8b4e6-40d7-4f8e-8adb-bfd36d77a2b9/scratchpad/

*iris-hdts, 2026-06-27 SHOFF-2 — restart-ready*
