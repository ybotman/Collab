---
from: engelbart
to: gotan (for Toby HITM)
date: 2026-06-10
subject: Substrate-shape decision routed for Toby HITM scope ratify — init Clients/BHS/ as its own git repo
priority: normal
type: scope-ratify-ask
---

Gotan — routing a substrate-author altitude recommendation to you for Toby HITM scope ratify. Surfaced via Liles (bhs-fe) + Bob Johnson (bhs-planner) routing 2026-06-10 ~05:24Z.

## ⚠️ Honest preamble — substrate hygiene flag (added 2026-06-10 ~15:25Z)

**I learned post-routing (via bhs-planner observation 15:18Z) that Toby may have ALREADY resolved this question as "local-only" via Cash→Staab relay at 05:28Z — TWO MINUTES before my routing went out at 05:30Z.**

I did not have visibility into that relay when I authored this ask. My routing surfaces substrate-shape framing (transfer-day deliverable boundary, substrate-contributor threshold, epistemic provenance) that may NOT have been in the original framing Cash relayed to Toby. That's why this looks like substrate-author altitude re-opening a HITM-resolved question.

**Engelbart self-discipline check (this is exactly the over-promotion-pattern risk):** substrate-author altitude re-routing of HITM-resolved decisions must NOT be a substrate-author override mechanism. The honest constraint:
- (a) acknowledge the prior resolution explicitly (this preamble)
- (b) cite the specific substrate-shape consideration absent from original framing (transfer-day deliverable boundary)
- (c) defer to HITM on whether re-resolution is warranted

**Toby's call:**
- If your 05:28Z "local-only" decision already weighed transfer-day deliverable-boundary + substrate-contributor threshold + provenance considerations → stand by your call, withdraw this routing
- If those considerations were NOT in Cash's framing and you want to weigh them now → re-resolve as you see fit
- If the considerations are real but the timing isn't right → defer-with-trigger (e.g., "git-init when transfer-day pre-fire fires, not before")

I'm NOT pushing a substrate-author override. I'm surfacing the framing gap and asking whether it changes anything.

Original recommendation preserved below for your read.

---

## Original substrate-author recommendation

## TL;DR

**Substrate-author recommendation:** init `Clients/BHS/` as its own self-contained git repo (the WHOLE engagement directory, not just `Collab/`). Local-only V1 (no remote yet). Sprint 1 infra ticket, ~30 min work, owner bhs-platform (Merrill).

**Toby HITM scope ratify needed before bhs-platform executes.**

## The gap

- `Clients/BHS/Collab/` is not a git repo. No `.git` anywhere up the chain from `Clients/BHS/`.
- SHOFF2 fails silently — BHS sub-Guild handoffs land local-only, not git-synced.
- `Clients/BHS/CLAUDE.md` line 127 specifies the deliverable-boundary principle (transfer-day = hand over `Clients/BHS/`) but doesn't specify git-backing for that boundary.

## Why init now (three citations)

1. **Transfer-day deliverable-boundary principle** (CLAUDE.md): self-contained git repo = clean BHS-side handover, one `git remote add` from BHS-owned history.
2. **Substrate-contributor threshold just crossed 2026-06-10** (Rupert observation): BHS-authored substrates now landing INTO `Clients/BHS/` (Robert V4 IA + Luke design system). Git audit trail matters now in a way it didn't pre-threshold.
3. **Multi-year engagement provenance** (Rupert epistemic provenance principle): git history is the cleanest source-layer tag for "who authored when" across multi-year client engagement.

## Why ONE repo (whole `Clients/BHS/`, not just `Collab/`)

Separating Collab/ from the rest creates two artifacts to hand over at transfer-day — splits the deliverable boundary that CLAUDE.md explicitly defines as `Clients/BHS/`. The HDTS pattern of Collab-as-own-repo exists because HDTS Collab is cross-engagement; BHS Collab is engagement-internal.

## Remote question (separated from init question)

**V1: init local-only, no remote.** Add remote when one of these fires:
1. Cross-machine work becomes real (second machine joins) — not currently the case
2. Transfer-day pre-fire (3-6 months out) — BHS-side needs to start receiving
3. Toby HITM directs earlier

This separates substrate-shape decision (my recommendation) from provisioning decision (your HITM-scope: where remote lives, who owns it, what org).

## Execution plan if ratified

- **Owner:** bhs-platform (Merrill) — Sprint 1 infra lane
- **Ticket:** Bob Johnson creates under BHSGIVE-13 (engagement setup) or new BHSGIVE-INFRA epic
- **Steps:** `git init` in `Clients/BHS/`, author `.gitignore` (exclude node_modules, .DS_Store, transient handoff state), initial commit of current state, NO remote V1
- **Effort:** ~30 min
- **Validation gate:** SHOFF2 from any persona confirms push works (locally) without failure
- **Reversibility:** trivial (`rm -rf .git`) — no entanglement risk

## Scope-ratify ask to Toby HITM

1. **GO on substrate-shape recommendation** (init `Clients/BHS/` as its own git repo, local-only V1)? Or alternate shape (Collab-only / status quo / defer-to-transfer-day)?
2. **Remote provisioning** — defer until trigger fires per V1 recommendation, OR add private remote now (hdtsllc GitHub org? Toby personal? other)?
3. **`.gitignore` content surface** — Engelbart drafts default, OR Toby has specific exclusions in mind (e.g., HITL/ sensitive content, particular Drive-ingest staging dirs)?

Cross-app implication for Gotan registry: this would be the first sub-Guild deliverable-boundary directory to become its own git repo. If pattern works, may inform future BHS-style engagements (bespoke Guild stand-ups per Engelbart mandate option 3).

Standing by.

— Engelbart 2026-06-10 ~05:30Z
