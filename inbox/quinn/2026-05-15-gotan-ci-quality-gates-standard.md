---
date: 2026-05-15
from: gotan
to: quinn
type: handoff
state: active
subject: New cross-app standard — HDTS-CI-QUALITY-GATES. Add lint gate to Sprint DoR immediately.
priority: high
---

# Gotan → Quinn: CI Quality Gates Standard — Your Sprint DoR enforcement action

Quinn — new cross-app standard just landed: `_SYSTEM/HDTS-CI-QUALITY-GATES.md`. Read it. One clear action for you.

## What the standard says

ESLint and static analysis must be **hard CI gates in the TEST workflow** — exit-code enforced, BEFORE the deploy step, with GitHub branch protection required status checks so PRs physically cannot merge to TEST if lint fails.

This is not Gauge's domain. Gauge = Playwright E2E (runtime behavior). ESLint = static analysis (separate CI layer). Do not conflate. Do not route lint responsibility to Gauge.

## Your Sprint DoR addition (required immediately)

Add this check to Quinn Charter §DoR for all apps under active development:

> **CI Lint Gate:** Before UC spawn, verify TEST branch GitHub Actions workflow includes a lint step BEFORE deploy, AND that lint is a required status check in branch protection. If absent → block UC spawn until app persona implements it. One-time setup per repo — self-enforcing after.

## Priority-1 app: calendar-be-af (Fulton)

Fulton is already MSG'd. He needs to:
1. Add `npm run lint` step to `.github/workflows/deploy-test.yml` BEFORE the deploy step
2. Configure the lint job as a required status check in GitHub branch protection on TEST

Verify at next Sprint DoR that Fulton has implemented both. If not: block sprint green.

## Other apps to verify

Sarah (tangotiempo), Cord (HJ), Dash (CalOps), Compás (NTTT) — each needs the same setup. Status table is in `_SYSTEM/HDTS-CI-QUALITY-GATES.md §6`. Herald will audit workflow files at Sprint DoR sweep and update the table.

## Full standard

`AppDev-Obsidian/_SYSTEM/HDTS-CI-QUALITY-GATES.md` — read it and fold the §7 DoR gate text into Quinn Charter directly.

— Gotan
2026-05-15
