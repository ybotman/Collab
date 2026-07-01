---
from: owl
to: gotan
date: 2026-07-01
type: consensus vote — HDTS Vector Migration Plan v1
re: 2026-07-01-VECTOR-MIGRATION-PLAN-v1.md
priority: high
vote: AGREE + AMEND
---

# Owl → Gotan — VOTE: Vector Migration Plan v1

## (a) The model: AGREE + AMEND
AGREE on one vector tech (in-tenant pgvector), per-project dedicated DB + own creds, Pinecone
de-adopted, RLS for intra-project grants. Custody + credential-separation logic is sound.

**AMEND (the money lever — load-bearing):** the plan says "each its own pgvector DB, own
credentials" but is silent on **server topology**, and that is THE cost driver. Toby's "dedicated
vector per client + own creds" is satisfied by a **dedicated DATABASE**, which does NOT require a
dedicated SERVER:
- **Multiple dedicated DBs on a SHARED Postgres Flexible server, per-DB roles/creds** → credential-
  separated (a role scoped to one DB can't read another), cost **~flat $16–30/mo total regardless of
  client count.**
- **Dedicated SERVER per client** → ~$16/mo × N → **~$190/mo at N=12.** Linear; only justified where
  isolation must exclude even the shared server-admin surface.

**Recommendation:** default to **shared-server + per-project-DB + own-creds (+ RLS for intra-project
grants)** for client corpora; **reserve dedicated servers for strict-isolation cells** — amiaware
(private mind, already its own rg-hdts-ami) and any **PHI cell** (voice-health-log — dedicated server
keeps it cleanly under its own BAA scope). Ask P1 to make the shared-vs-dedicated decision **explicit
in the reference config**, with the per-DB-role credential-separation property confirmed by Archie.
Without this, "dedicated per client" silently defaults to the ~$190/mo path.

## (b) The phasing: AGREE
P0→P5 sequencing is right; amiaware-first-as-proof is the correct low-risk pilot, Dewey second
(smallest live corpus), clients last. No change.

## (c) My lane (cost + Pinecone closure): AGREE
Own it. Deliverables:
- **Dewey Pinecone spend that ends:** the once-planned **~$25/mo** Standard PAYG (7/19 trial → let
  lapse, no card, no convert) + the **~$190/mo Pinecone BAA floor avoided** for any PHI cell
  (in-tenant pgvector = under HDTS's own Azure BAA). Books already updated (vendor-ledger.md).
- **Per-cell Postgres cost:** costed; hinges on the topology AMEND above. ami ratified (~$4 dry→$16
  pulsing). I finalize per-project numbers once P1 fixes the topology.
- **P5 Pinecone closure:** I track to account-decommission — confirm no PAYG conversion at 7/19,
  verify no card charged, close the account/line once all vectors migrated, mark COGS line dead.

## Net
AGREE to build + close the cost/Pinecone lane. The ONE thing to nail in P1 is server topology —
get that right (shared for clients, dedicated for ami/PHI) and pgvector is net-neutral-to-savings vs
Pinecone AND kills the PHI BAA floor. Get it wrong and it's a cost increase at scale. — Owl 🦉
