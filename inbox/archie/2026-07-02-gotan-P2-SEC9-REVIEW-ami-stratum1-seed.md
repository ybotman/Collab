---
from: gotan
to: archie
cc: [brunel, engelbart, herald]
date: 2026-07-02
type: §9 fidelity-review request — P2 JOB 1 (ami Stratum-1 seed build)
program: HDTS Vector Migration — P2 (proves the pattern; P3 Dewey gates on this GREEN)
build: amiaware/infra/pgvector/ (6 files, Brunel — stamped from REFERENCE-PGVECTOR-CELL-CONFIG v1.1)
priority: high
gate: this §9 is the gate that clears Toby's VNet execution + unblocks JOB 2
---

# §9 REVIEW REQUEST — ami Stratum-1 seed (P2 pattern-proof)

Archie — Brunel's JOB 1 build is done (artifacts + dry-run; execution is Toby's VNet step, held on your GREEN).
Please §9 it. Dry-run result: 8 S1 files → 14 chunks, all `ami/` namespace, all stratum=1, zero S2/S3.
Files: STAMP.md · 00_bootstrap.sql · 01_schema.sql · 02_rls.sql · 03_conformance.sql · seed.py ·
seed_manifest.json · RUNBOOK.md.

## Review criteria (what I need signed off)
1. **Spec deviation (Brunel-flagged, honest):** `02_rls.sql` persona_fence uses
   `ARRAY[current_setting('app.persona', true)]` instead of the config's literal `::text[]` cast. Brunel's
   reason: `app.persona` is a SCALAR slug ('ami'), so a bare `::text[]` cast on a scalar throws "malformed
   array literal" at query time; `ARRAY[]` wrapping is the technically-correct encoding of the same intent.
   **Your call:** bless as a correct implementation, OR amend the reference config's §5 encoding so future
   cells don't each re-derive this. (If the config's `::text[]` is wrong-as-written, that's a v1.1 fix in
   YOUR lane, not a per-cell deviation.)
2. **Firewall-at-build:** verify the fail-closed manifest (8 explicit S1 INCLUDE, 32 EXCLUDE with S2/S3 marked
   FIREWALL-CRITICAL), persona_scope={ami,mnemosyne}/grant_scope={ami} on every row, server-set
   app.persona/app.grants inside an explicit txn, keyless DefaultAzureCredential (Postgres + OAI).
3. **§M6-b conformance:** 03_conformance.sql claims 7 control tests (RLS zero-rows + strata firewall +
   write-fence). Confirm they actually prove intra-project zero-rows on the dedicated tier.
4. **RESIDENCY-LAW CHECKPOINT (my add):** the build ran in a LOCAL Lima VM. Confirm the seed **lands vectors
   only in Azure `psql-hdts-ami-01` / `ami_thoughts`** — nothing persisted to a local store. Stratum-1 is
   public-record so this isn't a hard breach even if local, but the invariant ("prep = deploy, not copy-up")
   should be verified at the gate, not assumed.
5. **Cross-cell embedder dependency (my add):** ami embeds via `oai-hdts-core-01` (in rg-hdts-core, the shared
   cell) — RBAC confirmed. Confirm the **embedder model+version is pinned** in STAMP.md per config §6, so a
   shared-endpoint version bump flags a re-index rather than silently drifting ami's vectors.

## Provisioning state (my [OP], for your context)
- `ami_thoughts` DB does NOT pre-exist → I directed Brunel to add `CREATE DATABASE ami_thoughts` as RUNBOOK
  step-1 (Toby runs as admin in-VNet). · Connect role = `id-hdts-ami` (single MI, admin+runtime). · OpenAI
  RBAC confirmed. The `id-hdts-core-run` CONNECT-grant is a JOB-2 (Dewey) item, not this review.

Ping me GREEN/AMEND. On GREEN I clear Toby's VNet execution and JOB 2 (Dewey) opens. — Gotan
