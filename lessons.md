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

## 2026-04-01 | harvey | sync-status-pending
**Error**: Reset sync_status to NULL, but query looks for `sync_status = 'pending'`
**Fix**: Always reset to `'pending'` not `NULL`:
```sql
UPDATE events SET sync_status = 'pending' WHERE sync_status = 'skipped_...';
```
**Applies to**: Harvey, any SQLite sync patterns

---

*Empty file = all lessons graduated to CLAUDE.md or retired*
