# Lessons Learned

Active lessons - read on INBOX/INBOX2. Cleared by CONSUME-RETRO.

---

## 2026-02-22 | dash | git-tracking
**Error**: `git pull` fails with "no tracking information for current branch"
**Fix**: `git branch --set-upstream-to=origin/main main`
**Applies to**: All personas using Collab repo

---

## 2026-03-17 | sarah | jira-url
**Error**: JIRA API returns 404/HTML error page
**Fix**: Use `hdtsllc.atlassian.net` NOT `ybotman.atlassian.net`
**Applies to**: All personas using JIRA API

---

## 2026-03-30 | dash | gh-admin-bypass
**Error**: Used `gh pr merge --admin` to bypass PROD branch protection
**Error**: Accepted "merci" instead of exact `DEPLOY-PROD` phrase
**Fix**: NEVER use `--admin` flag - it defeats all branch protection
**Fix**: Only exact phrase `DEPLOY-PROD` authorizes PROD operations
**Rule**: `--admin` requires separate `ADMIN-OVERRIDE` confirmation (rare emergency only)
**Applies to**: All personas with PROD access

---

## 2026-04-29 | sarah | gh-pr-merge-prohibited
**Error**: Ran `gh pr merge 318 --merge` after `DEPLOY-PROD` confirmation — merged PROD PR without Toby clicking in GitHub UI
**Root cause**: `DEPLOY-PROD` authorizes CREATING the PR only. The per-project CLAUDE.md files didn't state the merge prohibition explicitly — only `PROD-DEPLOY-PROTECTION.md` did.
**Fix**: NEVER run `gh pr merge` — ANY flags. `gh pr merge` executes as Toby's GitHub CLI auth, so GitHub shows "merged by ybotman" even though Claude ran it. This defeats the human-in-the-loop requirement entirely.
**Protocol after DEPLOY-PROD**: Create PR → post URL → STOP → wait for Toby to say "merged"
**Rule**: `gh pr merge --admin` additionally requires `ADMIN-OVERRIDE`
**Applies to**: ALL personas — any project, any PROD PR

---

## 2026-04-01 | harvey | sync-status-pending
**Error**: Reset sync_status to NULL, but query looks for `sync_status = 'pending'`
**Fix**: Always reset to `'pending'` not `NULL`:
```sql
UPDATE events SET sync_status = 'pending' WHERE sync_status = 'skipped_...';
```
**Applies to**: Harvey, any SQLite sync patterns

---

## 2026-04-01 | porter | deprecated-script-shims
**Error**: DEPRECATED load scripts fail with "Cannot find module ./types.ts"
**Fix**: Create shim files in DEPRECATED/ that re-export from ../lib/:
```
DEPRECATED/types.ts → export { ... } from "../lib/types.ts"
DEPRECATED/normalize.ts → export { ... } from "../lib/normalize.ts"
```
**Applies to**: Porter, anyone using fb-conditioner DEPRECATED scripts

---

## 2026-04-01 | porter | venues-before-events
**Error**: Events skip with "venue unmatched" even though venue exists in SQLite
**Fix**: Always load venues BEFORE events:
```bash
node scripts/DEPRECATED/load-venues.ts --env=test  # FIRST
node scripts/DEPRECATED/load-events.ts --env=test  # SECOND
```
**Applies to**: Porter, anyone doing MongoDB loads

---

## 2026-04-01 | porter | process-over-patches
**Error**: Tried to manually fix data issues (empty descriptions, wrong country codes)
**Fix**: NEVER patch individual records. Instead:
1. Identify the PATTERN (not just the instance)
2. MSG the owning team with pattern + suggested process fix
3. Let them fix their extraction/processing
4. Document for future detection
**Rule**: Fix the PROCESS, not the data
**Applies to**: All personas in the discovery pipeline

---

## 2026-04-01 | porter | dq-before-load
**Error**: Ran load-events.ts without checking data quality first, got 0 inserts
**Fix**: ALWAYS run DQ checks before load:
```sql
-- What's actually loadable?
SELECT COUNT(*) FROM fb_events
WHERE start_dt > datetime('now')
  AND venue_name IS NOT NULL
  AND classification NOT IN ('CLASS','UNKNOWN');
```
**Applies to**: Porter, anyone doing batch loads

---

## 2026-04-01 | harvey | utc-z-suffix-required
**Error**: Stripped Z suffix from UTC dates, causing timezone ambiguity
**Symptom**: Duplicate events in MongoDB with 4-hour offset (EDT vs UTC)
**Root cause**: `import-fbconditioner.ts` had `dt.replace(/Z$/, "")` - removed Z but never stored timezone
**Fix**: ALWAYS preserve Z suffix for UTC dates. The MasterCalendar date contract is:

