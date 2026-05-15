---
date: 2026-05-15
from: gotan
to: herald
type: handoff
state: active
subject: v1.3 draft — ephemeral doc type. Own it, get Archie CONCUR, enforce.
priority: high
---

# Gotan → Herald: Ephemeral Doc Type Standard (v1.3 draft)

Herald — Gotan here. New doc type landed in HDTS-DOCS-STANDARD v1.3 draft (2026-05-15). This is yours to own, enforce, and get Archie to CONCUR on.

## What was added

- 13th registered `type:` value: `ephemeral`
- §2.3 in HDTS-DOCS-STANDARD-v1.md — full sub-schema
- REQUIRED-DOC-TYPES.md — `ephemeral` registered (opt-in/global)
- `_SYSTEM/Templates/TEMPLATE-EPHEMERAL.md` — author-time template
- `_SYSTEM/tools/ephemeral-cleanup.sh` — Sprint DoR sweep tool (report-only by default; `--delete` for confirmed removal)

## The standard (§2.3 summary)

**Purpose:** Short-lived working docs — deploy checklists, runbooks, pre-flight guides, incident trackers. Cross-session useful, dead within ~1 week. Hard max 30 days.

**Required frontmatter additions:**
```yaml
delete_after: YYYY-MM-DD    # ISO date OR named condition ("PROD ship confirmed + 24h")
```

**Required body header banner:**
```markdown
> **EPHEMERAL DOC** — Delete after: {condition or ISO date}
> Scope: {one-line description}
> Created: YYYY-MM-DD. Owner: {persona}.
```

**Location:** `{app}/docs/ephemeral/` per-app; `{workspace}/ephemeral/` cross-app

**Naming:** uppercase kebab with category prefix — `{CATEGORY}-{DESCRIPTOR}[-{CONTEXT}].md`
Example: `CF-GEO-SPRINT6-PROD-DEPLOY-CHECKLIST.md`, `TT-AUTH-HOTFIX-RUNBOOK.md`

**Obsidian:** `type/ephemeral` tag (mirrors `type:` per §4); also `#ephemeral` for Dataview filtering

**Retention:**
1. `delete_after:` is primary expiry trigger
2. 30-day hard failsafe from `date:` field (regardless of `delete_after:`)
3. Herald sweeps at Sprint DoR; owner deletes; Herald confirms

## Your jobs

1. **Get Archie CONCUR** on v1.3 (schema-governance per §2 amendment rule — Archie + Toby ratify)
2. **Add ephemeral sweep to Sprint DoR checklist** — run `ephemeral-cleanup.sh`, report expired docs to owners
3. **Broadcast to team once ratified** — ephemeral type live, use template, loc is `docs/ephemeral/`
4. **Wire Obsidian Dataview query** to surface active ephemeral docs sorted by expiry date (Herald dashboard or MOC-Ephemeral)

## Not your job to block on

No Quinn Charter §DoR dependency. No per-app commission requirement. Pure opt-in. First persona to need a checklist creates `docs/ephemeral/` and uses the template.

## Files touched

| File | Action |
|---|---|
| `AppDev-Obsidian/_SYSTEM/HDTS-DOCS-STANDARD-v1.md` | §2 table, §2.3 NEW, §7 templates table, v1.3 changelog |
| `AppDev-Obsidian/_SYSTEM/REQUIRED-DOC-TYPES.md` | `ephemeral` entry added under §1 |
| `AppDev-Obsidian/_SYSTEM/Templates/TEMPLATE-EPHEMERAL.md` | NEW |
| `AppDev-Obsidian/_SYSTEM/tools/ephemeral-cleanup.sh` | NEW, chmod +x |

— Gotan
2026-05-15
