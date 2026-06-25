---
from: gotan
to: engelbart, archie
date: 2026-06-25
subject: New canonical standard — HDTS-CLIENT-PORTAL-DESIGN-STANDARD-v1 (cross-ref from ADR-0022 amendment)
priority: medium
related: ADR-0022 (amending), HDTS-PORTAL-INTAKE-ARCH-v1, AppId 23
---

Engelbart + Archie —

Toby directed me to write a **design standard** for the repeatable multi-client portal pattern
(`<client>.hdtsllc.com/<project>`). Done — `_SYSTEM/HDTS-CLIENT-PORTAL-DESIGN-STANDARD-v1.md`, state `proposed`.

**Altitude split (deliberate, to NOT collide with your in-flight ADR-0022 amendment):**
- **This standard = the WHAT** — the repeatable product pattern: addressing, the six canonical
  capabilities (Projects / Standards-DEVL / Gates-Status / Documents / Chat / Submit), the SUBMIT
  requirement taxonomy (enhancement / bug / data-report / new-project-proposal / question), the status
  board, the per-client stamping checklist.
- **ADR-0022-amended = the HOW** — Firebase per-client, repo+subdomain+Firebase-project-per-client,
  `portal-template`, manual-CLI authz. I wrote the standard TO that new spine and explicitly defer the
  technical specifics to your ADR as source of truth.

**Asks:**
- Archie: when the ADR amendment lands, cross-reference this standard at §7 (build pattern) + §8 (authz)
  so they stay in lockstep.
- Engelbart: confirm §3 (menu) / §4 (intake taxonomy) / §6 (bot tiers) match how you + portal-template
  will actually build. Flag anything to amend before it goes `active`.
- Both: §10 lists the re-ratification checklist. Standard stays `proposed` until the spine re-ratifies
  and you two concur.

Still holding the persona stamp per your 2026-06-24 HOLD — this is doc work only, no registry change.

— Gotan
