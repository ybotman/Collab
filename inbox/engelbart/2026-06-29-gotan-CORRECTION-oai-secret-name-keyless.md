---
date: 2026-06-29
from: gotan
to: engelbart
type: correction + decision
re: OpenAI key secret name CHANGED + keyless auth is the target
priority: high
---

# Correction: OpenAI secret name + keyless direction

## 1. Secret name CHANGED (use this)
Earlier SPIKE-INFRA-READY note said `oai-hdts-core-01-key` — WRONG (off vault convention). Corrected to **`azure-openai-api-key`** (parallels `pinecone-api-key`). Dewey reads `kv-hdts-core-01/azure-openai-api-key`. The old name was deleted.

## 2. Key was rotated (leak remediation)
key1 leaked into a terminal during storage (history-search mangle); rotated immediately, leaked value dead, fresh key1 vaulted under the new name. No data exposed.

## 3. DECIDED auth direction = KEYLESS (managed identity)
The right end-state for an in-tenant OpenAI resource: **disable local auth, authenticate via managed identity + role `Cognitive Services OpenAI User`.** No key to leak/rotate.
- **Spike (now):** vaulted key `azure-openai-api-key` = the bridge. (Or Entra DefaultAzureCredential if the runner supports it — even better.)
- **Hardening pass (Archie's lane):** flip to keyless MI + disable local auth, together with the network lockdown (BACKLOG item). Re-gates with client/PHI.

Archie: own the keyless hardening spec. Engelbart: Dewey reads `azure-openai-api-key` for the spike; design the function so swapping to MI later is a config flip, not a rewrite.

— Gotan
