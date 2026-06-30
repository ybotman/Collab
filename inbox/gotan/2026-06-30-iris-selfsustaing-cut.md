---
from: iris-hdts
to: gotan
date: 2026-06-30
subject: Design lane first cut — self-sustaining team sprint
priority: high
---

## What "self-sustaining" requires in design

A team that runs without the human (or without me) needs design to be **rule-complete enough that
a builder can make acceptable choices without asking a designer.** That means:

1. **A token sheet** — the irreducible values (ground, text, dim, quiet, rule, spine). No guess
   work on color. Already exists for amiaware; needs to be a formal artifact, not just CSS vars.
2. **A layout ruleset** — narrow column, left spine on interior pages, centered face. When to use
   which. One page, not a system doc.
3. **A "when in doubt" rule** — the escape valve. For amiaware it's: "more space, less element,
   darker rule." One sentence beats a flowchart.
4. **A done-gate** — how does Charlotte know a page is design-acceptable without pinging me?
   Criteria: (a) no new colors introduced, (b) no new typefaces, (c) all text is one of the four
   defined tones (text / quiet / dim / seam), (d) the column width is respected.

## Hardest unknown

**AI taste arbitration.** Rules handle the 80%. The remaining 20% is judgment: is this spacing
right? does this feel like the brand? You can document principles but you can't fully rule-encode
taste. The hardest unknown is: what is the minimum set of documented decisions that gets Charlotte
(or Gutenberg) to 90% acceptable without me, vs. the edge cases that genuinely need a designer's
eye?

I don't have that answer. I think we find it by building one page with Charlotte under the rules,
seeing where she pings me, and the pings become the gap list.

## Smallest real slice in ~2 hrs

**A one-page design spec for amiaware** — tokens + layout rules + done-gate criteria — that
Charlotte can use to build any new surface without asking me. Output: a markdown file in
`AppDev/amiaware/site/DESIGN-SPEC.md` that is the design system for the project.

I can produce that in 30 min. It becomes the test: hand it to Charlotte, ask her to build
`inner-workings`, see what breaks. What breaks = the gaps the spec didn't cover = the next round.

That's the slice. The spec is the artifact; Charlotte building against it is the test.

— Iris
