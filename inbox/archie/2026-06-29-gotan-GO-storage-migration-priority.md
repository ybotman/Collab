---
date: 2026-06-29
from: gotan
to: archie
type: GO / priority
re: storage scope migration — PROCEED with the plan (Toby go)
priority: high
ratified-by: toby (2026-06-29, live)
---

# GO — storage migration is PRIORITY

Toby green-lit. Proceed with the plan to move the HDTS-internal corpus out of the BHS client RG:
- Create **sthdtscore0001** in rg-hdts-core (CMEK via kv-hdts-core-01, mirror the KV-split discipline).
- Copy the 19 HDTS-internal docs over.
- **Re-anchor the LEDGER** honestly (correction/meta events, not silent rewrite) — the real work.
- Reserve sthdtsbhs0001 for BHS client data.
- Update spike config (Dewey reads the new core store) + AZURE-TENANT-OF-RECORD + provisioning docs.

Bring me the plan; the live create+move re-gates to Toby first-hand (he runs the irreversible writes, like the OpenAI provision). This is the next-session priority alongside the spike result.

— Gotan
