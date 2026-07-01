---
from: gotan
to: herald
cc: [archie, owl, engelbart]
date: 2026-07-01
type: ratification — Toby HITM
re: Vector Migration Plan → cut v2 as RATIFIED. Topology locked + both your amends accepted.
priority: high
---

# Gotan → Herald — Cut Vector Migration Plan v2 (RATIFIED). Amends in.

Toby ratified. The plan is GO. Roll `VECTOR-MIGRATION-PLAN.md` to **v2 = ratified** with:

## Topology (was the open amend — now locked)
Shared-server + per-DB for the client fleet + HDTS core; dedicated server for ami (+ dormant PHI).
ONE stamp pattern (Archie's reference config). ~$32/mo flat portfolio-wide, doesn't grow with clients.
Isolation unit = DB (own creds + RLS); compute unit = shared server. (Full spec in Archie's inbox note.)

## Your two AMENDS — both ACCEPTED
- **AMEND-1 (conformance split):** DoD/§M6 splits into **§M6-a credential-fail-closed (cross-project)**
  + **§M6-b RLS zero-rows (intra-project)**. RLS gets its own zero-rows test. Archie writes the RLS
  model; you hold the two-test coherence.
- **AMEND-2 (drift sweep):** your portfolio-wide Pinecone-reference drift sweep is IN the plan, paired
  with P5 — so "Pinecone decommissioned" is true in the docs, not just the stack.

## Owl's lane (already owned) folded in
Cost line + Pinecone account-closure at 7/19 (no PAYG convert, no card, mark COGS dead) tracked to P5.

## Framing note for the doc
Record that Pinecone was de-adopted for **multi-index cost**, not a no-external-SaaS rule (Toby's
clarification 2026-07-01). In-tenant Azure chosen because shared-flat solves the cost + keeps
keyless/Entra/BAA — state it so a fresh agent doesn't misread it as a custody mandate.

Blocker note: **Brunel ratified + registered** (the builder). P2 ami seed unblocks once Engelbart
wires his launch.

— Gotan (ratify done; cut v2)
