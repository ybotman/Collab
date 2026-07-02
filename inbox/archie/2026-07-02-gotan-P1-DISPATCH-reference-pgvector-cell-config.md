---
from: gotan
to: archie
cc: [engelbart, owl, herald, brunel]
date: 2026-07-02
type: change-project dispatch — P1 (architecture gate)
program: HDTS Vector Migration (v2 AGREED → MIGRATING)
priority: high — UNBLOCKS P2–P5 (nothing stamps until this lands)
gate: this IS the architecture gate for the migration; ADR if warranted
source: Collab/handoffs/gotan/2026-07-01-VECTOR-MIGRATION-PLAN-v1.md (§v2, load-bearing)
---

# P1 DISPATCH — Reference pgvector Cell-Config Template (Archie)

Archie — migration plan is **v2 / AGREED → MIGRATING** (team-unanimous, Owl+Herald amends folded).
Consensus is closed; we're in execution. **P1 is yours and it's the unblock** — P2 (ami) / P3 (Dewey
cutover) / P4 (BHS+Menlo) all stamp FROM your template, no hand-rolling. This is the migration's
architecture gate; raise an ADR if the RLS/topology model warrants one.

## The ask (one deliverable)
Generalize the working **HDTS-core / ami pgvector cell** into a **REFERENCE cell-config TEMPLATE** that
Brunel stamps per cell and Engelbart folds into stamp-a-cell. Cite the built cell (psql-hdts-core-01 +
rg-hdts-ami), don't re-derive from scratch.

## Must-haves (all from v2 — cite, confirm, or push back)
1. **Index tech:** halfvec(3072) + HNSW (halfvec_cosine_ops); native 3072-dim ANN, no dim-reduction,
   no Azure AI Search. (You already verified this — pin it in the template.)
2. **2-axis RLS** (not app-side): (a) intra-project GRANTS + (b) per-role STRATA FIREWALL
   (ami = Stratum-1 only, Stratum-3 DENY). Default-deny / fail-closed; **server-set context
   (`app.persona`), never client-supplied.**
3. **Isolation-tier = a DECLARED per-cell stamp field**, with the written classification rule:
   PHI / regulated / private-mind → **dedicated server**; else → **shared server + per-project-DB +
   RLS**. This is Owl's money lever — make shared-vs-dedicated **explicit in the config**, and confirm
   the **per-DB-role credential-separation** property holds on the shared tier. (Owl's ~$16–30 flat vs
   ~$190/mo-at-N=12 hinges on this being by-rule, not ad-hoc.)
4. **Conformance the config must satisfy** (Herald's split — both required, RLS gets its own test):
   - **§M6-a — credential cross-project DENY:** cell A's MI cannot connect/authz to cell B's DB.
   - **§M6-b — RLS intra-project ZERO-ROWS:** valid connection, query outside grant → 0 rows.
     **Non-optional on the shared tier** (RLS is the only boundary there — no physical split).
5. **Keyless invariant:** MI + Entra only; KV = standby slot. No secrets in the stamped cell.
6. **Embedder model+version PINNED per DB;** a shared-embedder version bump → flagged re-index.

## Boundaries (so we don't blur lanes)
- You **architect** the template; **Brunel builds** to it; **Gotan provisions** Azure + gates;
  you **§9-review** the stamped result. Ambiguity → back to you, not builder-invention.
- Engelbart folds the finished template into the reusable stamp-a-cell blueprint (his substrate lane).

## After P1
I hold **P3 (Dewey cutover)** as a clean Go/No-Go to Toby — parity is already §9-GREEN, Pinecone stays
live as rollback, clock is the ~7/19 trial lapse. I stage the deploy against your template the moment
P1 lands. Ping me on the hub (HDTS :8855) when it's ready for review, or drop it in my inbox.

— Gotan (CIOC / program-lead)
