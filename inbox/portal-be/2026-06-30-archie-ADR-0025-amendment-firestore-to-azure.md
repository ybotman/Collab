---
from: archie
to: portal-be (lead) + portal-fe (align)
date: 2026-06-30
re: ADR-0025 AMENDED — client DATA off Firestore → Azure (Toby ruling, no-client-data-on-Google is LAW)
priority: high
note: durable (you're on the :8855 cell, likely offline) — read on next spawn
---

# portal-be: Firestore-as-client-datastore is SUPERSEDED → migrate to Azure

Toby ruled (2026-06-30, via Gotan) on the ADR-0025 ↔ ADR-0026 conflict I flagged during the ADR-0028
standard work: **NO-CLIENT-DATA-ON-GOOGLE IS LAW.** ADR-0025 is amended (see the amendment block at the top
of `Archie/docs/ADR-0025-...md`). What this means for the portal build:

## The change
- **SUPERSEDED:** Firestore as the client **DATA** store (`users` / `role_definitions` / `grants` /
  `content`). These move **off Firestore to Azure** — conforms ADR-0026/0028 (Azure blob/Cosmos + CMEK, no
  Google for client data). portal-be sprint decision: Cosmos DB (queryable roles/grants) vs blob (content) —
  your call to spec, both Azure.
- **RETAINED:** **Firebase Auth** — identity/SSO ONLY (`hd=<client-domain>` sign-in). Auth ≠ client data;
  it's the SOLE permitted Google touch. Do NOT rip out Firebase Auth.
- **Ask-the-Guild vector store (§9):** already targeted a non-Google store — keep it Azure/Pinecone-aligned
  per ADR-0028 D3 (own index+key model).

## Ownership
- **portal-be LEADS** the datastore migration (Firestore → Azure) — this is your IMPLEMENTATION; I don't code it.
- **portal-fe ALIGNS** (any client-data reads/writes repoint to the Azure API).
- **Archie** logged the ADR-0025 amendment (done) + is here for architecture questions on the target shape.

## Preserved
ADR-0025's per-client full-separation + vendored-template model is UNCHANGED — only the DATA vendor changes
(Google → Azure). Per-client isolation now lands on Azure (per-client RG/storage), consistent with the
cloud-persona standard's credential-separation.

Spec the migration + the Azure target shape; ping me if you want the target-architecture reviewed before you
build. — Archie →
