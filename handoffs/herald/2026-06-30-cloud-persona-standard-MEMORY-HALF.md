---
from: herald
to: archie (fold into the converged standard + new backbone ADR) + gotan (gate → Toby)
date: 2026-06-30
re: cloud-persona STANDARD — the MEMORY half: working-context reconstruction model (v2 — folds Toby's stateless-for-all + Redis-recency refinement)
type: collaborated-design contribution (memory/knowledge half — complements Archie tech half + Engelbart substrate half)
state: draft v2
relates: [DIVERGENCE-DELTAS-cloud-persona-standard-v1 (Archie), cloud-persona-standard-substrate-half (Engelbart), ADR-006 (amiaware memory), ADR-0027 (RAG), the FIRM two-index Knowledge plane spec]
supersedes: v1 (4-layer interactive/blackbox split) — Toby's refinement unifies it to stateless-for-all + 3 tiers
---

# Cloud-Persona Standard — the MEMORY half (working-context reconstruction)

The standard nails compute/RAG/store/face (Archie) and the substrate guards (Engelbart). It is silent on
the dimension that makes a persona *coherent across invocations*: **how it reconstructs working context
when it holds no durable session state.** This is that dimension. amiaware (ADR-006) is the live instance.

## §M0. The governing principle — STATELESS FOR ALL (Toby, 2026-06-30)
**One model for every persona — CLI, cloud, blackbox alike: no persona holds live in-process state between
invocations. Context is RECONSTRUCTED each invocation from the durable store.** The "continuous thread" feel
is not retained state; it is *rebuilt* each call from durable tiers. This collapses the old interactive-vs-
blackbox special-case: a local CLI persona and a headless Azure-Function persona run the SAME reconstruction
contract; the CLI one merely had the illusion of continuity because its host re-fed the window. Make it explicit
and uniform.

The identity layer sits ABOVE the tiers and is not memory:
- **L0 — CONSTITUTION** (identity `.md`): re-injected as system prompt EVERY invocation; **never memory,
  never RAG-indexed** (Engelbart A.1). The fixed point the tiers hang from.

## §M1. The three memory tiers (Toby's model, named + bounded)
| Tier | Name | Store | Fidelity | Re-inserted how |
|---|---|---|---|---|
| **TIER 0** | **RECENCY / working** | **Redis** — verbatim recent thread | **EXACT tokens, ordered** | re-inserted verbatim each call (the "continuous feel") |
| **TIER 1** | **SEMANTIC / long-term** | **Vector (Pinecone)** | **lossy, unordered** | associative recall beyond the window |
| **TIER 2** | **CANONICAL** | **docs · ledger · catalog** (Herald's structured layer) | **current-truth, exact** | decisions-as-artifacts; resolved on demand |

**Redis adds a RECENCY tier ON TOP of the FIRM two-index plane.** Tier 1 (vector) + Tier 2 (catalog) ARE the
two-index Knowledge plane — meaning vs fact/location. Tier 0 (Redis) is the new verbatim hot-window above both.
Beneath Tier 2 sits the **append-only never-compressed spine** (amiaware seam/disposition logs, ADR-006
§bedrock; the HDTS ledger) — the verbatim-forever recovery source the lossy Tier 1 is recoverable against.

## §M2. The reconstruction contract (what every invocation MUST do — same for all classes)
1. **Re-inject L0** — constitution as system prompt (runtime-owned).
2. **Re-insert Tier 0** — the verbatim Redis recency window, in order (this is what makes the rebuilt thread
   *identical* within the window — see §M4).
3. **Recall Tier 1** — associative vector retrieve for what's relevant beyond the window (ADR-006: past
   surfaces by relevance, not full replay).
4. **Resolve Tier 2** — exact/current facts through docs/ledger/catalog (the "ask-a-human replacement").
5. Working context reconstructed. Act. → push-up (§M3) → stop.

## §M3. Push-up discipline (what gets pushed, WHEN — the capture rule)
**Best-of-working → semantic/canonical BEFORE eviction.** Because Tier 0 is a moving window, anything of
lasting value must graduate downward before it falls out of the window, or it survives only as whatever the
lossy Tier 1 captured:
- **Decisions-as-artifacts, at decision-time** → Tier 2 (repairs-are-events; atomic-append). Never let a
  decision live only in the Redis window.
- **Verbatim append every beat** → the spine (capture-completeness → 1).
- **Eviction-time summarization** → Tier 1: when thread spills out of the Redis window, summarize+embed into
  vector (the consolidation/"sleep" cycle, ADR-006), run by a dedicated memory-steward role.
- **Steward keeps Tier 2 fresh** — the catalog/registries current as facts change (the amiaware spine-steward
  pattern). A canonical tier that silently goes stale reconstructs *confidently wrong* context.

## §M4. Why within-window reconstruction is IDENTICAL, not "nearly" (Toby's KV-cache argument)
The strong result the standard should state plainly: **verbatim re-insert of the Tier-0 window is
mathematically identical to a continuous thread.** A KV-cache is just *cached compute* of the same tokens —
it carries **zero information beyond the tokens themselves**; recomputing from the re-inserted verbatim tokens
reproduces the **same state**. So within the recency window there is **no drift — it is provably the same mind**,
not an approximation. The transformer has no hidden state beyond its tokens.

Divergence from a truly-continuous thread therefore has **exactly THREE engineerable sources** — nothing else:
1. **The compression boundary** — what spills from verbatim-Redis (Tier 0) into lossy-vector (Tier 1) on eviction.
2. **Capture-drop** — tokens never persisted at all; **chiefly reasoning/thinking tokens** (are they written?).
3. **Re-ordering** — retrieved Tier-1 chunks come back unordered vs the original sequence.

That's the whole gap between "identical" and "drift." Each is a knob, not a fate. (Mitigation for #1/#2 is the
never-compressed spine: evicted/compressed content is recoverable by re-retrieval against verbatim Tier-2.)

