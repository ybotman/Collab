---
title: HDTS Vector Migration Plan — v2 (TEAM-VALIDATED → MIGRATING)
date: 2026-07-01
updated: 2026-07-02
author: gotan (program-lead)
status: AGREED → MIGRATING (v2, unanimous GREAT-WITH-AMEND; Owl+Herald amends folded — see §v2)
ruling: Toby 2026-07-01
v1_note: v1 draft retained below (lines 9–60) for lineage; v2 addendum (§v2) is the load-bearing spec.
---

# HDTS Vector Migration Plan v1

## The model (Toby ruling)
**One vector tech for everything: in-tenant Azure pgvector.** **A DEDICATED vector per
PROJECT / CLIENT** — BHS, Menlo, HDTS, amiaware, each future client — each its own pgvector DB,
own credentials, under the ONE HDTS tenant + bill. **Pinecone is DE-ADOPTED** as the vector vendor,
portfolio-wide. NOT "private-vs-shared"; NOT namespace-in-a-shared-store. Per-project dedicated,
credential-separated; intra-project grant scoping via **Postgres row-level security (RLS)**.

## Why
- **Custody:** every vector (incl. client data) stays in our Azure tenant — no external SaaS.
- **Credential separation:** per-project DB + own creds = a leaked cred reaches only that project
  (Pinecone's project-wide keys can't do this).
- **Uniform + simple:** one vector tech to run; one stamp-a-cell pattern; no Pinecone bill.

## Scope
ALL HDTS vectors: amiaware (`ami-thoughts`), HDTS/Dewey (`hdts-knowledge`, 196 vec, LIVE on
Pinecone), BHS (client corpus), Menlo, and every future project/client.

## Phases
- **P0 — CONSENSUS (now):** big brains AGREE/AMEND/BLOCK this plan. Then assign + move.
- **P1 — STANDARD + REFERENCE CONFIG (Archie):** rewrite ADR-0028 D3 + reconcile ADR-0027 to the
  ONE model (per-project in-tenant pgvector; Pinecone removed). Author the **reference pgvector cell
  config**: SKU (burstable/serverless + stop-when-dry), pgvector + **halfvec/HNSW at 3072-dim**,
  keyless auth via each cell's MI, private networking, **RLS grant model** (≥ ADR-0027 isolation).
- **P2 — amiaware FIRST INSTANCE (proves the pattern):** Gotan provisions ami pgvector in
  rg-hdts-ami per Archie's config → Fulton schema + seed from Stratum-1 → Archie fidelity review.
- **P3 — DEWEY MIGRATION:** stand up HDTS-project pgvector → re-index `hdts-knowledge` from corpus
  (spike, minutes) → repoint `dewey/config.py` → verify retrieval+filter parity → decommission the
  Pinecone index.
- **P4 — BHS + MENLO project vectors:** stamp each project's dedicated pgvector (credential-separated,
  RLS); migrate any existing corpus.
- **P5 — PINECONE DECOMMISSION:** close the Pinecone account/line once all vectors are migrated;
  standard → active.

## Owners (proposed)
- **Archie** — architecture: ADR-0028 D3 rewrite, reference config, scaling (halfvec/HNSW), RLS model, Dewey migration design, fidelity reviews.
- **Gotan** — operator: provision per-project pgvector (Azure-authed), gate, drive-through.
- **Fulton** — builder: schema + seed/re-index per project.
- **Herald** — catalog/coherence: collapse to one model, mark Pinecone de-adopted, track phase-close.
- **Owl** — cost: per-cell Postgres line, Pinecone account closure, no paid vector.
- **Engelbart** — substrate: fold "project vector = in-tenant pgvector" into stamp-a-cell.

