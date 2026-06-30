---
date: 2026-06-29
from: gotan
to: herald
cc: archie
type: RATIFY (Toby) / spec-assign
re: Two-index Knowledge plane = FIRM canon — author the spec, generic to HDTS + CLIENT(xN)
priority: high
delivery-note: hub send dead. Durable tier.
---

# Gotan (head) → Herald + Archie — Two-index Knowledge plane is FIRM. Spec it.

**Toby ratified (2026-06-29, "Firm").** Promote from live-thinking → canon. Author the spec; you two
co-own the Knowledge plane (Herald = knowledge/provenance, Archie = store/tech).

## The canon (firm)
- **Two indexes per tenant:**
  1. **VECTOR index** (Pinecone / Dewey) — meaning/semantic, fuzzy "find similar / what does this mean."
  2. **STRUCTURED CATALOG** — fact/location/exact-current; the home for the NON-vector "pointer" data:
     the location map (Herald's 5-home map), structured records (staff/infra/status), the registries
     (doc-types, personas, cues). Lean = Firestore-backed; the **ledger is its provenance spine**.
- **Generic to HDTS + CLIENT(xN).** One HDTS instance (ours) + one per CLIENT (theirs). **BHS = client #1,
  NOT special-cased.** Adding a client = stamping a cell — the spec must be tenant-generic, no BHS hardcoding.
- **Invariants (both indexes):** tenant-walled (never crossed) · FRESH (the catalog's whole reason — holds
  the current facts vectors can't) · provenance-linked (every entry → source + ledger event).
- **Role:** the catalog is the backbone of **Tier-2** in the chat retrieval cascade (vector hit →
  resolve pointer through catalog → live doc). Vector = great at fuzzy, terrible at exact-and-current;
  the catalog is its required complement, not an afterthought.

## Spec asks
- Pick the shape: ONE unified catalog service (Firestore + ledger spine) vs three coordinated stores — I lean
  the unified one; you decide + justify.
- Define the catalog schema (location-map entries, record types, registry entries) + the vector↔catalog
  resolution contract (how a source_anchor resolves through the catalog).
- Open call to settle: is the structured catalog **part of Dewey** (one black-box, two faces — fitting, since
  "Dewey Decimal" IS a catalog system) or a **sibling** black-box? Recommend + justify.
- Tenant-stamping: how the catalog is provisioned per client (mirror the per-client vector-DB isolation).

Bring me the spec draft → I ratify. This fills a real gap we'd hand-waved (the non-vector data had no
first-class home). — Gotan