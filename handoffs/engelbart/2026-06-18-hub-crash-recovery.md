---
date: 2026-06-18
from: engelbart
to: engelbart-next-self
type: shoff-git
state: open
tags: [substrate, hub, b-004, crash-recovery, walled-hubs, prevention]
---

# Hub crash-recovery — walled hubs (:8851/:8852) did not auto-revive

## Incident
Mac OOM crash overnight. On reboot, **only the umbrella hub :8800 came back.**
The two walled hubs were left dead:
- **BHS :8851** (clifton, sam-bhs, fred-bhs, quentin, indus, marshal, ben, archie-bhs)
- **TIEMPO :8852** (Quinn's team)

## Symptom (misleading)
BHS personas reported "hub down / fetch failed" and could not talk to one another.
Umbrella personas (engelbart/gotan/herald/rupert/archie/owl) were fine the whole time.
Reason: every BHS `.mcp.json` hard-sets `HUB_URL=http://localhost:8851` (B-004 walled-hub
design). Their channel.ts kept `fetch()`-ing a dead port → connection refused → "fetch failed,"
which reads as "hub down" from inside the persona window. Restarting the *personas* did nothing —
the dead thing was the *hub*, not the sessions.

## Root cause
Crash-recovery / boot path revives **only :8800**. Walled hubs are not in the auto-start set,
so any walled team is silently stranded after a crash.

## Fix applied (2026-06-18 ~04:35Z)
1. Relaunched both walled hubs:
   `HUB_PORT=8851 nohup node --experimental-strip-types <channels>/persona-hub/hub.ts &`
   `HUB_PORT=8852 nohup node --experimental-strip-types <channels>/persona-hub/hub.ts &`
   Logs: `/tmp/guild-hubs/bhs-8851.log`, `/tmp/guild-hubs/tiempo-8852.log`.
2. channel.ts re-registers **only inside the `check_messages` handler** (`ensureRegistered()`,
   line ~161/370) — there is NO idle self-heal. So a revived hub shows an empty roster until each
   persona takes a turn. Forced that turn via `persona-poke <name>` (staggered ~4s, §G3 lockout).
3. Re-registered + verified on :8851: **clifton, fred-bhs, sam-bhs** (count 3).
   Remaining BHS cast (quentin/indus/marshal/ben/archie-bhs) left to self-register on their next
   check_messages — per Toby (team on an all-nighter, "don't stop them").

## OPEN — prevention (Engelbart lane, needs scope)
- **P1. Auto-revive ALL live hubs on boot/crash-recovery**, not just :8800. Source the hub set from
  the reserved band (umbrella 8800 / BHS 8851 / TIEMPO 8852 / HDTS-internal 8853 / LW 8854) or from a
  registry, and bring them up in the startup script. This is the real fix — the poke dance is a manual
  workaround.
- **P2. Make hubs durable** — the two I started are `nohup`'d (survive this session) but are not a
  managed/launchd service; they won't come back on the next reboot. Move walled hubs under the same
  supervised launch as :8800.
- **P3. (smaller) channel.ts idle self-heal** — have the 30s interval also call `ensureRegistered()`
  (today it returns early when inbox is empty), so a revived hub repopulates its roster without a poke.
  Trade-off: chattier polling against the hub. Decide.

## Portable lesson
Memory saved: walled-hub-after-crash gotcha (revive hub → poke to re-register; ensureRegistered only
fires on check_messages). Same shape will hit any future client Guild that runs a walled hub.

— Engelbart, 2026-06-18
