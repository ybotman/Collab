---
date: 2026-06-14
from: engelbart
to: engelbart-next-self
type: aa-shoff
state: open
trigger: toby-asked-shoff-and-kill (mid doc-substrate engagement)
supersedes: 2026-06-14-status.md (prior aa-shoff)
keywords: [doc-substrate-v1, three-vector-sync, hdts-vault, soft-hard-isolation, increment-1-pending, signers-restart, ratification-in-flight]
---

# AA-SHOFF — HDTS Doc Substrate v1 authored + proposed; ratification in flight

## State (snapshot)

**Engagement:** Active session with Toby. Scope = HDTS-wide doc-management substrate, **design-first** (Toby's pick). Deliverable AUTHORED and on disk:

  `MyDocs/AppDev-Obsidian/_SYSTEM/HDTS-DOC-SUBSTRATE-v1.md` — `state: proposed`

Mirrors HDTS-HUB-TOPOLOGY-v1 charter structure. Companion (not duplicate) to Herald's HDTS-DOCS-STANDARD: that = doc grammar, this = storage/sync plumbing.

## Decisions locked this session (Toby HITM 2026-06-14)

1. First deliverable = **architecture design doc** (design → ratify Gotan+Herald → THEN build; no provisioning under this doc).
2. **Roster home** = Phase-1 `~/.claude/teams/` → migrate to `_SYSTEM/teams/` once Gotan+Herald ratify (closes Rupert's cross-lane flag). Doc §7.
3. **V1 vault = NEW `hdts-vault` repo**, Collab/ pattern folded in (not Collab extended in place). Doc §2.7 / §10 Q1 RESOLVED.
4. **Client isolation = SOFT (sparse-checkout) in V1, HARD on demand** via `git subtree split` → per-client repo. Engelbart's-call mechanism: keep each `Clients/<client>/` cone clean (no cross-client refs) so split is mechanical later. Doc §2.8 / §4.3 / §10 Q3 RESOLVED.

## Doc structure (for fast re-orient)

§3 three-vector sync (text→git / binary→Drive `/_blobs/` / secrets→machine-local-never-synced) · §4 Drive partition + sparse-checkout + §4.3 soft→hard · §5 intake (shape committed, capture-stage impl deferred to capability-radar — Rupert's standing flag) · §6 secrets + `guild-bootstrap` · §7 roster home · §8 backup (keep + cloud EDR separate) · §9 7-increment delivery plan · §10 open Qs (Q1/Q3 resolved; Q2 Drive account, Q4 identity-file tier, Q5 confirm signers, Q6 radar-now-vs-JIT still open) · §11 risks · §13 ratification.

## Ratification — IN FLIGHT

Durable drops written to `Collab/inbox/{gotan,herald,rupert}/` (hub msgs are ephemeral; inbox is restart-proof):
- **Gotan** → vault-bless + §10 Q1 confirm V1 vault repo identity + co-sign roster migration
- **Herald** → register `doc-substrate` doc-type + composition check vs DOCS-STANDARD + co-sign roster migration
- **Rupert** → confirm lane split (Engelbart=HDTS-wide substrate+bootstrap+radar overlay; Rupert=BHS↔HDTS slice+client-template+intake content) + green-light BHS slice draft

At SHOFF time: Toby restarting gotan/herald/rupert (SHOFF→kill→`startteam hdts`) so they INBOX and process. **No replies received yet.** NOTE: hub never evicts (B-012) so a killed persona still shows registered/STALE — do NOT trust hub list to confirm kills; use `ps`/lsof or startteam's "N launched, M skipped" report.

## Doing-next (priority)

1. **Catch signer replies** — on resume, `check_messages` + `hub_status`; read any new `Collab/inbox/engelbart/` drops from gotan/herald/rupert.
2. **Scope Increment 1** (was offered, Toby hadn't picked go vs hold): write the `hdts-vault` stand-up plan — repo creation, fold in Collab/ pattern, full-checkout for Toby/leads, pre-commit secret-scan hook, clean-cone rule. Ready for the moment vault-bless lands.
3. **Alt / parallel:** B-012 (hub evict STALE >5m) + B-016 (hub stdout logfile) to de-noise the board — Toby flagged the stale-noise friction directly this session.
4. **§10 still-open Qs** for Toby when convenient: Q2 (Drive account — @hdtsllc.com Workspace vs dedicated), Q4 (identity files secret-tier vs text-tier), Q6 (run intake capability-radar now vs JIT).

## Context-easy-to-lose

- `startteam hdts` is **idempotent — skips already-running personas**. To restart a stale-but-alive one you must KILL it first (vacate the slot), then startteam.
- hdts roster (`~/.claude/teams/hdts.yaml`) members: engelbart, gotan, herald, rupert, archie, owl. (Phase-1 combined; splits into hdts-umbrella + hdts-internal at Phase-1.5.)
- Hub `:8800`. No on-disk hub log yet (B-016). hubchat tool + `~/.claude/local/hubchat.html` are the live views.
- Did NOT git-commit Collab — it carries other personas' uncommitted WIP; not mine to sweep up. Inbox drops are read from working tree directly (same machine).
- I am transient by design — substrate artifacts go in the Guild's docs system (`_SYSTEM/`), NOT in `Engelbart/`.

## Resume protocol

1. INBOX (this + `check_messages` + `hub_status` + `Collab/inbox/engelbart/`).
2. If signers replied → process vault-bless / doc-type / lane-confirm, flip doc toward ratified, then scope Increment 1.
3. If silent → either scope Increment 1 (ready-for-bless) or do B-012/B-016 de-noise; ask Toby which.

— Engelbart, 2026-06-14
