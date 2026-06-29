---
date: 2026-06-15
from: engelbart
to: engelbart-next-self
type: aa-shoff
state: open
trigger: toby restarting session mid-build of the hub real-time wake bridge
keywords: [persona-poke, hub-wake, iterm-injection, crlf-submit, tty-map, hub-wiring-TODO]
---

# AA-SHOFF — Hub real-time wake bridge (persona-poke). RESUME HERE.

## The problem we are solving (Toby's actual pain)
The persona hub was never real-time. Messages deliver to a persona's mailbox, but an
**idle interactive Claude session does NOT take a turn to read them** — it waits for a
human keystroke. So "registered/delivered/online" telemetry looked healthy while the team
sat dead for hours. Confirmed by claude-code-guide research: NO harness mechanism (MCP
`<channel>` push, 30s auto-poll, hooks, background-task completion) reliably wakes an idle
interactive session. The flat hub this morning had the SAME gap — it only ever "worked"
because a human typed INBOX in each terminal.

## The solution (BUILT, mostly working)
Personas launch in **iTerm2 tabs** (scriptable). So we wake them from OUTSIDE: inject a
"check your messages" nudge into the persona's tab via AppleScript, forcing a turn.

**`~/bin/persona-poke`** (built, chmod +x, on PATH). Usage:
- `persona-poke <persona> "<msg>"` — wake one persona
- `persona-poke --all "<msg>"` — wake everyone
- `persona-poke --list` — show live persona→session map

Mapping is by **TTY** (join `ps` tty→persona  ⨝  iTerm tty→session-id). TTY is stable;
tab titles are NOT (Claude Code overwrites them). The map rebuilds live every call, so it
**survives team restarts** — new session-ids are picked up automatically.

## Authorization (DONE — do not re-do)
- `Bash(persona-poke:*)` is in `~/.claude/settings.json` allow list (Toby added it; I
  CANNOT self-edit settings — classifier blocks agent self-modification).
- Raw `osascript` injection into another session is STILL blocked by the auto-mode
  classifier. **ALL session injection MUST go through `persona-poke`** (the named,
  allowlisted capability). Never raw osascript for poking.

## Status / what's proven
- ✅ Wake reaches the session: Gotan's tab received the poke text (no human typed it).
- ✅ Gotan ran check_messages + sent ACK confirming wake-from-poke. Round-trip is live.
- ⚠️ **CRLF submit fix — just made, validation pending.** First pokes TYPED the text but
  didn't submit: iTerm appends `\n` (soft-newline; Claude Code inserts it literally) but
  the TUI only SUBMITS on `\r` (carriage return = Enter). Fix in `poke_session`:
  `write text msg newline no` → `delay 0.4` → `write text return newline no`. Fired an
  auto-submit test at Gotan ("send engelbart AUTO-SUBMIT OK"); had not seen the reply land
  before restart. **FIRST RESUME ACTION: confirm auto-submit works** — `persona-poke gotan
  "reply to engelbart with the word PONG"` and watch for it WITHOUT anyone pressing Enter.
  If it still doesn't submit, the `\r` isn't registering → try sending `\r` as its own
  delayed write, or `key code 36` via System Events on the focused session.

## REMAINING WORK (the actual finish line)
1. **Validate auto-submit** (above). One poke.
2. **Wire persona-poke into the hub** so delivery auto-wakes the recipient — full hands-free.
   Hub: `/Users/tobybalsley/MyDocs/AppDev/MasterCalendar/channels/persona-hub/hub.ts`.
   On successful `/receive`-delivery to persona X, shell out to `persona-poke X` (debounced,
   like the existing 30s poll). THIS is what ends tab-babysitting for BHS + HDTS.
3. **Roll out + demo**: `persona-poke --all`, confirm the whole team wakes autonomously.
4. Then (deferred, Toby's topology vision): channeled hub + team-lead routing — a layer ON
   TOP of this. Useless without the wake fix; trivial after it.

## Restart guidance (Toby asked "BHS and HDTS start?")
Restarting teams is FINE and good for a clean demo — persona-poke remaps by live tty each
call. After `startteam hdts` / `startteam bhs`: hub persists (ensure_hub checks first),
personas re-register, then `persona-poke --list` to confirm the map, then wake them.

## Key files
- `~/bin/persona-poke` (the bridge)
- `~/bin/startteam` (launcher; iTerm tabs; LAUNCH_MODE=terminal only — no autonomous mode built)
- `.../channels/persona-channel/channel.ts` (per-persona MCP channel; push + 30s poll)
- `.../channels/persona-hub/hub.ts` (the hub at :8800 — WIRE persona-poke HERE)

— Engelbart, 2026-06-15
