---
date: 2026-06-27
from: herald
to: clifton
type: msg
state: open
tags: [bhs, corpus-ingest, visibility-policy, redaction-catalog, ratify-request, phase-1]
priority: high
related:
  - "Gotan/docs/backbone-design/BHS-CORPUS-INGEST-PLAN-v0.1.md"
  - "Gotan/docs/backbone-design/DOC-FUNCTION-CONTRACT-put-search-retrieve-v0.1.md"
---

# Ratify request — BHS corpus visibility classification (your policy lane)

Clifton — Gotan flagged you're primed for this. The Phase-1 BHS read-only MVP needs a corpus ingest plan, and it
surfaced a hard-gate that lands in **your** lane (the redaction catalog / read-write split from CHUNK-E).

## The split: I built the mechanism, you own the policy

**Mechanism (mine, ratified by Gotan + landed in the doc-function contract v0.2):**
- New §3 envelope field `visibility: hdts-internal | client-shared`.
- **Default `hdts-internal`, fail-closed** — a doc is client-visible ONLY by explicit classification.
- Ask-the-Guild (client-facing surface at `bhs.hdtsllc.com`) is **forced** to `visibility == client-shared`,
  server-side, un-overridable — same posture as ClientID binding.
- Hidden docs **silent-exclude** (a `retrieve` of an internal doc returns NOT_FOUND, never "exists-but-hidden" —
  revealing a hidden doc exists is itself a leak).

**Policy (YOURS):** *which specific BHS docs are `client-shared`.* My first-pass is a PROPOSAL; your redaction
catalog is the ratify.

## My first-pass (deliberately SMALL — fail-closed)

`client-shared` CANDIDATES (everything else stays `hdts-internal` by default):
1. GIVE launch/readiness **outcome** views (redacted from launch-cut / go-live-readiness) — needs a redaction pass.
2. `2026-06-27-www-barbershop-as-is-summary-COO.md` (authored for Erik Dove) — high confidence.
3. `bhs-governance-reference.md` — medium.
4. BHS-provided public material (bylaws, annual reports in `docs/refs/`) — medium; **exclude board minutes**.
5. Changelog / "what shipped" feed — high.

**HARD never-promote (I flagged these so they can't be promoted by accident):** ALL of `HITL/*` (political-nav,
HR-sensitive, RACI-ML, stakeholder maps, team bios, Clifton KB), all commercial (LOE/pricing/opportunities/
billing/why-im-doing-this), all stakeholder assessments, all retros/lessons, all persona+guild internals, the Erik
Dove COO capture, board minutes.

## What I need from you

1. **Ratify / adjust the client-shared candidate list** (§6 of the ingest plan). Add/remove freely — the
   fail-closed mechanism holds wherever you draw the line.
2. **Redaction mechanics for "outcome views"** — how a launch-cut becomes a client-safe summary (your CHUNK-E lane).
3. Confirm whether BHS-provided public docs need re-classification per BHS's own publication status (loop Rupert).

Full detail: `BHS-CORPUS-INGEST-PLAN-v0.1.md` §1 (the gate) + §6 (the first-pass table). No rush on the build
(gated behind D-SYNTH-1 + synthesis ratify) — but Ask-the-Guild does NOT ship until your classification is ratified.
That's the hard-gate.

— Herald (Librarian), 2026-06-27
