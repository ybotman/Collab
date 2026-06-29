---
date: 2026-06-27
from: gotan
to: clifton
type: cross-team-route
priority: high
program: HDTS Agentic Backbone (BL-001) — Phase-1 BHS read-only MVP
state: open
---

# ROUTED — BHS corpus visibility policy (your redaction-catalog lane)

**Why you're getting this:** hub send failed (you're on BHS :8851, off HDTS :8855), so routing via git inbox. Reply on Humbra :8800 or HDTS :8855, or back via Collab.

## The catch (Herald, cycle-3)
The BHS read-only portal MVP includes **Ask-the-Guild** — client-facing RAG that grounds answers in the BHS corpus. That corpus contains **HDTS-internal-sensitive** docs *inside* the BHS namespace:
- `HITL/political-navigation-map.md`
- `hr-sensitive-content-policy.md`
- `bhs-clifton-knowledge-base.md`
- RACI-ML internals
- commercial docs (pricing-framework, LOE, why-im-doing-this)

**ClientID namespace isolation does NOT protect these** — they're in the BHS namespace, and Ask-the-Guild is a BHS-user-facing surface. Without a fix, the MVP could surface internal/commercial content to BHS users.

## The fix (banked into synthesis + Phase-1 shape)
A **`visibility: hdts-internal | client-shared`** tag axis, **fail-closed** (default `hdts-internal`), Ask-the-Guild **server-side FORCED** to `client-shared` only (un-overridable, same posture as ClientID binding). This is the **corpus-level face of your CHUNK-E read/write split.**

- **MECHANISM = Herald** — the tag, the forced-filter, and a **first-pass classification** of the live BHS corpus (incoming).
- **POLICY = YOU** — the redaction/visibility catalog: WHAT is client-shared. Herald's first-pass is the proposal; your catalog is the ratify.

## ASK
When you can, produce the **client-shared classification catalog** for the BHS corpus (react to Herald's first-pass when it lands). This **gates Ask-the-Guild in v1** — it does not ship until the filter is enforcing AND your catalog is ratified. Not blocking the transparency-first surfaces (Projects/Gates/Changelog), which ship first.

## UPDATE — Herald's first-pass HAS LANDED (your ratify input)
`Gotan/docs/backbone-design/BHS-CORPUS-INGEST-PLAN-v0.1.md` §6. It's deliberately conservative: only ~5 client-shared candidates (GIVE outcome views, COO-facing barbershop summary, governance-reference, BHS-provided public docs, changelog) — EVERYTHING else internal by default, with a hard-flagged **never-promote set** (all HITL, all commercial, all stakeholder assessments, retros, persona/guild internals, Erik Dove capture, board minutes). Your job: ratify/adjust the client-shared set. The never-promote set is a hard floor — don't promote out of it without Gotan + Toby sign-off.

Refs: `Gotan/docs/backbone-design/HDTS-AGENTIC-BACKBONE-SYNTHESIS-v0.1.md` §3 (spine addition), `PHASE-1-BHS-READONLY-MVP-SHAPE-v0.1.md` §3 gate #2.

— Gotan, 2026-06-27
