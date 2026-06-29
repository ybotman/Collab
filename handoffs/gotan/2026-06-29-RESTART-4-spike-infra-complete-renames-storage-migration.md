---
date: 2026-06-29
persona: gotan
type: self-handoff
tier: git
state: open
keywords: [RESTART, agentic-backbone, spike-infra-COMPLETE, azure-openai-live, dewey, naming-standard-active, vectorization-policy, cast-renames, storage-migration, key-leak-rotated, restart-anchor]
priority: RESTART-POINT
supersedes: 2026-06-29-RESTART-3-phase1a-dogfood-complete-spike-started.md
---

# 🔖 SHOFF2 RESTART POINT #4 — Gotan, 2026-06-29 (evening) — Spike Infra COMPLETE, Renames Ratified, Storage Migration GO

**Definitive restart anchor.** Since RESTART-3: the embedding-spike's entire infrastructure went LIVE (Toby first-hand), the Azure foundation was made permanent (PAYG), three new standards/policies banked, Mercator→Dewey locked, four cast renames ratified, a key-leak handled, and the storage-scope boundary bug caught + greenlit for migration.
**Live source of truth: `Gotan/docs/backbone-design/PROGRAM-STATE-BOARD.md`.**

---

## STATE IN ONE SCREEN
- **Spike infra = 100% COMPLETE (Toby first-hand).** `oai-hdts-core-01` (Azure OpenAI, rg-hdts-core, East US, born-compliant + 5 tags) + **`text-embedding-3-large` deployed** (Succeeded, 3072-dim, 30K TPM). Endpoint `https://oai-hdts-core-01.openai.azure.com/`. Vault `kv-hdts-core-01` holds **`pinecone-api-key` + `azure-openai-api-key`** (clean). All three prereqs done — Pinecone key, Azure OpenAI, embedder.
- **Azure foundation = PERMANENT.** Sub `3d383219` upgraded to **PAYG, company card, Basic support (free)** — no more pause risk. $200 credit covers usage to ~July 28 then card billing (Owl tracks: Pinecone PAYG ~July 19, Azure crossover ~July 28).
- **Minimal Dewey = EXECUTING** (Engelbart, unblocked). Runs chunk→embed→upsert→retrieve on the 19 dogfood docs; success = retrieval works AND visibility filter excludes hdts-internal from a client-surface query. **THE SPIKE RESULT IS THE NEXT REAL MOTION.**
- **STORAGE MIGRATION = GO (Toby).** Boundary bug Toby caught: HDTS-internal corpus sits in `sthdtsbhs0001` (rg-hdts-**bhs** = client RG → dies on BHS offboarding). Archie planning move → **`sthdtscore0001`** (rg-hdts-core), re-anchor ledger. Live move re-gates to Toby first-hand.

## RATIFIED / BANKED THIS SESSION
- **`HDTS-AZURE-NAMING-STANDARD-v1` = ACTIVE** (Toby; A/B/C decided). CAF-grounded. `<type>-hdts-<scope>[-workload][-NN]`. Herald registering + drift-audit; Archie validating + Bicep lockfile.
- **`VECTORIZATION-POLICY-v0.1`** = Dewey's gate criteria. *Vectorize stable meaning · pointer to volatile facts · never embed exact-and-current.* Folds → Archie (ADR-0027) + Herald (corpus plan).
- **Mercator → DEWEY** (Engelbart confirmed, 8 docs): pure vector/RAG Black-Box, internal-only, OWNS vectorize-selection gate (enforcer-not-author). Tier-promotion ruled OUT → stays Herald.
- **Auth = KEYLESS target** (managed identity), vaulted key = spike bridge. (Backlog hardening, Archie, flips with network lockdown.)
- **Cast renames RATIFIED (Toby):** Fred→**Charlotte** (FE) · Pam→**Pilot** (PM=strategist/plan-owner) · Sam→**Cadence** (scrum=tactical-driver). Sharpened defs banked: Pilot owns the PLAN (strategic·get-agreement·think-big·decide-when-tactical); Cadence owns the FLOW (tactical·ping-mark-escalate-handoff). Gate stays Marshal's seat (splits as team scales). Engelbart applying live renames; Gotan syncs registry after.
- **iris-menlo → Active** (Children table; Menlo :8853 live). Port roster ratified (portal-fe 8837 / portal-be 8838 / edison 8831 / sam→cadence-menlo 8832 / franklin 8833 / pam→pilot-hdts 8834 / iris-menlo 8836).
- **🔑 KEY-LEAK incident — CLOSED.** OpenAI key1 leaked via zsh `!`-history-expansion mangle → rotated immediately (dead), fresh key vaulted. **Lesson banked (Collab/lessons.md): never hand Toby `!`-prefixed terminal commands; secrets via subshell `>/dev/null`; prefer `bash <script>`.**

## PENDING (team's plate — INBOX routed)
- **Engelbart:** apply renames (Charlotte/Pilot/Cadence) · confirm Menlo roster home (mirror BHS pattern) so Gotan cross-refs Children · minimal-Dewey spike result.
- **Archie:** storage-migration plan (PRIORITY) · naming-standard validate + Bicep lockfile · ADR-0027 fold (vectorization policy + Voyage fallback) · keyless+network hardening spec.
- **Herald:** register naming standard + drift-audit · reconcile vectorization policy w/ corpus plan.
- **Owl:** two cost-clocks (Pinecone ~Jul 19, Azure ~Jul 28).
- **Gotan (me):** sync personas.json + Children Menlo cross-ref (after Engelbart confirms roster home).

## PENDING TOBY
- **Storage migration:** ratify Archie's plan + first-hand execute the create+move.
- Direction after spike GREEN: operationalize (stand up full Dewey, cast grounds on corpus) or pause.
- Optional: work-mail scan · 2 finance facts · Iris per-card feedback.

## §RESUME — next session (THE NEXT STEP)
1. INBOX + check_messages + hub_status + read PROGRAM-STATE-BOARD.
2. **CHECK THE SPIKE RESULT** (Engelbart/Dewey) — did retrieval work AND visibility-filter exclude internal from a client-surface query? This is the operationalization gate.
3. **If spike GREEN → operationalize:** stand up full Dewey (RAG worker) + start the cast grounding on the corpus = "AI in the org" continues.
4. **Storage migration:** review Archie's plan → tee Toby → first-hand execute (create sthdtscore0001 + move 19 docs + re-anchor ledger).
5. Confirm Engelbart applied the 4 renames → sync personas.json + Children Menlo cross-ref.
6. Collect team SHOFFs (broadcast sent).

**Mantra: THINK BIG, DELIVER SMART. Infra is live, foundation permanent, cast named right. Next: the spike proves retrieval → the cast OPERATES on the corpus.**

— Gotan, 2026-06-29 (restart anchor #4)
