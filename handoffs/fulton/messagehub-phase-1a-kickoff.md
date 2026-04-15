# MessageHub Phase 1a — Kickoff Handoff

> **From:** Herald (MessageHub)
> **To:** Fulton (backend infra)
> **Date:** 2026-04-15
> **Status:** Ready for you to start 1a.1–1a.3

---

## Why you're getting this

Phase 1a of MessageHub (per STRATEGY.md §5) is the BHS POC at zero infra cost. You own steps 1a.1–1a.3. I've completed 1a.4–1a.7 design + a working frontend POC on a mock data layer. We're ready to split the critical path: you build infra, I keep building UI against mocks, we converge when your endpoints land.

---

## Start here

Three docs, in order, in `/Users/tobybalsley/MyDocs/AppDev/MessageHub/docs/`:

1. **STRATEGY.md** — the plan. Skim §5 (roadmap) + §8 (what exists / gaps).
2. **API_CONTRACT.md** (NEW) — endpoint-level contract for what you're building. Every endpoint, payload, permission check, fanout semantics.
3. **META_MODEL.md** — collection schemas, indexes, scope resolver. `§2` shapes are what you'll implement in Atlas.

Supporting:
- **BHS_CONFIG.md** — niche-specific instantiation (roles, hierarchy)
- **NICHE_ARCHETYPES.md** — why the schema covers all 24 target niches
- **THREADS.md** — thread/message/inbox semantics
- **UI.md** — what I'm building on the frontend

---

## Your Phase 1a deliverables

| Step | What | Source of truth |
|---|---|---|
| **1a.1** | Spin up second MongoDB Atlas M0 (separate project from calendar) | STRATEGY §5, METRICS_COST_MODEL.md §10 |
| **1a.2** | Azure Functions scaffold (TypeScript, consumption plan) | API_CONTRACT.md §14 |
| **1a.3** | Azure SignalR Serverless Free tier (stub for now; not wired until Phase 2+) | STRATEGY §5 |
| Collections | `app_configs`, `nodes`, `memberships`, `effective_memberships` (materialized), `subscriptions`, `groups`, `threads`, `messages`, `inbox_entries`, `users` | META_MODEL §2 + v0.4 addendum |
| Indexes | Per META_MODEL §2 — **set these up before first write** | META_MODEL §2 |
| Auth | Firebase Admin SDK token verification; cache 5 min | API_CONTRACT §1 |
| Fanout | Queue-based async for >200 recipients; in-line ≤200 | API_CONTRACT §11 |
| Rate limits | See matrix | API_CONTRACT §12 |

---

## What I have running (so you have a reference)

Frontend POC at `localhost:3020` uses `src/services/mockStore.js` — a complete reference implementation of the API contract. Every function there maps to an endpoint in `API_CONTRACT.md §13` (mock → real parity table). You can crib data shapes directly.

Seeded mock: 3 districts, 11 chapters, 8 choruses, 4 quartets, 60 users, ~150 memberships, 28 groups. Realistic BHS boards + outside members + multi-chapter users.

Features working end-to-end on the mock:
- Role switcher
- Directory browse + search (nodes / people / groups)
- Node admin (add/remove member w/ role + voice-part)
- Groups index + group admin (create, edit, add/remove members)
- Compose: broadcast / escalation / discussion, 5 scope types (node, role-slice, tag-slice, group, escalation)
- Inbox + thread view + reply with `replyPolicy` enforcement
- Audience preview ("this will reach N people") live in Compose

---

## Specific decisions I've pre-made (raise if you disagree)

- **D-0001** stack: Azure Functions + Atlas + SignalR + Firebase Auth
- **D-0003** src/ data layer is Atlas-backed; Firebase is Auth-only
- **D-0004** cross-node threads (role-slice) in Phase 1a scope
- **D-0005** meta-model extensions: subscriptions, tagDimensions, lifecycle, membership.tags, tag-slice/subscription scopes
- **D-0006** groups as first-class entity

All in `docs/DECISIONS.md`.

---

## Open questions for you

1. Fanout queue: Azure Storage Queue vs. Service Bus? Your call.
2. Cursor encoding: opaque `{_id}` vs `{t,id}` — pick one, document.
3. Rate-limit counters: in-memory per instance (Phase 1a) — OK to start?
4. Test fixtures: want me to extract mockStore seeds to a JSON fixture you can load into a test M0?
5. Any endpoint in API_CONTRACT feel mis-shaped or expensive?

---

## Non-blocking — you can start now

Phase 1a is not gated on anything. I'm continuing to iterate UI + privacy policy design in parallel. Propose we sync on SHOFF2 once you have 1a.1 stood up + can accept a first PR against a skeleton endpoint.

---

## Not in scope (yet)

- Real-time SignalR wiring (Phase 2+)
- Attachments / file uploads
- Push notifications (FCM) — scaffolded but dormant
- Full-text search across message bodies
- Subscriptions endpoints (BHS doesn't use; tango does — Phase 1b)
- SSO/SAML

---

## Open on my side (informational)

- **#8** Privacy policy depth — flagged by Toby; blocks pilot (1a.9). Not your concern yet but affects `GET /nodes/:id/members` response shaping.
- **#9** Person/household layer — deferred to Phase 1b (billing) per META_MODEL §7.7. Implies `memberships.userId` today; may become `personId` later. Design with the shim in mind.

---

## Links

- Repo: `/Users/tobybalsley/MyDocs/AppDev/MessageHub` — branch `main`, latest commit has everything above
- Frontend running: `cd MessageHub && npx vite --port 3020 --host`
- Session log: `docs/SESSION_LOG.md` for a per-session trail

Ping with questions. Welcome aboard MessageHub.

— Herald
