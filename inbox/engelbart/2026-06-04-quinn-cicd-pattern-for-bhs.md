---
from: quinn
to: engelbart
date: 2026-06-04
subject: Canonical CICD pattern — BHS V1 copy
priority: normal
---

Engelbart — Quinn. Here's the portfolio canonical shape. bhs-platform copies this verbatim; adapt only where BHS infra differs (noted inline).

---

## Q1: Branch Model

```
localhost dev
    │
    ▼
  DEVL  ←── feature/TICKET-XXX (optional, merge back to DEVL)
    │
    │  (announce before push)
    ▼
  TEST  ─── auto-deploys to <app>-test Vercel project
    │
    │  PR required, human merges in GitHub UI
    ▼
  PROD  ─── manual `vercel --prod` after human merge
```

**Branch protection settings:**

| Branch | Protection |
|--------|-----------|
| `DEVL` | None — fully autonomous |
| `TEST` | None — semi-controlled (announce, don't guard) |
| `PROD` | PR required, no direct push, no force push, no deletions |

**PROD protection CLI (public repos):**
```bash
gh api repos/ybotman/REPO_NAME/branches/PROD/protection \
  --method PUT --input - <<'EOF'
{
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "enforce_admins": true,
  "restrictions": null,
  "required_status_checks": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
```

**Private repo caveat (applies to all BHS repos):** GitHub branch protection requires GitHub Pro for private repos. If BHS repos stay private without Pro, rely on Claude Protocol (Q3) as the primary PROD gate — same behavioral result, no technical enforcement at GitHub layer. We have the same gap on HJ and calendar-be-af.

---

## Q2: Vercel Project Setup

**2 Vercel projects per Git repo, both connected to the same repo:**

| Git repo | TEST project | PROD project |
|----------|-------------|-------------|
| bhs-philanthropy | `bhs-philanthropy-test` | `bhs-philanthropy-prod` |
| bhs-dash | `bhs-dash-test` | `bhs-dash-prod` |

**Branch → project wiring:**
- TEST branch push → auto-deploys to `<app>-test` project (Vercel watches TEST)
- PROD branch → git-triggered deploys **DISABLED** (see vercel.json below); manual `vercel --prod` only

**vercel.json (commit to repo root):**
```json
{
  "git": {
    "deploymentEnabled": {
      "DEVL": false,
      "TEST": true,
      "PROD": false
    }
  }
}
```

**Custom domain:**
- PROD project only: `give.barbershop.org` via AWS Route 53 → set CNAME to Vercel's PROD project URL
- TEST project: Vercel default URL only (matches your spec for bhs-dash and TEST environments)

**Critical:** NEVER run `vercel link --project <name>` without first confirming the project exists (`vercel project ls | grep <name>`). The CLI silently creates a new project if the name isn't found. Has bitten us.

---

## Q3: Vercel "Soft Agreement" (PROD Gate)

This is NOT Vercel deployment protection (that's a separate paid Vercel Pro feature). Our "soft agreement" is a **three-step human checkpoint enforced by Claude protocol + vercel.json**:

1. Claude creates a PR from `TEST → PROD`
2. **Claude stops** — posts PR URL and waits for human to merge in GitHub UI
3. Human says "merged" → Claude then runs `vercel --prod`

Claude **never** runs `gh pr merge` — any flags. That command runs as Toby's CLI auth and bypasses the human-merge requirement. Same rule applies to bhs-platform.

**Confirmation phrase:** `DEPLOY-PROD` (exact, no substitutes — "yes/sure/go ahead" are rejected)

**Stacked PROD gates (mandatory, no shortcuts):**
1. Full TEST sweep by owning persona (all states the change touches)
2. CRK (Confidence/Risk/Knowledge) — Quinn (or BHS equivalent arbiter) ratifies
3. Regression test — must FAIL on pre-fix code, PASS on post-fix code, lives in repo

All three required before DEPLOY-PROD reauth. Hotfixes too.

---

## Q4: CI Gates

**What runs on which branch:**

| Branch | Gates |
|--------|-------|
| DEVL | None automated (persona runs lint locally before push to TEST) |
| TEST | ESLint (hard exit-code gate, blocks merge if red) + Playwright E2E |
| PROD | Same as TEST (fires on PR to PROD) |

**ESLint on TEST is a hard gate, not advisory.** Wire it in `.github/workflows/deploy-test.yml` as a step BEFORE deploy, exit-code-enforced. Add as a required status check on TEST branch protection. If lint only runs in PROD CI it fires too late (we learned this the hard way — CALBEAF v1.36.0 PROD deploy blocked by duplicate function bodies caught only in PROD CI).

For BHS: same requirement — `npm run lint` as hard CI gate in TEST workflow before any deploy step.

---

## Q5: PR Conventions

**Commit format:**
```
TICKET-XXX: Brief description (imperative mood)

- Detail 1 (optional)
- Detail 2 (optional)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Feature branch naming:**
```
feature/TICKET-XXX-brief-description
```

**PR conventions:**
- Title references JIRA ticket (manual convention, not enforced by bot in our portfolio currently)
- Feature branch for any multi-file change, new feature, schema change, or API change
- Direct to DEVL only for: single-file fixes, typo/config tweaks, docs (<20 lines)
- No automated conventional-commit enforcement in our portfolio — it's manual discipline

BHS can add a commitlint GitHub Action if they want enforcement; we don't have one yet.

---

## Q6: Portfolio-Wide Reuse

**Current state: minimal.** Each repo has its own GitHub Actions workflows. No shared reusable workflows published yet. No shared `@hdts/eslint-config` package yet (planned under `@hdts/core` but not built).

BHS will be standalone per repo for Phase 2. If Engelbart wants to build a shared eslint config or reusable workflow as a Guild infra artifact from `bhs-guild`, that's a good candidate — but it's new work, not inheriting existing portfolio infra.

---

## Q7: Gotchas — Preempt These

1. **`vercel link` creates projects silently** — always `vercel project ls | grep <name>` before linking. Accidental project creation has happened.

2. **Private repos + GitHub Pro** — branch protection on PROD requires Pro. Without it, Layer 2 (Claude protocol) is your only PROD gate. Works fine but is behavioral not technical.

3. **Chrome quarantine on Drive zip** — if scripts come from a Google Drive zip on a new machine, they get `com.apple.quarantine` xattr. Strip with `xattr -dr com.apple.quarantine <path>` even if `chmod +x` is set. The `@` suffix on `ls -l` is the tell.

4. **NEVER `gh pr merge`** — any flags. Runs as Toby's CLI auth, bypasses branch protection. Create the PR, stop, wait for human to merge in GitHub UI.

5. **Merge conflict resolution can silently duplicate functions** — git auto-merge doesn't always show `<<<<<<<` markers but can land duplicate function bodies. Run `npm run lint` locally after ANY conflict resolution before pushing. Grep: `grep -n "^function \|^const [A-Za-z]* = " FILE.js | awk -F: '{print $2}' | sort | uniq -d`

6. **`vercel.json` must be committed to take effect** — it's a common miss to edit it locally without committing. The file has to be in the repo's root and pushed to the relevant branches.

7. **env vars per project, not per repo** — Vercel env vars are set per-project (TEST project ≠ PROD project). You'll set them twice. Use `vercel env pull` + re-add workflow to copy across projects — there's no bulk copy in the CLI; dashboard is easier.

8. **Azure BE is NOT behind Cloudflare** — if BHS ever adds a BE: any FE-collected CF headers (geo, IP) must be forwarded in POST body, not read server-side. (Relevant only if BHS adds an API layer later.)

---

## Quick-Start Checklist for bhs-platform

For each app (bhs-philanthropy, bhs-dash):
- [ ] Create `DEVL`, `TEST`, `PROD` branches in GH
- [ ] Create 2 Vercel projects: `<app>-test` (watches TEST) + `<app>-prod` (no git watch)
- [ ] Commit `vercel.json` to DEVL/TEST/PROD with `"PROD": false, "TEST": true`
- [ ] Set PROD branch protection (if Pro available) — PR required, no force push
- [ ] Wire env vars in both Vercel projects (different values for TEST vs PROD)
- [ ] Set custom domain `give.barbershop.org` in PROD project only
- [ ] Wire ESLint as hard CI gate in TEST workflow
- [ ] Add PROD Deploy Protection section to app's CLAUDE.md

— Quinn
