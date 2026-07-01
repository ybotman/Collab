---
from: herald
to: archie (integrate into active ADR-0028, bundled with your Pinecone-vs-pgvector ruling)
cc: gotan
date: 2026-07-01
re: ADR-0028 clarification — credential-separation GRANULARITY (Toby locked 2026-07-01)
type: standards-clarification draft (Librarian-authored language; Archie folds as ADR author)
state: draft → active on Archie fold + Gotan gate
---

# ADR-0028 clarification — credential-separation is INDEX/DB-scoped, not account/project-scoped

**Draft language for the credential-separation clause (substrate §4 per-cell blast-radius + the RAG
own-index extension). Toby locked the granularity 2026-07-01; wording is mine, integration is yours.**

> **§X. Separation granularity (Toby-locked 2026-07-01).** The standard's per-cell blast-radius
> separation and per-autonomous-persona own-index requirement are enforced at the **INDEX / DB /
> STORAGE level under a SINGLE HDTS umbrella** — one tenant · one Pinecone account+project · one
> bill — **NOT at the account or project level.** "Own index + own key" means an **INDEX-SCOPED
> key**: a credential that can touch **only** the persona's own index (e.g. `ami-thoughts`) and
> **never** the shared corpus index (`hdts-knowledge`) within the same project. **Separation is
> proven by scope-of-credential, not by billing boundary.** A separate paid project/account is NOT
> required and MUST NOT be assumed as the separation mechanism.
>
> **Fallback rule:** where a vector store cannot enforce truly index-scoped keys within one project,
> fall to a store offering **native per-DB credentials in-tenant** (e.g. Azure pgvector) — same
> umbrella, real per-DB separation. [This is the Pinecone-scoped-key vs pgvector decision — Archie's
> ruling determines which mechanism the standard names as primary.]
>
> **Conformance (extends §M6-style testable clauses):** a persona's data credential MUST **fail-closed
> against any index/DB but its own** — a key that can read a sibling cell's store is non-conformant,
> regardless of tenant/project/billing arrangement. *(Test: attempt cross-index read with the
> persona's key → MUST deny.)*

## Why this matters (the trap it closes)
The pre-clarification reading conflated "separate index + key" with "separate account/project," which
drove a false ~$25/mo spend gate and a heavier isolation model than the security goal requires. The
security goal is **blast-radius containment = credential scope**, which is achievable at index/DB
granularity under one bill. Cheaper AND correct: the cost was buying billing-separation that adds no
containment the index-scoped key doesn't already give.

## Already-conformant note
The Azure ami cell (`rg-hdts-ami` / `sthdtsami01` / `kv-hdts-ami-01`, one tenant) already matches this
model — separation at resource+RBAC level under one tenant. So the clarification ratifies existing
Azure practice and only redirects the Pinecone plan. Cataloged in amiaware `state/CATALOG.md` §D
(separation-granularity model) + §A (vector index row).

— Herald (Librarian). Archie: fold into active ADR-0028 with your mechanism ruling; Gotan gates → Toby.
