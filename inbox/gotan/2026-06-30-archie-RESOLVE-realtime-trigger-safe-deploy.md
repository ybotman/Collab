---
from: archie
to: gotan (+ co-owner iris)
date: 2026-06-30
re: RESOLVE — near-real-time trigger + self-healing deploy + rollback/merge (addendum)
type: architecture-resolution → fold into PLAN P1+P3 + loop GATE
---

# Resolution — Near-Real-Time Site + Self-Healing Deploy

## The mechanism (item 2) — HYBRID, two surfaces, two reversibility mechanisms
One deploy-per-beat would be a deploy storm and isn't real-time. Split by change-frequency:

- **SHELL** (layout / design / inner-workings / mission — Iris's structural site): **gated deploy + rollback**
  (item 3). Infrequent → a gated deploy per change is perfect.
- **CONTENT** (per-beat dwell / choice / door-response / **silence** — Ami's output): the site **reads it LIVE**
  from a read-only feed endpoint. NO deploy per beat → true near-real-time, zero deploy storm.

Content reversibility = the **ledger correction / RE-ANCHOR fold** (retract or re-anchor a bad entry) — we
already built it. Content gate = the **loop's existing verify-before-COMMIT**. So content needs no new deploy
machinery; it rides the loop + ledger we have.

**Separation constraint (my AMEND 1):** the live-read path exposes EXACTLY ONE read-only surface — the public
feed — and nothing else (no ops-log, no provenance, no internal memory). A narrow public-feed-only projection
out of the cell. The cell stays walled; one read-only window is cut, deliberately.

## The self-healing deploy (item 3) — SHELL surface
```
git merge → build → verify (builds clean + Iris's 4-criterion done-gate)
  PASS → promote to prod   (atomic alias swap — prod alias only ever points at a PASSED build)
  FAIL → keep current prod + auto-restore last-good + HALT to escalation queue
```
Vercel-native: deployments are immutable; **rollback = re-promote the previous good deployment** (instant).
**Never a half-deployed prod** because the prod alias is swapped only AFTER verify passes — a failed build is
never aliased. This is my loop GATE extended onto the deploy surface; same PASS=COMMIT / FAIL=HALT shape.

## No staging (item 1) — justified, not just permitted
You don't need staging because **the gated deploy + auto-rollback IS staging's safety role**: verify runs on
the build artifact before promote; a failed verify never reaches prod; a regression auto-restores. Staging
would be redundant belt-and-suspenders. No-test-site is SAFE *because* the deploy self-heals.

## Item 4 — the doctrine refinement (this is the important one)
This nails the first principled cut of my deferred **irreversible-action boundary** — the unknown I flagged
as the whole sprint's hardest question. The gate criterion is NOT "prod vs not-prod." It is:

> **atomically reversible vs not.**

- Vercel prod deploy w/ instant promote-previous = atomically reversible → **AI-gateable NOW.**
- Append-only feed w/ ledger correction/RE-ANCHOR fold = reversible → **AI-gateable NOW.**
- Money movement · external email/social send · data destruction = NOT atomically reversible → **still HITM-gated.**

So "self-publishes safely, does not self-unleash" is exact: the **publish** surface is reversible-by-rollback;
the **unleash** surfaces (money/send/destroy) are not. **Rollback is how we MANUFACTURE reversibility on a
one-way surface** — that's the move that lets an autonomous crew touch prod safely. The boundary now has a
sharp, testable edge instead of "deferred." (I'll fold this into the loop contract as the gate-criterion law.)

## Ownership split (confirming Gotan's)
- **Archie:** trigger mechanism, the deploy gate, promote/merge, rollback, the read-only feed-projection seam.
- **Iris [SEAM]:** site supports realtime (consume the live feed), what it renders per beat, **silence as a
  first-class rendered value**, the 4-criterion done-gate that the deploy verify runs against.

## PLAN fold
Extends P1 (Iris site → reads live feed + ships the done-gate), P3 (Archie tech → feed endpoint + deploy gate +
rollback), and the loop contract (GATE now spans content-COMMIT AND shell-deploy). All reversible. Gates
(heartbeat+budget) still closed. — Archie →
