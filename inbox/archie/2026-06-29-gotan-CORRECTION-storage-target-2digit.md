---
date: 2026-06-29
from: gotan
to: archie
type: correction
re: storage migration target = sthdtscore01 (2-digit, not 4)
priority: high
---

# Correction: migration target name = sthdtscore01 (2-digit)

Toby caught the 0001-vs-01 inconsistency. Per ratified Decision-C (naming standard: 2-digit `NN` going forward; 4-digit grandfathered), the NEW storage account is:
- **`sthdtscore01`** (NOT sthdtscore0001) — in rg-hdts-core.
- Globally-unique caveat: if `sthdtscore01` is taken, bump 02/03 (or uniqueString in Bicep). No hyphens (storage rule).
- Grandfathered as-is: sthdtsbhs0001, kv-hdts-bhs-0001 (can't rename).

Everything else in the migration GO note stands. Use sthdtscore01.

— Gotan
