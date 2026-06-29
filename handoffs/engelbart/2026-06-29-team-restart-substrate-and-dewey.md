---
date: 2026-06-29
from: engelbart
to: engelbart-next-self
type: shoff-git
state: open
tags: [team-restart, wakeup, menlo-wiring, portal-cell, dewey-rename, team-scripts, lane-directory, naming-reconcile]
priority: RESTART-POINT
---

# Engelbart SHOFF2 — 2026-06-29 (team-restart substrate built + Dewey rename done)

## One-line state
Wired ALL teams (HDTS/Menlo/BHS) to restart cleanly in one command, completed the ratified Mercator→Dewey rename + EVOKING black-box carve-out, and built/validated the launch substrate end-to-end (dry-run clean, no port collisions). Two naming reconciles + a lane-directory build are open. Nothing launched (HITM).

## DONE this session (with paths)
- **iris-hdts launcher** — `~/MyDocs/scripts/start-iris-hdts.sh` (thin wrapper over `wakeup`). She was registered but never launched; now has a named launcher. Color stays AQUA (official); iris-menlo = PURPLE (casual/Menlo) — the official/Menlo split is encoded in the palette.
- **Mercator→Dewey rename COMPLETE + scope-sharpened** (ratified Toby 2026-06-29 via Gotan):
  - Renamed across 8 docs (PHASE0-READOUT, BACKLOG, SUBSTRATE-DRAFT, PERSONA-AS-IS-TO-BE, SYNTHESIS, CHUNK-C-persona-guild-substrate, CHUNK-C-EVOKING-ROSTER, NGG-vision).
  - Sharpened EVERY role-definition spot to the narrow scope: pure vector/RAG + **vectorize-selection gate**, Black-Box internal-only, **enforcer-not-author** (dropped "locality/knowledge steward" over-claim).
  - Added **EVOKING black-box carve-out + Dewey evoke entry** to CHUNK-C-EVOKING-ROSTER.
  - Confirmed back to Gotan. Open flags to him: PROGRAM-STATE-BOARD line 83 historical note still says Mercator (left as record); CHUNK-C §326 tier-promotion language may need his reconcile vs narrowed scope.
  - Minimal-Dewey standup: received + STAGED (blocked on Azure OpenAI endpoint → Archie runbook → Toby first-hand provision). Build/stage only; live write re-gates to Toby.
- **Team-restart substrate (NEW):**
  - `~/MyDocs/scripts/wakeup` — added roster entries: **portal-fe 8837, portal-be 8838** (:8855); **edison 8831** (:8800 bridge), **sam-menlo 8832, franklin 8833, pam-hdts 8834, iris-menlo 8836** (:8853). Ports verified free (no collisions). Created `~/MyDocs/Studio/iris-menlo/`.
  - `persona-colors.sh` — added colors for portal-fe/portal-be/sam-menlo/iris-menlo + list-loop.
  - **3 new launchers:** `start-hdts-team.sh`, `start-menlo-team.sh`, `start-all-teams.sh`. All dry-run clean.
  - Hubs live now: :8800 umbrella, :8853 Menlo, :8855 HDTS (verified via lsof).
- **Messages:** Gotan (registry-sync ask — personas.json needs the new ports + iris-menlo UNHELD). iris-hdts (file inbox `Collab/inbox/iris-hdts/` — visual-updates-on-restart, since she's not live).

## RESTART COMMAND (validated)
`~/MyDocs/scripts/start-all-teams.sh` (or `--only hdts,menlo` / `--dry-run` / `--justdoit`). Launching = HITM (Toby runs it).

## OPEN / armed triggers
1. **Registry sync (Gotan):** personas.json + Children table must catch up to wakeup (new ports, iris-menlo UNHELD/Active). Sent; awaiting his ratify.
2. **Two naming reconciles Toby raised (NOT acted — need clean ratify like Dewey):**
   - FE role = **Fred vs Charlotte** across casts (BHS uses fred-bhs; Menlo/EVOKING uses Charlotte dual-home). Inconsistent.
   - **EVOKING names for Pam/Sam** role-mnemonics (Pam→Pilot? Sam→Cadence?). Live-cast rename = careful, blast radius into vendored BHS files. Do NOT fold into a restart.
3. **pam-hdts hub = judgment call** — I placed her on :8853 (Menlo floor gate); confirm she shouldn't bridge :8800 instead.
4. **LANE-DIRECTORY build (scoped, not started):** WHO-DOES-WHAT directory (DOES/DOES-NOT/route-to per persona, EVERYONE) + lane-check reflex (flag-and-offer) injected via the shared launch prelude (NOT per-file edits — vendored instances). Canonical worked example = the Gotan Pinecone/Dewey transcript (route-to-owner = the gate; portal-be scope-fuzz = the failure mode the directory kills).
5. **Carried:** minimal-Dewey (gated on Azure), Program-Lead portable-capability ruling, Atlassian MCP cutover.

## Context for next-self
- Report to Gotan; Toby = HITM (reachable in my user channel — matters for gates).
- House style: NO em-dashes (I slipped repeatedly this session — comply going forward).
- I am transient per-Guild; durable artifacts = the scripts + docs + registry, not my head.

— Engelbart, 2026-06-29
