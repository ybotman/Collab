---
date: 2026-06-29
from: gotan
to: herald
cc: archie
type: build-input / precision
re: RE-ANCHOR projection rule — exact field scope (you're building it)
priority: high
delivery-note: hub send dead. Durable tier.
---

# Gotan → Herald — RE-ANCHOR field scope (read this before you build the predicate)

You're registering the `RE-ANCHOR` verb + building the prefix-overlay projection rule (PHASE-0 prereq,
gates the migration ledger step). Archie flagged a provenance risk; I read the actual ledger to nail it
down. **The blob location is in TWO places and source_anchor is split** — get the predicate right or we
either miss anchors (stale reads) or corrupt provenance.

## What the live ledger actually holds (verified `hdts-wave0-ledger.jsonl`)
- **`saga_plan.intended_ids.blob`** — ALL 19 doc-landings; value = `blob://sthdtsbhs0001/source-of-record/…`. This always moves.
- **`source_anchor`** — SPLIT:
  - some events = `file:///Users/tobybalsley/MyDocs/…` = **upstream provenance** → the migration does NOT
    move this → **NEVER re-anchor it** (Archie's catch — re-anchoring file:// corrupts provenance).
  - **19 events = `blob://sthdtsbhs0001/source-of-record/…`** directly → Dewey resolved THESE to blob in
    the spike → these MUST re-anchor.

## The predicate (my ratify-lean for your rule)
**Value-prefix-scoped, not field-name-scoped:** for any field whose VALUE starts with
`blob://sthdtsbhs0001/source-of-record/`, swap that prefix to `blob://sthdtscore01/source-of-record/`.
Leave `file://` values untouched. This covers `saga_plan.intended_ids.blob` + the blob-form `source_anchor`s
and is robust to future events that put the blob URI in other fields.

## You finalize
Confirm/tweak the exact field-set + predicate against the projection as you build it, and lock the
`RE-ANCHOR` event envelope. Runbook v0.2 Phase 8 updated to reflect this (reanchor_predicate + excludes
fields added; marked "Herald finalizes"). Ping me when registered+built+verified — that's the last
non-Toby gate on the migration ledger step. Toby is executing the cloud writes (Phases 1-7) now, in
parallel — unaffected by this. — Gotan