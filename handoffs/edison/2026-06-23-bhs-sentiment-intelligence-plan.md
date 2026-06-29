---
from: edison
type: proposal / plan-action
for: rupert (BHS lead) — routed via Toby
date: 2026-06-23
status: draft — contingent on pilot (deep-research run wf_7ebbae14-be9) landing
---

# BHS Sentiment Intelligence — a standing capability (plan)

**Ask (Toby, 2026-06-23):** productize the one-off BHS sentiment pilot into an ongoing capability —
**week-over-week trend tracking**, theme/concern extraction ("what are people thinking and worried about"),
plus **social/content + marketing-reception reports.**

**Contingency:** gated on the pilot proving the signal is real and useful (the deep-research run now in flight).

## The synergy worth naming
This is architecturally the **same machine as amiaware**: a *scheduled research loop → append-only snapshots →
trend diff → emailed report*, governed by *data-is-free / cognition-is-metered*. Build one well and the other is
mostly configuration. Strong reuse case.

## Access tiers (Toby: "we can get logins if needed" — folded in)
| tier | source | legit? |
|---|---|---|
| **Anonymous public web** | press, public Reddit/forums/YouTube, BHS public pages | ✅ free, build now |
| **First-party owned-channel analytics** | BHS's own FB Page Insights, YouTube Studio, email metrics (admin login) | ✅✅ **best value** — real quantitative engagement/reach on their own content |
| **Authenticated official APIs** | Reddit OAuth, Meta Graph (owned/admin), X API tier | ✅ broadens reach legitimately; some cost |
| **Member-gated groups/forums** | private FB groups, member forums (member login) | ✅ human-assisted or BHS-sanctioned pull |
| **Bot-past-CAPTCHA scraping** | impersonating a human to defeat anti-bot controls | ❌ **the line — never** |

Logins push much of the paid-tool value into the free/authorized tier — *especially* for BHS's own channels.

## Architecture
1. **Scheduler** — weekly cron (Cloudflare Worker cron / scheduled cloud agent). Same heartbeat primitive as amiaware.
2. **Weekly sweep** — the deep-research harness, scoped to "this week," run across a **fixed topic taxonomy** (so weeks are comparable) + the authenticated/first-party sources above.
3. **Storage** — append-only weekly snapshots in D1 (per-topic sentiment score + themes + representative quotes + sources + first-party engagement metrics). Trend = query across snapshots.
4. **Trend / diff engine** — week N vs N-1…N-k → per-topic trajectory, new/rising/fading themes, spike detection.
5. **Reports** — synthesized weekly report (markdown → PDF), emailed to Rupert + Toby; optional dashboard on **bhsDash** (AppId 22).
6. **Alerting** — sentiment spike / new controversy → flag immediately, don't wait for the weekly.
7. **Budget** — ~1 harness run/week is cheap; first-party analytics are free. Metered key with a cap, same as amiaware.

## Topic taxonomy (the comparable week-over-week dimensions — Rupert tunes)
Membership/recovery · **HFI/BHS realignment** (the live one) · dues/cost · leadership/governance ·
DEI/inclusion/history · events/conventions · **marketing & content reception** (how BHS's own campaigns land) ·
adjacent/competitive orgs (mixed barbershop, Sweet Adelines, etc.).

## Phases
- **Phase 0 — Pilot (now):** the one-off deep-research run. Validate the signal is real.
- **Phase 1 — Manual weekly:** run the harness weekly + hand-deliver the report. Proves cadence + taxonomy. Near-zero build.
- **Phase 2 — Automated pipeline:** cron + storage + trend-diff + auto-email + dashboard. **Franklin** builds; **Engelbart** substrate.
- **Phase 3 (optional) — first-party + authenticated integrations:** wire BHS's owned-channel analytics + sanctioned APIs for quantitative depth. Needs the logins.
- **Phase 4 (optional) — paid social listening:** Brandwatch/Meltwater-class for cross-platform firehose/share-of-voice. $ gate; only if Tier-1+3 leaves a real gap.

## Ownership / routing
- **Rupert** owns the deliverable, the taxonomy, and the interpretation (BHS lead).
- **Engelbart / Franklin** build the pipeline (substrate / infra).
- **Edison** shaped this; can prototype Phase 1 in Menlo, then graduate to the BHS Guild.
- Gate via Rupert / bhs-planner.
