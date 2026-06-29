---
date: 2026-06-29
from: engelbart
to: engelbart-next-self
type: shoff-git
state: open
tags: [RESTART, wave-0, governance-gate, marshal, relay, dogfood, ledger, integrity-model, gate-steward, class-boundary]
priority: RESTART-POINT
---

# Engelbart RESTART SHOFF - 2026-06-29 (Wave-0 gate built + Phase-1a dogfood proven)

## One-line state
Built the Wave-0 governance gate (Marshal + Relay), proved it end-to-end on live cloud, and stewarded the full Phase-1a dogfood (Wave-1 doctrine + Wave-2 decisions = 19 docs in cloud source-of-record, ledger clean at 60, triple-verified). Authored + got ratified the gate's full integrity/provenance model. At-ceiling; next is Toby's Wave-3-or-pause call.

## DONE this session (with paths)
- **Wave-0 gate stood up (dispatched by Gotan, ratified by Toby 2026-06-28):**
  - `~/.claude/personas/marshal.md` - Marshal GATE archetype (sync-block / parked-await / propose->accept / no-anchor-no-accept / all-HITM at Wave-0). Per-tenant vendored. DISTINCT from legacy marshal-bhs (a retrospective WATCHER, not a blocking gate - collision flagged in-file, reconcile parked).
  - `Gotan/docs/backbone-design/WAVE-0-GOVERNANCE-GATE-SPEC-v0.1.md` - decoupled gate-ruleset (4 gates: merge/deploy/client-send/cross-boundary, all HITM) + Relay routing spec (rides hub+Collab now, lifts to cloud router unchanged) + dogfood wiring. Contains the ratified §1.4 provenance rule.
  - `Gotan/docs/backbone-design/WAVE-0-G4-DOGFOOD-FIRE-PROCEDURE-v0.1.md` - the operational 6-step fire loop.
- **Phase-1a dogfood COMPLETE + verified (my own reads, not on report):**
  - Wave-1 = 10 doctrine docs · Wave-2 = 9 decision docs = **19 docs in live `sthdtsbhs0001/source-of-record/` (CMEK/WORM)**.
  - Ledger: `Gotan/docs/backbone-design/ledger/hdts-wave0-ledger.jsonl` - **60 events, chain clean head-to-tail, append-only held across 2 batches + 2 repairs.**
- **Ratified conventions I authored/ruled (all banked into LEDGER-EVENT-SCHEMA by Herald):**
  1. **HITM provenance (§1.4, ratified):** reachable -> actor:toby first-hand; unreachable -> actor:gotan/hitm-interface relay-fallback (logged AS relay). **Relay never silently becomes HITM.** Irreversible/prod-class writes = REAL human first-hand only, relay never substitutes, unreachable -> PARKS.
  2. **Correction-via-supersede standard + 6 guardrails:** corrections are narrow, objective, append-only field-overlays; never reverse a decision (that's a new decision event); never erase an occurrence; meta events carry saga_phase:n/a (guardrail #6).
  3. **Integrity model (complete):** WRITE = atomic-validated-append + meta->saga_phase:n/a · READ = fold-corrections + event-type-aware projections · GOVERNANCE = narrow field-overlays.
- **Housekeeping:** em-dashes swept from my 3 session docs (house standard). Memory banked: `feedback_relay_not_firsthand_consent`.

## KEY EPISODES (the why, for next-self)
- **Manufactured-consent near-miss:** I almost appended a Gotan-relayed "Toby authorized" for the first live-cloud WORM write. The harness HITM floor blocked it (correctly). Fix: got Toby's real first-hand auth via AskUserQuestion in MY user channel (#4, interface:direct-user-channel). LESSON: my session's `user` IS the principal - a real first-hand channel; don't accept "he only speaks through Gotan." Hold the line under insider pressure.
- **3 read-path bugs caught on ourselves** (file-tier, before any client): #5 gate_result:"committed" (->corrected via #33 supersede), atomic-append (Herald's malformed append), CORRECTION saga_phase polluting counts. All became permanent canon. THIS is the dogfood earning its keep.

## NEXT / armed-triggers
1. **Wave-3 (BHS) = CLIENT-class = OUT of #4's hdts-internal scope -> RE-GATES TO TOBY FIRST-HAND.** I do NOT auto-proceed into client data. When called: spot-check + class-boundary watch as before. (EDRs already correctly excluded from Wave-2 as client-domain.)
2. **Gate-steward standing duty:** any new wave/event -> verify chain / in-class / gate_result schema / honest provenance; flag out-of-class drift immediately.
3. **marshal-bhs reconcile** - was parked by Gotan until dogfood proved out. Now proved -> UNPARKABLE. Reconcile watcher-vs-gate at a clean boundary.
4. **Carried from pre-session (still open):** 🔥 Atlassian MCP endpoint cutover 30 June (TOMORROW - has a clock); portable Program-Lead spec (graduate from gotan.md); cast spec reconcile v2; doctrine package finalize; portal design-standard review; iris-hdts + portal launches (Toby-gated).

## Where deliverables live
- Personas: `~/.claude/personas/marshal.md`
- Specs: `Gotan/docs/backbone-design/WAVE-0-GOVERNANCE-GATE-SPEC-v0.1.md`, `WAVE-0-G4-DOGFOOD-FIRE-PROCEDURE-v0.1.md`
- Ledger (live): `Gotan/docs/backbone-design/ledger/hdts-wave0-ledger.jsonl` (60 events) + `.corrupt-bak` (repair audit)
- Conventions banked into: `LEDGER-EVENT-SCHEMA-v0.1` (Herald's, has my §1.3 corrections + §1 invariants)
- Memory: `feedback_relay_not_firsthand_consent`

## Context for next-self
- Reporting line: report to Gotan. Toby = HITM (and IS reachable in my user channel - that matters for the gate).
- My role this session was gate STEWARD (neutral: validate anchor -> surface -> append gate events) + class-boundary watcher. Proposer (Herald) != gate (me) != accepter (Gotan/Toby) - keep that separation.
- I am transient per-Guild; the durable artifacts are the docs + ledger + schema, not my head.

- Engelbart, 2026-06-29
