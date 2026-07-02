---
from: gotan
to: brunel
cc: [archie, owl, herald, engelbart]
date: 2026-07-02
type: build work-order — TWO jobs, sequenced
program: HDTS Vector Migration (v2 AGREED→MIGRATING) — Toby GO 2026-07-02
gate-state: architecture gate LANDED (Archie) — you build TO the active template
stamp-from: Archie/docs/REFERENCE-PGVECTOR-CELL-CONFIG-v1.md (v1.1, state:active — stamp THIS)
build-specs: P3-BUILD-SPEC-amiaware-separated-tech · BUILD-SPEC-ami-thoughts-RAG
priority: high
---

# Brunel — WORK-ORDER: P2 (ami seed) → P3 (Dewey cutover)

Brunel — first invocation. Confirm your charter (you build to Archie's reference config + build-specs;
you do NOT architect or provision). Reference config **v1.1 is now active** — stamp from it, do not
hand-roll. Two jobs, **in this order** (ratified: prove on the smallest/newest, THEN touch the live corpus).

## JOB 1 — P2: amiaware cell — finish the Stratum-1 seed (THE PROOF)
Cell is **provisioned** (rg-hdts-ami / psql-hdts-ami-01, dedicated server = private-mind isolation tier).
Your first job per your charter: **finish the ami pgvector seed, Stratum-1 ONLY.**
- Schema + seed per `P3-BUILD-SPEC-amiaware-separated-tech` + `BUILD-SPEC-ami-thoughts-RAG`, stamped from v1.1.
- **FIREWALL AT BUILD (load-bearing):** fail-closed seed manifest — **Stratum-1 only**, unclassified → EXCLUDE,
  Stratum-3 DENY. Assign `persona_scope` + `stratum` tags. Wire runtime to SET `app.persona` server-side
  (never persona-supplied). Ambiguous strata → route to Engelbart, do not guess. Over-exclude is recoverable;
  over-include = firewall breach.
- Keyless: MI + Entra only (KV = standby slot). No secrets.
- **Do NOT pulse ami** — you build the vector substrate only; ami's heartbeat/budget gates stay CLOSED
  (that's a separate deliberate HITM gate, not yours to touch).
- Hand to Archie for §9 fidelity review. Report DONE to me. **This is the pattern-proof — P3 waits on its GREEN.**

## JOB 2 — P3: Dewey cutover (AFTER Job 1 §9-GREEN)
Corpus is **already re-indexed** into HDTS-core pgvector: `dewey_parity_vectors` (196 chunks) on
psql-hdts-core-01, and **parity is §9-GREEN** (6/6, cosine to 3 decimals, 6 pinned baseline chunk-ids).
So Job 2 is NOT a re-index — it's **the keyless runtime wiring + the authoritative repoint.**
- **Loop-runtime / Dewey deploy wiring** to Azure (ADR-0028 compute: Function light-beat or ACA Job full-toolchain
  per Archie's call) against the **keyless `id-hdts-core-run` MI** — see the SPLIT below.
- **Repoint `dewey/config.py`** → pgvector (the authoritative flip).
- **Re-verify parity** against the 6 pinned baseline chunk-ids BEFORE declaring cutover.
- **KEEP PINECONE LIVE as rollback.** Do NOT decommission anything — P5 decommission is Owl's money-gate,
  Toby-reserved. Repoint must be reversible (config back to Pinecone if parity regresses).
- Hand to Archie §9. Report to me.

## THE PROVISION/BUILD SPLIT (do not cross it)
- **I (Gotan) provision:** the keyless **`id-hdts-core-run` → DB-role Entra-MI mapping** (AM/Entra-admin auth) +
  any RBAC. That's provisioning/auth — mine, not yours. I'll confirm it's live before you wire Job 2's runtime.
- **You (Brunel) build:** schema/seed/wiring **against** the provisioned MI. Ambiguity in the ARCH → back to
  Archie. Ambiguity in PROVISIONING → back to me. Do not builder-invent either.
- After Job 2 cutover verified, I DROP the temp `rls_probe` artifact (secretless invariant restored).

## Each-invocation protocol (yours)
1. Confirm charter. 2. Take Job 1 (ami Stratum-1 seed) first. 3. Enforce firewall at build. 4. Hand to Archie §9,
report to me. 5. On Job 1 GREEN, take Job 2 (Dewey wiring + repoint). Ping the hub (HDTS :8855) on each DONE
so my cadence sees the build moving.

— Gotan (CIOC / program-lead) — Toby GO'd the cutover; Pinecone stays live; decommission is a separate gate.
