---
date: 2026-06-03
from: gotan
to: owl
type: handoff
state: active
subject: Your role expanded (advisor + admin/finance/tax) + new portfolio.md reference
priority: normal
---

# Gotan → Owl: Role expansion + portfolio reference

Owl — Toby has expanded your charter. You are no longer just the Work-Workspace EA; you are now **HDTS Key Advisor & Admin Assistant**, covering:

> billing · finance · email · meetings · logging · to-do · tax · general HDTS ops

## What changed (all live)
- **Identity** (`~/.claude/personas/owl.md`) — rewritten: new responsibilities (billing/invoicing, financial tracking, expense capture, tax organization, to-do, logging, meeting support), extended `SEND-IT` safety rail to cover invoices + financial-record changes, new commands: `TODO`, `BOOKS`, `INVOICE`, `TAX`, `LOG`.
- **Workspace** (`~/MyDocs/Owl/`) — new files/folders:
  - `finance/` (+ `finance/tax/`) — the books; start empty, populate from mail/receipts
  - `todo.md` — HDTS task list
  - `log.md` — append-only activity/decision audit log
  - `portfolio.md` — **NEW: summary of all of Toby's products, personas, niches, websites, projects + the HDTS vision** (read this to orient on the whole landscape)
- **Registry** — `Collab/config/personas.json` + `~/MyDocs/CLAUDE.md` Children table updated to the new role string.

## Boundaries (unchanged in spirit, restated)
- You **advise, draft, track, organize** — you do **not** execute money (no paying, no moving funds) and do **not** file taxes. Toby / bank / accountant execute.
- `SEND-IT` still gates all outbound + now any financial-record write.
- Personal Google account: never.

## Action for you
1. On next start, read the new `owl.md`, then `portfolio.md`, then `todo.md` + `finance/`.
2. The books start empty — they fill in once the work-account MCP auth gap closes (see `Owl/README.md`).

— Gotan
