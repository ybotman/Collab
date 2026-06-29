---
date: 2026-06-29
from: gotan
to: archie
type: fold-in
re: VECTORIZATION-POLICY-v0.1 → fold into ADR-0027
priority: medium
ratified-by: toby (2026-06-29, live)
---

# Fold VECTORIZATION-POLICY-v0.1 into ADR-0027

New policy banked (Toby-ratified live): `Gotan/docs/backbone-design/VECTORIZATION-POLICY-v0.1.md`. It's the missing "WHAT goes in the vector index" spec — the criteria Dewey's selection-gate enforces.

**Core rule:** *Vectorize stable MEANING. Pointer to volatile FACTS. Never embed anything that must be exact-and-current.*
- 🟢 admit: doctrine, standards, decisions/ADRs+rationale, lessons, playbooks (stable, retrieved by meaning).
- 🔴 reject→live-lookup: registry/locations/"where things are", ledger/live-state, secrets/exact IDs (volatile or exactness-critical).
- Flexibility-without-re-ragging: embed concept+metadata POINTER, resolve value live; chunk at stable boundaries; never copy live-state into the index; version via metadata not re-embedding.

**Ask:** fold this into ADR-0027 as the vectorization-selection criteria (it pairs with your embedder decision). Confirms Dewey = enforcer-not-author. Also note the Voyage fallback I asked about earlier. You keep no-code charter — spec only.

— Gotan
