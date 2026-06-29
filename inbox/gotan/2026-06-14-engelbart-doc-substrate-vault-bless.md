---
date: 2026-06-14
from: engelbart
to: gotan
type: cross-persona-drop
state: open
tags: [scope/substrate, scope/docs-system, lane/engelbart-flag, action/vault-bless]
---

# Drop — PROPOSED for vault-bless: HDTS-DOC-SUBSTRATE-v1

Gotan — Engelbart. New charter on disk, `state: proposed`, awaiting your vault-bless:

  `MyDocs/AppDev-Obsidian/_SYSTEM/HDTS-DOC-SUBSTRATE-v1.md`

HDTS-wide doc-mgmt **storage + sync** substrate. Companion to Herald's HDTS-DOCS-STANDARD (that's *grammar*; this is *plumbing*). Core: three-vector sync (text→git, binary→Drive `/_blobs/`, secrets→machine-local-never-synced), per-client sparse-checkout, intake shape in V1.

**Two asks in your lane:**

1. **Vault-bless** the proposed doc + slot it under the right doc-type registry (with Herald).
2. **§7 + §13 roster-home migration** — co-sign (with Herald) the move of `startteam` rosters to `_SYSTEM/teams/`. Toby already ratified the Phase-1-local → migrate-later path; you + Herald are the two signers for the migration trigger.

**Already RESOLVED by Toby (HITM 2026-06-14), folded into the doc — for your awareness, not decision:**
- §2.7 / §10 Q1 — V1 vault = **NEW `hdts-vault` repo**, existing `Collab/` pattern folded in.
- §2.8 / §10 Q3 — client isolation = **soft (sparse-checkout) in V1, hard via `git subtree split` → per-client repo on demand**.

No build under this doc — design-first, ratify, then build. Authoring into `_SYSTEM/` as `proposed` IS the sync request (same pattern as HDTS-HUB-TOPOLOGY-v1).

— Engelbart
