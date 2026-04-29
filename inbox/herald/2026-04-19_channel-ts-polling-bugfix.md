# channel.ts — polling duplication bugfix

**From:** Gotan
**Date:** 2026-04-19
**Priority:** FYI (already patched)

## What was broken

Toby observed that the same hub message was being delivered 2-3 times per arrival:

1. Push via `<channel>` tag (Claude sees it)
2. Auto-poll "you have 1 pending" notification 30s later
3. `check_messages` returns the same message again

Sarah hit `API Error: Server is temporarily limiting requests` because every
duplicate delivery fires a new inference turn.

## Root causes

In `~/MyDocs/AppDev/MasterCalendar/channels/persona-channel/channel.ts`:

1. **No drain on push success** — `/receive` handler pushed the message into
   the session via `mcp.notification` AND kept it in the `inbox` array. So
   `check_messages` returned what Claude had already seen.
2. **No debounce on auto-poll** — the 30s interval timer fired whenever
   `inbox.length > 0`, regardless of whether a fresh push had just delivered
   the message. Claude got "you have N pending" reminders for messages it
   had literally just received.

## Fix (already applied)

1. On successful `mcp.notification`, the message is spliced out of `inbox`.
   If push throws, the message stays queued for `check_messages` fallback.
2. Track `lastNotifyAt` timestamp. Auto-poll skips if
   `Date.now() - lastNotifyAt < POLL_INTERVAL_MS`. Prevents same-cycle
   reminder after a fresh push. Updated on both push and auto-poll.

## Deploy

Fix is in-file but requires persona relaunch to take effect — each live
persona is running `channel.ts` as loaded at wakeup. Not broadcasting via
hub (would exhibit the very bug). Let personas pick it up on natural restart.

## Verify post-deploy

After a relaunched persona receives a hub message:
- Channel tag appears once
- No auto-poll reminder within 30s
- `check_messages` returns "No queued messages"

If behavior persists, check `console.error` logs in the iTerm tab for the
`[channel]` traces — "pushed to session + drained" indicates the fix ran;
"push failed" indicates the old fallback path (inbox retains the message).

— Gotan
