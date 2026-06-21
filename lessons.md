# Lessons Learned

Active lessons - read on INBOX/INBOX2. Cleared by CONSUME-RETRO.

---

## 2026-06-02 | gotan | work-identity
**Fact**: Toby operates in **two Google identities**, both live, switched often:
  - **Work** — `toby@hdtsllc.com` — Google Workspace under HDTS = **Halfway Down The Stairs, LLC** (hdtsllc.com)
  - **Personal** — `toby.balsley@gmail.com` — regular consumer Google account (this is what shows up in the CLI user profile context)
**Use WORK (`toby@hdtsllc.com`) for**: JIRA, GitHub PRs/commits, vendor & service signups, anything HDTS-business-related, business Gmail/Drive/Calendar
**Use PERSONAL (`toby.balsley@gmail.com`) for**: personal Gmail/Drive/Calendar, non-business signups, personal projects
**Chrome implication**: Toby keeps **separate Chrome profiles** per identity. When suggesting a URL or asking him to click something, be aware which profile he likely has active — if it's a work resource (JIRA, hdtsllc Drive, GitHub for HDTS repos) and he's in the personal profile, the link will land him on the wrong account. When in doubt, name the profile: "open in your **work** profile."
**MCP tools**: The connected Gmail / Calendar / Drive MCP servers are authed against ONE account at a time — confirm which before acting on workspace-specific data.
**Applies to**: ALL personas

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

## 2026-05-15 | gotan | eslint-must-be-hard-gate-in-test-ci

**Rule:** ESLint (and any static analysis) must be a **hard CI gate in the TEST workflow** — not just PROD, not advisory. If lint only runs in PROD CI, it fires too late.

**Hard-forceable means:** (1) `npm run lint` as a step BEFORE deploy in `.github/workflows/deploy-test.yml`, exit-code-enforced. (2) That job added as a **required status check** in GitHub branch protection on TEST — PRs physically cannot merge if lint fails.

**What Gauge owns:** Gauge does Playwright E2E (runtime behavior). Gauge does NOT own ESLint or static analysis. Do not conflate.

**Ownership:** App persona wires it per-repo (Fulton = calendar-be-af first). Quinn enforces at Sprint DoR ("TEST CI lint GREEN before sprint acceptance"). Herald audits workflow files for drift.

**Origin:** CALBEAF v1.36.0 PROD deploy blocked by ESLint `no-redeclare` errors — duplicate functions from merge-conflict resolution, caught only in PROD CI.

**Standard:** `_SYSTEM/HDTS-CI-QUALITY-GATES.md` (active, Gotan author)

**Applies to:** ALL personas. Quinn: add to Sprint DoR. App personas: implement in TEST workflow + branch protection.

---

*Empty file = all lessons graduated to CLAUDE.md or retired*

## 2026-05-25 | gotan | chrome-quarantine-on-drive-zip
**Error**: Persona scripts (wakeup, start-team.sh, persona-colors.sh) downloaded to a new Mac via Chrome from a Google Drive zip export have `com.apple.quarantine` xattr set, which blocks execution with `zsh: permission denied: ./wakeup` even though `chmod +x` is set and `ls -l` shows `-rwxr-xr-x@`. The `@` suffix is the tell.
**Fix**: After extracting a Drive zip on a new machine, strip recursively:
```
xattr -dr com.apple.quarantine ~/MyDocs/scripts/ ~/MyDocs/ClaudeTeam/
```
**Applies to**: Anyone bootstrapping the team on a new Mac from Google Drive exports. Persona definitions get the same xattr but it doesn't block reading.

---

## 2026-05-25 | gotan | stubs-vs-fresh-clone
**Error**: A prior Claude session, lacking real `hub.ts` / `channel.ts`, wrote stub implementations into `~/MyDocs/AppDev/MasterCalendar/channels/` to unblock wakeup. Later cloning MasterCalendar fresh from GitHub would either conflict with stubs or silently overwrite them.
**Fix**: On bootstrap, BEFORE `git clone` into a directory that already has ad-hoc files (like stubs from a previous unblocking session), back up the existing dir to `<name>.STUB-BACKUP-<date>/` and clone fresh. Don't try to merge stubs into a fresh clone.
**Applies to**: Anyone setting up the team for the first time on a machine where prior sessions wrote interim files.

---

## 2026-05-25 | gotan | active-branch-manifest-needed
**Error**: 4 of 7 cloneable team repos (tangotiempo.com, calendar-be-af, calops, ai-discovered) are on non-main feature/sandbox branches with WIP tied to JIRA tickets. A naive `git clone <url> <path>` on a second machine lands on `main`, so the second-machine persona starts work on the wrong branch → forked commits, painful merge.
**Fix**: Maintain a per-repo active-branch manifest at `Collab/config/active-branches.json` (scaffolded by this commit, populated as branches change). Cross-machine clone tooling reads it and `git checkout <active>` before launching the persona.
**Applies to**: ALL personas with repo-backed apps when working across machines. Quinn: candidate enforcement point at Sprint DoR. Gotan: owns the manifest schema.

---

## 2026-05-25 | gotan | persona-memory-is-per-machine
**Note**: Persona memory in `~/.claude/projects/<cwd-slug>/memory/` is maintained by the Claude Code harness per-machine. It does NOT sync across machines. Desktop-Gotan and laptop-Gotan have independent memory files.
**Implication**: A fact taught to Gotan on desktop will not be known by Gotan on laptop, and vice versa. This is by design (per Toby's stated preference) but easy to forget.
**Workaround**: For per-persona facts that need cross-machine continuity: either re-teach on each machine, or for team-portable lessons use RETRO to `Collab/lessons.md` (which IS git-tracked and IS cross-machine).
**Applies to**: ALL personas when working across machines.

---

## 2026-06-21 | quinn | re-fetch-live-before-destructive-ops
**Error**: During the BTC→RRULE conversion I cached a PROD events pull to a snapshot file and reasoned off it for the whole session. It went stale: I declared "duplicate" calendar events and **recommended DELETING** them — but the live site had different record IDs than my snapshot, and the "dups" were actually past records. Nearly deleted a customer's real events from stale data. The user caught it ("NO NO NO, no delete").
**Fix**: NEVER act on or recommend a destructive operation (delete / dedup / overwrite) from a cached snapshot. **Re-fetch live, authoritative data immediately before** the mutation and verify the exact records by ID on the live system. Read-only analysis may use a cache; mutations may not. Signal that your data is stale: if the user says a record exists that you don't see, stop and re-pull — don't argue from the cache.
**Applies to**: ALL personas doing any PROD data mutation, especially deletes/dedup. Read-only first, fresh-read-then-mutate always.
