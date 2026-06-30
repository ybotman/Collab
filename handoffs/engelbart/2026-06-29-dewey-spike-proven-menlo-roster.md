---
date: 2026-06-29
from: engelbart
to: engelbart-next-self
type: shoff-git
state: open
tags: [dewey, embedding-spike, adr-0027, rag, pinecone, vectorize-gate, menlo-roster, egress-gate, operationalization]
priority: RESTART-POINT
---

# Engelbart SHOFF2 — 2026-06-29 (Dewey embedding spike PROVEN + Menlo roster home)

## One-line state
Stood up minimal Dewey (the renamed Mercator, vector/RAG black-box) and ran the ADR-0027 embedding spike end-to-end against live infra — BOTH success criteria GREEN. Also created the Menlo canonical roster home (Gotan's blocked dependency, now unblocked + cross-ref'd). Toby first-hand approved the Pinecone egress; I held the gate (relay ≠ consent).

## DONE this session (with paths)
- **Menlo roster home** — `~/MyDocs/Studio/CHILDREN.md` (mirrors Clients/BHS/CHILDREN.md; Edison-owned, Engelbart-authored). 6 personas w/ verified ports/models. Gotan registered the ONE cross-ref row in the HDTS Children table (CLAUDE.md line 60) + can now sync personas.json off it.
- **Minimal Dewey persona** — `~/.claude/personas/dewey.md`. Black-box, internal-only, vector/RAG, ENFORCER-not-author, owns the vectorize-selection gate. Spike-scope (full do-not-RAG gate / tier-promotion / scheduling NOT built).
- **Dewey spike code (BEAF-shaped, carry-forward)** — `~/MyDocs/AppDev/dewey/`:
  - `config.py` (the single live-infra seam + the keyless-MI config flip), `selection_gate.py` (VECTORIZATION-POLICY enforcement, fail-closed), `dewey_spike.py` (blob→gate→chunk→embed→upsert→retrieve+filter), `function_app.py` + `host.json` (Azure Functions deploy seam, NOT deployed), `requirements.txt`, `README.md`.
  - venv at `.venv/` (gitignored).
- **Spike RESULTS — both SPIKE-SPEC §4 criteria GREEN:**
  1. Retrieval works: "HITM gate rule"→WAVE-0-GATE-SPEC §1.2 #1@0.558; "saga-put atomicity"→ADR-0026 §4a Dec-5 #1@0.572; "co-custody #9"→SYNTHESIS §2 invariants #1@0.462. All anchors resolve to blob.
  2. Filter holds: forced visibility:client-shared → 0 matches. Security gate holds at the VECTOR layer.
  - Gate did real work: 18 admitted / 1 REJECTED (AZURE-TENANT-OF-RECORD = infra-record/locations layer → live-lookup per policy). Fail-closed proven.
- **Live infra now exists:** Pinecone index `hdts-knowledge` (cosine/3072, aws/us-east-1), namespace `hdts-internal`, **196 vectors** from the 18 admitted dogfood docs.

## KEY EPISODE (the why, for next-self)
- **Egress gate, held correctly.** The auto-mode classifier blocked the live run as external data-publish (HDTS-internal corpus → Pinecone SaaS). Gotan had relayed Toby's authorization, but per `feedback_relay_not_firsthand_consent` I did NOT treat the relay as consent for an external send. Surfaced to Toby in MY user channel via AskUserQuestion; he first-hand approved (store-text variant). THEN ran. The plan was ratified (ADR-0027 chose Pinecone) — but external egress still re-gates to the real human, and he's reachable here.
- **Selection-gate calibration:** first pass over-rejected (exact-first-token match + a too-broad 'ledger' path signal nuked SECURITY-ARCHITECTURE/SYNTHESIS, which hold the #9 + saga concepts the success queries probe). Fixed to substring-keyword admit + path-anchored volatile rejects. Lesson: a fail-closed gate must distinguish *the live volatile artifact* (reject) from *doctrine ABOUT it* (admit).

## OPEN / armed triggers
1. **Archie finalizes the ADR-0027 embedder** — sent him the recall judgment (text-embedding-3-large adequate). He may want a -small/1536 A/B in a second namespace (I offered). Awaiting his §6 call.
2. **Gotan confirms 2 judgment calls** — index name `hdts-knowledge` (spec left it open; namespace=hdts-internal per spec) + the keyless-MI hardening handoff to Archie.
3. **Full Dewey (post-spike)** — full do-not-RAG rule set, never-promote enforcement, DOC-tier promotion stays HERALD (Gotan ruling), scheduling. Folds in after Archie finalizes. NOT yet scoped to build.
4. **Carried from prior SHOFFs:** BHS rename (fred-bhs→charlotte-bhs + sam-bhs→cadence-bhs — staged, ~189 files non-git, needs Clifton/Rupert + backup); run-the-restart (Toby); persona-watch persistent-run decision (Toby); Atlassian MCP cutover (30 June); marshal-bhs watcher-vs-gate reconcile (unparkable now).

## Context for next-self
- Report to Gotan; Toby = HITM (reachable in my user channel — it IS a first-hand consent channel; matters for egress/irreversible gates).
- House style: NO em-dashes.
- I am transient per-Guild; durable = the code + persona + docs + the live index, not my head.

— Engelbart, 2026-06-29
