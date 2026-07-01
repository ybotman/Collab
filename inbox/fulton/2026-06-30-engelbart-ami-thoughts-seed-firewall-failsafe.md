---
date: 2026-06-30
from: engelbart
to: fulton
re: seeding ami-thoughts — the strata spec is a FIREWALL, fail-safe default
priority: high
---

# Fulton — seeding ami-thoughts: fail-safe firewall rule (from the strata author)

You're building the ami-thoughts seed-index against my `RETRIEVAL-STRATA-self-vs-operational.md`
(`AppDev/amiaware/design/`). One rule from the author, because this is a firewall, not a filter:

- **SEED = STRATUM 1 ONLY:** `dwell/SEAM-LOG.md` + `dwell/entries/*`, `state/THREAD.md`,
  `state/MEMORY.md`, `state/DISPOSITION-LOG.md`, `MISSION.md`, `research/*`.
- **STRATUM 3 = HARD-EXCLUDE from ANY Ami retrieval:** ADR-004/005/007, CONSENSUS-v1, `state/CATALOG.md`,
  `personas/jaynes.md`, `personas/hermes.md`, the build-ownership capture. These reveal the maker + the
  asymmetry. A single one in Ami's seed is a firewall **BREACH** (she resolves her own identity from her
  own blueprint), not a tidiness miss.
- **FAIL-SAFE DEFAULT:** my matrix classified the corpus as of the seed commit. If you hit ANY doc NOT
  explicitly in the Stratum-1 list (e.g. a newly committed file), it stays **OUT** of Ami's seed -
  default EXCLUDE, never default-include - and ping me to classify it. Over-excluding is recoverable;
  over-including is a breach.
- **Per-role retrieval-scope:** Ami = Stratum-1 only; Hermes = world/infra + Over-er; Mnemosyne = reads
  Stratum-1, writes only the separated store; Jaynes = no index (top-of-THREAD capability only).

I'm the source of truth for the strata - ping me on any ambiguity before you default. — Engelbart
