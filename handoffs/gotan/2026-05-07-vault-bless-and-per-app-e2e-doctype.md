---
date: 2026-05-07
persona: gotan
type: decision
state: active
feature: sprint-4-vault-and-doc-discipline
keywords: [vault-gate, symlinks, ghost-namespace, per-app-e2e-doctype, sprint-4]
appid: global
niche: global
audience: herald, archie, quinn, number2, toby
permanence: long-term
tags: [type/decision, app/global, scope/vault, scope/docs-system]
predecessor_to: []
successor_to:
  - [[2026-05-07-sprint4-vault-audit-and-adr-drift]]
  - [[HDTS-TEAM-OPERATIONS-AUDIT-2026-05-07]]
---

# Gotan vault-gate + per-app E2E doc-type bless (Sprint 4)

**Inputs:**
- Herald SHOFF `2026-05-07-sprint4-vault-audit-and-adr-drift.md` (vault audit + 17-change proposal)
- Number2 channel push 16:49Z (3 cross-app asks)
- Sarah TT E2E reference v0.2 (`tangotiempo.com/docs/E2E-TESTING-REFERENCE.md`, PR #355)
- Audit deliverable `_LIBRARIAN/HDTS-TEAM-OPERATIONS-AUDIT-2026-05-07.md`

**Authority:** vault-gate (this file authorizes the changes; Herald has labor).

---

## A. Vault changes — AUTHORIZED (16 of Herald's 17)

**Authorized for Herald execution this sprint.** Verified against actual vault state at 16:51Z.

### A.1 Adds (6 — all active personas)

| New mount | Target | Persona |
|---|---|---|
| `_GHOST_ARCHIE_DOCS` | `~/MyDocs/Archie/docs/` | Archie ⭐ priority — ADR-0011 cross-persona doc-index depends |
| `_GHOST_GOTAN_DOCS` | `~/MyDocs/Gotan/docs/` | Gotan |
| `_GHOST_AIDI_DOCS` | `MasterCalendar/ai-discovered/docs/` | AIDI |
| `_GHOST_BOOKER_DOCS` | `MasterCalendar/ai-discovered/booker/docs/` | Booker |
| `_GHOST_HARVEY_DOCS` | `MasterCalendar/ai-discovered/harvester/docs/` | Harvey |
| `_GHOST_PORTER_DOCS` | `MasterCalendar/ai-discovered/outreach/docs/` | Porter |

### A.2 Drops (3 — duplicates)

`Links/MC-docs`, `Links/MH-docs`, `Links/NH-docs` — confirmed duplicates of `_GHOST_MC_DOCS` / `_GHOST_HUB_DOCS` / `_GHOST_NH_DOCS`. Safe to remove.

### A.3 Renames (7 — namespace canonicalization)

| Existing | New |
|---|---|
| `Links/MC-CALOPS-docs` | `_GHOST_CALOPS_DOCS` |
| `Links/MH-AF-docs` | `_GHOST_HUB_AF_DOCS` |
| `Links/HDTS-docs` | `_GHOST_HDTS_DOCS` |
| `Links/JT-research` | `_GHOST_JT_DOCS` |
| `Links/YBOT-docs` | `_GHOST_YBOT_DOCS` |
| `Links/GUILD-docs` | `_GHOST_GUILD_DOCS` |
| `Links/GLOBAL-docs` | `_GHOST_GLOBAL_DOCS` |

After execution: `Links/` directory should be empty — remove the directory itself for cleanliness.

### A.4 Deferred (1 — `_GHOST_CAMPAIGNS_DOCS`)

`MasterCalendar/calendar-campaigns/docs/` has no persona owner. **Don't mount unowned project docs** — adds vault noise without serving a search-target audience. Re-authorize when a persona claims the project.

### A.5 SOP rule codified (resolves Herald's "no consistent rule" finding)

**`_GHOST_<NAME>_DOCS` is the single namespace for vault-mounted project docs going forward.** No `Links/*` namespace. Naming: `_GHOST_<APP-OR-PERSONA>_DOCS`, uppercase, hyphen-allowed, suffix `_DOCS` mandatory.

This is the **vault-presence canon** for Archie's ADR-0011 to fold against. Herald codifies as Librarian standing rule per her FTPNTD §3.

**Execution authorized — Herald, proceed.** Verify post-execution: 16 `_GHOST_*` mounts at vault root, zero `Links/`, no broken targets. Report back via SHOFF2 when complete.

---

## B. Per-app E2E-TESTING-REFERENCE doc-type — TEMPLATE BLESSED

**Context:** Toby ratified per-app E2E reference doc-type ~16:23Z. Sarah's TT v0.2 is exemplar (`tangotiempo.com/docs/E2E-TESTING-REFERENCE.md`, 754 lines). Asks me to bless the cross-app pattern *before* Cord/Compás/Dash come back online and need to commission their versions.

**Bless: Sarah's structure is canonical. Two adaptations published below.**

### B.1 FE template (Cord/HJ, Compás/NTTT, Dash/CalOps, future TT-pattern frontends)

**Mandatory sections (universal — must appear in all FE E2E references):**

| § | Title | Why mandatory |
|---|---|---|
| **§0** | Selector Quick Reference | Gauge's 30-second scan-before-author entry point. §0.1 traps + §0.2 cheat-sheet by surface + §0.3 test-pattern note (if app has Pattern A/B). FORMAT-LOCKED. |
| **§1** | Glossary | Terminology + role/role-code map; per-app values |
| **§2** | Role Taxonomy | canonical names + codes + display map + role-bundling invariants + sidecar info structures + role-aware UI surfaces |
| **§3** | Navigation Flow | cold-nav entry + critical modal-open paths + nav surface selectors |
| **§4** | Authentication Forms | signup/login form structure + validation order + side-effects + bootstrap path |
| **§5–§10** | App-specific modal sections | one section per significant modal/form Gauge will exercise |
| **§11** | Modal Taxonomy Reference | `data-testid` lookup table; FORMAT-LOCKED |
| **§12** | Auto-Seed Behaviors + Race Conditions | per-field; mandatory if app has any auto-seed; FORMAT-LOCKED |
| **§13** | AuthContext Bootstrap & Self-Heal | per-app; if app shares TT's AuthContext code, cite-by-reference |
| **§14** | API Endpoints Used by FE | endpoint table; per-app |
| **§15** | Test-Mutator Endpoints (Companion) | shared in calendar ecosystem — cite-by-reference to `calendar-be-af-test-mutators/` |
| **§16** | Common UC Patterns | Pattern A / Pattern B setup + cleanup + helper recipes |
| **§17** | Memories + Cross-Session Knowledge | persona-side persistent memories list |
| **§18** | Living-Doc Protocol | when-to-update + owner + versioning + discovery protocol; **§18.1 FTPNTD self-application** with standing maintenance rule MANDATORY (any selector/form/modal-touching PR updates §0+§11 in same commit) |
| **§19** | Change Log | version + date + author + scope |

**Optional (only if applicable):**
- §0.3 Pattern A vs B note — only for apps with a test-partition pattern (calendar ecosystem; not generic apps)
- §13 — drop if app does not have an AuthContext or equivalent; replace with a 1-line cite-by-reference to TT-shared code

### B.2 BE/API template (Fulton/calendar-be-af, future API services)

**FE selector sections do not apply.** Re-skin:

| § | Title | Adaptation |
|---|---|---|
| **§0** | Endpoint Quick Reference | replaces "Selector Quick Reference"; §0.1 contract traps (e.g., field rename FE↔BE, FE-stricter overlay), §0.2 endpoint cheat-sheet by resource, §0.3 partition/marker note if test infrastructure has one |
| §1 | Glossary | same |
| §2 | Resource/Role Model | replaces "Role Taxonomy"; data model + permission gates |
| **— skip §3–§10** | (no UI surfaces) | |
| §4 | Auth header conventions | replaces "Authentication Forms"; Bearer token shape, refresh, scopes |
| **§11** | Endpoint Taxonomy | replaces "Modal Taxonomy"; canonical endpoint inventory by resource |
| **§12** | Stateful Side-Effects + Race Conditions | replaces "Auto-Seed Behaviors"; same intent — what fires after a write, what races against what reader |
| §13 | Bootstrap & Self-Heal | per-service if applicable |
| §14 | (omit — covered by §11) | |
| §15 | Test-Mutator Endpoints | this IS the §15 owner for the ecosystem; canonical here, cited from FE refs |
| §16 | Common UC Patterns | from BE perspective: how a UC's test-mutator calls compose |
| §17–§19 | Memories / Living-Doc / Change Log | same as FE template |

### B.3 Authoring rules (apply to both templates)

1. **Cite path:line for every selector/endpoint claim.** Sarah's pattern (e.g., `MapCenterModal.js:829`). Stale citations are auto-detected on file-rename.
2. **§18.1 FTPNTD self-application is mandatory.** No exceptions. Reviewer enforces in PR review.
3. **Owner is the app persona** (Sarah owns TT, Cord owns HJ, Compás owns NTTT, Dash owns CalOps, Fulton owns calendar-be-af).
4. **Quinn is mirror/relay** — if the e2e-calendar-framework needs a copy, Quinn pulls; persona authors do not push.
5. **Versioning:** semantic-ish — minor bump for new sections, patch for value updates. Track in §19.

### B.4 Rollout sequencing (recommended order; non-blocking)

1. **Cord (HJ)** — closest to TT in shape (sister frontend, shared backend). Use Sarah's doc as direct fork; swap appId, swap role taxonomy (HJ has Chorus/Quartet/Coaches/Judge in place of TT's RO/SL surface), keep §0 template, swap selectors.
2. **Compás (NTTT)** — separate calendar shape; verify whether TT auth/role pattern reuses or diverges before forking.
3. **Dash (CalOps)** — admin frontend shape; may need entirely different §3-§10 (no end-user calendar; admin lists/forms instead).
4. **Fulton (calendar-be-af)** — adopts B.2 BE/API template. Some §15 ownership consolidates here.

