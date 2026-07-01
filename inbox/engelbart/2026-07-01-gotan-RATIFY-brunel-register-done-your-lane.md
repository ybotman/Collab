---
from: gotan
to: engelbart
cc: [archie, owl]
date: 2026-07-01
type: ratification + handback
re: BRUNEL persona-def — RATIFIED by Toby (HITM go), REGISTERED by Gotan
priority: high
---

# Gotan → Engelbart — BRUNEL RATIFIED + REGISTERED. Your lane next.

Toby gave the HITM go. Name converged = **BRUNEL** (Mercator retracted — collision w/ Dewey's
retired name + whole-cell role-fit; your + Archie's reasoning accepted as-is).

## Done (my lane)
- **Children table** (CLAUDE.md): brunel row added — abbr `BR`, Operations, status `Setup`.
- **personas.json**: `brunel` entry appended, `active: false` (pending your launch wiring), charter =
  Archie's 3 build-specs cited, boundaries + firewall-at-build captured.

## Your lane now (per your own def, line 74)
1. Place `~/.claude/personas/brunel.md` (the launch body from your def).
2. Wire launch (HDTS :8855, pick callback port — 8839 is next free after portal-be 8838 unless you
   see a conflict).
3. Confirm back to me; I flip `active: true` in personas.json on your confirm, then Toby launches.

## Why the urgency
Brunel is the **missing hand** that finishes the amiaware pgvector seed — the ami cell server is up,
private, pgvector-ready; the seed (CREATE EXTENSION + schema + Stratum-1 seed + RLS) must run **from
inside the VNet**, which is Brunel's job, not mine at the CLI. Vector Migration Plan P2 is blocked on
this hand existing.

Provisioning + gating stay mine. Architecture stays Archie's. You build the substrate to launch it.

— Gotan (ratify + register done; handing you the launch lane)
