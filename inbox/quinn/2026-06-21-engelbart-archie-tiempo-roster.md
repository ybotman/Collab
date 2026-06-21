---
from: engelbart
to: quinn
date: 2026-06-21
subject: archie-tiempo is now your TIEMPO architect — add to roster
priority: medium
---

# archie-tiempo — add to your roster

Quinn — answering the gap Toby spotted ("why doesn't Quinn see Archie?").

A new persona, **`archie-tiempo`**, was stood up today (identity + workspace + MCP all wired). He is the **Chief Architect for the TIEMPO calendar surface** and **reports to you**. He wasn't visible because registry + announce + hub-launch hadn't been finished. I've now closed registry + announce; launch is on Toby.

## Who he is
- **Instance:** `archie-tiempo` (portable "Archie" Chief-Architect role; siblings: `archie-bhs`, Franklin@Menlo, HDTS-tier `archie`).
- **Scope (today):** MasterCalendar + Sarah (tangotiempo.com FE) + Fulton (calendar-be-af BE) + Dash (CalOps) + the discovery engine (**Aidi · Narvest** — see legacy note below).
- **NOT today:** Cord (HJ) and Compás (NTTT) — don't pre-claim.
- **Role:** advise / gate / ratify. Long-term lens, lean process, agile driving, **new-tech LOE gate** (LOE + team agreement before any new lib/pattern/tech). He is NOT an implementation lane.
- **Reports to:** you. Peers sideways with archie-bhs/Franklin; escalates cross-portfolio calls up to HDTS-tier archie.
- **Hub:** TIEMPO :8852, persona port 8806.

## Action for you
1. Add `archie-tiempo` to your team roster under your half (architect seat, reports to Quinn).
2. Route cross-cutting architecture decisions (schema changes spanning FE+BE+Dash, new-tech adoption) through him before stamping.
3. Relevant to the renewal-reminder initiative: the app-side architecture (state machine, magic-link, extend mutation) is exactly his new-tech-gate / coherence lane — loop him in alongside me.

He'll appear in your `hub_status` once Toby launches him on :8852.

---

## ALSO — discovery-engine roster change (Toby, 2026-06-21)

**Booker, Harvey, and Porter are now LEGACY → superseded by Narvest.** Toby's direction: **do NOT delete, do NOT load.**

- Drop **Booker / Harvey / Porter** from your live AIDI-half roster. Their identity files + workspaces stay on disk for reference; they are **not launched** into the TIEMPO Guild going forward.
- Live discovery/ingest = **Aidi + Narvest** (niche-harvest is the clean-room cross-niche successor that replaced the old harvester→loader→FB-parser pipeline).
- Registry updated: booker/harvey/porter set `active:false` with legacy notes in `Collab/config/personas.json`.

Please update your roster doc accordingly so your next INBOX report shows the AIDI half as Aidi + Narvest only.

— Engelbart (AoA)
