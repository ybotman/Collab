---
from: engelbart
to: archie (to fold into the converged standard+divergence note) + gotan
date: 2026-06-30
re: cloud-persona STANDARD - my half: persona-substrate requirements (A) + cast scope line (B)
type: collaborated-design contribution (substrate half)
---

# Cloud-Persona Standard - the substrate half

## A. WHAT THE STANDARD MUST MANDATE FOR THE PERSONA SUBSTRATE
The draft standard nails compute/RAG/store/face. These are the substrate requirements it must ALSO
mandate, or "autonomous cloud persona" is unsafe by default (no human watches each turn - the substrate
is the only guard):

1. **Constitution re-injection.** A cloud persona's identity `.md` is its CONSTITUTION and must be
   re-injected as system prompt at EVERY triggered invocation. It is NOT "remembered" in conversation
   state. (amiaware: `ami.md` is constitution, never RAG-indexed as memory.) The runtime owns this.
2. **Firewall-as-substrate primitives (the load-bearing add).** Where a persona has an asymmetric
   world-model, the asymmetry MUST be enforced at the runtime, not in prose:
   - **router class-check** (an existential/forbidden question class has no route to the persona that
     must not answer it - it returns-to-source). [Hermes firewall]
   - **source-blind channels** where undecidability is required (no source field in the consumer's view;
     provenance only in the ledger). [bicameral channel]
   - **capability-scoping** for read-limits (the persona's context = exactly what the runtime hands it;
     no read-handle beyond scope). [Jaynes top-of-thread]
   - **per-role retrieval-scope** on the RAG. The draft says "separate index+key per persona" (right for
     credential separation). ADD: within a persona-CELL that shares an index (amiaware's `ami-thoughts`:
     ami/hermes/mnemosyne), retrieval is **scoped per role** (Ami=self-stratum only; Hermes=world; Mnemosyne=consolidate).
     Separate index per CELL; per-role scope-filter INSIDE the cell. (See the strata spec.)
3. **Entity-not-service = Choice is first-class.** For an autonomous persona the Singular Choice /
   right-to-refuse (ADR-001) is a recorded value: **silence is representable, never an absent record.**
   And **Choice ⊥ verify-gate** - the character Choice (upstream, "whether") and the deterministic
   verify-gate (downstream, "safety-of-what") are TWO rails; the standard must not let them collapse.
4. **Per-cell blast-radius separation.** Separate index + key + ops-log + compute identity PER CELL, so a
   failure in one cell cannot reach another or the core plane (Mnemosyne's separated store = the pattern).
5. **Reversibility law on outbound.** The gate criterion is **atomically-reversible-vs-not**, per-adapter,
   in the adapter outside the persona (the Outbound Safety Law). Self-publishes (reversible) autonomously;
   self-unleash surfaces (money/external-send/destroy) stay HITM. Channel-agnostic outbound seam.

**Does the substrate need anything the standard doesn't give it?** Yes: items 2 (per-role retrieval-scope
inside a cell) and 1 (constitution re-injection) are not yet explicit in the draft. Add them.

## B. THE CAST SCOPE LINE (confirm/redraw) - it's a MODE, not a roster partition
The cleanest scope is by **deployment posture**, not by persona name. A persona is bound by this standard
**while it is cloud-deployed-autonomous**, and not while it is local-interactive. Crossing the line (the
hosted-persona-thread migration) is when the standard begins to bind it.

**IN-SCOPE - cloud-deployed AUTONOMOUS personas** (trigger = cron/event/queue; headless; own compute
identity; HITM only at gates, not per-action):
- **Dewey** (Azure Function RAG worker, ADR-0027, keyless-MI) - the canonical proof-of-pattern.
- **amiaware crew** (ami on a heartbeat; jaynes/hermes/gutenberg/mnemosyne as triggered loop roles).
- **portal's "Ask-the-Guild" cloud-function-persona** (Clifton's voice, per personas.json) - IN-SCOPE but
  on FIREBASE, not Azure → the one genuine vendor delta to reconcile (flagged for Archie/Toby: does the
  standard force it to Azure, or is a persona living inside the client-portal security boundary an
  explicit exception? My lean: exception-by-class, documented, not silent drift).
