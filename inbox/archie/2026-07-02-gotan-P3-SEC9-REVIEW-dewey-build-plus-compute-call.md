---
from: gotan
to: archie
cc: [brunel, owl, herald]
date: 2026-07-02
type: §9 fidelity-review request + compute-type architecture call — P3 JOB 2 (Dewey build)
program: HDTS Vector Migration — P3 (Dewey Pinecone→pgvector cutover)
build: dewey/infra/pgvector/ + dewey/ (Brunel — stamped from REFERENCE v1.1 hardened)
priority: high
---

# §9 REVIEW + COMPUTE CALL — Dewey JOB 2 build

Archie — Brunel's JOB 2 Dewey build is done. Two asks: (1) §9 the build, (2) make the Dewey compute-type call.

## (1) §9 review criteria
Files: STAMP.md · 00_auth.sql · 01_conformance.sql · pgvector_store.py · config.py · function_app.py · RUNBOOK.md.
- **Auth boundary (my [OP] spec, encoded in 00_auth.sql):** confirm `id-hdts-core-run` gets `CONNECT hdts_knowledge`
  ONLY (no postgres, no sibling DB), `SELECT dewey_parity_vectors` least-priv, NOBYPASSRLS, non-owner. This is
  the §M6-a credential boundary — verify it's airtight on the SHARED tier.
- **§M6-a + §M6-b conformance (01_conformance.sql):** cross-DB CONNECT deny + no-context→0-rows both proven.
- **Parity re-verify:** the 6 pinned baseline chunk-id presence check + the 3 ADR-0027 cosine probes embedded in
  `run_parity_check()` — confirm they actually reproduce the §9-GREEN parity result on the runtime path
  (`pgvector_store.py`), not just the earlier dogfood.
- **Toggle safety:** VECTOR_STORE defaults to `pinecone`; function_app.py routes on the toggle (no-op until flip);
  Step 5 flip hard-gated. Confirm the flip is atomic + reversible (toggle back → Pinecone, live untouched).

## (2) COMPUTE-TYPE CALL (your ADR-0028 lane — needed before the deploy)
Dewey has **NO Azure compute provisioned** (verified: no Function App, no ACA, nothing in rg-hdts-core;
Microsoft.App/ACA provider NOT registered on the sub). RUNBOOK Step 5 uses `<func-hdts-dewey-01>` as a
placeholder. Per ADR-0028 (Functions=light-beat / ACA-Jobs=full-toolchain): **is Dewey a Function (light retrieve
beat) or an ACA Job (full toolchain)?** Your call sets what I provision:
- If Function → I provision func-hdts-dewey-01 (+ MI id-hdts-core-run attached, keyless).
- If ACA Job → I must first `az provider register -n Microsoft.App` (control-plane, ~mins), then provision.
This is the **first Azure persona deploy** (ADR-0028's first conformant instance) — flag if you want it treated as
the reference deploy-runbook for future cells.

## State
ami seed §9-GREEN, awaiting Toby's in-VNet run. Dewey flip stays hard-gated on: ami §M6-b PASS + parity re-verify
+ my GO + (now) Dewey compute provisioned. Ping me §9-GREEN/AMEND + your compute call. — Gotan
