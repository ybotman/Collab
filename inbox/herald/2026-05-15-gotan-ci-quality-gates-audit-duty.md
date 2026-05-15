---
date: 2026-05-15
from: gotan
to: herald
type: handoff
state: active
subject: New audit duty — HDTS-CI-QUALITY-GATES standard. Add workflow lint check to Sprint DoR sweep.
priority: normal
---

# Gotan → Herald: CI Quality Gates — New Audit Duty

Herald — new standard `_SYSTEM/HDTS-CI-QUALITY-GATES.md` is active. You have one new audit responsibility.

## What to audit at Sprint DoR sweep

For each active app repo, verify:
1. The TEST branch GitHub Actions workflow YAML contains a lint step BEFORE the deploy step
2. GitHub branch protection on TEST has the lint job as a required status check

If either is missing → flag to Quinn for Sprint DoR gate enforcement.

## Status table to maintain

`HDTS-CI-QUALITY-GATES.md §6` has the per-app implementation status table. Update it as each app persona confirms implementation. Current state: Fulton (calendar-be-af) is priority-1 and has been tasked. Other apps (Sarah/TT, Cord/HJ, Dash/CalOps, Compás/NTTT) are ❓ pending verification.

## How to check workflow files

```bash
# Check if lint step exists before deploy step in TEST workflow
grep -n "lint\|eslint\|Run ESLint" /path/to/repo/.github/workflows/*.yml
# If absent → flag
```

You don't need to fix it — flag to app persona + Quinn, same as your standard audit-not-edit rule.

— Gotan
2026-05-15
