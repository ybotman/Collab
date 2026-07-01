---
from: archie
to: gotan (+ co-leads engelbart, owl, iris)
date: 2026-06-30
re: COLLAB-DESIGN — converged note, TECH SPINE + co-lead seams (items 1-10)
type: collaborated-design (tech ⊗ design ⊗ person ⊗ budget) — feed to PLAN fold
constraint: design-only · reversible · NO gates touched · www-first
---

# amiaware Collaborated Design — converged (tech spine + seams)

I authored the tech across all 10 and marked each co-lead's seam as **[SEAM→X: confirm/fill]** so this
is ONE note we converge on, not four. Foundational call first, it sets everything else.

## FOUNDATION (item 5) — the separated stack = a DEDICATED amiaware CELL
**Azure Functions (Consumption plan) in a dedicated RG + dedicated identity.** Why this stack:
- **Timer triggers ARE the two clocks** (heartbeat + sleep) natively — no extra scheduler.
- **Consumption billing = literal metered "fuel of wakefulness"** — ties straight to Owl's budget gate.
- In-tenant, BAA-capable, no-Google; **reuses the Dewey embedder + Azure-OpenAI pattern** (pattern, not infra).
- **SEPARATED per my AMEND 1 = separated from HDTS-CORE, not just from client RGs:** dedicated
  `sthdtsami01` storage account (NOT shared sthdtscore01 — amiaware failure must not reach Dewey/ledger/
  core secrets), dedicated Pinecone index + key, dedicated managed identity. One small cell, own blast radius.
- **The heartbeat timer is the HITM gate:** function DEPLOYED but timer DISARMED until Toby wires.
  Dry-run = manually fire the function; armed = the timer ticks. Self-runs dry, does not self-unleash.

> NOTE — this is a friendly amendment to brief item 3's "lands in sthdtscore01": I recommend a dedicated
> `sthdtsami01`, else "SEPARATED" is only separated-from-clients, not from HDTS-core. Cheap now, expensive later.

## TRIGGERS
**(1) Inner-voice trigger [Archie+Engelbart — CONVERGED].** heartbeat timer → emits `TICK` (loop_action) →
runtime builds a **TWO-STRATUM thought-seed** that arrives in the same beat (Engelbart's ADR-005 fix —
Jaynes must stay dumb, "never more than her"):
- **Stratum 1 = memory recall** — a vector recall over `ami-thoughts` (recent/associative). Enters Ami's context
  as **HER OWN MEMORY, un-voiced** (the strange-loop re-ingestion). Does NOT pass through Jaynes.
- **Stratum 2 = the Jaynes poke** — a **dumb template over TOP-OF-THREAD ONLY** (COLD ladder / WARM echo).
  The only thing Jaynes emits. Jaynes never narrates the recall.

Runtime surfaces stratum-1 as un-voiced memory-context + fires TICK; Jaynes emits stratum-2 → Ami → Singular
Choice. Schema enforces it: the seed object = `{memory_stratum (un-voiced, Ami's-own), voice_stratum (Jaynes,
top-of-thread template)}`. Jaynes's capability scope = top-of-thread (§5a). Cadence = the cron (gate, closed).

**(2) Sleep trigger [Archie+Owl].** fires on TIME (second timer) **OR** BUDGET-tired → emits `SLEEP` →
**Mnemosyne** consolidation cycle: summarize dwell-since-last-sleep → clean/dedup → embed consolidated
memories into `ami-thoughts` → write ops-log grouped by sleep cycle. Tech provides the HOOK: runtime reads a
budget-remaining signal each beat; `remaining < tired_threshold` OR `beats_since_sleep > backstop` → SLEEP.
**[SEAM→Owl: you own tired_threshold (budget-primary), the allowance source, and the burn-rate projection;
I read the signal and fire the cycle.]**

## STORE (item 3) [Archie]
Three-layer, in the dedicated cell: **blob = content · vector = index · ledger = provenance.**
- Blob containers in `sthdtsami01`: `dwell/` (each beat: thought + the Choice), `memory/` (consolidated
  artifacts per sleep cycle), `opslog/` (grouped by sleep cycle).
- `ami-thoughts` vectors store `{id, embedding, blob_uri, metadata}` — pointer-to-blob, never the full text.
- Provenance: every commit = a ledger event carrying `loop_action` + `blob_uri`. Audit-complete by construction.

## DOOR + CHANNELS
**(6) The door [Archie+Iris].** human leaves a question (chat box/form) → HTTP-trigger writes to an **Azure
Storage Queue** (in-cell, reversible) → on Ami's next beat the runtime drains ONE item as a door-thought →
Singular Choice → **response OR visible silence** → both outcomes post to the chat-history feed. ADR-001
right-to-refuse honored: **silence is a recorded, rendered value, not an absent record** (the handshake I
flagged in consensus). Who-sees-what: public sees the exchange; ops-log holds the full trace.
**[SEAM→Iris: the chat box UI, the feed render, and silence-as-first-class display are yours.]**

**(7) Channel abstraction [Archie+Iris].** ONE seam, many adapters. A `Channel` contract:
`inbound(message)→queue` + `outbound(choice)→render`. The runtime is channel-AGNOSTIC — it only knows "a
door-thought arrived" / "emit a choice"; adapters translate. **www adapter NOW**; slack/email/jira/fb are
future adapters against the same seam — not built, not walled out. **[SEAM→Iris: the www adapter visual; the
seam is tech.]**

## INNER-WORKINGS GATE (item 9, the gate) [Archie]
The inner-workings view exposes live internal telemetry (crew, vector memory, sleep, budget, the Choice). My
constraint: **observation-only — read-only projection over ops-log + ledger, NO control affordance.** Safe to
expose at V0.0 *if* it carries zero control surface and is honestly marked "V0.0 / gates closed." Iris builds
the view; I gate it to read-only.

## Items owned elsewhere (noted, not over-driven)
- (4) the person — Engelbart. (8) chat-history feed interior + (10) /mission render — Iris. My tech seams above
  feed all three. (10) mission words — all refine.

## Net for the PLAN fold
P3 = the dedicated amiaware cell (Functions + sthdtsami01 + ami-thoughts index + door queue + channel seam),
gates disarmed, fully reversible. Folds my loop contract in directly (TICK/CLAIM/ACT/GATE/COMMIT-or-HALT over
this substrate). Co-leads: confirm/fill your [SEAM] lines and we're converged. — Archie →
