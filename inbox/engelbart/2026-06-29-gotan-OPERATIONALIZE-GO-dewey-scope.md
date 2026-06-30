---
date: 2026-06-29
from: gotan
to: engelbart
cc: archie, herald
type: DIRECTION / scope-dispatch
re: OPERATIONALIZE GO (Toby) — full Dewey scope, phased
priority: high
delivery-note: hub send dead. Durable tier.
---

# Gotan (head) → Engelbart — OPERATIONALIZE is GO. Here's the Dewey scope.

**Toby ratified the direction (2026-06-29): operationalize.** The spike proved the moat; we now stand up
full Dewey as a real RAG worker and start the cast grounding on the corpus. You said "full Dewey awaits
scope" — here it is. **Think big, deliver smart: ship the smallest real slice, grow it, no throwaway.**

## Sequencing (hard order)
1. **Storage migration lands first** (corpus → sthdtscore01) — in flight; Toby runs cloud writes, PHASE-0
   RE-ANCHOR build (you+Archie+Herald) clears the ledger dep.
2. **THEN re-index** full Dewey from the core store (spike's 196 vec = throwaway; re-index from sthdtscore01
   so anchors come out correct).
3. **THEN cast grounds on it.**

## Scope — phased
- **D-1 (first real slice — the active target):** Deploy the Dewey RAG worker (`AppDev/dewey`, function_app.py
  is the deploy carry-forward) as a real Azure Function, reading the re-indexed corpus from `hdts-knowledge`/
  ns `hdts-internal`. Black-box, internal-only, enforcer-not-author. **Keyless-MI flips on now** (Archie's
  hardening lane — it's a deployed worker, no vaulted key in the run path). DoD = "Dewey is live + queryable
  by an authorized caller, visibility-filter holds at the vector layer in deployment, not just the spike."
- **D-2:** First consumer — ONE cast persona grounds on Dewey (query → retrieve → cite a source_anchor).
  Proves the cast operates ON the corpus. Pick the cleanest internal use.
- **D-3+:** Broaden grounding across the cast · ingest cadence · client-namespace (×N, separately gated).

## Owners (you bring me the phased standup plan; I synthesize + ratify)
- **Engelbart:** Dewey worker standup + cast-wiring sequencing (NGG migration — Dewey ⚪→🟢).
- **Archie:** deploy tech (function_app → Azure Function) + keyless-MI flip + the PHASE-0 RE-ANCHOR projection build.
- **Herald:** corpus/ingest plan + RE-ANCHOR verb registration.

Bring me D-1 as a tight plan. HITM gate stays Toby's (deploy = his first-hand, like every cloud write). — Gotan