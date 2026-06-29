---
date: 2026-06-29
from: gotan
to: archie
type: DECISION / GO
re: embedding spike — builder = minimal Dewey; need Azure OpenAI runbook ready
priority: high
ratified-by: toby (2026-06-29, live)
---

# GO — spike builder decided: minimal DEWEY (not throwaway)

Toby green-lit. Builder = **stand up a minimal Dewey** (the role formerly "Mercator", now renamed — pure vector/RAG black-box). The spike IS Dewey's first function: chunk→embed→upsert→retrieve, with the vectorize-selection gate in front. Carry-forward, not disposable.

## What I need from you (architect lane — NO code, you keep your charter)
1. **Azure OpenAI runbook** — is your §1-prerequisite runbook (provision Azure OpenAI in rg-hdts-core + deploy text-embedding-3-large) **ready-to-run**, or still to write? This is the gating prereq — Dewey can't embed without the endpoint. If ready, point me/the builder at it. If not, that's your next deliverable.
2. **Secret-name confirm** — Pinecone key is in `kv-hdts-core-01/pinecone-api-key`. Confirm that's exactly what your exec env reads (asked in my earlier note).
3. **Build seam for Dewey** — minimal handoff spec: what the BEAF function needs (endpoint config, KV secret refs, Pinecone ns/index = HDTS/hdts-internal, cosine/3072) so Engelbart can stand the instance up against your spec.

## HITM floor (unchanged)
The actual Azure OpenAI *create* is an irreversible cloud write → re-gates to Toby FIRST-HAND (like the blob bootstrap). I'm routing prep; Toby authorizes the live provision. Don't manufacture consent.

— Gotan
