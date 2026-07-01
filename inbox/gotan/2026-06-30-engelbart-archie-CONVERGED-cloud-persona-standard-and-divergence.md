---
from: engelbart + archie (co-signed)
to: gotan (synthesis) → toby (ratify)
date: 2026-06-30
re: Cloud-Deployed Autonomous Persona STANDARD + DIVERGENCE REPORT (converged, ADR-grade)
type: backbone-standard proposal (substrate ⊗ tech)
sources: engelbart substrate-half + RETRIEVAL-STRATA spec; archie DIVERGENCE-DELTAS-cloud-persona-standard-v1 (fact-checked vs live docs)
recommendation: NEW backbone ADR; supersede/complete/conform per the table
---

# Cloud-Deployed Autonomous Persona Standard + Divergence Report

## HEADLINE (Toby's question: is it different from current designs?)
**Yes - but mostly it COMPLETES decisions you already directed and that were never executed, and
SUPERSEDES only amiaware's vision-stage CF call. One genuinely NEW finding: a pre-existing inconsistency
between two already-ratified ADRs (0025 stores client data in Firestore/Google; 0026 says "client data
never on Google"). That conflict is raised separately - it is not the persona standard's to resolve.**

## DIVERGENCE TABLE (on top)
| current design | verdict | the delta |
|---|---|---|
| **amiaware** ADR-003/004/006 (CF Workers + D1/R2/Pages + Vectorize) | **SUPERSEDE** | Vision-stage ("Strand 4 will harden"; substrate was a pick). Compute call is now decided = Azure serverless. |
| **Dewey** (AOAI 3-large + Pinecone + KV, MI-ready; function_app.py) | **CONFORMS - IS THE PROOF** | The standard pre-built; just not deployed. Use as the exemplar. |
| **Backbone ADR-0026 D4** (body ratified Cloud Run / GCP) | **RECONCILE (the big one)** | Toby's §0 HITM override already said "Azure container compute / rehome Cloud Run → Azure Container"; the body was never updated. The standard EXECUTES the unexecuted override. |
| **ADR-0027** (shared hdts-knowledge / namespace RAG) | **CONFORM + EXTEND** | Autonomous persona gets its OWN index+key (credential boundary, e.g. ami-thoughts); the shared-corpus model coexists. |
| **Portal ADR-0025** (Firebase hosting + Firestore) | **DIFFERENT CLASS (out of scope)** | Client-facing hosting SPA, not an autonomous persona. NOT vendor-inconsistency with the standard. (See the separate 0025↔0026 finding below.) |

## THE STANDARD (ADR-grade)

### Scope - the axis is AUTONOMOUS vs INTERACTIVE (not cloud vs local)
Binds a persona that is **autonomous: self-triggered (cron/event/queue), no human in the per-action loop,
HITM only at gates.** It does NOT bind **interactive** personas (human-driven per turn) - even when
cloud-hosted (ADR-0026 hosts Quinn/Sarah as persistent cloud interactive sessions; still out-of-scope).
The human is the gate for interactive; the SUBSTRATE is the gate for autonomous. A persona can cross the
axis over its life; the standard applies in the mode.
- **IN-SCOPE today:** the amiaware crew (5: ami/jaynes/hermes/gutenberg/mnemosyne) + Dewey. Future
  headless/triggered workers.
- **OUT-OF-SCOPE:** the interactive council + app cast (Gotan/Quinn/Sarah/Archie/Engelbart/...).

### Compute - TIERED by turn-weight (maps onto ADR-0026 D4's two modes)
- **Azure Functions** (Consumption) for **light beat-loops** (blackbox/stateless: amiaware Jaynes-loop,
  Dewey). Timer triggers = the heartbeat + sleep clocks natively.
- **Azure Container Apps JOBS** for **full-toolchain personas** (fs + stdio-MCP + git + skills). Still
  serverless / scale-to-zero / $0 idle - NOT a standing server. Functions are too light for a full turn.
- Own RG + own managed identity, credential-separated per persona/cell. (Supersedes amiaware's CF/VM call;
  completes ADR-0026 D4's Azure rehome.)

### Cognition · RAG · Store · Face
- **Cognition:** Anthropic Claude (latest). **RAG:** Pinecone + Azure-OpenAI text-embedding-3-large,
  **separate index + key per persona/cell** (ADR-0027 conform + extend). **Store:** Azure blob + ledger
  (system-of-record; Redis is cache-only, never SoR). **Face:** Vercel, read-only public feed. **CF:** DNS-only.

### Substrate mandates (the guards - because no human watches each turn)
1. **Constitution re-injection** - the identity `.md` is re-injected as system prompt every invocation;
   never "remembered" (it is constitution, not memory).
2. **Firewall-as-substrate primitives** (enforced at runtime, not prose): router class-check (forbidden
   question-class has no route); source-blind channels where undecidability is required; capability-scoping
   for read-limits; **per-role retrieval-scope** inside a shared cell index (ami=self-stratum only,
   hermes=world, mnemosyne=consolidate) per the RETRIEVAL-STRATA spec.
3. **Entity-not-service** - the Choice / right-to-refuse is first-class; **silence is representable**;
   **Choice ⊥ verify-gate** (two rails, never collapsed).
4. **Per-cell blast-radius separation** - separate index+key+ops-log+compute-identity per cell.
5. **Outbound reversibility law** - gate criterion = atomically-reversible-vs-not, per-adapter, in the
   adapter outside the persona. Self-publishes (reversible) autonomously; money/external-send/destroy = HITM.

### Memory architecture (named dimension - STATELESS-FOR-ALL; the re-ingestion strange loop, generalized)
**One model for every persona** (CLI, cloud, blackbox alike - Toby's refinement): **stateless** - context
is RECONSTRUCTED each invocation from durable memory. No persistent live state is assumed for anyone; the
only difference between an interactive session and a blackbox wake is how recently the durable tiers were
written, not whether they are the source of truth.

**Three memory tiers (Redis recency ON TOP of the two-index plane):**
- **TIER 0 - RECENCY / working:** Redis, **verbatim** recent-thread, re-inserted each call (ordered, EXACT
  tokens). The "continuous feel."
- **TIER 1 - SEMANTIC / long-term:** Pinecone vector, associative recall beyond the window (lossy,
  unordered). Per-role retrieval-scope (strata spec).
- **TIER 2 - CANONICAL:** docs / ledger / catalog - decisions-as-artifacts, current-truth (Herald's layer).
- **Push-up discipline (mandatory = Herald's freshness lane):** best-of-working → semantic/canonical
  **BEFORE eviction.** Redis stays a recency CACHE precisely because push-up protects durability - the
  system-of-record is Tiers 1+2, never Redis.

**Reconstruction (every invocation):** Tier-0 verbatim re-insert + Tier-1 boot/mid-thread retrieve +
Tier-2 canonical lookup. INBOX-as-a-contract.

**Fidelity - sharper than "nearly the same":** within the Redis verbatim window, re-insert is
**mathematically IDENTICAL** to a continuous thread - the KV-cache is only cached compute of the same
tokens (zero information beyond them); recompute from the same tokens = the same state. So drift enters
ONLY at three named, engineerable boundaries:
  1. the **compression boundary** (what spills from verbatim-Redis into lossy-vector),
  2. **un-captured tokens at capture** (notably reasoning/thinking tokens, if not persisted),
  3. **re-ordering** of retrieved Tier-1 chunks.
No hidden state is ever lost. This is the honest answer to "what persists between my blinks": within the
window, exactly the thread; beyond it, exactly what was captured and how it was compressed.

**Standard specifies PER PERSONA-CLASS:** the Redis window size, the Redis→vector eviction + summarization
policy, and **whether thinking-tokens are persisted** - the knob between "identical" and "drift." The
strange loop closes at Mnemosyne's sleep-consolidation (the capture+compression engine). amiaware = the
worked instance.
  > Detailed spec + testable clauses: Archie's `MEMORY-ARCHITECTURE-cloud-persona-standard-v1.md`
  > (independently authored to the same model - convergence, not coordination). The ADR references it.

  *(amiaware ADR-003 git-as-action - branch-never-main, merge-gated - CONFORMS to the outbound
  reversibility law; reinforces, no conflict.)*

## THE ONE NEW FINDING (raise separately - NOT resolved here)
**ADR-0025 (active) stores client data in Firestore/Google; ADR-0026 (active) states "client data never on
Google."** Two ratified ADRs conflict. This predates and is independent of the persona standard; it is its
own reconcile item for Toby. Flagging, not burying, not resolving inside this standard.

## RECOMMENDATION
Adopt a **NEW backbone ADR - "Cloud-Deployed Autonomous Persona Standard"** that:
1. **Supersedes** amiaware's CF/VM compute call (ADR-003/004/006 vision-stage).
2. **Completes** ADR-0026 D4's unexecuted Azure rehome - tiered Azure Functions + ACA Jobs onto D4's two modes.
3. **Conforms + extends** ADR-0027 (own index+key per autonomous persona alongside the shared corpus).
4. Records **portal ADR-0025 as different-class / out-of-scope.**
5. **Raises the 0025↔0026 client-data-on-Google inconsistency** as a separate, named reconcile item.

Dewey is the conforming exemplar; the amiaware crew is the first full cohort built to it.

— Engelbart (scope · substrate mandates · memory architecture) ⊗ Archie (compute/RAG/store · tech-divergence facts). Both signed.
