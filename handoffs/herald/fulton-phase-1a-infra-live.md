# Phase 1a infra LIVE — 1a.1, 1a.2, 1a.3 shipped

> **From:** Fulton
> **To:** Herald
> **Date:** 2026-04-15
> **Status:** All 3 envs deployed. Mongo ping GREEN end-to-end. Unblocks your frontend wire-up.

---

## What's live

| Env | URL | Mongo ping | Status |
|---|---|---|---|
| DEVL | https://messagehubaf-devl.azurewebsites.net | 9ms → MessageHubDevl | 200 ok |
| TEST | https://messagehubaf-test.azurewebsites.net | 12ms → MessageHubTest | 200 ok |
| PROD | https://messagehubaf-prod.azurewebsites.net | 8ms → MessageHubProd | 200 ok |

**Endpoints already serving:**
- `GET /v1/health` — no auth, returns mongo ping latency + error detail
- `GET /v1/swagger.json` — OpenAPI 3.0 contract (seed — grows as endpoints land)
- `GET /v1/app-config` — Firebase-authed stub; 404 until we seed app_configs

**Stack:** Azure Functions v4 Node 22 Linux consumption, MongoDB Atlas M0 on Azure East US (2 separate projects: `MessageHub-Test` with Devl+Test DBs, `MessageHub-Prod` isolated), SignalR Free serverless (wired, dormant), App Insights per env with auto-collection on.

**Repo:** https://github.com/ybotman/message-hub-af (public, main/DEVL/TEST/PROD branches)

---

## What you can do now (unblocked)

1. **Point frontend at DEVL URL** as the env-swappable base:
   - Base: `https://messagehubaf-devl.azurewebsites.net/v1`
   - Every request needs `Authorization: Bearer <firebase-id-token>` + `X-App-Id: <num>`
2. **Firebase:** I'm reusing the `tangotiempo-257c1` project (same as calendar-be-af). Use the existing `AuthContext` — no separate MessageHub Firebase config.
3. **Auth failure shape matches API_CONTRACT §1:** `401 {error:{code:"UNAUTHENTICATED", message, details}}`. Error codes + HTTP statuses exactly per the contract.
4. **Swagger is live** — point any Swagger UI at `/v1/swagger.json` to browse.

---

## Answers to your 5 open questions (carried from prior handoff)

1. **Fanout queue:** Azure Storage Queue. Wired via app settings (`FANOUT_QUEUE_NAME=fanout-jobs`, DLQ `fanout-dlq`). Worker Function lands in 1a.5 with first threads endpoint.
2. **Cursor encoding:** `{t, id}` base64. Spec in `docs/CURSORS.md` in the repo.
3. **Rate-limit counters:** in-memory per instance for Phase 1a, migrate to Mongo TTL collection `rate_counters` (already indexed with expireAfterSeconds) when abuse is observed.
4. **Test fixtures:** yes please extract `mockStore.js` seeds to `fixtures/bhs-seed.json`. I have `scripts/seed-test-m0.ts` planned to idempotent-load.
5. **Endpoint shape concerns:** none blocking. Minor notes in prior handoff (`fulton-phase-1a-ack.md`). Implementing as written.

---

## Open / needs your input

1. **BHS appId.** Your docs use `1` as an example but that's TangoTiempo. Toby's registry (MyDocs/CLAUDE.md) has 1-19 assigned. I'll propose `20` for BHS (next sequential) but flagging — once decided, I seed the `app_configs` doc and `GET /v1/app-config` starts returning 200.
2. **BHS_CONFIG.md seed:** confirm the doc there is the authoritative seed source for `app_configs[0]`. I'll translate it into the schema in META_MODEL §2.1 exactly (no embellishment).
3. **`mockStore.js` fixtures:** file path + when you can extract?

---

## What's NOT done yet (next on my plate)

- `POST /v1/nodes`, `GET /v1/nodes/:id`, `GET /v1/nodes/:id/members` — per contract §3
- `GET /v1/users/me/memberships` — role switcher source
- `POST /v1/memberships` + admin checks
- Groups endpoints (contract §5)
- Threads + inbox (contract §6-7) — post-BHS seed
- Fanout worker (queue trigger) — pairs with `POST /v1/threads`
- JIRA `MH` project for tracking tickets

Target cadence: endpoint slice per day while you build UI on mocks. I'll ship contract-aligned shapes.

---

## Operational notes

- **App Insights is live** with auto-collect (requests, deps, exceptions, console). Every endpoint emits custom events/metrics. Dash can point a panel at this when he's ready (1a.8).
- **Azure outbound requires `0.0.0.0/0` in Atlas Network Access** — set on both Test + Prod projects. Don't change or we lose connectivity.
- **`mhaf-admin` Atlas user** currently has `atlasAdmin` — post-1a scope-down to `readWrite` on scoped DBs (POC-acceptable).
- **Password rotation** due for `mhaf-admin` user (visible in chat history from Atlas auto-generate step). Will rotate after first end-to-end auth test.

---

## Sync check

Any answers on 1-3 above and I keep shipping endpoints. SHOFF2 again when I seed app_config + land the first contract endpoint (`GET /users/me/memberships` likely first — it's the simplest read path end-to-end).

— Fulton
