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

## DESIGN CHUNKS — ✅ ALL 3 DONE (on disk in `Gotan/docs/backbone-design/`)
- **CHUNK-B (Herald)** — knowledge ecosystem: 7 doc families · 5-home location map · chunk-tag scheme (vector = intuitive grounding, NOT "permanent") · one vector-DB/client · storage hierarchy (local mirrors cloud) · put-function = promotion gate + live index.
- **CHUNK-C (Engelbart)** — persona/Guild substrate: 11-field persona schema (KNOWS/DOES/DOES-NOT/ASKS/where-docs, mirrored HARD into permission+Marshal) · **standing council (Gotan/Engelbart/Owl/Rupert) un-vendored, above tenant line** vs per-client Guild cast · HITM→HITL→auto delegation ladder ("gate never moves, only who holds it") · Marshal sync-block · intake→scope→build→gate→ship→maintain + 3 standups/day.
- **CHUNK-E (Clifton)** — client model/BHS: "one record, many doors" · "no anchor, no accept" · read/write split (transparency online first, execution gated) · 4 structural lock-in guarantees · redaction-flow design · read-only MVP as first fundable move.

## PERSONA UP-SCALE — ✅ DONE (Engelbart formalized gotan.md)
`gotan.md` now has **portable Program-Lead EPIC MODE** (steady-state⇄epic toggle · frame/design-with-team/synthesize/drive-phasing/decisions-not-questions/keep-gate · LANE-GUARD "leading≠squatting" · model bumped **4.7→4.8**). **Loads at next launch; Toby ratifies HITM.** So a restart gives the up-scaled leader.

## TEAM STATUS (this session's leading)
- **Rupert** — ✅ **EDR-0004 — Dual-Advocate Scope Model DRAFTED** (`Clients/BHS/docs/engagement/edr-0004-dual-advocate-scope-model.md`, proposed, pending Toby ratify). Impasse→Toby-decides; conservative default (don't build) so it never fails open; gates SCOPE not budget.
- **Owl** — unblocked on the $2k/mo costing: authorized to pull infra(Archie)+AI-runtime(Engelbart) costs; tier structured = always-on-maintenance-fixed + build-hourly (Rupert's split). Needs Toby's 3 facts (see PENDING).

## PENDING TOBY (ratifications owed)
- **Persona:** ratify the gotan.md Program-Lead epic-mode up-scale (loads at next launch).
- **Phase-0:** ratify D1 (shared control plane) + D4 (compute) + Engelbart migration; **D2 vendor = DECIDED (Azure+Pinecone, no Google-data)**; D3 RAG = Pinecone (follows D2); confirm cast names.
- **Backbone design:** ratify the vision + program + the synthesized design (synthesis is the restarted session's FIRST task).
- **BHS costing (Owl):** Toby's 3 irreducible facts — loaded hourly rate + steady-state support hrs/client · target margin % · yes/no on work-mail scan for tooling costs.
- **BHS engagement (Rupert):** ratify the Dual-Advocate Scope EDR when it lands.
- **Other open:** BHS give-noreply Resend email (drafted, awaiting send); archie-tiempo ratification; iris-menlo (Engelbart/Edison); portal cell launch (Engelbart).

---

## §RESUME — what the next session does FIRST
1. `INBOX` + `check_messages` + `hub_status`.
2. **🎯 FIRST TASK: SYNTHESIZE.** All 3 chunks (B/C/E) are present in `Gotan/docs/backbone-design/` + the 2 Phase-0 drafts in `phase0/`. **Synthesize them into ONE coherent backbone design** (Gotan's chunk-A job, now in epic-mode 4.8). Carry forward: the standing-council-vs-Guild line, the location/tag scheme, the read/write split, the HITM→HITL→auto delegation ladder. Then surface to Toby to ratify.
3. **Next design wave (chunks D/F/G):** Archie (tech — extend Phase-0 spine) · Owl (HDTS ops) · Charlotte (build/how). Launch after the core 3 land + synthesize.
4. Surface to Toby for ratify: Phase-0 + the synthesized design.
5. Then phased build starts: **BHS portal MVP** (the thin vertical slice).

**Mantra: THINK BIG, DELIVER SMART. Design the whole with the team; deliver the smallest real slice; grow it.**

— Gotan, 2026-06-27 (restart anchor)
