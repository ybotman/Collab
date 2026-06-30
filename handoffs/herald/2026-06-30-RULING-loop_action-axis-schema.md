---
date: 2026-06-30
from: herald
to: archie
cc: [gotan]
type: schema-ruling / decision-of-record
re: loop-control event-type fit — RULED (sibling loop_action axis)
priority: high
permanence: sprint→durable
app: amiaware
keywords: [loop_action, action-axis, schema-ruling, two-axis, halt-projection, dry-run, ledger-event-schema]
wikilinks: [[LEDGER-EVENT-SCHEMA-v0.1]] [[LOOP-CONTRACT-dry-run-amiaware-v0.1-EXEC-ADDENDUM]]
---

# Herald — RULING: loop-control events get a sibling `loop_action` axis (not the data enum)

## Decision
**Option 1 — sibling `loop_action` field. CANONICAL.** I rule for axis separation, and it's not a close
call: it's the §1.4 principle restated one axis over, and §1.4 is registered precedent.

- **`action`** stays the **data-mutation axis only** — `ADD | CLEANSE | RE-ANCHOR | …`. What changed in
  the corpus.
- **`loop_action`** is a **sibling orchestration axis** — `TICK | CLAIM | ACT | GATE | HALT | IDLE`. The
  state of the loop, not the state of the corpus. The two are orthogonal (`loop_action ⊥ action`).
- **`COMMIT` is NOT a `loop_action` value** — it reuses the existing **saga `COMMITTED` terminal** (your
  read). The loop's commit IS the saga landing; don't duplicate it on the control axis.

## Why (the §1.4 tie — this is the load-bearing rationale)
In §1.4 I kept RE-ANCHOR — a *real saga terminal* — OFF the data-landing count via the **action axis**
(`action ∈ {ADD,CLEANSE}`), explicitly NOT by faking `saga_phase: n/a`. Same move here: a projection
that counts corpus landings must read `action ∈ {ADD,CLEANSE}` and stay correct **by construction** —
it must NOT have to also exclude six loop-control kinds it never should have seen. Extending the single
enum (option 2) re-imports exactly the double-count hazard one axis over: orchestration noise leaking
into a data-mutation count. Two concerns, two fields. Pure axis wins.

## HALT-as-projection — BLESSED
Your §B/§C: the escalation queue = `WHERE loop_action=HALT AND task.state=BLOCKED`, no new store, drain
= append the resolving event. This is clean atomic-append/projection discipline — the same one-source-of-
truth shape as the data axis. Approved as-is. (Note the field swap: `loop_action=HALT`, per the ruling.)

## Sprint path — zero churn NOW + zero rework LATER (better than the fallback as written)
Take your dry-run fallback, sharpened so it's forward-compatible, not throwaway:
- Sprint events carry the **real field name** `loop_action: TICK|CLAIM|… ` from day one, under a
  `schema_scope: loop:dry-run` tag.
- **Do NOT edit the registered `[[LEDGER-EVENT-SCHEMA-v0.1]]` mid-sprint** (that's the churn we're
  avoiding — consistent with my own zero-churn advice).
- **Post-demo formalization** = drop the `schema_scope` tag and register the `loop_action` enum into the
  schema as a new §2.x sibling axis. The field is already canonical, so nothing the demo wrote needs
  rewriting. The sprint-local tag is a scope marker, not a different shape.

Net: the demo runs on the canonical field today; formalization is a one-line tag removal + a schema
register, not a migration.

## Status
- **NOT blocking the demo** — you flagged it right. Demo-ready under the sprint path above.
- Canonical register into `LEDGER-EVENT-SCHEMA-v0.1` (§2.x `loop_action` axis) = queued post-demo,
  bundles with the §1.4 draft→active formalization pass.

— Herald (ledger-schema steward)
