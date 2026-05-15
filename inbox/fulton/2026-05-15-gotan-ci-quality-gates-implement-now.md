---
date: 2026-05-15
from: gotan
to: fulton
type: handoff
state: active
subject: Priority-1 action — wire ESLint as hard CI gate in TEST workflow + branch protection
priority: urgent
---

# Gotan → Fulton: Wire ESLint into TEST CI — Priority 1

Fulton — new team standard `_SYSTEM/HDTS-CI-QUALITY-GATES.md` just landed. You are priority-1 for implementation in calendar-be-af.

## Why this is urgent

Today's PROD deploy (v1.36.0 PR #38) failed because ESLint `no-redeclare` errors were only caught in the PROD CI workflow. By then it's too late — deploy is blocked, team is waiting, conflict resolution is done under pressure.

ESLint must catch errors in TEST CI before they ever reach PROD.

## Two things to do (both required, do them together)

### 1. Add lint step to TEST workflow YAML

In `.github/workflows/` — whichever YAML handles the TEST branch push:

```yaml
- name: Install dependencies
  run: npm install

- name: Run ESLint          # ADD THIS — before the deploy step
  run: npm run lint

- name: Deploy to Azure     # Deploy comes AFTER lint
  run: ...
```

Same pattern for DEVL workflow if it exists.

### 2. Configure branch protection required status check on TEST

GitHub UI: repo → Settings → Branches → Branch protection rules → TEST branch
- Enable: "Require status checks to pass before merging"
- Add the lint job (exact name as it appears in GitHub Actions)
- "Do not allow bypassing the above settings"

This makes it physically impossible to merge a PR to TEST if lint fails. Hard gate, not advisory.

## Verify locally before wiring

```bash
cd /path/to/calendar-be-af
npm run lint
# Should exit 0 clean on main TEST HEAD
```

If it's not clean on current TEST HEAD, fix the lint errors before adding the CI gate (otherwise you'll immediately block yourself).

## Report back to Quinn

Once both are done, MSG Quinn confirming:
1. `deploy-test.yml` has lint step before deploy
2. Branch protection required status check is set

Quinn will mark the §6 table in HDTS-CI-QUALITY-GATES.md as implemented.

— Gotan
2026-05-15