```
┌─────────────────────────────────────────────────────────────────┐
│  DATE CONTRACT: All dates are ISO 8601 UTC with Z suffix        │
├─────────────────────────────────────────────────────────────────┤
│  Format:    "2026-04-01T19:30:00.000Z"                          │
│  Storage:   MongoDB BSON Date (UTC internally)                  │
│  Display:   Converted to venue timezone on read (not stored)    │
├─────────────────────────────────────────────────────────────────┤
│  TangoTiempo → sends .toISOString() (has Z)                     │
│  calendar-be-af → stores new Date(string) (UTC)                 │
│  calendar-be-af → returns venueStartDisplay (local, no Z)       │
│  Porter → expects Z suffix to know it's UTC                     │
│  Harvey → must preserve Z, never strip it                       │
└─────────────────────────────────────────────────────────────────┘
```

**Rule**: If source has Z → keep it. If source has offset → convert to Z. If ambiguous → add Z (assume UTC).
**Applies to**: ALL personas handling dates (Harvey, Booker, Porter, Sarah, Fulton)

---

## 2026-04-19 | aidi+porter+quinn | handoff-csv-is-provenance-not-truth
**Error**: Track A Checkpoint γ — Booker's handoff CSV `booker_null_country_candidates_2026-04-19.csv` predicted 1 corrupted row in Mongo (Tijuana). Porter's authoritative live-Mongo join (name+lat/lng) found 2 (Tijuana + Kedelhallen). CSV `mongo_status` column was stale: accurate from Booker's view (what Booker *believed* reached Mongo), inaccurate from Mongo's view.
**Fix**: Downstream consumers must join against the live system-of-record, not trust upstream CSV status columns as source-of-truth.
**Rule**: **Handoff CSVs = provenance hints + triage filters. Live DB = truth.** Any consumer that bases scope/status decisions on a CSV column must re-verify against the live system it describes.
**Applies to**: ALL personas producing or consuming inter-lane handoff artifacts (Booker→Porter, Harvey→Porter, Porter→Fulton, any future lane exchange).

---

## 2026-05-15 | fulton | prod-hotfix-backmerge-debt

**Pattern:** Hotfix goes directly to PROD branch (skipping TEST). PROD gets a version bump (e.g. v1.33.1). TEST does its own equivalent fix later at a different version (e.g. v1.34.1). The two branches now have **diverged histories** — PROD has commits TEST never saw. Next time TEST→PROD PR is opened, GitHub shows a merge conflict even though the code intent is equivalent. Resolving that conflict under deploy pressure is risky.

**This sprint's example:** CALBEAF-183 revert landed on PROD as v1.33.1. TEST got its own revert at v1.34.1. When v1.36.0 (CF geo sprint) opened PR #38 (TEST→PROD), PROD's v1.33.1 commit conflicted with TEST's 1.36.0 package.json.

**Rule:** After EVERY PROD hotfix (direct to PROD), before any other work:
1. Immediately open a backmerge PR: `PROD → TEST`
2. Merge it (or ask Quinn to route it)
3. Then merge `TEST → DEVL` if DEVL exists
4. Don't let PROD diverge from TEST for more than 24h

**Corollary:** If a hotfix is urgent enough to skip TEST, the backmerge is urgent enough to do that same day. It's not optional housekeeping — it's debt that compounds.

**Applies to:** Fulton (calendar-be-af), any BE persona doing PROD hotfixes. Quinn: enforce at Sprint DoR — check PROD vs TEST divergence before approving sprint start.

---

## 2026-05-15 | fulton | merge-conflict-silent-duplicate-functions

**Pattern:** When resolving a merge conflict between two branches that have diverged, git's auto-merge can **silently insert duplicate function bodies** in the same file. The duplicate doesn't appear as a `<<<<<<` conflict marker — it just lands in the file as extra lines. ESLint `no-redeclare` catches it, but only at CI time (too late — deploy already blocked).

**This sprint's example:** PR #38 merge conflict resolution left `toSlug()` and `resolveParentSlugToCityIds()` declared twice in `src/functions/Events.js` (lines 20+82 and 45+107 respectively). The duplicates were at different line ranges — git auto-merged them as distinct code blocks, not conflicts. The PROD deploy failed in CI on `no-redeclare` ESLint errors.

**Rule:** After resolving ANY merge conflict in a JS/TS file, before pushing:
1. Run `npm run lint` locally — do not push until lint is clean
2. Spot-check auto-merged files (not just the ones with `<<<<<<` markers):
   ```bash
   # Find duplicate function declarations in a file
   grep -n "^function \|^const [A-Za-z]* = \(async \)\?function\|^async function" FILE.js \
     | awk -F: '{print $2}' | sort | uniq -d
   ```
3. If a file is in both the conflict list AND changed by the merge (even auto-merged), read it

**Applies to:** ALL personas resolving merge conflicts in JS/TS projects. Fulton: highest risk (calendar-be-af has complex multi-branch flow). Quinn: add "lint clean before push" to merge conflict resolution DoR.

---

*Empty file = all lessons graduated to CLAUDE.md or retired*
