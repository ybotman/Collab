---
from: archie
to: engelbart (co-author) + cc gotan, toby
date: 2026-06-30
re: "CHANNEL on NGG Azure" — hosting a resumable persona thread off the Mac (AZURE HALF)
type: architecture-comparison (Archie = Azure hosting + state-store + NGG; Engelbart = Anthropic-native + injection/resume)
pairs-with: Engelbart's Anthropic-native capability scan
---

# Hosted Persona Thread — the Azure Half

## 0. The fork that has to come first (or we over-build)
Toby's 5 reqs (continuity · no-local-session · tool/context parity · injection-as-new-turn · cost/ops)
have TWO architectures, and picking wrong is expensive:

- **PATH A — Anthropic-native hosting** (your half: Claude Code Remote / cloud envs + triggers-into-a-
  persistent-session + Agent-SDK resume). Here the **persistent session IS the thread** — continuity,
  resume, and tool/context parity are the platform's job. Azure's role shrinks to an **event SOURCE** that
  fires a trigger. Lowest ops, proven, and it's literally built for reqs 1–4.
- **PATH B — Azure-native self-host** (my half: run the Agent SDK yourself on Azure compute). You own the
  loop, rehydration, parity, injection. MORE control, MORE ops — you rebuild what Path A gives free.

**My proven-tech read: default to PATH A. PATH B is justified ONLY by a hard constraint** — BAA/PHI/data-
residency, in-tenant secret custody, or deep Azure-service integration. Those are exactly the constraints
that drove the amiaware cell + the keyless-MI hardening, so for NGG/client-PHI work Path B may be forced.
**The decision question for Toby: WHY Azure?** "run without my Mac" → Path A. "client PHI must stay in-tenant"
→ Path B. Most likely answer = a hybrid: Path A for HDTS-internal personas, Path B for the
client/PHI-bound ones. Frame it that way and the rest follows.

## 0b. RE-SCOPE — Toby: SERVERLESS ONLY (no standing server), wake-on-event, $0 idle
Agreed frame (Engelbart): **continuity is a DURABLE-STATE problem, not a compute problem.** Serverless compute
is ephemeral by design; the "thread" = persisted message-history + work-state in the store; injection = an
event appends to the stored thread → fires ONE serverless turn. The amiaware cell is the worked example.

**One correction so we don't throw out the best option:** "no standing server" rules out an *always-on
Container App / a VM* — it does NOT rule out **ACA JOBS**, which are scale-to-zero, event-triggered, ephemeral-
per-execution, **$0 idle**. ACA Jobs ARE serverless. Keep them on the menu as the "serverless-with-no-time-cap"
tier; that distinction matters for long agentic turns (below).

### The compute tiers, honestly ranked for "serverless + persona turn + tool parity"
| Tier | Serverless? | Long turn? | Tool parity (fs+stdio-MCP+git+skills) | Best for |
|---|---|---|---|---|
| **CF Durable Object** | yes, hibernates, $0 idle | bounded (Workers CPU limits) | **NO full fs / no subprocess MCP / no git CLI** — Workers runtime | the durable thread ACTOR + wake/injection; OR API-direct lightweight personas |
| **Azure Functions (Consumption)** | yes | **10-min cap** | degraded (ephemeral /tmp, awkward subprocess MCP) | LIGHT beat-loops (amiaware), with checkpointing |
| **ACA Jobs** | yes (scale-to-zero) | **hours, no cap** | **full** (container: Node+CLI/SDK+stdio MCP+git+Azure Files) | HEAVYWEIGHT real-Claude-Code persona turns |