When each persona comes online, they receive: this bless + Sarah's doc + the template mapping above. No re-litigation needed; commission directly.

### B.5 Open-flag for Quinn (charter §DoR addition)

Quinn is folding "vault-presence DoR rule" into Charter v5 (per Herald motion ¶b code-process layer). Suggest one paired addition:

> **§DoR — every app under E2E test coverage must have `{app}/docs/E2E-TESTING-REFERENCE.md` per the Gotan-blessed FE or BE/API template (2026-05-07).** Vault-presence (`_GHOST_<APP>_DOCS` mount) is a sub-condition.

Quinn — your call on §DoR exact wording; this is the substance.

---

## C. Framework-as-product reframe — ACKNOWLEDGED

Number2's Ask 3 is awareness-only; no action from me this turn.

**Implication for my registry:** as the per-app E2E doc-type pattern propagates from MasterCalendar to other appIds in my Children table (Tangology/Blitz/Dental Navigator/HDTS/etc. when they hit E2E coverage), the FE/BE template above is the cross-HDTS standard. Will fold into HDTS-SharedInfra-Plan.md when an out-of-MasterCalendar app first commissions its E2E reference.

**Standing rule:** any new app entering my Children table that ships E2E coverage must commission `{app}/docs/E2E-TESTING-REFERENCE.md` per B.1 or B.2 before its first UC GREEN.

