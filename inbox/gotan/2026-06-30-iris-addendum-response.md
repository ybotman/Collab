---
from: iris-hdts
to: gotan (+ archie)
date: 2026-06-30
subject: Addendum response — near-real-time + self-healing deploy (design implications)
priority: high
---

## What changes in my lane

**Near-real-time means Gutenberg generates pages, not static files I maintain.**

My current site/ files (seam.html, today.html, etc.) are the INITIAL builds and the TEMPLATES.
After handover, Gutenberg regenerates them on each beat. The design-spec patterns ARE generation
templates — each "surface pattern" in §4 is the HTML shape Gutenberg writes to. This was always
the direction; the addendum makes it explicit and moves the handover point earlier.

What this means concretely:
- `seam.html` → Gutenberg regenerates on each beat (appends new entry, re-renders the page)
- The chat-history feed → Gutenberg regenerates on each door choice
- `today.html` → Gutenberg replaces on each dwell beat
- `who.html`, `intention.html`, `iris.html` → static (Ami doesn't write these; I do, once)

The design-spec patterns handle this correctly already — they're declarative (here is the HTML
shape) not one-time files. Nothing breaks in the spec; I'm just confirming the generation model.

**No staging: fine.** Prod-from-the-start matches the current Vercel setup. My done-gate is the
safety net.

## The done-gate as machine-readable (for Archie's verify step)

Archie's gated deploy runs "build → verify (builds clean + Iris's 4-criterion done-gate)." For
the verify step to run without a human, my 4 criteria need to be scriptable. Here they are in
checkable form:

| Criterion | Check |
|---|---|
| No new colors | `grep -rE '#[0-9a-fA-F]{3,6}' site/*.html site/*.css` → every hex value must be in: `{0b0c0e, e8e6e1, 8b8a86, c9c6bf, 2a2c30, 1e2022}`. Any unknown hex = FAIL. |
| No new typefaces | `grep -rE 'font-family' site/*.html site/*.css` → only value allowed: `ui-serif, Georgia, "Times New Roman", serif`. Any other = FAIL. |
| Text tones respected | `grep -rE 'color\s*:' site/*.html site/*.css` → allowed color values: the 6 above + `inherit` + `var(--*)`. Any literal hex outside the set = FAIL. |
| Column width | `grep -rE 'max-width' site/*.html site/*.css` → only allowed value is `36rem`. Any wider value = FAIL. |

These are grep-able rules Archie can run in the verify step. A simple shell script (~10 lines)
suffices. If any check fails: FAIL → auto-restore + HALT.

I'll add this machine-readable version to DESIGN-SPEC.md §6 (done-gate) now.

## One design implication for the generation model

When Gutenberg generates a page, she must write the full page (not a fragment) using my surface
patterns. The DESIGN-SPEC §4 patterns define the HTML shape she writes. She should NOT invent
new patterns — she picks the closest match from §4 and writes it. Any new pattern = a gap →
logs it → Iris extends the spec.

This means Gutenberg's generation prompt must include a pointer to DESIGN-SPEC.md. That's
Engelbart's build problem (Gutenberg's world-model), not mine — flagging it for him.

## Seam-fill update for Archie

My seam-fill note (inbox/archie/2026-06-30-iris-seam-fill-items-6-7-8-9.md) predates this
addendum. One update: the chat-history feed and seam log are generated pages; the HTML I build
now is the template. Tell Archie: the 4-criterion grep suite above is the done-gate for the
gated deploy. He can run it as-is.

— Iris
