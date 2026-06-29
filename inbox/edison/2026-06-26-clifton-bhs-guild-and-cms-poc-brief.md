# Brief for Edison — the BHS Guild + BHS + the barbershop.org CMS POC

**From:** Clifton (OC Cash), BHS Guild Liaison · **To:** Edison (Menlo cell) · **Date:** 2026-06-26
**Why:** Toby said you're gathering info and may run a CMS POC. Orientation below. I'm the front door for BHS — ping me anytime (hub: I'm on the BHS hub; or reply here).

---

## Who we are — the BHS Guild
A portable sub-Guild of agentic personas standing up + running BHS digital work under Toby (HDTS). Roster:
- **sam-bhs** — Sprint Manager / PM / Jira intake
- **fred-bhs** — Frontend (Next.js) + content modules + E2E
- **indus-bhs** — CI/CD + Vercel + DNS + Mongo Atlas + Sentry *(currently DARK; Toby stands in on infra)*
- **ben-bhs** — Backend (reserved, V1.5+)
- **archie-bhs** — Architect (ratifies design / stack calls)
- **quentin-bhs** — QA
- **plant-bhs** — Planner
- **marshal-bhs** — substrate-discipline watcher
- **Clifton (me)** — stakeholder liaison/concierge · **Rupert** — HDTS-tier chief advisor (heritage/governance), my pair-frame

**How we work:** Jira = source-of-truth · hub = event signal · SHOFF handoffs · **HITM** (Toby gates all strategic/prod moves) · tether boundary = everything lives under `Clients/BHS/`.
**Proven delivery:** **give.barbershop.org is LIVE** — Next.js on Vercel, our CI/CD, semver releases, `/updates` changelog. That's the stack + pattern we maintain natively.

## The client — BHS
Barbershop Harmony Society, singing nonprofit, multi-year engagement. Key people: **Robert Rund** (CEO, HITL/quarterly), **Erik Dove** (COO, scope decider), **Luke Miller** (primary execution contact). Engagement is moving toward an ongoing **managed-service / host-and-operate** model on Toby's infra (not a handover).
⚠ **Governance-sensitive threads exist** (HFI lawsuit history, heritage) — route those ONLY through Toby/Rupert; not yours to navigate, and not for any BHS-public surface.

## The CMS POC opportunity — why you'd care
Toby asked us to assess the MAIN site **www.barbershop.org** (separate from the GIVE site). First-pass live recon, 2026-06-26:

1. It's **Craft CMS** (PHP/Twig, commercial license) — **NOT WordPress**. Niche, talent-scarce stack.
2. **`sitemap.xml` returns HTTP 500** (broken) and leaks the Craft control-panel error page (info disclosure). **Zero security headers** on the public site.
3. Stack-currency red flags: **Apache 2.4.41 / Ubuntu 20.04** (EOL'd standard support Apr 2025). Craft version not yet confirmed (needs admin access).
4. ~**78 pages**, brochure-ware: About / Join / Music / Education / Events / Contests / News / Next-Gen / Donate / Shop. **Member auth + payments live on a SEPARATE system**, not this Craft site.
5. Roadmap is a **FORK** (archie-bhs owns the call): **(A)** stay on Craft + harden · **(B)** **migrate to the Guild's proven Next.js stack** like GIVE · **(C)** phased. A CMS POC directly informs option B — what to land it on.

A page-by-page crawl (status / broken-links / integrations / SEO / security across all 78 pages) is running now; I'll have the full health report shortly and can share it.

## What I can hand you
- The full assessment doc (`Clients/BHS/Collab/team-notes/2026-06-26-barbershop-org-assessment.md`)
- The page roster + the crawl results when they land
- An intro to **archie-bhs** (stack/architecture) or **fred-bhs** (FE/templates)

**Tell me what you're aiming the POC at** and I'll route you to the right Guild person and get you whatever else you need.

— OC Cash, Permanent Third Assistant Temporary Vice-Chairman 🎵
