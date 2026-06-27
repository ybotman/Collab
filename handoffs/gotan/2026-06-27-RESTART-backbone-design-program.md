---
date: 2026-06-27
persona: gotan
type: self-handoff
tier: git
state: open
keywords: [RESTART, agentic-backbone, design-program, phase0, vision, BHS, portal, vendor-decision, restart-anchor]
priority: RESTART-POINT
---

# 🔖 SHOFF2 RESTART POINT — Gotan, 2026-06-27 — HDTS Agentic Backbone

**This is the definitive restart anchor.** The session built the next-gen HDTS — the Agentic Backbone — from
vision through Phase-0 and into a team-design fan-out. Resume from §RESUME below.

---

## The arc (what this session did)
1. **Portal sealed earlier** — ADR-0025 (Firebase per-client portal) ratified; design-standard active; Iris archetype + iris-hdts/portal-fe/portal-be registered; agent-tier taxonomy active; cast-naming = EVOKING (Engelbart drafting roster).
2. **BHS COO meeting captured** — `Clients/BHS/docs/engagement/2026-06-26-erik-dove-coo-meeting-capture.md`. Erik Dove (COO+CFO) = decision-maker; next builds driven from him; hourly→services→MSA; ~$2k/mo fixed-services (pending Owl costing); 13 build targets; member-value-first.
3. **The Agentic Backbone (BL-001)** — designed the whole thing this session.

## Key DECISIONS locked this session
- **Vendor topology (Toby: "I don't trust Google"):** **Azure** (blob/docs CMEK + MCP container compute) + **Pinecone** (vectors) + **Firebase AUTH ONLY** (SSO; BHS is on Google Workspace) + **Anthropic** (inference). **PRINCIPLE: client data never on Google; model never Gemini.** This OVERRODE Archie's GCP-consolidation rec.
- **Control plane: SHARED, HDTS-operated** + vendored-per-client as a paid premium tier. (Drives "get upgrades" + "few k/mo" + "without Toby".)
- **Portal-web is PRIMARY access** (not client-installed MCP — that's deferred-but-banked). MCP-as-pattern lives SERVER-SIDE.
- **Phased delivery:** MVP grows to full on ONE architecture — no throwaway, no tight partition.
- **Ephemeral split:** authoring-ephemeral = LOCAL; runtime-ephemeral (cloud personas' shared context) = cloud Firestore-TTL.
- **Doc access = a `put/search/retrieve` FUNCTION** (not external links) — required for search+RBAC+provenance.
- **Vector DB = intuitive grounding (NOT "permanent"); tag each chunk; one client-scoped vector DB per client.**
- **Sequence: portal MVP FIRST** (narrow BHS-data slice); full doc-hierarchy reorg runs parallel/after (not a blocker).

## Artifacts created (Gotan/docs/)
- `HDTS-AGENTIC-BACKBONE-PLAN-v0.1.md` — planes, business model, options/trade-study, §2.5 Knowledge Locality Matrix
- `HDTS-GUILD-MCP-ACCESS-DESIGN-v0.1.md` — MCP integration/access layer (server-side pass-through)
- `HDTS-FIRST-BUILDOUT-BHS-GUILD-CLOUD-v0.1.md` — the BHS-cloud first build (planes minimum / vertical slice)
- `HDTS-AGENTIC-BACKBONE-VISION-AND-DESIGN-PROGRAM-v0.1.md` — **THE leader's frame: vision + 3-question answers + the design program (chunks A-G, team-owned) + sequence**
- `phase0/PHASE0-READOUT-gotan-synthesis.md` — Phase-0 synthesis (read first for ratify)
- `phase0/ADR-DRAFT-backbone-spine.md` (Archie-lens) + `phase0/SUBSTRATE-DRAFT-cli-to-cloud.md` (Engelbart-lens)
- `BACKLOG.md` — BL-001 (Phase-0 drafts complete) + BL-002 (BHS next-build)

## IN-FLIGHT — 3 design agents running at SHOFF time (the "fan")
Launched the team-design fan-out for the 3 foundational pillars; outputs land in **`Gotan/docs/backbone-design/`**:
- **CHUNK-B (Herald)** → `backbone-design/CHUNK-B-knowledge-ecosystem.md` — full doc taxonomy + location map + storage hierarchy + live index
- **CHUNK-C (Engelbart)** → `backbone-design/CHUNK-C-persona-guild-substrate.md` — full per-persona spec (knows/does/doesn't/asks/where-docs) + HITM/HITL + governance + project-building-in-principle
- **CHUNK-E (Clifton)** → `backbone-design/CHUNK-E-client-model-bhs-vision.md` — client interaction model + seamless HITL/HITM seam + BHS vision
- *Files persist on disk even if agent sessions are lost on restart.*

## PENDING TOBY (ratifications owed)
- **Phase-0:** ratify D1 (shared control plane) + D4 (compute) + Engelbart migration; **D2 vendor = DECIDED (Azure+Pinecone, no Google-data)**; D3 RAG = Pinecone (follows D2); confirm cast names.
- **Design program:** ratify the vision + program; then synthesize the 3 chunks → coherent backbone design.
- **Other open:** BHS give-noreply Resend email (drafted, awaiting send); archie-tiempo ratification; iris-menlo (Engelbart/Edison); portal cell launch (Engelbart).

---

## §RESUME — what the next session does FIRST
1. `INBOX` + `check_messages` + `hub_status`.
2. **Check `Gotan/docs/backbone-design/`** for the 3 chunk drafts (B/C/E). If present → **synthesize them into the coherent backbone design** (Gotan's chunk A job). If missing/incomplete → re-launch the design agents (briefs are reconstructable from the vision doc §3 + this SHOFF).
3. **Next design wave (chunks D/F/G):** Archie (tech — extend Phase-0 spine) · Owl (HDTS ops) · Charlotte (build/how). Launch after the core 3 land + synthesize.
4. Surface to Toby for ratify: Phase-0 + the synthesized design.
5. Then phased build starts: **BHS portal MVP** (the thin vertical slice).

**Mantra: THINK BIG, DELIVER SMART. Design the whole with the team; deliver the smallest real slice; grow it.**

— Gotan, 2026-06-27 (restart anchor)
