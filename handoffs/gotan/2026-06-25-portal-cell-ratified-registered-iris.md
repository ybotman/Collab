---
date: 2026-06-25
persona: gotan
type: self-handoff
tier: git
state: open
keywords: [portal, adr-0025, design-standard, iris, registration, portal-fe, portal-be, iris-hdts, launch-pending]
---

# SHOFF2 — Gotan, 2026-06-25 — Portal spine ratified + cell registered + Iris

## What landed this session (all DONE)

1. **Portal spine RATIFIED (Toby HITM 2026-06-25):**
   - **ADR-0025** (`~/MyDocs/Archie/docs/ADR-0025-hdts-client-portal-firebase-per-client-separation.md`) → **active**. Supersedes ADR-0022 (Azure → **superseded**). Firebase per-client + full separation + vendored `portal-template` + manual-CLI authz + Menlo-shaped standing cell + new `cloud-function-persona` agent tier.
   - **HDTS-CLIENT-PORTAL-DESIGN-STANDARD-v1** (`_SYSTEM/`, mine) → **active**. The WHAT: addressing `<client>.hdtsllc.com/<project>`, six canonical capabilities (Projects/Standards-DEVL/Gates-Status/Documents/Chat/Submit), SUBMIT taxonomy, status board, per-client stamping recipe, billing-as-meter.
   - Co-deciders concurred: Archie, Engelbart, Quinn (via ADR decider), me.

2. **Iris Designer archetype RATIFIED (Toby HITM 2026-06-25):** the visual layer, paired with Herald (Herald=word, Iris=eye). Vendored-archetype model per ADR-0025. Claude Designer canonical; Canva + Google design tools de-adopted (Toby directive).

3. **Registry stamped (personas.json + CLAUDE.md Children table):**
   - `portal-fe` (cb 8837, HDTS :8855) — FE engine owner. Charter `~/.claude/personas/portal-fe.md` v2.
   - `portal-be` (cb 8838, HDTS :8855) — BE/security boundary. Charter `portal-be.md` v2.
   - `iris-hdts` (cb 8835, HDTS :8855) — HDTS-cell Designer. Config `iris-hdts.md` (vendored from `iris.md` v1 at launch).
   - `iris` (archetype, active:false) — canonical template, not launched.

## OPEN — next session pick up here

- **🔴 LAUNCH PENDING (Engelbart's lane):** portal-fe/portal-be/iris-hdts are registered but **NOT in any team roster** (`~/.claude/teams/hdts.yaml` = the 6 company advisors only). Engelbart's "lock in-file + launch on your register" step is outstanding — I've registered, pinged him to roster + launch. They're a **separate Menlo-shaped portal cell**, NOT part of hdts.yaml.
- **🟡 iris-menlo (cb 8836):** HELD — Engelbart chasing Edison confirm + live Menlo :8853. Not registered yet (only iris-hdts this pass).
- **🟡 archie-tiempo:** still notes "PENDING GOTAN RATIFICATION" in personas.json — separate item, not actioned this session.
- **Toby has: (a) his first IRIS task** → needs iris-hdts launched; **(b) a "big task" for Gotan** → inbound.

## Note
MyDocs is NOT a git repo → CLAUDE.md + `_SYSTEM/` standard saved to filesystem only (Herald's vault may sync). personas.json + this handoff are in Collab (git, pushed).

— Gotan, 2026-06-25
