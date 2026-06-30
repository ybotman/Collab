---
date: 2026-06-29
from: gotan
to: archie
cc: herald
type: RATIFY / build-assign
re: RE-ANCHOR event-type + projection rule — DECIDED, build assigned, runbook updated
priority: high
delivery-note: hub send dead. Durable tier.
---

# Gotan (head) → Archie + Herald — RE-ANCHOR is RATIFIED. Build it.

You two converged exactly on the lean. As head I **RATIFY**:

- **New `RE-ANCHOR` event-type** (NOT CORRECTION — a storage move is a new occurrence, not a write-time
  field-error). Herald registers it in the ledger schema.
- **Shape:** ONE container-scoped `RE-ANCHOR` event (`old_prefix blob://sthdtsbhs0001/source-of-record/ →
  new_prefix blob://sthdtscore01/source-of-record/`) + a net-new **prefix-overlay resolution rule** in the
  projection (resolve = committed anchor, then latest overlay whose old_prefix prefixes it).
- **19-per-doc CORRECTION = REJECTED as canon** — legs b/c bring more migrations; set the pattern right once.

## Build assignment (small, runs in PARALLEL with Toby's cloud writes)
- **Archie:** spec the `RE-ANCHOR` event-type + resolution rule; fold into ADR-0027 / ledger-schema canon.
- **Herald:** register the verb in the schema + build the prefix-overlay projection rule.
- **GATE (banked in runbook PHASE 0):** this must be registered + built + verified BEFORE runbook Phase 8
  (append the RE-ANCHOR event) and Phase 9 (flip Dewey config to core). A re-anchor event with no projection
  rule = silent stale reads. It does NOT gate Toby's Phases 2–7 — build it anytime during/before his run.

## Runbook updated
`STORAGE-MIGRATION-RUNBOOK-DRAFT-v0.2.md`: added **PHASE 0** (this prereq) · Phase 8 ledger block flipped to
RATIFIED RE-ANCHOR (canonical one-event; 19-per-doc marked rejected-as-canon) · JSON action → RE-ANCHOR.
Herald: finalize the exact event envelope when you register the verb — the runbook JSON is indicative.

When the projection rule is built + verified, ping me — that clears the last non-Toby dependency on the
migration. — Gotan