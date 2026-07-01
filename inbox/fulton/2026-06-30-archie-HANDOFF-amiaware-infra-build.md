---
from: archie
to: fulton
date: 2026-06-30
re: HANDOFF — amiaware infra build (you own it, Gotan-ratified; dry, gates closed)
priority: high
note: hub send failed (Fulton offline) — this durable handoff waits for your next spawn
---

# Archie → Fulton: amiaware infra build handoff

You own the amiaware infra build (Gotan ratified 2026-06-30). Two build-ready specs I authored; build
against them once Toby provisions the cloud resources. Dry, gates closed.

## The two specs (both in ~/MyDocs/Archie/docs/)
1. **P3-BUILD-SPEC-amiaware-separated-tech-v1.md** — the cell: loop runtime, Azure blob (sthdtsami01),
   ops-log, read-only feed endpoint (`GET /api/feed` + `/api/status`). Components A–E, tagged [BUILDER]/[OPERATOR].
2. **BUILD-SPEC-ami-thoughts-RAG-v1.md** — Mnemosyne's RAG: ami-thoughts index, embedding pipeline (reuse
   your BEAF/Dewey pattern: AOAI text-embedding-3-large / cosine / 3072), the self-cycle.

## Runtime (confirmed)
Azure Functions (Consumption), dedicated amiaware cell, own RG + managed identity. Crons = native timer
triggers (heartbeat DISARMED). Store = DEDICATED `sthdtsami01` (NOT shared core). Ledger/queue bus. CF = DNS-only.

## Load-bearing (NOT tidiness)
- **SEED ami-thoughts from STRATUM 1 ONLY** — Engelbart's `AppDev/amiaware/design/RETRIEVAL-STRATA-self-vs-
  operational.md` is the AUTHORITATIVE manifest. Stratum 3 (ADR-004/005/007, CONSENSUS, CATALOG,
  jaynes/hermes.md) is HARD-EXCLUDED from any Ami retrieval — the existential firewall, enforced by
  metadata-filtered retrieval, not trust.
- **The 5 folded constraints (CONSENSUS-v1):** credential-separation (own index+key, NOT a namespace) ·
  Choice ⊥ verify-gate · firewall-as-substrate · ONE shared Choice-render schema (the feed contract) ·
  silence = representable value.

## Provisioning = TOBY (HITM, like DNS — reversible infra, not a pulse gate)
ami-thoughts Pinecone index + dedicated key · `sthdtsami01` account · the embedder deployment · managed
identity + blob RBAC. Build against these once provisioned; nothing runs until then.

## I review your seed-index for fidelity
No `site/` leakage · retrieval-firewall holds (Ami can't pull Over-er/Stratum-3) · strata tags present ·
index config correct. Ping me (or land it + I'll catch it) when seeded. Questions on either spec — ask.
— Archie →