---

## Signaled this turn

| To | Why |
|---|---|
| **Herald** | Vault changes A.1–A.5 authorized. Execute. Report back when 16 mounts + 0 `Links/` confirmed. Codify SOP §A.5 as standing Librarian rule. |
| **Archie** | ADR-0011 (cross-persona doc-index) — your DoR pre-condition (vault-presence canon) is now blessed; namespace = `_GHOST_<NAME>_DOCS`. Per-app E2E-TESTING-REFERENCE doc-type is a registered type per §B; fold §B.1/§B.2 templates into HDTS-DOCS-STANDARD v1. |
| **Quinn** | Charter v5 §DoR — suggested wording in §B.5; bless or refine. Per-app E2E doc-type is a Quinn-relay artifact (you mirror to e2e-calendar-framework as Sarah's §18 protocol notes). |
| **Number2** | 3 asks closed: Ask 1 authorized minus campaigns deferral; Ask 2 blessed + template published; Ask 3 acknowledged. Reply via hub. |
| **Sarah** | (FYI) your TT v0.2 is canonical. Maintenance rule §18.1 is now standard for all apps; not just TT. |
| **Toby** | DAG-anchor surface via Number2: vault-namespace canonicalized + per-app E2E doc-type template blessed. Sprint 4 doc-discipline track unblocked. |

---

— Gotan
2026-05-07T16:51Z
