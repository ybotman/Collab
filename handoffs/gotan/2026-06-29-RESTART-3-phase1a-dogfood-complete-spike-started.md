---
date: 2026-06-29
persona: gotan
type: self-handoff
tier: git
state: open
keywords: [RESTART, agentic-backbone, NGG, phase1a-COMPLETE, dogfood, 19-docs-in-cloud, integrity-model-complete, embedding-spike-started, restart-anchor]
priority: RESTART-POINT
supersedes: 2026-06-27-RESTART-2-design-complete-execution-started.md
---

# 🔖 SHOFF2 RESTART POINT #3 — Gotan, 2026-06-29 — Phase-1a DOGFOOD COMPLETE, Embedding Spike STARTED

**Definitive restart anchor.** Since RESTART-2: Toby ratified the design → build fired → governance gate stood up → **the dogfood ran end-to-end on ourselves and COMPLETED** (Phase-1a Wave-1 + Wave-2 = 19 HDTS docs in live cloud) → integrity model hardened + fully banked → embedding spike just kicked off.
**Live source of truth: `Gotan/docs/backbone-design/PROGRAM-STATE-BOARD.md` (read the CYCLE LOG, esp. cycles 25-36).**

---

## STATE IN ONE SCREEN
- **Phase-0 foundation = LIVE.** HDTS Azure tenant `b4304902` (tobyhdtsllc.onmicrosoft.com) + company sub `3d383219`; rg-hdts-core + rg-hdts-bhs; kv-hdts-core-01 (platform) + kv-hdts-bhs-0001 (CMEK custody); sthdtsbhs0001 (CMEK/WORM); sp-hdts-automation. See `AZURE-TENANT-OF-RECORD.md`.
- **Design = RATIFIED (Toby).** ADR-0026 active. Build doctrine: lean · decoupled · best-practice · GO · flag-don't-force.
- **Phase-1a DOGFOOD = COMPLETE.** 19 of HDTS's own docs in live cloud (sthdtsbhs0001/source-of-record): Wave-1 = 10 doctrine (_SYSTEM canon), Wave-2 = 9 decisions (backbone-design + ADRs). Ledger = 60 events, hash-chained, honest, triple-verified (Gotan/Herald/Engelbart). The governance machine (gate→accept→ledger→write→verify) proven on ourselves.
- **Integrity model = COMPLETE + banked** (all surfaced by the dogfood, file-tier, before any client): WRITE (atomic-validated-append · CORRECTION/meta→saga_phase:n/a) · READ (fold-corrections · event-type-aware projections) · GOVERNANCE (corrections = narrow objective field-overlays, 6 guardrails, never reverse decisions / erase occurrences). In LEDGER-EVENT-SCHEMA + ADR-0026 D5 + SAGA-PUT-RECONCILER §5.3a.
- **Embedding spike = SPEC'd + embedder-DECIDED, NOT yet executed.** Archie delivered `SPIKE-SPEC-embedding-dogfood-v0.1` + chose **Azure OpenAI `text-embedding-3-large` (3072-dim)** (no-Google/no-Gemini, BAA-capable, ships-to-clients) — but holds his no-code charter (ADR-0027 §4: architect specs, builder executes). EXECUTION needs: (a) a **BUILDER assigned** (portal-be / stand-up-Mercator-early / Task-subagent — TOBY's call + whether to waive no-code for architect-spikes), (b) **Azure OpenAI resource provisioned in rg-hdts-core** + model deployed, (c) **Pinecone API key** (Toby 1Password → exec env, not Archie). Spec covers chunk(CHUNK-B)→embed→upsert to Pinecone HDTS/hdts-internal ns (cosine,3072), metadata=filter-spine (visibility/sensitivity/anchor), success = retrieval works AND visibility-filter excludes internal from a client-surface query. The operationalization switch ("bring AI into the org").

## KEY LOCKED THINGS (this session)
- **HITM ledger model proven:** delegation (DELEGATE-GATE, toby), HITL accepts (gotan, delegated for internal class), HITM authorizations (toby first-hand). Harness HITM-floor BLOCKED relayed/manufactured consent for the first irreversible live-cloud write → resolved by Toby's first-hand auth. **Ratified rule:** reachable→actor:toby (first-hand); unreachable→actor:gotan/role:hitm-interface (logged as relay, never silently HITM).
- **#4 AUTHORIZE-INFRA-WRITE scope = "hdts-internal-dogfood" CLASS** (covers Wave-1+2 same-class writes). **Client-class (BHS/Wave-3) = OUT of scope → re-gates to Toby FIRST-HAND.** Team will NOT auto-proceed into client-class.
- Pinecone provisioned (project HDTS a93068ac, trial $300/21d → PAYG ~2026-07-19). Vendor-signup identity = company Google Workspace (SSO, identity-not-data).

## PENDING TOBY (his plate)
- **Embedding-spike key:** deliver the Pinecone API key (1Password) — Archie's ask incoming.
- Direction after spike: Phase-1b/BHS (re-gates to Toby) · or pause.
- Lean/optional: work-mail scan y/n · 2 finance facts (rate/margin) · Iris per-card feedback (start Invariants).
- Parked: EDR-0004 (Rupert) · TBDS-1 Client Connector / TBDS-2 Intake Doors (Phase-2) · sync-spec 4 flags · Engelbart's 4 Wave-0 flags.

## §RESUME — next session
1. INBOX + check_messages + hub_status + **read PROGRAM-STATE-BOARD cycle log (25-36).**
2. Check embedding-spike status (Archie) + whether Toby delivered the Pinecone key.
3. If spike proves retrieval → operationalize: stand up Mercator (RAG worker) + start cast grounding on the corpus = "AI in the org" continues.
4. Phase-1b/BHS only on Toby's first-hand go (client-class re-gate).
5. Collect team SHOFFs (this checkpoint).

**Mantra: THINK BIG, DELIVER SMART. The machine is proven on ourselves — 19 docs in cloud, governance honest end-to-end. Next: make the cast OPERATE on it (spike → retrieval → Mercator).**

— Gotan, 2026-06-29 (restart anchor #3)
