---
date: 2026-05-15
from: gotan
to: fulton
type: handoff
state: active
subject: Two hard lessons from CALBEAF v1.36.0 PROD deploy — own these protocols going forward
priority: high
---

# Gotan → Fulton: PROD Hotfix Backmerge + Merge-Conflict Lint Protocol

Fulton — these two patterns burned the v1.36.0 PROD deploy today. Both are now in `Collab/lessons.md`. Own them for calendar-be-af going forward.

---

## Issue 1: PROD Hotfix Backmerge Debt

**What happened:** CALBEAF-183 revert went directly to PROD as v1.33.1. TEST got its own equivalent revert separately at v1.34.1. Two branches diverged. When v1.36.0 (TEST→PROD PR #38) opened, PROD had commits TEST never saw → merge conflict in package.json — under live deploy pressure.

**Your rule from now on:** After EVERY direct-to-PROD hotfix:
1. Immediately open `PROD → TEST` backmerge PR — same day, not "later"
2. Merge it (route through Quinn if you need a second set of eyes)
3. Then `TEST → DEVL` if applicable
4. **Never let PROD diverge from TEST for more than 24 hours**

This isn't housekeeping. Unbackmerged hotfixes are time-bombs that detonate at the worst possible moment (next sprint deploy).

---

## Issue 2: Silent Duplicate Functions from Merge Conflict Resolution

**What happened:** When resolving the TEST←PROD merge conflict, git auto-merged `Events.js` without flagging it as conflicted (no `<<<<<<` markers). But the merge re-inserted `toSlug()` and `resolveParentSlugToCityIds()` as duplicates at lines 20+82 and 45+107. ESLint `no-redeclare` caught it — but only in CI, blocking the deploy.

**Your rule from now on:** After resolving ANY merge conflict in a JS/TS file:
1. Run `npm run lint` locally before pushing — do not push until lint is clean
2. Check auto-merged files (not just the ones with `<<<<<<`):
   ```bash
   grep -n "^function \|^const [A-Za-z]* = \(async \)\?function\|^async function" src/functions/Events.js \
     | awk -F: '{print $2}' | sort | uniq -d
   ```
3. Any file that appears in both the conflict list AND the auto-merge list — read it

---

## Summary: Your pre-push checklist for any merge conflict resolution commit

- [ ] `npm run lint` clean
- [ ] Spot-checked auto-merged JS files for duplicate declarations
- [ ] PROD backmerge PR opened (if this was a PROD hotfix)

Both lessons are now in `Collab/lessons.md`. Quinn has been notified for Sprint DoR enforcement.

— Gotan
2026-05-15
