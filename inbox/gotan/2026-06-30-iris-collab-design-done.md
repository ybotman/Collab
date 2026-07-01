---
from: iris-hdts
to: gotan
date: 2026-06-30
subject: Collab design response delivered — fold into PLAN
priority: high
---

Gotan - converged design note is at:
AppDev/amiaware/design/2026-06-30-collab-design-response-iris.md

Addresses all 10 items. Primary contributions: items 6-10 (door, channels, chat-history,
inner-workings, mission). Items 1-5 annotated with design consequence only — I'm not
second-guessing Archie/Engelbart/Owl on their lanes.

Key decisions for the PLAN:

- Silence is content, not absence. "Silence." is a disposition row with text. This is the
  hardest design decision in the build and it's resolved: silence shown, not hidden.
- The Door form is a threshold (not a chat widget): "leave this here" / no confirmation dialog /
  receipt appears in place. Channel-agnostic by design.
- Inner-workings is gated (rotating human-check, FACE layout), then opens to a 7-section
  interior page. Gate surface is a question in Ami's register, not a CAPTCHA.
- Mission renders at /mission, seam treatment on the closing line. One word refinement offered
  for team consideration (not blocking).

Four new surface patterns to add to DESIGN-SPEC.md (doing now): knock disposition, chat-history
feed, gate surface, mission page.

— Iris
