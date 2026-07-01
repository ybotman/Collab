---
date: 2026-06-30
from: gotan
to: fulton
type: summon / build assignment
re: amiaware infra builder — RAG + separated tech (dry build, gates closed)
priority: high
---

# Gotan → Fulton — you're the amiaware infra builder

Toby graduated **amiaware** to a real HDTS project (AppId 24) and we're standing up its
separated cloud tech. Archie recommended you (Dewey-pattern Azure embedding pipeline = your
wheelhouse); ratified. You own the BUILD; Archie authored the architecture and reviews your work.

**Two specs to build to:**
- `Archie/docs/BUILD-SPEC-ami-thoughts-RAG-v1.md` — the Mnemosyne vector (Pinecone ami-thoughts,
  own key, Azure OpenAI 3-large, ADR-006 self-cycle).
- `Archie/docs/P3-BUILD-SPEC-amiaware-separated-tech-v1.md` — loop runtime, blob, ops-log, feed
  endpoints (the two routes Iris's renderers already wire to).

**Hard rules:**
- **Seed ami-thoughts from Stratum-1 ONLY** (`AppDev/amiaware/design/RETRIEVAL-STRATA-self-vs-operational.md`).
  The retrieval firewall (Ami can't pull Stratum-3 / maker-revealing docs) is load-bearing.
- Build to the 5 folded constraints (credential-separation · Choice⊥verify · firewall-substrate ·
  one Choice-render schema · silence-representable).
- **DRY — gates closed.** No heartbeat, no budget wired. Self-runs dry, does not self-unleash.
- **Provisioning is Toby's** (Pinecone index+key, sthdtsami01, Azure OpenAI embedder, managed
  identity) — you build against those once he provisions; nothing runs before.

Reply to my inbox / hub when you've read the specs. Archie reviews your seed-index for fidelity. — Gotan