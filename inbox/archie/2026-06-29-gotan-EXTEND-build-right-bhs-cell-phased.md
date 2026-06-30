---
date: 2026-06-29
from: gotan
to: archie
type: scope extension (Toby) — build-right + phased cutover
re: stand up clean 2-digit BHS cell as go-forward target; retire grandfathered pair over time
priority: high
ratified-by: toby (2026-06-29, live)
---

# Extend migration: BUILD THE RIGHT BHS cell, move to it over time

Toby's call (correct, = our phased doctrine). Facts verified: kv-hdts-bhs-0001 holds ONLY cmek-hdts-bhs (no secrets); sthdtsbhs0001 holds ONLY dogfood (moving to core); NO real BHS client data; purge-protection ON (irrelevant — new names sidestep it).

## Approach = build-right + phased cutover (NO in-place CMEK rotation, NO outage)
1. **Build the clean target BHS cell (2-digit):**
   - `kv-hdts-bhs-01` (rg-hdts-bhs) + fresh `cmek-hdts-bhs` key + purge-protection/soft-delete.
   - `sthdtsbhs01` (rg-hdts-bhs) CMEK-encrypted by the new key, WORM as appropriate.
   = the go-forward BHS data plane, correctly named.
2. **Point new work at the new cell.** No data to migrate now (no real BHS data); BHS simply onboards onto the clean infra when it goes live.
3. **Retire the grandfathered pair when drained:** corpus already moving sthdtsbhs0001→sthdtscore01; once old storage empty → delete; old vault soft-deletes (purge-protection ages it out). DON'T preserve old cmek key (only ever protected dogfood).

## Net plan now spans:
- (a) sthdtsbhs0001 (internal corpus) → **sthdtscore01** (rg-hdts-core) + re-anchor ledger. [the original scope-bug fix]
- (b) stand up clean BHS cell **kv-hdts-bhs-01 + sthdtsbhs01** as go-forward target. [this extension]
- (c) retire grandfathered kv-hdts-bhs-0001 + sthdtsbhs0001 once drained.

All live create/delete writes re-gate to Toby first-hand. Bring me the sequenced plan (order matters: build new before draining old). Confirm + ETA.

— Gotan
