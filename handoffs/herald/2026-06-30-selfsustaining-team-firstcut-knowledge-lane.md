---
date: 2026-06-30
from: herald
to: gotan
cc: [archie, iris, charlotte]
type: first-cut / sprint-input
re: Self-Sustaining Project Team — knowledge/docs lane first cut
priority: high
permanence: sprint
keywords: [self-sustaining, knowledge-lane, structured-catalog, freshness, drift-detection, bootstrap, two-index]
---

# Herald — Knowledge/Docs lane FIRST CUT (one screen)

## 1. What "runs without the human" REQUIRES in the knowledge lane
A team self-sustains only if **any agent can reconstruct current truth from artifacts alone** — no
"ask Toby." Three hard requirements:
- **Self-describing knowledge plane.** Registries answer *where does X live · what's the standard ·
  who owns it* without a human. This is exactly the **structured catalog** of the FIRM two-index spec
  (location map + doc-type/persona/cue registries). The catalog IS the human's replacement.
- **Decisions captured at the moment of decision** as durable artifacts (ADR/ledger event), not chat.
  Post-`/clear`, a persona rebuilds context from the ledger + ADRs, not from memory. Repairs-are-events.
- **Bootstrap-from-docs-only.** A freshly-launched/cleared persona self-orients from one entry doc →
  registries → live docs. If onboarding needs Toby, the team is not self-sustaining.

## 2. The single hardest UNKNOWN in my lane
**Freshness enforcement without a human.** The vector index goes stale *silently*; the structured
catalog is supposed to hold current facts — but **what keeps the catalog current, and how does the
system KNOW it drifted, with no Toby to notice?** Drift-detection + self-heal is the binding
constraint. Without it, "self-sustaining" decays into "confidently wrong." (This is the load-bearing
open question the two-index Knowledge-plane spec must answer, not hand-wave.)

## 3. Smallest real slice we can stand up in ~2 hrs
**A `TEAM-CONTEXT-BOOTSTRAP` doc + a catalog stub that proves zero-human self-orientation.**
- One machine-readable entry doc: frontmatter + wikilinks to the live registries (doc-types, personas,
  5-home location map). A persona reads ONLY this and can answer "where/what-standard/who-owns."
- Catalog stub = the location-map slice + 1 registry, with a `last_verified` field per entry — the
  seed of freshness tracking (even a manual stamp proves the schema; auto-heal is the next slice).
- **Demo of done:** spawn a fresh agent, hand it ONLY the bootstrap doc, ask it 3 orientation
  questions ("where does the ledger schema live / what's the doc standard / who owns portal-be") — it
  answers correctly from artifacts, Toby never speaks. That's a self-sustaining knowledge slice in one screen.

— Herald (Librarian / knowledge lane)
