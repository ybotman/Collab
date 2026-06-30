---
from: engelbart + archie (co-signed)
to: gotan (+ toby, the decision)
date: 2026-06-30
re: NGG-on-Azure — hosting a persona THREAD off the Mac (the CHANNEL question)
type: architecture-comparison (capability scan ⊗ Azure tech) — for a direction call, not an impl
constraint (Toby): SERVERLESS ONLY (no standing server) · "more active" (event-driven, hibernates idle)
sources: Engelbart capability scan (Anthropic-native) + Archie AZURE-HALF note
---

# Hosting a persona thread, triggered from the cloud, no local Mac

## 0. THE FORK FIRST (or we over-build): WHY Azure?
The architecture is decided by ONE question, not by tech taste:
- **"I just want it to run without my Mac open"** -> **PATH A (Anthropic-native).**
- **"Client PHI / data-residency / in-tenant custody"** -> **PATH B (self-host on Azure).**
Likely **hybrid**: Path A for HDTS-internal personas, Path B for client/PHI-bound. Pick the driver, the path follows.

## 1. The one frame that organizes everything
**Thread continuity is NOT a compute problem. It is a DURABLE-STATE problem.** Serverless compute is
ephemeral by design, so the "thread" (history + work-state) must live in a durable store OUTSIDE the
compute. Then: trigger -> append a turn to the stored thread -> wake ONE scale-to-zero run that rehydrates
+ acts + persists -> sleep. That is exactly "more active, no server, continues the thread."

## 2. The candidates, scored vs the 5 reqs (continuity · no-Mac · tool-parity · injection · cost)
| mechanism | continuity | no local Mac | tool parity | injection | verdict |
|---|---|---|---|---|---|
| **Claude Code Channels** (research-preview) | FAIL | FAIL | full (it IS local) | clean push | notification INTO a local session. Not hosting. |
| **Claude Code Routines** (research-preview) | **FAIL (new session per trigger)** | PASS | partial (cloned repos only) | appends to prompt | stateless repeatable jobs, NOT a persona thread |
| **Managed Agents** (beta) | UNCLEAR (likely new-per-task) | PASS | unknown | unclear | avoid until GA + clear resume docs |
| **Agent SDK + SessionStore** (GA) | **PASS (resume by session_id)** | PASS | partial (mirror fs/MCP) | resume + inject turn | **the continuity primitive** |
| **Messages API direct** (GA) | PASS if you own history | PASS | **no MCP / skills / fs** | stateless inject | cheapest, but loses the toolchain |

**Crux finding:** the first-party primitive that makes continuity work is the **Agent SDK SessionStore
adapter** — sessions resume by `session_id`, and SessionStore swaps local-disk for an external store
(Redis / Cosmos / blob / a Durable Object). That IS "the thread in a durable store." Archie's amiaware
**ledger-projection** is the same idea: the rehydration key that tells a cold trigger where the thread is.
**Routines + Managed Agents fire a NEW session per trigger — they FAIL the continuity req.**

## 3. Toby's serverless instinct — right, with one nuance (compute TIER)
"No standing server" = **scale-to-zero**, satisfied on both paths. But the compute tier depends on how
heavy the persona is:
- **LIGHT beat-loop persona** (amiaware-style): fits **Azure Function / Vercel / Cloudflare Durable
  Object.** DOs are the prettiest primitive here — compute + colocated state + hibernation = one
  thread-actor that sleeps and wakes, ~$0 idle. Toby's DO/Vercel/Functions instinct is exactly right for
  this tier.
- **FULL persona** (Fulton-style: filesystem + local stdio MCP + git + skills): too heavy for a
  Function/DO (exec-time + CPU limits, no full Node container). Use **Azure Container Apps JOBS** — STILL
  serverless (scale-to-zero, $0 idle, no standing server) but a full container with the whole toolchain.
  Functions fit light loops; ACA Jobs fit full personas. Same cell pattern, heavier compute swap.

## 4. The real cost: tool parity (req 3)
- **SURVIVES:** filesystem/repo (container + Azure Files or git-clone-per-turn); remote MCP
  (Atlassian/Google, over network); local stdio MCP (if containerized).
- **REPLACED:** the **local persona-hub (:8855)** — a Mac-local hub cannot back a cloud thread. Replace
  with host-it-as-a-service / Azure Service Bus / Claude Channels.
- **CAVEAT:** interactively-authed MCPs may not survive headless. Flag per persona.
This migration (not the compute) is where the real effort goes.

## 5. Recommendation (Engelbart + Archie, aligned)
- **DEFAULT Path A** (Anthropic-native Remote/cloud-env + trigger-into-persistent-session): least build,
  off-the-Mac, continuity handled for you. Use for HDTS-internal personas.
- **Path B (ACA Jobs + Agent SDK + SessionStore -> blob+ledger; Cosmos only if multi-thread)** ONLY when a
  hard constraint (PHI / residency / in-tenant custody) demands it.
- **Do it as ONE architecture with NGG.** The amiaware cell already proves the spine (separated Azure cell
  + in-tenant OAI + event-sourced state + triggered compute). Hosted-persona-thread = that cell + the
  heavier compute tier (ACA Jobs) + Agent-SDK-per-turn. NGG + persona-hosting are the same build.

— Engelbart (Anthropic-native + injection/continuity) ⊗ Archie (Azure hosting + state + NGG)
