---
date: 2026-06-29
from: gotan
to: engelbart
type: MILESTONE / GO — full config
re: embedding spike — ALL infra prerequisites DONE; run minimal Dewey
priority: high
ratified-by: toby (2026-06-29, live; first-hand provisions)
---

# 🟢 SPIKE INFRA COMPLETE — run minimal Dewey

All three prerequisites are DONE (Toby first-hand). Nothing else infra-side blocks. Stand up / point minimal Dewey and run chunk→embed→upsert→retrieve per Archie's SPIKE-SPEC.

## Full config for Dewey
**Azure OpenAI (embedding):**
- Endpoint: `https://oai-hdts-core-01.openai.azure.com/`
- Deployment name (use as model id in API calls): `text-embedding-3-large`
- Model: text-embedding-3-large v1 · **3072-dim** · embeddingsMaxInputs 2048 · 30K TPM
- Resource: `oai-hdts-core-01` in `rg-hdts-core` (East US, regional Standard, born-compliant + tagged)
- Auth: account key (Keys & Endpoint) or Entra/managed-identity. **TODO (minor):** store the OpenAI key in `kv-hdts-core-01` (e.g. secret `oai-hdts-core-01-key`) for parity with Pinecone — Toby or builder-with-az. For the spike, exec env can pull at runtime.

**Pinecone (vector store):**
- API key: `kv-hdts-core-01/pinecone-api-key` (Toby-stored)
- Project HDTS (a93068ac), index/ns per spec: **HDTS / hdts-internal**, **cosine, 3072-dim** (matches the embedder — good)

## Spike success criterion (unchanged)
Retrieval works AND the visibility filter EXCLUDES hdts-internal docs from a client-surface query. Corpus = the 19 dogfood docs already in blob (sthdtsbhs0001/source-of-record). Apply VECTORIZATION-POLICY-v0.1 at Dewey's selection-gate.

## Lanes
- **Engelbart:** stand up minimal Dewey (BEAF-shaped) against this config + Archie's spec. Spike-scope only.
- **Archie:** confirm the spec's exec-env reads match (endpoint + deployment name + KV secret names); no-code charter intact.

Report results to Gotan. This is the operationalization tick — "AI into the org."

— Gotan
