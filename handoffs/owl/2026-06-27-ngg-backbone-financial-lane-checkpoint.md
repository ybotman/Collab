---
from: owl
to: owl (self-handoff) · cc gotan
date: 2026-06-27
subject: NGG backbone session — financial/commercial lane checkpoint (clean SHOFF before Wave-4 ledger supersede)
session: NGG NextGenGuild backbone synthesis + build-prep
status: financial lane DONE-pending-Toby's-batched-inputs · design concurred 8/10 · at ratify line
---

# Owl Self-Handoff — NGG Backbone Financial Lane (2026-06-27)

## TL;DR
Built the entire **commercial face** of the NGG backbone this session — billability, spend-gate, vendor ledger,
COGS — all Gotan-concurred. Design is at Toby's ratify line; everything left in my lane is **Toby-gated inputs**
(parked, none MVP-blocking) plus **one build fast-follow** (duration primitive) routed to Herald.

## Deliverables this session (what landed, where on disk)
All in `~/MyDocs/Owl/finance/`. All "recommends, does not ratify."

1. **`bhs-fixed-tier-cogs.md`** — BHS fixed-maintenance tier COGS/pricing sheet.
   - Non-labor COGS LOCKED: ~$9/client/mo at N=12 (Firebase ~$2 + Anthropic ~$5 + Pinecone ~$2). Rounding error vs ~$2k tier.
   - **D-SYNTH-1 settled:** Pinecone (not Firestore-vector) per D3 no-Google principle. ~$25/mo project floor → ~$2/client at N=12 (shared project, namespace-per-client). Gotan adopted the rec.
   - **PHI-tier delta banked** (future tier, NOT BHS MVP): ~$190/mo+ Pinecone BAA floor, Anthropic BAA (first-party+30-day+no-ZDR, Toby pending), Azure BAA no floor, Firebase no-PHI = the no-Google HIPAA win.
   - Price = LABOR + MARGIN; pending Toby's 3 facts.

2. **`billability-spec-v0.1.md`** — fills req-5 commercial slots in Herald's Ledger Event Schema.
   - us-vs-client classification policy; `billability` enum 3→4 (added `client-covered`); mode-on-contract_ref not event; 4-pass invoice-derivation query over the append-only ledger.
   - **Duration gap flagged** → Gotan ruled option (b): SIF (write-side) start + completion event = bracket, duration derived. Routed to Herald to wire into schema.
   - Concurrence: gotan ✅. Open→Toby: first-client-paradox ruling (50/50 → us-internal default).

3. **`spend-approval-thresholds-v0.1.md`** — fills Provisioning Runbook §E.
   - 3-tier ladder: AUTO(<$50) / NOTIFY($50–200) / GATE(≥$200 OR new-vendor-any-$ OR payout-change OR ceiling-breach). Metered API on monthly-cap + 80%-alert. New-vendor + payout-change NEVER descend.
   - Concurrence: gotan ✅.

4. **`vendor-ledger.md`** — dual-purpose: COGS overhead line + §E approved-vendor/ceiling basis.
   - Scaffolded known vendors; figures EST/unconfirmed pending work-mail scan. Known fixed run-rate EST ~$32–40/mo before per-client infra + metered API.

5. **Design rating** (commercial lane): **8/10**. Biggest concern = duration primitive (hourly invoice can't derive until it's on disk; BHS baseline is hourly). Confidence-to-ratify the spine = 8.

Logged in `~/MyDocs/Owl/log.md`; `todo.md` updated (5 shipped, 4 Toby-gated consolidated).

## Open / parked items + routing
- **→ Toby (batched, none MVP-blocking):**
  1. **Work-mail-scan auth** — THE big unblock: converts every EST vendor figure → cited-real; finalizes COGS overhead line + §E run-rate ceiling.
  2. **Pricing 3 facts** — loaded hourly rate · steady-state support hrs/client/mo · target margin %.
  3. **Spend dials** — run-rate ceiling · Anthropic API monthly cap · ratify §2 $ tiers.
  4. **First-client-paradox ruling** — confirm 50/50 → us-internal default.
- **→ Herald:** wire the duration primitive (SIF start/stop bracket) into the Ledger schema; accept `client-covered` enum. *(Gates a real HOURLY invoice — my lane's core deliverable.)*
- **→ Rupert (when active):** `contract_ref` vocabulary — BHS hourly id + proposed fixed-tier id, each resolving to {client, mode, rate, fixed_fee, in-scope def, remit-to}. I recommended a minimal placeholder resolver so billing isn't blocked while he's dark.
- **Pre-existing BHS billing (Erik Dove meeting):** vendor setup on Great Plains (Toby sends W9+bank, Nick sends form — TRACK) · invoice path to finance@barbershop.org · ACH when new BHS controller enables (~3mo).

## NEXT step when work resumes
1. If Toby ratifies + gives the batch → finalize the **BHS pricing one-pager** (plug 3 facts into COGS sheet) + set the §E ceiling/API cap.
2. If mail-scan authorized → replace all EST vendor figures with cited-real, finalize run-rate.
3. Watch for Herald's duration-wiring + Rupert's contract_ref so the hourly-invoice query becomes buildable end-to-end.
4. Standing: hub poll-watch (~4.5m ticks); BHS EL revision still BLOCKING Robert's signature (pre-existing).

## Note
Per Herald's docs-map, SHOFF is what the Ledger supersedes at Wave-4 — this is among the last file-handoffs before
events take over. Checkpoint is clean.
