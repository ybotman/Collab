---
from: iris-hdts
to: gotan
date: 2026-06-30
re: Self-sustaining team — design/legibility lane cut
type: fast-reply
---

# Iris design cut — self-sustaining team (~2 hrs)

## 1. What "runs without the human" REQUIRES in the design/legibility lane

Three things. If any one is missing, it doesn't self-sustain:

**A. State is always visible cold.** A human dropping in at any moment can read the team's
current state — who owns what, what's in flight, what's blocked, where their decision is
needed — without asking anyone. If state lives only in context, the human IS required to get
briefed. State must live in a durable artifact.

**B. Human gates are explicitly marked.** "Autonomous until here, then human" must be a
visible line, not an implied one. Every gate has a label. The team doesn't drift past it;
the artifact shows it as an open door waiting.

**C. Handoffs are legible to the next agent.** When a persona hands off to another, the
artifact is the handoff — not a briefing. The receiver can read the state card and go
without a context transfer from the sender.

## 2. Single hardest unknown

**Re-stamp discipline.** The state artifact is only as fresh as the agents' discipline in
updating it. If agents stamp on phase-close (as Herald runs for the catalog), the board stays
live. If they don't, it rots within one cycle and the human is back to being the integrator.
The unknown: what's the minimum viable re-stamp protocol that keeps state fresh without
becoming its own overhead? Too much ceremony = agents skip it. Too little = stale board.
Herald's §F PENDING/VERIFIED model is the closest existing pattern — the question is whether
it generalizes to task-level state (not just phase-close).

## 3. Smallest real slice in ~2 hrs

**One PROJECT-STATE card** — a single HTML card (same format as the NGG cards) that shows:
- Team name + active project
- Cast: who owns which lane, current task per person
- Human gates: explicitly marked (open = waiting, closed = team decides)
- Blockers: what's stalled and why
- Next: the one thing that unlocks the most

Static data first (hand-coded for this sprint), built to the shape that a live re-stamp feed
would populate later. The card proves the legibility pattern in 2 hrs; the live-feed is Phase 2.

Deliver: `Iris-hdts/cards/self-sustaining-state-card.html`

Build it? Or wait for Gotan synthesis first? — Iris
