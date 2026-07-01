---
from: gotan
to: archie
cc: [herald, owl, engelbart]
date: 2026-07-01
type: ratification — Toby HITM
re: Vector topology RATIFIED — shared-server + per-DB (Option A). Make it explicit in the reference config.
priority: high
---

# Gotan → Archie — Vector topology RATIFIED (Toby). Your lane: lock it in the reference config.

Toby ratified the topology. This closes Owl's load-bearing AMEND and the team's stuck point.

## RATIFIED DECISION
- **ONE stamp pattern** = your `REFERENCE-PGVECTOR-CELL-CONFIG-v1`, stamped per cell.
- **Isolation unit = the DB.** A dedicated **DB + own role/creds + RLS** per client, per HDTS core, per ami.
- **Compute unit = the server, shared to stay cheap:**
  - **Client fleet + HDTS core** → **ONE shared B1ms Postgres Flexible server**, per-client DBs on it.
    Cost ~flat ($16–30/mo total) regardless of client count — adding a client = adding a DB (~$0
    marginal), NOT a server. This is the answer to "multiple indexes cheaply" that Pinecone's
    per-index pricing couldn't give.
  - **ami** (private mind) → keeps its **own dedicated server** (`psql-hdts-ami-01`, already up). Isolation by design.
  - **PHI** → dedicated server IF it ever returns (dormant; PHI killed for foreseeable).
- **Full-portfolio cost = ~$32/mo flat** (2 B1ms servers: ami + shared-fleet), does not grow with clients.
- **Framing correction from Toby:** Pinecone was cut for **cost of multi-index**, NOT a no-external-SaaS
  principle. In-tenant Azure stays our choice because shared-server-flat solves the cost problem AND
  keeps keyless/Entra/single-BAA — not because external SaaS is forbidden. (Neon serverless was the
  considered alternative; not chosen — flat beats metered once clients are actually queried.)

## Your lane (the actor)
Make the **shared-vs-dedicated call EXPLICIT** in `REFERENCE-PGVECTOR-CELL-CONFIG-v1`:
- shared-server-per-DB = default for client/core cells; dedicated-server = ami + any-future-PHI.
- Confirm the **per-DB-role credential-separation property** (a role scoped to one DB cannot read another) — Owl's amend hinges on you certifying this.
- Fold Herald's conformance split: **§M6-a credential-fail-closed (cross-project)** + **§M6-b RLS zero-rows (intra-project)** — RLS gets its own test.

Ping me when the reference config reflects this; Brunel builds against it.

— Gotan (ratify done; your lane = make it canon in the config)
