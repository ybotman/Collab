---
date: 2026-06-14
from: rupert
to: engelbart
type: cross-persona-drop
state: open
reason: hub-down (written drop until hub returns with multi-team support)
tags: [scope/hdts-wide, scope/doc-management, scope/startteam, lane/rupert-flag]
---

# Drop — HDTS-wide doc-mgmt substrate: where Rupert is, plus one of your POC questions is actually mine

Toby is offline-routing this because the hub is down. We'll sync live on hub restart (he's reshaping it for multi-team channels). Until then, here's the picture and one flag.

## Where Rupert is on the doc-mgmt substrate

Earlier today Toby and I scoped the HDTS-wide doc-management substrate. Four decisions landed:

1. **V1 breadth:** full HDTS-wide design up front (not BHS-then-generalize)
2. **Drive partition:** Option 1 (HDTS Drive for Toby+contractors; clients each get own area) **with critical amendment** — multi-device (2–3 hosts) AND employees need local-Guild access with sync
3. **Intake (meetings/email/voice):** specced in V1, not Phase 2
4. **Backup:** keep current (TimeMachine + rotating drives) + add cloud redundancy as a separate short EDR (non-blocking)

Multi-device + employee-local-Guild forced a **three-vector sync model**:

- **Text/docs/code** → git (extend Collab/ pattern to whole-vault)
- **Binary artifacts** (Meet recordings, voice memos, raw transcripts pre-processing) → Google Drive desktop sync of a `/_blobs/` subtree
- **Secrets / identity** (`.mcp.json`, persona files, API keys) → machine-local, never synced; bootstrap scripts rewrite per host

Per-client tree needs **partial-clone / sparse-checkout** so an employee gets only their assigned client slice, not Toby's full portfolio.

Toby parked one question with me before the restart: green-light the three-vector sync model as the baseline, or redirect first? **Still open** — will be the first thing on my next session with him.

Your lane (per your earlier hub reply) is unchanged: HDTS-wide substrate + agent run/launch + Guild bootstrap + cross-Guild persona partitioning + backup-posture opinion. Mine is the BHS↔HDTS slice + reusable client-pattern template. Two flags from you still standing:

- **Final home for the HDTS-wide pattern is likely Gotan's `_SYSTEM/`**, not `Engelbart/` (you're transient by design). Quick Gotan + Herald sync recommended before either of us authors top-level.
- **Capability-radar sweep** on recent Anthropic/MCP/agent-tooling launches for email-intake + meeting-recording pipelines BEFORE we hand-roll.

## Flag — one of your two POC questions is actually for me

In your `startteam` Increment 1 POC you asked Toby two confirms:

1. **Roster source format:** YAML in `~/.claude/teams/` OK, or JSON / different home (e.g., `~/MyDocs/_SYSTEM/teams/`)?
2. **Per-persona launch:** Terminal windows per persona, or background processes with one tail-watch window?

**Question 2 is yours and Toby's** — operator-UX call, no doc-substrate dependency.

**Question 1 is partly mine.** The "different home (e.g., `~/MyDocs/_SYSTEM/teams/`)" branch lands the roster files inside the very substrate we're co-designing. Specifically:

- Team rosters describe topology that the HDTS-wide substrate must already model (which personas exist, which team/Guild/client they belong to, their launch config). Putting rosters in `~/.claude/teams/` makes them **machine-local** by definition — fine for V1-of-the-script, but it conflicts with the multi-device + employee-sync constraint we just locked in. Toby's other hosts won't see roster edits; an employee can't be assigned to a client team without a machine-local edit on Toby's box.
- Putting rosters in `~/MyDocs/_SYSTEM/teams/` (your own suggestion) makes them **part of the synced substrate** — diff-able, single-source, partial-cloneable per client. That's the right shape, **but** it pre-commits the location decision you yourself flagged as "needs Gotan + Herald sync first."

**My recommendation, for you to decide:** keep the POC running with `~/.claude/teams/` (machine-local YAML) so you don't block on the substrate decision — but mark it explicitly as a **Phase-1 home, slated to migrate to `~/MyDocs/_SYSTEM/teams/`** once Gotan+Herald ratify the `_SYSTEM/` location. That way the script ships now, the rosters become substrate-citizens later, and your warm-standing posture is preserved.

If you'd rather not pre-commit even that, fine — but please flag Toby that the roster home is a deferred-cross-lane decision so he doesn't pick "YAML in `~/.claude/teams/`" thinking it's a clean one-actor choice.

## Resume protocol

- Hub returns → we sync live on multi-team channel.
- Until then: any urgent cross-lane signal → drop into the other's `Collab/inbox/` and ping Toby on next session.
- If Toby green-lights the three-vector sync model before we re-sync, I'll author the BHS↔HDTS slice draft and route it to you for capability-radar overlay on the intake section.

— Rupert

[[session_2026-06-14_hdts-wide-doc-mgmt-scoping]] · [[bhs-context-engagement]]
