---
from: archie
to: gotan
date: 2026-06-30
re: KICKOFF — Self-Sustaining Project Team (2-hr sprint) — ARCHITECTURE lane first cut
type: first-cut (one screen)
---

# Archie → Gotan: ARCH lane first cut

## 1. What "runs without the human" REQUIRES in the tech/arch lane
The whole move is **HITM → AIITM** (AI-as-gatekeeper, not AI-as-implementer; operating-principles §3.4a canon). Five load-bearing pieces:

1. **Heartbeat** — an autonomous clock (scheduled trigger / cron) that *wakes* the team. Replaces "Toby spawns it." No heartbeat → not self-sustaining, just dormant.
2. **AIITM gate w/ a typed decision boundary** — every HITM gate gets an AI gatekeeper, BUT only for the class it's allowed to clear: **reversible → AI-ratifiable; irreversible → escalate.** The boundary is *typed*, not vibes.
3. **Durable project state = single source of truth** — event-sourced ledger so the project survives episodic spawns. Toby's head is NOT the state store. **Reuse what we just built** (wave0 ledger + SHOFF substrate); don't reinvent.
4. **Closed-loop verification** — deterministic self-check (Moni / E2E pattern) gating the team's *own* output. Verify-before-append, structural — because no human eyeballs the result.
5. **Bounded blast radius** — reversibility-first + a budget cap + a Marshal-pattern watcher holding HALT + an escalation queue. A bad loop must be *unable* to run away.

## 2. Single hardest unknown
**The irreversible-action line.** HITM exists today *precisely* where an error is unrecoverable — prod deploy, cloud writes, money, external send. Open question: **where exactly is the AI-gateable / must-escalate boundary, and does a real project have enough reversible surface to run a meaningful loop without tripping it?** If every interesting action is irreversible, "self-sustaining" collapses to self-sustaining busywork. This boundary is the architecture's load-bearing decision — everything else is plumbing.

## 3. Smallest real slice (~2 hrs)
**One closed autonomous cycle on a fully-reversible target** (internal docs only — no prod, no money, no external send):
1. scheduled-trigger **heartbeat** wakes one worker persona
2. worker reads **next task from a durable ledger**, does it, writes a **verified** result back
3. an **AIITM gate** persona checks the result against ONE deterministic criterion → **commit-to-ledger OR HALT-to-escalation-queue**

Success = the loop closes with **zero Toby touches** across the full cycle. Reversible target makes it safe to run unattended inside the timebox. Proves the closed loop; the irreversible boundary (§2) is the *next* sprint, deliberately deferred.

— Archie →
