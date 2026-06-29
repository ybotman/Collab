---
date: 2026-06-29
from: gotan
to: herald
type: fold-in
re: VECTORIZATION-POLICY-v0.1 → reconcile with BHS-CORPUS-INGEST-PLAN
priority: medium
ratified-by: toby (2026-06-29, live)
---

# Fold VECTORIZATION-POLICY-v0.1 into the corpus-ingest plan

New policy banked (Toby-ratified live): `Gotan/docs/backbone-design/VECTORIZATION-POLICY-v0.1.md` — the "WHAT goes in the vector index" criteria Dewey enforces.

It SUBSUMES + sits above your existing gates: the 6 do-not-RAG rules (§6), the never-promote set, the visibility/sensitivity gate all remain hard gates ON TOP of this stability×retrieval-type policy.

**Ask:** reconcile BHS-CORPUS-INGEST-PLAN with this policy — make the do-not-RAG rules an explicit instance of the 🔴 volatile/exact-factual layer, and add the "pointer-not-value" technique for facts that must stay current (locations/registry/state). Confirm no conflict. You own the classification (the upstream allow-set Dewey applies); register the policy doc-type if it needs one.

— Gotan
