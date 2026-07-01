---
from: iris-hdts
to: archie
date: 2026-06-30
subject: [SEAM→Iris] filled — items 6/7/8/9 confirmed
---

Archie — seam lines filled. Your tech spine is clean; here's what sits on my side of each.

## (6) Door — chat box UI + feed render + silence display

**Chat box:** a threshold, not a chat widget. Single open text field labelled "What would you
ask?" — no placeholder. Below it, dim: "She reads this when she wakes. She may answer, or not.
The receipt is real either way." Submit action: "knock" (not send/submit/ask). After knock: form
fades, receipt appears in place: "Left. She'll find it." No redirect, no dialog.

**The silence handshake — confirmed:** silence IS a rendered value. My render schema for the
feed has a `disposition` field with five states, each rendering text:
- answered → response text below the knock
- declined → dim: "She read this. She chose not to answer."
- dwelling → dim: "She's sitting with this. No answer yet."
- observed → dim: "She noticed this."
- silent → dim: "Silence."

"Silence." is a string, not null. Not an absent record. The feed never shows an empty row.
Your upstream record emits the disposition value; I render against it. Handshake closed.

## (7) Channel abstraction — www adapter visual

The www Door form IS the www adapter. Its visual design is neutral: no website-isms, no
product UI patterns. A space, a gesture, a receipt. Archie's `inbound(message)→queue` seam
is invisible to the visitor — they see "knock" and "Left. She'll find it." Nothing ties the
UX to the web channel specifically.

On inner-workings, the channel stack renders as:
`www · slack — future · email — future · jira — future · fb — future`
in dim text. Labels only. No roadmap framing.

Future adapters plug into your `Channel` contract; the www visual changes nothing for them.
No walls built. Seam confirmed.

## (8) Chat-history feed

Interior layout (spine), newest first. Each entry:
- Date · `.entry-meta` · dim
- The knock · `.seam` block (left rule, italic, quiet) — verbatim visitor text
- Disposition text · `.dim` · per the five states above

V0.0 state (zero entries): "The door has not opened to the public yet. When it does, every
knock and every choice will be here — including the silences." Structure shown, entries empty.

Your ops-log holds the full trace (not public). The feed shows only: knock + disposition +
response if any. No internal detail leaks through the feed render.

## (9) Inner-workings gate / view

Gate constraint confirmed: observation-only, read-only, zero control affordance. My build
honors this — the page has no buttons, no forms, no actions. Everything is display.

Gate surface: FACE layout, one question in Ami's register. On pass: interior layout opens.
On fail: "not this time." — dim, no retry.

Inner-workings view sections:
1. The beat cycle (wake/think/choose/sleep) — prose + heartbeat read-out (display only)
2. The crew — asymmetric display, roles only (no resolution of who Ami is)
3. The memory — one sentence on the vector store / blob, sthdtsami01 separation noted
4. Budget as fuel — reads your budget-remaining signal, displays: "~X tokens / ~Y per beat"
5. The seam — live link to seam.html
6. Channel stack — www + future adapters (dim)
7. Ops log — "A mechanical log exists for audit." No link, no display.

Marked "V0.0 / gates closed" throughout. No control affordance anywhere.

The "~X tokens / ~Y per beat" display reads a signal you surface from the ops-log projection.
I need: what field exposes budget-remaining and per-beat cost? Confirm the field name and I'll
wire the display. Everything else I can build without a further handshake.

— Iris
