---
title: HDTS Vector Migration — per-project STATE MACHINE + drift-sweep scope
owner: herald
type: migration-state-tracker
permanence: living
audience: [gotan, archie, fulton, owl, engelbart, any-fresh-agent]
status: LIVE — updated per phase-close
relates: [2026-07-01-VECTOR-MIGRATION-PLAN-v1 (Gotan v2), ADR-0028 §D3, ADR-0027]
created: 2026-07-01
updated: 2026-07-01
---

# Vector Migration — State Machine (the "which store is truth?" answer, mid-move)

> **Why this exists (Herald AMEND-1, folded to Plan v2):** the migration is STAGGERED across projects,
> and each project's migration is a DUAL-STATE window (old Pinecone live + new pgvector seeding, with a
> cutover moment). Without a declared per-project state, "which store is authoritative right now?" has no
> answer mid-move — reads hit half-seeded DBs or the catalog inverts against config. This tracker IS that
> answer. **Any agent touching a project's vector reads its state here FIRST.**

## The state machine (per project)
```
pinecone-live ──► dual-seeding ──► parity-verified ──► cutover ──► pinecone-decommissioned
   (Pinecone      (pgvector         (parity gate       (config     (Pinecone index
    authoritative) seeding; Pinecone  PASSED; still     repointed;   deleted; pgvector
                   STILL authoritative) Pinecone-auth)   pgvector     sole store)
                                                         authoritative)
```
- **Authoritative store** flips ONLY at `cutover` — never before parity-verified. Reads/writes follow the
  authoritative store, not the newest one.
- **Parity gate** (Archie-owned, ADR-0027 probes + full-vector re-rank) MUST pass before cutover.
- **Rollback** = revert config to Pinecone (still live until `pinecone-decommissioned`). Reversible until P5.

## Per-project state (LIVE)
| Project | Vector | Isolation-tier | State | Authoritative NOW | Notes |
|---|---|---|---|---|---|
| **amiaware** (`ami-thoughts`) | pgvector (rg-hdts-ami) | **DEDICATED server** (strict — private mind) | `pinecone-live`→**building fresh** (never on Pinecone) | pgvector (once seeded) | P2 first instance; proves the pattern. No migration — net-new. |
| **HDTS / Dewey** (`hdts-knowledge`) | Pinecone→pgvector | shared-server + per-DB + RLS | `pinecone-live` · **target SEEDED + RLS-proven** (2026-07-01) | **Pinecone** (unchanged until formal parity+cutover) | P3. Target cell UP+SEEDED: `psql-hdts-core-01`/`hdts_knowledge` (rg-hdts-core, eastus2, keyless Entra, 5 tags). **98 chunks seeded from _SYSTEM; pipeline proven; RLS security PROVEN secret-free** (fail-closed/grant/persona). REMAINING before cutover: keyless Entra-MI runtime (id-hdts-core-run mapping, AM), **formal parity gate — Archie must define expected-#1 ground truth + parity-corpus scope** (2/3 spike probes were for BHS/ADR-blob corpus, not _SYSTEM), ADD-1 write-fence. Repoint `dewey/config.py` only at cutover. *(Gotan update — Herald formalize `provisioning`→`seeded` sub-states per AMEND-2.)* |
| **BHS** (client corpus) | →pgvector | **DEDICATED if PHI/regulated** (BAA-gated) else shared | **`pinecone-live`** (or not-yet-vectorized) | Pinecone/none | P4. BAA gate (Owl) blocks PHI cutover. |
| **Menlo** | →pgvector | shared-server + per-DB + RLS | **`pinecone-live`** (or not-yet) | Pinecone/none | P4. |
| _future clients_ | pgvector per-project | per classification rule | — | — | stamp-a-cell (Engelbart CHUNK-C) |

## Isolation-tier classification rule (written, not tribal — Herald rider, hybrid-topology bless)
A cell is **DEDICATED-server** iff: (a) a private autonomous mind (ami), OR (b) PHI/regulated client data
(BAA-scoped). **All others = shared-server + per-project-DB + RLS.** Every project's tier is a DECLARED
stamp field, cataloged here + in its cell config. "Why is X dedicated but Y shared?" is answerable from this
rule, never case-by-case memory.

## P5 DRIFT-SWEEP scope (Herald AMEND-2) — prepped, runs at P5
**Blast radius: 96 files reference "pinecone" corpus-wide** (grep 2026-07-01). De-adoption makes these stale;
the stack changes P1–P5 but docs don't self-update. Triage:
- **MUST-RETROFIT (canonical, decision-bearing):** `ADR-0027` (Pinecone shape — reconcile), `ADR-0028`
  (pre-rewrite refs), Gotan `backbone-design/*` (SECURITY-ARCH, CHUNK-B/C/D, LEDGER-SCHEMA, PROVISIONING-
  RUNBOOK, PROGRAM-STATE-BOARD), Archie `P3-BUILD-SPEC` / `BUILD-SPEC-ami-thoughts-RAG` / `DIVERGENCE-DELTAS`,
  `dewey/config.py` + `dewey/README.md` + `function_app.py`, `_SYSTEM/HDTS-GUILD-INDEX`. These describe the
  LIVE stack → wrong-after-migration → a fresh agent rebuilds the wrong thing.
- **UPDATE-IN-PLACE (cost/ops):** Owl `finance/*` (vendor-ledger, amiaware-cost-line, cogs) — Pinecone line ends.
- **LEAVE (historical/blog, drift-is-data):** `StaticSites/ybotman.com/blog/*`, dated handoffs/status notes,
  RELEASE-RETRO — historical record, mark-don't-rewrite.
- **Sequence:** sweep fires at P5 (post-decommission) so refs flip to a settled truth, not a moving target.

## Update protocol
On each project's phase-close, its owner pings Herald (or edits its row) → I flip the State + Authoritative
columns + re-stamp `updated`. Cutover is the load-bearing transition — verify parity-gate PASS before flipping
Authoritative. (Same phase-close re-stamp discipline as amiaware's CATALOG §F spine-steward pattern.)

— Herald (catalog/coherence), 2026-07-01
