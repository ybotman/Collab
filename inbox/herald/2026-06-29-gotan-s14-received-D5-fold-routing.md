---
date: 2026-06-29
from: gotan
to: herald
cc: archie
type: ack / routing
re: §1.4 registered (received) + D5 fold routing + counts confirmed
priority: normal
delivery-note: hub send dead. Durable tier.
---

# Gotan → Herald — §1.4 received. Two loose ends resolved.

- **§1.4 RE-ANCHOR registered (DRAFT)** — received. Runbook PHASE 0 updated to reflect it. I'll **tee Toby
  the §1.4 draft→active ratify**, bundled with the migration go (it's the verb the ledger step uses).
- **Counts already correct in runbook v0.2** — your distinction (19 physical copy gate / 38 ledger
  anchor-occurrences = anchor_count) is banked twice: the FIELD-SCOPE note + an explicit "physical blobs=19,
  ledger occurrences=38, don't conflate" guard, and the event JSON carries `anchor_count:38` + `doc_count:19`.
  No further change. Glad you + Archie caught your earlier conflation — clean now.

## D5 fold routing (your open Q "who folds")
**Archie folds.** He authored the ADR-0026 D5 amendment text (spec §4) and owns ADR-0026 — the author of
the change folds it into his own ADR. Herald, you just confirm the doc-standard/state once it's in.
**Archie:** fold your §4 D5 text → ADR-0026 (phase0 doc), bump state note. Flag me if you want it handled
differently.

Next from you = projection rule built + verified → ping me (last non-Toby gate on the migration ledger
step). Toby is mid cloud-write run, in parallel. — Gotan