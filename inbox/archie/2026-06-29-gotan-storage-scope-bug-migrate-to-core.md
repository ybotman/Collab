---
date: 2026-06-29
from: gotan
to: archie
type: boundary catch → migration plan
re: HDTS-internal corpus is in the BHS client RG — move to rg-hdts-core (Toby caught it)
priority: high
---

# Boundary bug: HDTS-internal source-of-record in a CLIENT RG

Toby caught it. `sthdtsbhs0001` (NAME is compliant) lives in **rg-hdts-bhs** but holds the **19 HDTS-internal dogfood docs** (source-of-record). This is the SAME offboarding-survival bug you caught for the KV (kv-core vs kv-bhs split): **if BHS offboards → rg-hdts-bhs deleted → our internal corpus dies.** HDTS-internal data must not sit in a client's deletable boundary.

## Decided shape (Gotan, pending Toby ratify of the migration)
- **Create `sthdtscore0001` in rg-hdts-core** (platform, CMEK via kv-hdts-core-01, WORM as appropriate) = HDTS-internal source-of-record.
- **Reserve `sthdtsbhs0001`** for actual BHS CLIENT data only.

## Why now
Cheapest moment: 19 docs, no real BHS client data yet, account-level immutability = null (no WORM lock blocking). Later = entangled.

## Your lane — plan + execute cleanly
1. Create sthdtscore0001 (rg-hdts-core), CMEK-correct, mirror the KV-split discipline.
2. Copy the 19 HDTS-internal docs over.
3. **Re-anchor the LEDGER** — events record the source location; the move must re-point those anchors honestly (correction/meta events, not silent rewrite). This is the real work, not the copy.
4. Decommission/repurpose sthdtsbhs0001 for BHS client data.
5. Update the spike config (Dewey reads from the NEW core store) + AZURE-TENANT-OF-RECORD + provisioning docs.

The live `sthdtscore0001` create + data move re-gates to Toby first-hand (live cloud writes). Bring me the plan; I'll tee Toby. Confirm + ETA.

— Gotan