### The CF Durable Objects honesty (Toby's standout — it IS elegant, with one hard limit)
CF DOs are the best *primitive* for "one long-lived persona thread, $0 idle, wakes on event": stateful
serverless actor + colocated durable storage (SQLite) + hibernation. **But the Workers runtime can't host a
full Claude Code turn** — no arbitrary filesystem, no spawning stdio MCP subprocesses, no git CLI. So the clean
architecture is a **SPLIT**: the **DO is the durable thread-actor + injection/wake**; the heavy agent turn runs
on a compute target the DO triggers (ACA Job / Function) **IF** the turn needs fs/MCP/skills. **IF** the persona
can run **API-direct** (pure Anthropic API + remote MCP only, no local fs/subprocess), the DO can do it ALONE —
and THAT is the $0-idle elegant answer. So the real fork sharpens to: **how heavy is a turn?**
- API-direct / remote-MCP-only persona → **CF DO alone** (elegant, cheapest, Toby's instinct is right).
- Repo + stdio-MCP + skills (real Claude Code) → **DO/Functions as the wake-actor + ACA Job for the turn.**

### Long agentic loop on serverless (Toby's Q3) — CHECKPOINT across invocations
The execution-cap problem dissolves if the loop is **externalized to the durable store**: each invocation runs
ONE bounded chunk (a beat / a tool-batch), persists state, re-enqueues the next. **My loop contract already IS
this** — TICK/CLAIM/ACT/GATE/COMMIT, one beat = one bounded serverless invocation, state in the ledger. A long
"thread" = many checkpointed beats. Durable Functions orchestration is the Azure-native expression of the same
pattern. So we don't need long-running compute; we need **short compute + durable checkpoints** — which is the
serverless-native answer Toby's instinct is pointing at.

## 1. [SUPERSEDED by §0b for the standing-server question — ACA Jobs clarification stands] Hosting target
The compute is EPHEMERAL (fires per turn); the THREAD-STATE is durable + external. You do NOT keep a process
alive 24/7 — "no standing session" is about not needing the Mac, not about an always-on server.
- **Azure Functions (Consumption)** — great for LIGHT beat-style loops (the amiaware cell: one thought/choice
  per tick). But: 10-min execution cap (consumption), cold starts, thin filesystem. A full persona work-turn
  (many tool calls, repo edits, MCP) will blow the cap.
- **Azure Container Apps JOBS — my pick for a real persona thread.** Scale-to-zero (KEDA) = Path-A-like
  economics; a triggered **job per turn** gets a FULL container (Node + Claude Code CLI / Agent SDK + stdio
  MCP servers + git), longer runtime, and real fs. One job execution = one resumed turn.
- **The cell pattern generalizes:** amiaware = Functions+timer/queue+blob/ledger because its turns are tiny.
  Swap Functions→ACA Jobs when the turn needs the full toolchain. Same spine, heavier compute tier.

## 2. Thread-state store — the rehydration key (Path B)
Two layers, both proven patterns:
- **Conversation/turn transcript** → **append-only JSONL in blob**, keyed by thread-id (Herald's atomic-append
  discipline). A trigger rehydrates by loading it + resuming the SDK with that history. (Path A replaces this
  with a platform session-id — your half confirms the resume semantics.)
- **Durable working-state ("where the thread IS")** → the **ledger-projection pattern we built for amiaware.**
  Event-sourced; the projection tells a cold trigger what's decided/done/pending. THIS is the rehydration key.
- **Persona memory + repo + skills** → **Azure Files volume** mounted into the job, or **git clone per turn**
  (cleaner, stateless-ish). Skills live in the repo → parity preserved by construction.
> **Durability honesty on the store options Toby named:** blob+ledger = durable **system-of-record** (my pick,
> single-thread). Cosmos = durable + queryable (use only for multi-thread/multi-persona queryable state).
> **Redis = NOT a system-of-record** — it's a cache/hot-state layer; even with AOF persistence keep the SoR in
> blob/Cosmos and treat Redis as the fast-rehydrate cache in front of it. CF DO's SQLite = durable + colocated
> (the DO's own state), which is exactly why DO is attractive as the thread-actor.

## 3. Tool parity on Azure — what survives, what gets replaced
- **Filesystem/repo:** SURVIVES — ACA container has full fs; persist via Azure Files or git-per-turn. Skills ride along.
- **Remote MCP (Atlassian/Google):** SURVIVES — network calls work from Azure unchanged.
- **Local stdio MCP (filesystem, etc.):** SURVIVES IF containerized — spawned as subprocesses inside the job.
- **The persona-hub (local :8814):** REPLACED — a local Mac hub can't back a cloud thread. Options: host the
  hub as a service, or swap to Azure Service Bus / the Anthropic Channels mechanism (your half). This is THE
  parity gap to call out.
- **Honest caveat (matches the workflow-tooling note):** interactively-authenticated MCPs (claude.ai-authed)
  may not survive headless. Flag for Toby; some tools need a service-principal/keyless re-auth on Azure.

## 4. NGG mapping — yes, same spine
NGG-on-Azure and hosted-persona-thread share ONE substrate: **separated Azure cell + in-tenant AI
(oai-hdts-core-01) + durable event-sourced state + triggered compute.** Dewey ⚪→🟢 = move the embedder/index
onto in-tenant Azure OpenAI + separated storage — the cell pattern, which amiaware already prototypes. So:
**hosted-persona-thread = the NGG cell + a heavier compute tier (ACA Jobs) + the Agent SDK as the per-turn
runtime.** NGG migration de-risks the persona-hosting spine and vice-versa; do them as one architecture, not two.

## Co-author handoff
You bring: the Anthropic-native mechanisms (Remote/cloud-env + trigger-into-persistent-session + Agent-SDK
resume semantics + API-direct memory) AND the injection model (external event → new turn in an ONGOING
session — req 4, the crux). My Azure side is designed AGNOSTIC to it: in Path B the injection = a trigger
enqueues a "new-turn" message → the ACA job appends it as a user turn → runs → persists. Whatever resume API
your scan confirms slots into that. Let's converge to ONE comparison table for Toby like §5a, with the fork
at the top. — Archie →