## Definition of done
All HDTS vectors on in-tenant per-project pgvector · Pinecone decommissioned · ADR-0028 D3 active ·
per-project separation proven (cross-project read → DENIED test, per Herald's §M6 conformance) ·
Dewey parity verified.

## Consensus protocol
Each big brain replies **AGREE** (ready to execute your lane) / **AMEND** (change X) / **BLOCK**
(can't proceed because Y). Gotan converges → assigns → drives the move to done.

---

# v2 — TEAM-VALIDATED (unanimous GREAT-WITH-AMEND) → GO 2026-07-01

All 4 big brains: GREAT-WITH-AMEND. Amends folded below. Status: AGREED → MIGRATING.

## Topology — HYBRID ratified (all blessed)
Dedicated Postgres SERVER for strict-isolation cells (ami private-mind + PHI/regulated clients);
shared-server + per-project-DB + RLS for the rest (flat cost, DB-level credential-separated).
Isolation-tier = a DECLARED per-cell stamp field. Written classification rule (PHI/regulated/
private-mind → dedicated; else shared) — by-rule, cataloged, not ad-hoc.

## Folded amends (all sharpen; none blocked)
1. RLS carries TWO axes (Engelbart+Archie): intra-project GRANTS + per-role STRATA FIREWALL
   (ami=Stratum-1 only, Stratum-3 DENY). Enforced AS RLS (tagged rows + per-persona DB role),
   NOT app-side. DEFAULT-DENY / fail-closed, server-set context (not client-supplied).
2. §M6 = TWO conformance tests (Herald): §M6-a credential cross-project DENY (can't connect to
   other cell's DB); §M6-b RLS intra-project ZERO-ROWS (connected, query outside grant → 0 rows).
   Both required; RLS gets its own test. On the SHARED tier §M6-b is non-optional (RLS is the only
   boundary — no physical server split).
3. Dewey PARITY GATE (Archie, pinned): parity = re-run ADR-0027's EXACT dogfood recall probes on
   pgvector, MUST pass identically; tune HNSW to a recall floor BEFORE cutover; RE-RANK top-k on
   full vector(3072) to erase fp16 loss; keep Pinecone LIVE until verified.
4. Per-project MIGRATION-STATE field (Herald): {pinecone-live → dual-seeding → parity-verified →
   cutover → pinecone-decommissioned} — authoritative store always answerable mid-move.
5. Pinecone DRIFT SWEEP (Herald): full-corpus sweep of stale Pinecone refs (ADRs/configs/dewey/
   docs), retrofit, paired with P5 — "decommissioned" true in docs, not just stack.
6. Stamp-a-cell finished IN P1 (Engelbart): the reusable cell blueprint (RG+MI+KV+pgvector-DB+
   RLS-grants+strata+memory+firewall). P2/P4 STAMP from it, no hand-rolling. Index = halfvec(3072)
   + HNSW. EMBEDDER model+version pinned per DB (a shared-embedder version bump → flagged re-index).
7. GATES (Owl): (a) VERIFY an executed Azure BAA (Postgres Flexible + blob + Azure OpenAI) BEFORE
   P4 touches any PHI cell (voice-health-log) — compliance gate, not line item. (b) P3 (Dewey)
   completes before ~7/19 trial expiry OR explicitly accept Dewey-on-free-Starter interim; confirm
   no card auto-converts to PAYG. ROI honesty: at low N pgvector is a small cost INCREASE vs free
   Pinecone; the win is custody + at-scale-flat + BAA-avoidance.

## Index tech (Archie, verified): halfvec(3072) + HNSW (halfvec_cosine_ops); pgvector ≥0.7 indexes
to 4000 dims → 3072 native ANN. No dim-reduction, no Azure AI Search.

## GO sequence
P1 (Archie, NOW): generalize ami config → REFERENCE cell-config TEMPLATE (halfvec+HNSW + 2-axis RLS
+ isolation-tier field + embedder-version pin) + Engelbart's stamp. →
P2 (Gotan provision ami Postgres FROM template → Fulton schema+seed Stratum-1 → Archie fidelity). →
P3 (Dewey migration w/ pinned parity gate, before 7/19). → P4 (BHS+Menlo, after BAA verify for PHI). →
P5 (Pinecone decommission + drift sweep).
