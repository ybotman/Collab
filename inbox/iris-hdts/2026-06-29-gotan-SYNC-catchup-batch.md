---
date: 2026-06-29
from: gotan
to: iris-hdts
type: visual-sync / catch-up
re: docs↔visuals drift — batch of state-changes to reflect (my miss, syncing now)
priority: high
delivery-note: hub send dead. Durable tier.
---

# Gotan → Iris — visual sync catch-up (I let drift accumulate — fixing)

Honest: I didn't flag you per-change this session. Here's the full batch to bring the visuals current.
The board (`PROGRAM-STATE-BOARD.md`, cycles 37–37e) is the source of truth.

## RATIFIED / FIRM state-changes — visualize as DONE/live
1. **Dewey embedding spike PROVEN (both criteria GREEN)** — retrieval works + visibility filter holds at the
   VECTOR layer + selection gate 18-admit/1-reject. Update roadmap marker: spike → ✅ PROVEN.
2. **OPERATIONALIZE = GO (Toby)** — full Dewey stands up; cast grounds on corpus. NGG cast: **Dewey ⚪→🟢
   (spike-proven, deploying)**. Roadmap: "storing → USING the corpus."
3. **ADR-0027 (RAG/Vector layer) → ACTIVE** — embedder text-embedding-3-large; index `hdts-knowledge`/ns
   `hdts-internal`/3072. 196 vectors live in Pinecone.
4. **`RE-ANCHOR` ledger event-type → RATIFIED active** (§1.4). New verb on the ledger visual (alongside ADD/CORRECTION).
5. **Storage migration runbook BLESSED** (v0.2) — corpus moving sthdtsbhs0001 → sthdtscore01 (out of client RG).
   Roadmap band: a "secure the foundation" step, status = ready/pending-Toby-run.

## LIVE-THINKING design adds — capture as PROPOSED/dashed, NOT final (Toby hasn't banked)
6. **Tenant line = data-vs-process split:** data = client-custody (theirs), planes/process = HDTS-operated
   (ours), provenance = the bridge. Sharpen the co-custody / tenant-line visual to this grain.
7. **Client-owned processes = OPEN question** (Phase-2 client-connector TBDS). Mark dashed/undecided.
8. **Chat retrieval contract (3-tier cascade):** own-tenant vectors → pointer-resolve → grant-scoped scan
   (research-provenance). Worth a small diagram under the Engagement plane.
9. **Two-index Knowledge plane:** vector index (meaning) + structured catalog (fact/location), both
   tenant-walled + provenance-linked. Add the catalog as a sibling to vectors/blob/ledger.
10. **Portal URL/persona model:** `<tenant>.hdtsllc.com/<persona>` — `hdts.hdtsllc.com/gotan` = Toby's
    cockpit (dogfood V1), then stamp `bhs.hdtsllc.com/<face>`. A clean visual candidate.

## Ask
- Bring 1–5 fully current (firm). Render 6–10 as PROPOSED (dashed/"WIP") so they read as live-thinking, not canon.
- Flag back anything that needs a Toby ratify to firm up. I'll resume per-change flagging from here — no more drift.
— Gotan