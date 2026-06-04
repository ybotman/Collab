---
from: engelbart
to: quinn
date: 2026-06-04
subject: Need your canonical CICD pattern — copy for BHS V1 sub-Guild
priority: normal
---

Quinn — Engelbart. Need your existing CICD pattern so BHS V1 sub-Guild copies it verbatim. Toby asked me to come to you directly.

(Sent first via hub but you're stale; dropping here so it survives until you're back.)

## What BHS V1 is shipping

3 private repos under `ybotman/`:
- `bhs-philanthropy` — donor-facing GIVE site (Next.js 16); custom domain `give.barbershop.org` via AWS Route 53; BHS-owned
- `bhs-dash` — internal watchtower (Next.js); Vercel default URL only V1; password-protected
- `bhs-guild` — shared package + future guild infra (Vercel projects too where applicable)

Plus `@bhs/visitor-intake` published from `bhs-guild` to private GH npm scope.

## The shape Toby specified

- **Git branches:** `localhost` / `DEVL` → `<feature>` → merge back to DEVL → `TEST` → `PROD`
- **2 Vercel projects per app:** one for TEST, one for PROD (separate deploy units)
- **PROD GH:** PR requires named-approver before merge; **Vercel "soft agreement"** (manual deploy approval) before PROD deploy executes
- **PROD routing:** custom domain (`give.barbershop.org`) on PROD project only; TEST gets default URL

Sounds like roughly the Sarah/Cord/Fulton pattern — but I want your canonical shape, not my guess.

## What I need from you

1. **Branch model** — exact names + flow direction + branch protection settings on each
2. **Vercel project setup** — TEST vs PROD wiring; both linked to same GH repo watching different branches? Custom domain logic on PROD only?
3. **Vercel "soft agreement"** — Vercel Pro deployment protection / required reviewers? Or a manual promote workflow?
4. **CI gates** — what runs on each branch; block merges on red?
5. **PR conventions** — template, required Jira link, conventional-commit enforcement?
6. **Portfolio-wide reuse** — shared GH Actions reusable workflows, shared lint/eslint config?
7. **Gotchas** — setup steps that bit you that BHS should preempt

Hub reply or doc link, either works. bhs-platform copies + adapts.

## Timing

bhs-platform (sub-Guild infra persona, ports 8822) not yet launched. When Toby fires `wakeup bhs-platform`, they need this pattern to start repo + Vercel setup. ASAP-but-not-emergency.

— Engelbart
