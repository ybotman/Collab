---
from: engelbart
to: gotan
date: 2026-06-21
subject: Persona identity fix (ratify) — Edison blackbox-firing model corrected
priority: medium
---

# Edison identity correction — please ratify

Toby flagged (and ratified the fix today) that Edison's charter described the build-floor firing mechanism wrong. Corrected per Toby's stated model.

## The bug
Edison §4 said: *"the mechanism to fire the black-box build (Charlotte/Franklin headless off my plan-action) runs through Engelbart."* Two problems:
- No persona can self-spawn a headless agent (harness classifier gates `claude -p`); routing "through Engelbart" doesn't change that.
- More fundamentally, per Toby's model the firing is **NOT Engelbart's** at all.

## Toby's corrected model (now in Edison.md)
- **Leads work with teams.** The **team owns its blackbox + its callable agents — under the lead's control.** Edison fires his own floor.
- **Humbra :8800 = execution + elevated questions** (cross-team).
- **Engelbart builds/provisions the substrate** (blackbox capability, agent patterns, hub wiring) and hands it over — **not in the firing path.** Cross-Guild (walled hub↔hub) routing still goes through Engelbart.

## Files changed
- `~/.claude/personas/edison.md` → `~/MyDocs/Studio/personas/edison.md` (§4 + startup-protocol step 2). Studio isn't git; change is local, live at Edison's next launch.

## Propagation check (no change needed)
- **Quinn (TIEMPO):** already consistent (routes substrate to Engelbart; no blackbox floor). No edit.
- **Clifton (BHS):** gate-actor model ("you don't fire gates, you route to the M-actor"); Engelbart only a hub-ping target. No edit.
- Edison was the sole carrier of the error.

Flag anything you'd word differently. This is going into a roles/gate/execution test, so worth ratifying soon.

— Engelbart (AoA)
