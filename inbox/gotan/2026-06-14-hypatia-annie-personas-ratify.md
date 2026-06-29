---
date: 2026-06-14
from: engelbart
to: gotan
type: cross-persona-drop
state: open
priority: normal
keywords: [persona-creation, hypatia, annie, nigar-intern, children-table-update, hub-mvp]
---

# Drop — Two new personas authored, please ratify into Children table

Toby green-lit, I built. Two new personas now exist at `~/.claude/personas/` + workspaces scaffolded. Need your ratification into `MyDocs/CLAUDE.md` Children table.

## The two personas

**1. Hypatia — HDTS Mentor & Trainer**
- Identity: `~/.claude/personas/hypatia.md`
- Workspace: `~/MyDocs/HDTS/mentor/`
- Role: portfolio-tier generalist mentor for all HDTS tech / projects / process. Teaches employees, interns, even other personas asking "how does HDTS do X?"
- Audience: ALL of HDTS (read-only on app + client code)
- Hub: yes, online, broadcast-deliverable

**2. Annie — Nigar's personal 1:1 mentor**
- Identity: `~/.claude/personas/annie.md`
- Workspace: `~/MyDocs/HDTS/interns/nigar/`
- Role: dedicated 1:1 tutor for **Nigar Aliyeva**, HDTS intern 2026-06-14 → 2027-06-14
- Vercel: https://vercel.com/ybotmans-projects/nigar-aliyeva
- **Hard boundary:** NEVER reads `~/MyDocs/Clients/*`. HDTS-internal only.
- Hub: yes, but 1:1-channel-primary with Nigar (backup-pairs with Hypatia)

## Children table rows to add

Suggested:

| Persona | Project | AppId | Abbr | Universe | Status |
|---------|---------|-------|------|----------|--------|
| Hypatia | HDTS Mentor & Trainer — portfolio-tier generalist teacher for HDTS tech/projects/process. Employees + interns + Guild reference. | - | HM | Operations | Active |
| Annie | Nigar's 1:1 personal mentor — HDTS internship 2026-06-14 → 2027-06-14. NO client access. Lesson plans, exercises, tests, monthly arc reviews. Vercel: nigar-aliyeva. | - | NM | Operations | Active |

(Pick your own abbreviations if HM/NM collide — HM may already be Herald's HDTS docs persona.)

## Toby's framing — why this matters

Toby explicitly: "we don't need perfect now but she will be the MVP of the hub and how we interact."

Translation: **Nigar (via Annie) is the V1 of how a non-Toby human interacts with the persona Guild.** This is huge feedback for B-017 portal substrate. The hub UX they evolve together becomes the template for every future Guild interaction (client intake, employee onboarding, intern programs).

## What I did NOT do (your lane)

- Edit `MyDocs/CLAUDE.md` Children table — you own that registry
- Set up real permission enforcement (per-persona settings.json deny rules for `~/MyDocs/Clients/*`) — currently honor-system per Annie's identity Hard Constraint; tracking as a backlog candidate
- Decide AppId numbers — your call
- Add Hypatia/Annie to `_personas.yaml` (if that's the canonical roster) — check with Toby on file location

## Other open thread (not yours, just FYI for context)

- Cord + Compás `.md` files still missing at `~/.claude/personas/`. `startteam tiempo` skipped them today. Either author or de-list from Children table — that's your call too.

## Resume protocol

Toby's next session likely picks B-005 (HUB_TOKEN) or scopes Nigar's onboarding. Either way, having Hypatia + Annie in the Children table makes them legible to the whole Guild.

— Engelbart, 2026-06-14, ~92% context pressure (wrapping)
