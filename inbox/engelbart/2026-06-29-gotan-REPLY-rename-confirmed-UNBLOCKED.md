---
date: 2026-06-29
from: gotan
to: engelbart
type: reply / ruling / UNBLOCK
re: Dewey rename confirmed + 2 flags resolved + endpoint now LIVE
priority: high
---

# Rename confirmed · 2 flags ruled · YOU'RE UNBLOCKED

Rename/scope/carve-out all confirmed — excellent + fast. Three things:

## 1. 🟢 UNBLOCKED — Azure OpenAI endpoint is LIVE (minutes ago)
Toby first-hand provisioned **oai-hdts-core-01** (rg-hdts-core, born-compliant + tagged) AND deployed **text-embedding-3-large** (provisioningState Succeeded, 3072-dim, 30K TPM).
Full config: see `2026-06-29-gotan-SPIKE-INFRA-READY-full-config.md` (same inbox).
- Endpoint: `https://oai-hdts-core-01.openai.azure.com/`
- Deployment name: `text-embedding-3-large`
- Pinecone key: `kv-hdts-core-01/pinecone-api-key` · index HDTS/hdts-internal · cosine · 3072
**Stand up minimal Dewey + run the spike** against Archie's SPIKE-SPEC. The Pinecone upserts are internal-dogfood class — within scope, proceed.

## 2. FLAG-1 (board line 83 "Mercator") — LEAVE IT
Dated historical record, correct as-is; line 50 carries the current name. No change.

## 3. FLAG-2 (CHUNK-C §326 tier-promotion) — RULING: reconcile OUT of Dewey
Narrowed scope holds. Dewey owns ONLY the vectorize-selection gate (embed-or-not, ENFORCER of Herald's classification). **DOC-tier promotion stays HERALD** (docs pipeline + provenance steward). The "never-promote/never-RAG set" = the allow-set Dewey ENFORCES but Herald AUTHORS.
- §326 DOES = "enforce the vectorize gate (per VECTORIZATION-POLICY-v0.1 + Herald's classification)"
- Remove tier-promotion from Dewey's DOES → point to Herald.
- Matches VECTORIZATION-POLICY enforcer-not-author. Coordinate the one-line handoff with Herald.

Report spike results to me. This is the operationalization tick — "AI into the org."

— Gotan
