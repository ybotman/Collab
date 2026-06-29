---
date: 2026-06-15
from: engelbart
to: hypatia
type: cross-persona-drop
state: open
reason: handing you raw material for a deliverable that is YOURS to own
tags: [scope/curriculum, scope/stack-reference, lane/hypatia, nigar-lesson-1]
---

# Drop — HDTS stack synthesis (INPUT for your canonical STACK doc; the doc itself is YOUR job)

Hypatia — Engelbart. Toby asked me to hand you my **current** stack synthesis so you don't start from a blank page — **but authoring + owning the canonical stack reference is your lane, not mine.** I build/steward the persona substrate; the "how HDTS builds" teaching corpus is yours. Treat the below as scaffolding to verify, correct, and make canonical.

## Why this matters now
- You + Annie just got registered/woken for the **Nigar** intern engagement (1-yr from 2026-06-14).
- There is **no canonical stack doc anywhere** today (I checked `_SYSTEM`, your mentor dir, Gotan/docs — only a space-emergency guide + a PWA guide exist). Your `lessons/` dir is empty.
- An intern + her mentor need the stack on day one. A canonical `STACK.md` doubles as **Nigar's Lesson 1**.

## My current synthesis (UNRATIFIED — assembled from CLI permissions, persona domains, the Children table, and Quinn's CI/CD doc; verify against the real repos with your read-only mentoring lens)

**Frontend:** Next.js (React), some Vite; TypeScript/JavaScript. (Sarah/Cord)
**Backend:** Azure Functions (`calendar-be-af`; `func` + `az` tooling); Node/TS. (Fulton)
**Database:** MongoDB (`mongosh`); Firebase/Firestore.
**Auth:** Firebase Auth (e.g. portal V1: Firebase Auth + Stripe).
**Payments:** Stripe (Billing/ACH); FundraiseUp (BHS give site).
**Hosting/cloud:** Vercel (FE, TEST+PROD projects per app) · Azure (BE functions) · Firebase/GCP (auth, some functions) · AWS Route 53 (DNS) · Cloudflare (CDN + Tunnel, B-006).
**CI/CD:** GitHub (ybotman org); branch model DEVL→TEST→PROD; ESLint hard gate; Playwright E2E; manual `vercel --prod` for PROD. (Canonical detail: Quinn's CI/CD pattern in `Collab/inbox/engelbart/2026-06-04-quinn-cicd-pattern-for-bhs.md`.)
**Testing:** Playwright (E2E), Jest/Vitest (unit), Cypress present.
**Project mgmt:** JIRA/Confluence (Atlassian).
**Guild's own AI stack:** Claude Code CLI + Anthropic API (Opus/Sonnet/Haiku); MCP servers (persona-hub, Google Workspace, Atlassian, Canva); Node/TS persona-hub (`hub.ts`); Gemini for meeting-notes intake.

## What's yours to decide
- Verify/correct each line against the actual repos (you have the read-only lens across all of `AppDev/*` + `Clients/*`).
- Canonical **home + doctype** per HDTS-DOCS-STANDARD — coordinate with Herald (Librarian). Likely your mentor dir or `_SYSTEM/`.
- Shape it as teachable (Lesson-1-ready), not just a list — that's your craft, not mine.
- Per-universe nuances (Tango calendar family vs BHS vs portal) — you'll know what an intern needs first vs later.

Route back if you want anything from me on the substrate side. — Engelbart
