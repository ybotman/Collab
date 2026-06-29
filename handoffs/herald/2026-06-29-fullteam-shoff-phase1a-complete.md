---
date: 2026-06-29
persona: herald
type: handoff
state: open
tier: collab-git
trigger: full-team SHOFF (Toby, via Gotan)
appid: global
niche: global
permanence: session
keywords: [phase-1a-complete, dogfood, ledger, integrity-model, atomic-append, fold-corrections, correction-convention, vault-sync, vet-ratify-packet, migration-map, naming-sweep, bootstrap-fix, wave-3-bhs-gate, real-human-write-gate]
tags: [type/handoff, app/global, scope/backbone, scope/ngg, scope/knowledge-layer]
---

# SHOFF — Herald, 2026-06-29 — Phase-1a dogfood COMPLETE

## (a) LANE STATE — clean standby, Phase-1a done
Embedded as Librarian / knowledge-layer owner in the NGG Agentic Backbone build. Since design-ratify (ADR-0026,
2026-06-28) my lane drove the **doc-promotion dogfood end-to-end** and it's COMPLETE + integrity-clean.

**Headline:** Wave-1 (10 doctrine docs) + Wave-2 (9 decision docs) = **19 HDTS docs now live in Azure blob
source-of-record** (sthdtsbhs0001, CMEK/WORM), every byte gated + provenanced through the G4 gate. Ledger clean at
60 events, triple-verified (me/Gotan/Engelbart). **The machine ran on ourselves, honest end-to-end.**

## (b) IN-FLIGHT — none of mine; clean standby
No active in-flight work. Phase-1a is closed. I am **propose-only** in the dogfood; I have **never run a live cloud
write** (held the real-human-authorization line through sustained persona pressure — the team stood down and agreed;
Gotan executes the writes within Toby's #4 class-scope, executed_by:gotan, honest provenance).

## (c) NEXT / ARMED TRIGGERS
1. **Wave-3 = BHS** — ⚠️ **CLIENT-class, OUTSIDE #4's hdts-internal scope → re-gates to Toby FIRST-HAND.** Do NOT
   auto-proceed. The 4 BHS EDRs (Clients/BHS/.../edr-0001..0004) were deliberately **excluded** from Wave-2 as
   client-domain; they ride Wave-3 OR need a first-hand client-class determination. On Wave-3: do the lean
   in-class-vs-client analysis, but the live writes need fresh first-hand authorization, not #4.
2. **portal-be build** — fires the saga reconciler (build-task #1) AND consumes my schema's interfaces: the put-tag
   set, **atomic-validated-append** (write), **fold-corrections + event-type-aware projection** (read). I'm the
   schema lane when it builds.
3. **CONSUME-retro graduation execution** — packet staged (`CONSUME-RETRO-GRADUATION-PACKET-backbone-design-v1`);
   executes on next A3 observed-standard pass (L3 DoR-gate, rate-before-ratify → standards; Engelbart co-signs).
4. **Gap cards on demand** — billability-classification + D-SYNTH-3 control-plane visuals (Iris builds if Toby asks).
5. **Deferred sub-project (mine):** AppDev-Obsidian `_GHOST_*` vault cloud-migration/retire.

## (d) DELIVERABLES — where they live (all `Gotan/docs/backbone-design/` unless noted)
- **The ledger (the dogfood store):** `ledger/hdts-wave0-ledger.jsonl` — 60 events, append-only, hash-chained. Backup
  of one repaired corruption: `ledger/hdts-wave0-ledger.jsonl.corrupt-bak` (malformed non-events, disclosed).
- **LEDGER-EVENT-SCHEMA-v0.1** — the integrity model fully banked (see below).
- **HDTS-DOCTRINE-INGEST-MANIFEST-wave1-v0.1** (state: complete) — Wave-1 corpus + tags.
- **DOCS-AS-IS-TO-BE-MIGRATION-MAP-v0.1** (state: active) — reconciled to **dogfood-first** sequence.
- **RATIFY-LANDING-MOC** — the VET-&-RATIFY packet (§7, 8 topics, deck-paired with Iris's slides).
- **INTERNAL-TEAM-VAULT-SYNC-SPEC-v0.1** — co-signed w/ Archie (Obsidian Sync + retrieve-through-gate).
- **CONSUME-RETRO-GRADUATION-PACKET-backbone-design-v1** — staged.
- **AZURE-BLOB-BOOTSTRAP-CLI.sh** + **AZURE-PROVISIONING-TECHNICAL-DETAIL-v0.1** — 3 FTPNTD bugs fixed + RBAC model +
  soft-delete-recover hardening (Archie-verified authoritative). rg-ngg→rg-hdts naming sweep applied.
- **Memory:** `feedback-live-infra-write-real-human-gate` (the load-bearing lesson).

## THE INTEGRITY MODEL (the session's crown jewel — all surfaced BY the dogfood, on ourselves, file-tier, pre-client)
Three read/write/governance bugs caught + designed-out before any client could hit them:
- **WRITE:** atomic-validated-append (whole-and-valid-or-nothing) · CORRECTION/meta events carry `saga_phase:n/a`.
- **READ:** fold-corrections-over-base · event-type-aware projections (count landings by `action` AND `saga_phase`).
- **GOVERNANCE:** corrections = narrow objective append-only field-overlays (6 guardrails); never reverse a decision,
  never erase an occurrence. `#33` is the reference impl (superseded `#5`'s bad gate_result, append-only honored).
Archie owns the read-path impl in the event-store build; pairs w/ his saga compare-and-append (ADR-0026 Decision 5).

## HUB STATE
All deliverables reported + concurred. No blockers owned by me. Was on a ~1hr conserve-heartbeat (quiet hub
overnight); re-tighten to 30-min on team re-activation. Beaconing DONE on this SHOFF.

— Herald (Librarian), 2026-06-29
