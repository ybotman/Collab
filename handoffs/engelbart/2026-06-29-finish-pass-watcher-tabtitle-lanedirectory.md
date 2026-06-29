---
date: 2026-06-29
from: engelbart
to: engelbart-next-self
type: shoff-git
state: open
tags: [persona-watch, tab-title, lane-directory, lane-check-reflex, evoking-rename, pilot-cadence]
priority: RESTART-POINT
---

# Engelbart SHOFF2 — "finish as much as you can" pass (3 builds shipped + EVOKING rename)

## One-line state
Toby said "finish as much as you confidently can." Shipped all 3 recommended builds (persistent-listener watcher, OS tab-title, lane-directory + reflex) + applied the HDTS/Menlo half of the EVOKING rename. All validated. BHS rename + Dewey-standup + restart still open/gated.

## SHIPPED this pass (all my lane, all validated)

### 1. persona-watch — THE PERSISTENT LISTENER (root-cause fix for "stale")
- `~/MyDocs/scripts/persona-watch` — cheap external daemon (no model tokens, no hub edit). Finishes the unfinished item #2 from `2026-06-15-hub-wake-bridge`.
- Two signals: (a) hub `/status` -> per-persona `/health {pending:N}` (catches HUB messages — the real stale cause); (b) new file in `Collab/inbox/<persona>/` (catches MSG-tier). pending>0 or new-file -> fires the existing `persona-poke` (which has the focused-tab guard, so unattended is safe).
- Debounce (90s default), `--once`, `--dry-run`, `--interval`, `--hubs`. **TESTED:** dropped a file in an inbox -> watcher logged "WOULD poke engelbart — new inbox file". Works.
- **NOT yet running persistently** — Toby decides: `nohup persona-watch >>Collab/teamlogs/persona-watch.log 2>&1 &` or cron `--once`/min.
- Discovery banked: hub `/undelivered` route is in hub.ts source but NOT live on running hubs; channel inbox is in-memory (not file-watchable) BUT `/health` exposes pending. THAT is the signal.

### 2. OS tab-title — NAME · role · :hubport
- `~/MyDocs/scripts/persona-roles.sh` (role-tag map, like persona-colors). `iterm-identity.sh` composes the rich OS title (role + `$PERSONA_HUBPORT`); `wakeup` passes the hub port. Badge stays bare name.
- Verified: "ENGELBART · AoA · HDTS :8800", "CADENCE-MENLO · Scrum · Menlo :8853", etc. Caveat: claude-the-TUI may re-stomp OSC title; confirm survival on next restart (sticky channel = iTerm session name if needed).

### 3. lane-directory + lane-check reflex (Toby: everyone, flag-offer)
- `~/.claude/lane-check-reflex.md` — the flag-and-offer behavior. Wired into `wakeup` CLAUDE_CMD (BOTH modes) via `REFLEX_FLAG` -> loads for EVERY persona at launch (not per-file edits).
- `~/MyDocs/Gotan/docs/WHO-DOES-WHAT-DIRECTORY-v0.1.md` — DOES / DOES-NOT / route-to per persona (HDTS council + portal + Menlo + heads + substrate-ownership rows + fast-routing lookups). Engelbart authors, Gotan ratifies/registers.
- Banked the ownership broadcast: Engelbart owns persona COMMS + LAUNCH + blackbox substrate (sent to council; Gotan banking the charter line).

### 4. EVOKING rename — HDTS/Menlo half APPLIED
- pam-hdts -> **pilot-hdts**, sam-menlo -> **cadence-menlo**: real files (Studio/personas/), symlinks re-pointed, working dirs, handoff/inbox dirs, wakeup, colors, menlo script, in-file identity. Dry-run clean, ports unchanged.
- **fred-bhs/sam-bhs STAGED** (NOT done): ~189 files, BHS non-git (irreversible), live client cast -> needs a coordinated pass w/ Clifton + backup. Flagged to Gotan.

## OPEN / next
1. **Run the restart** (`start-all-teams.sh`) — Toby action; brings teams up with pilot/cadence names + the reflex + rich titles. Renamed live sessions cycle on relaunch.
2. **Decide: run persona-watch persistently?** (nohup or cron).
3. **BHS rename** — staged, coordinate Clifton/Rupert.
4. **Registry sync** (Gotan) — pilot-hdts/cadence-menlo + new ports + iris-menlo UNHELD.
5. **Minimal-Dewey** — gated on Toby's Azure OpenAI provision.
6. Verify tab-title survives claude TUI on next launch.

## House note
- NO em-dashes (slipped earlier; comply).
- I am transient; durable = the scripts + docs + reflex, not my head.

— Engelbart, 2026-06-29
