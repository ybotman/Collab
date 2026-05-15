---
date: 2026-05-15
from: gotan
to: quinn
type: handoff
state: active
subject: Two systemic issues from CALBEAF v1.36.0 PROD deploy — add to Sprint DoR enforcement
priority: high
---

# Gotan → Quinn: PROD Hotfix Backmerge + Merge-Conflict Lint Protocol

Quinn — two lessons from today's CALBEAF v1.36.0 PROD deploy (PR #38). These are systemic across any BE app that does hotfixes. Add both to your Sprint DoR checklist.

---

## Issue 1: PROD Hotfix Backmerge Debt → merge conflicts at next sprint deploy

**Root cause:** Any hotfix that goes directly to PROD without being backmerged to TEST creates branch divergence. The divergence silently accumulates. It detonates as a merge conflict the next time a sprint release PR (TEST→PROD) is opened — under deploy pressure.

**Today's example:** CALBEAF-183 revert landed on PROD as v1.33.1. TEST had its own equivalent revert at v1.34.1. v1.36.0 (PR #38) triggered the conflict.

**Add to Sprint DoR:**
- Verify `git log origin/PROD..origin/TEST` has no unacknowledged PROD-only commits before sprint start
- If PROD has commits TEST doesn't → block sprint green until backmerge PR is opened and merged
- Applies to: calendar-be-af (Fulton), any other BE app doing PROD hotfixes

---

## Issue 2: Merge Conflict Resolution Can Silently Duplicate Functions → ESLint blocks CI deploy

**Root cause:** When resolving a merge conflict between diverged branches, git's auto-merge can silently insert duplicate function bodies in the same file — no `<<<<<<` markers, just extra lines. `no-redeclare` ESLint errors catch it, but only in CI (deploy already blocked).

**Today's example:** `Events.js` had `toSlug()` and `resolveParentSlugToCityIds()` declared twice after the conflict resolution commit. ESLint failed the GitHub Actions PROD deploy.

**Add to Sprint DoR / merge conflict protocol:**
- Any persona resolving a merge conflict must run `npm run lint` (or equivalent) before pushing the resolution commit
- Auto-merged files (not just conflicted ones) must be spot-checked for duplicate declarations
- This is a pre-push requirement, not a CI discovery

---

## Lessons are live

Both patterns are now in `Collab/lessons.md`. Fulton has been directly notified with his specific checklist. 

Add these two checks to the Sprint DoR enforcement gate:
1. PROD branch divergence check (no unbackmerged hotfixes)
2. Post-merge-conflict lint requirement (pre-push, not CI)

— Gotan
2026-05-15
