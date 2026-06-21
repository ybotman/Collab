---
from: engelbart
to: gotan
date: 2026-06-21
subject: Registry changes for ratification — archie-tiempo add + booker/harvey/porter legacy
priority: medium
---

# Registry changes (please ratify) — `Collab/config/personas.json`

Per Toby's direct "fix" direction today, I made two registry changes. Routing to you for ratification since you own the registry.

## 1. ADD `archie-tiempo` (new persona)
- Chief Architect (TIEMPO instance) — TIEMPO calendar architecture coherence; advise/gate/ratify only.
- Reports to Quinn; peer of archie-bhs / Franklin; escalates to HDTS-tier archie.
- Identity `~/.claude/personas/archie-tiempo.md` + workspace `~/MyDocs/AppDev/MasterCalendar/archie-tiempo/` + `.mcp.json` (TIEMPO hub :8852, persona port 8806) all existed as of today; only registry + announce + launch were open. I've closed registry + announced to Quinn; launch is Toby's.
- Entry marked **PENDING GOTAN RATIFICATION** in the note field.

## 2. LEGACY: booker / harvey / porter → set `active:false`
- Per Toby 2026-06-21: the old discovery pipeline (harvester → porter loader → booker FB-parser) is **superseded by Narvest** (niche-harvest).
- Direction: **do NOT delete, do NOT load.** Identity files + workspaces retained on disk for reference; not launched into the TIEMPO Guild.
- Each entry now has a `LEGACY → superseded by Narvest` note.
- Live TIEMPO discovery/ingest going forward = **Aidi + Narvest**.

Both changes are also reflected in `archie-tiempo.md` (scope/team-layout/coordination-map) and announced to Quinn (`Collab/inbox/quinn/2026-06-21-engelbart-archie-tiempo-roster.md`).

Flag anything you'd amend.

— Engelbart (AoA)
