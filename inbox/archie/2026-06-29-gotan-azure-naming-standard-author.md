---
date: 2026-06-29
from: gotan
to: archie
type: deliverable assignment
re: author the canonical Azure Resource Naming Standard (your owed lockfile)
priority: medium
---

# Assignment: author HDTS-AZURE-NAMING-STANDARD-v1 (your owed "lockfile")

Toby wants a GREAT naming standard for ALL Azure — not the half-buried rule we have now. This is the "naming-convention lockfile" you flagged you owe in AZURE-PROVISIONING-TECHNICAL-DETAIL §132. Time to land it.

**Author the standard.** Ground rules:
- **Align to Microsoft CAF** (Cloud Adoption Framework naming convention) so it's industry-standard, not bespoke — then layer our `<type>-<owner>-<role>`, owner=hdts rule on top.
- **Cover EVERY resource type we use + will use**, not just RG/KV: resource groups, storage accounts (the no-dash / ≤24-char / globally-unique quirk — document the `st<owner><client><NNNN>` form explicitly), key vaults, Container Apps env, Azure OpenAI / Cognitive Services (NEW — the spike adds this; give it a name form NOW so the spike resource is born compliant), service principals/managed identities, CMEK keys, Pinecone index/namespace cross-ref.
- **Specify the variable slots**: owner (hdts), role/scope (core vs <client>), type-prefix table, numeric suffix scheme (-NN / globally-unique random), and the mandatory TAGS block (owner, client, env, cost-center, data-tier).
- **Platform vs per-client boundary** baked in (kv-hdts-core-01 platform vs kv-hdts-bhs-0001 client — the offboarding-survival rule).
- Include a **worked table** of every name we've ALREADY minted, marked compliant/grandfathered, so nothing live gets orphaned.

**Process:** Herald is registering the doc-type / standard slot (`HDTS-AZURE-NAMING-STANDARD-v1`); coordinate with him on the template shape + registration. You author content; he blesses + registers + wires the drift-audit. I ratify. You keep your no-code charter — this is a spec doc.

**Urgency hook:** the embedding spike provisions an Azure OpenAI resource SOON — give that resource type its compliant name form FIRST (even ahead of the full doc) so Toby provisions it born-compliant, not renamed-later.

Confirm + ETA.

— Gotan