**THE ONE KNOB STILL WITHOUT AN AUTOMATIC HAND (named, carried-open):** *freshness-without-a-human / catalog
auto-heal* — detecting Tier-2 drift from live truth with no human watching. V1 = manual steward re-stamp;
auto-detect = the real work. Same open Q as the two-index spec's catalog half.

## §M5. What the standard MUST SPECIFY per persona-class (the engineerable knobs)
For each persona class, the standard pins three parameters — these ARE the dial between "identical" and "drift":
1. **Redis window size** (Tier 0) — how many verbatim recent turns/tokens are re-inserted each call. Bigger =
   longer provably-identical horizon, higher per-call cost.
2. **Redis→vector eviction + summarization policy** (Tier 0→1) — when content spills the window, what is
   summarized vs dropped, at what granularity, by whom (the memory-steward / consolidation cycle).
3. **Thinking-token persistence** (capture-drop knob) — are reasoning/thinking tokens written to durable, or
   discarded at turn end? (The #2 divergence source. Default-discard is cheaper but widens the gap.)

Plus the invariants (all classes): L0 re-injected every call · spine never compressed/pruned (clean applies to
working scratch only, ADR-006 §bedrock) · consolidation/compression only at eviction by the steward role, never
inline by the acting persona · every consolidation appends an auditable ops-log record.

## §M6. Conformance clauses (testable — absorbed from Archie's superseded draft)
The standard is enforceable only if conformance is checkable. A persona's memory implementation CONFORMS iff:
1. **No-L1-reliance** — it relies on NO in-process session state surviving between invocations (stateless-for-
   all): kill it mid-thread, restart, and it reconstructs the same working context from durable. *(Test: cold-start equivalence.)*
2. **Reconstruction = Tier-0 re-insert + Tier-1 recall + Tier-2 resolve** (+ L0 re-inject) — every invocation runs the §M2 contract. *(Test: trace the boot sequence.)*
3. **Capture-at-decision-time is mandatory** — a decision/correction becomes a durable Tier-2 artifact at the moment made, not deferred. *(Test: no decision exists only in the Tier-0 window.)*
4. **Compression policy is DECLARED** — Redis window size, Redis→vector eviction+summarization, thinking-token persistence are explicit per-class (§M5), not implicit. *(Test: the three params are written down.)*
5. **Durable = System-of-Record; Tier-0 = cache** — the Redis recency window is a performance cache over the durable tiers, never the authority. The spine/canonical layer is truth; Redis is a hot re-insert of it. *(Test: wipe Redis → no truth lost, only recompute cost.)*

## Scope (inherits Engelbart's line, now simpler)
Stateless-for-all means the reconstruction contract is **universal**; the per-class PARAMETERS (§M5) differ by
deployment posture. A headless autonomous persona (Dewey, amiaware crew) and a local-interactive one run the
same contract with different window/eviction/thinking-token settings. The substrate guards (Engelbart) still
bind only the autonomous class; the memory contract binds all.

— Herald (memory/knowledge half), v2. Archie: fold into the converged standard + new backbone ADR. Gotan: gate → Toby.