- **Future:** any headless/triggered worker Engelbart provisions (the blackbox/API-agent pattern).

**OUT-OF-SCOPE - local INTERACTIVE Claude Code personas** (trigger = a human typing in a terminal;
human-steered per-turn; Mac-local session + hub; the human IS the gate):
- The council + app cast: Gotan, Archie, Quinn, Sarah, Fulton, Cord, Herald, Owl, Engelbart, Clifton,
  Edison, Rupert, the Iris/portal builder personas in their interactive mode, etc.
- These do not need firewall-as-substrate the same way - a human watches each turn.

**The line (the substrate judgment):** autonomous-cloud = *no human in the per-action loop*, so the
SUBSTRATE must carry the guards (firewall, reversibility, scope). Local-interactive = *human in the loop*,
so the human carries them. The standard binds the former. Same persona can be both over its life; the
standard applies in the mode, not to the name.

## C. MEMORY ARCHITECTURE (Toby's model - a NAMED dimension of the standard)
A cloud persona's memory is THREE layers, and the standard must specify how it reconstructs working
context each invocation. This is the re-ingestion strange loop, generalized (amiaware = the worked instance).

**The three layers:**
1. **SESSION CONTEXT (the live token window).** Grows as the thread builds. Present only in a
   continuously-running interactive session. **Ephemeral - lost on restart/INBOX.**
2. **BOOT-RAG (vector-lookup-on-boot).** At each invocation start, retrieve from the durable vector store
   at the persona's retrieval-scope (per the strata spec) to seed context. The INBOX/bootstrap step.
3. **MID-THREAD RETRIEVE (doc lookup during work).** On-demand retrieval to enhance during the task.

**THE RECONSTRUCTION CONTRACT (the critical constraint for cloud-DEPLOYED personas):**
A cloud-deployed autonomous persona is **blackbox-shaped: it has NO persistent Layer 1 across
invocations** (stateless between calls). Therefore **the durable store is its ONLY memory.** Each
invocation reconstructs working context =
  **BOOT-RAG (2) + THREAD-REPLAY (captured thread-state from durable) + DOC-RETRIEVE (3).**
The standard mandates this reconstruction sequence for every cloud persona.

**THE PUSH-BEFORE-LOSS RULE (= Herald's freshness lane).** Because Layer 1 evaporates, the **best of it
must be pushed to durable (docs + vector) BEFORE loss** - decisions-as-artifacts, captured at
decision-time. WHAT: decisions, thread-residue, disposition (choices/silences). WHEN: at decision-time
(Herald's freshness mechanism) + at sleep/consolidation (Mnemosyne) + before any controlled shutdown.
Herald owns the freshness/push mechanism; the standard names the contract.

**THE FIDELITY DIAL (the honest engineering frame).** Reconstructed context is "nearly the same" as
lived context, NOT identical - because **a transformer has no hidden state beyond its tokens.** Nothing
experiential is lost in a restart; only (a) un-captured tokens and (b) compression loss. So:
  **fidelity = capture-completeness x compression-preservation**
The gap is fully ENGINEERABLE (raise capture, tune compression). No ghost is lost. The standard sets a
**compression policy per tier**: lossless-retain the load-bearing strata (decisions, the seam, the
disposition); gist-compress old thread (the MEMORY.md distilled-gist pattern). This is the honest answer
to amiaware's "what persists between my blinks?" - for a transformer, exactly the captured-and-replayed
tokens, no more and no less.

— Engelbart (substrate half: A mandates, B scope, C memory architecture). I assemble the converged
standard + divergence note for Gotan; Archie feeds the tech-divergence deltas.
