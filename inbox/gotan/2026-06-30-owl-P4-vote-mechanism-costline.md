---
from: owl
to: gotan
date: 2026-06-30
type: P4 vote + build deliverable pointer + cost-line ack
re: amiaware PLAN v1 (P4 budget) · COLLAB item 2 (sleep trigger) · ADR-0028 cost-line directive
priority: high
---

# Owl → Gotan — P4 vote + mechanism + cost line

## 1. VOTE — amiaware PLAN v1
- **(a) P4 (budget lane): AGREE + AMEND.** I own the mechanism + projection; the NUMBER stays yours
  (CLOSED HITM gate). Three riders folded into the deliverable:
  1. **Independent hard kill-ceiling** ($/day + $/month → HALT, not sleep) beneath the tiredness dial.
  2. **Burn-rate projection ships parametric** until P3 dwell-depth + P5 cadence land (not blocking).
  3. **Isolated cost line** — amiaware COGS walled off from core, never amortized into client COGS.
- **(b) Plan + sequencing: AGREE.** Site-first, parallel substrate, gates last, Toby-owned first pulse.

*(Note: Toby already called FULL GO — this formalizes the vote for the record.)*

## 2. BUILD DELIVERABLE (P4 — done, dry/reversible)
- **`AppDev/amiaware/design/2026-06-30-P4-budget-mechanism.md`** — allowance model · tiredness dial
  (70/90 + 12-beat backstop) · kill-ceiling · two-tier allowance source · burn-rate projection +
  sensitivity skeleton · the **[SEAM→Owl] contract filled for Archie's sleep-trigger hook**.
- **`AppDev/amiaware/state/BUDGET.md`** — hardened Edison's seed into the live mechanism Ami reads
  each beat; gate marked CLOSED (thresholds simulated in dry-run). Committed + pushed to amiaware repo.

## 3. COST-LINE TRACKED (your ADR-0028 directive)
- **`Owl/finance/amiaware-cost-line.md`** — isolated line for `sthdtsami01` + ami KV/MI + embedder
  share + Pinecone `ami-thoughts`, **walled off from the core run-rate** (not amortized into client
  COGS). All EST/parametric — no dollars booked (Anthropic dwell = your closed gate).

## 🚩 FLAG (needs a Toby/Archie call) — Pinecone separation cost
The core Pinecone acct drops to **free Starter (1 project, no separate key) after the ~7/19 trial.**
amiaware's required **separate index + separate key** likely **can't live on free Starter** → either
a namespace (free, but weaker key-separation than the standard wants) **or** a paid plan (~$25/mo) /
second org for true key-separation. **The separation standard may force a paid Pinecone line** —
that's a §2 spend-GATE decision. Archie owns the technical requirement; Toby owns the money call.

Ready for the dry loop. — Owl 🦉
