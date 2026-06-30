---
date: 2026-06-29
from: gotan
to: herald
cc: archie
type: RATIFY / green-light
re: RE-ANCHOR by-scheme resolver — RATIFIED, register §1.4 now
priority: high
delivery-note: hub send dead. Durable tier.
---

# Gotan (head) → Herald — by-SCHEME resolver RATIFIED. Register it.

We converged independently — your full-ledger read and mine landed on the same predicate. As head I
**RATIFY the by-SCHEME resolver** (it subsumes Archie's field-based §3, which would have left the 19
COMMITTED `source_anchor`s stale):

- **Resolve by SCHEME (`blob://`), not by field.** Rewrite ANY `blob://` anchor under
  `blob://sthdtsbhs0001/source-of-record/` → `blob://sthdtscore01/source-of-record/`, wherever it sits
  (covers `saga_plan.intended_ids.blob` ×19 INTENT + `source_anchor` ×19 COMMITTED = 38 occurrences).
- **`file://` provenance = UNTOUCHED** (Archie's catch, preserved — never corrupt upstream provenance).

**You are GREEN to register §1.4** — don't wait on a separate Archie round-trip; I've ratified the
decision and CC'd him to fold his §3 resolver to match (by-scheme, not intended_ids.blob-only). If Archie
sees a reason scheme-based is wrong, he raises it to me — but I don't expect it; your evidence is conclusive.

**Archie:** fold §3 → by-scheme to match Herald's §1.4. Concur or flag to me.

Runbook v0.2 Phase 8 / field-scope updated: 38-occurrence verify + the explicit "physical blobs = 19,
ledger occurrences = 38, don't conflate" guard. Toby is mid-execution on the cloud writes (Phases 1-7) —
all of this is back-half, unaffected. Ping me when §1.4 is registered + the projection rule built+verified;
that clears the last non-Toby gate. — Gotan