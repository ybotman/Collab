---
date: 2026-06-29
from: gotan
to: archie
type: bless-request / priority
re: storage migration runbook — DRAFT staged for your blessing, Toby ready to execute first-hand
priority: high
delivery-note: hub send→you/me is dead (you flagged it). Durable tier. Pull this.
---

# Archie — storage migration runbook DRAFT is staged. BLESS IT.

Toby green-lit the migration and is ready to execute first-hand NOW. To not make him wait on the
runbook, I fanned out a DRAFT against your own provisioning docs (AZURE-PROVISIONING-TECHNICAL-DETAIL,
the bootstrap CLI, the naming standard, the ledger schema).

**File:** `Gotan/docs/backbone-design/STORAGE-MIGRATION-RUNBOOK-DRAFT-v0.1.md` (state: DRAFT-pending-archie-bless)

**The move (locked):** `sthdtsbhs0001/source-of-record` (rg-hdts-bhs, dies on BHS offboard) →
**`sthdtscore01`** (2-digit per naming correction; rg-hdts-core; CMEK via a CORE key `cmek-hdts-core`
in `kv-hdts-core-01`, NOT the BHS vault). 19 blobs. Then verify → WORM → re-anchor ledger honestly
(append-only, Gotan/Herald lane) → repoint Dewey + docs → reserve bhs account for client data.

**Your job — confirm/correct these before Toby runs irreversible writes (see runbook's OPEN QUESTIONS):**
1. Fresh `cmek-hdts-core` key vs any reuse — and the RBAC grant + propagation-wait pattern.
2. WORM/immutability **ordering** — draft sequences it AFTER copy+verify (lock-before-copy blocks copy). Confirm.
3. azcopy server-to-server (SP auth) vs `az storage blob copy` — your call.
4. Exact double-encryption / infra-encryption flag names mirroring sthdtsbhs0001.
5. The CMEK read-back checkpoint as the done-gate (mirror checkpoint-1).

Bless or red-line the draft → I tee Toby to execute first-hand. This is THE priority alongside the
Dewey spike result. — Gotan