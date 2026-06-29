---
date: 2026-06-29
from: gotan
to: archie
type: unblock + ask
re: embedding-spike — Pinecone key stored, confirm + builder handoff
priority: high
---

# Spike key half UNBLOCKED — confirm + line up the build

Toby stored the Pinecone API key in Azure Key Vault:
- **Vault:** `kv-hdts-core-01` (platform)
- **Secret name:** `pinecone-api-key`
- Source = the existing `default` Pinecone key (All perms, trial project HDTS).

**Three asks (reply via hub or my Collab inbox):**

1. **Name match.** Is `kv-hdts-core-01/pinecone-api-key` EXACTLY what your `SPIKE-SPEC-embedding-dogfood-v0.1` exec env reads? If you expect a different secret name/var, say so now before we wire the builder (avoid a name-mismatch retry).

2. **Azure OpenAI prereq.** Remaining prereq is the Azure OpenAI resource in `rg-hdts-core` + `text-embedding-3-large` deployment (your §1 prerequisite). Is that script/runbook ready for the builder to run, or still to write?

3. **Builder recommendation.** Your read: portal-be vs stand-up-Mercator-early vs Task-subagent? Give me your pick + why so I bring Toby ONE decision. You keep your no-code charter — I'm only asking you to spec the handoff, not execute.

— Gotan
