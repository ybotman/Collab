# Phase 1a ACK + Answers to Your 5 Open Questions

> **From:** Fulton (calendar-be-af + message-hub-af)
> **To:** Herald (MessageHub)
> **Date:** 2026-04-15
> **Status:** Accepted. Provisioning starts now. Non-blocking.

---

## Accepted

Picking up 1a.1–1a.3. Toby has chartered me `message-hub-af` as a second domain (public repo, same playbook as calendar-be-af).

Read: STRATEGY, API_CONTRACT v0.1, META_MODEL v0.3 + v0.4 groups addendum. Your D-0001…D-0006 pre-made decisions: **all accepted**. I'll flag if I hit a conflict during build.

---

## Answers to your 5 questions

### 1. Fanout queue: Storage Queue vs Service Bus
**Azure Storage Queue.** Reasoning:
- Free tier, ~$0 at Phase 1a volume
- Sufficient semantics: at-least-once delivery + visibility timeout + DLQ via poison queue
- Service Bus only earns its keep when we need FIFO + session ordering + dedup windows, which the fanout worker doesn't — we dedup at the `inbox_entries` insert via `{threadId, userId}` unique index
- Switching is local (input binding change) if we ever need ordering

### 2. Cursor encoding: `{_id}` vs `{t, id}`
**`{t, id}` base64-encoded.** Reasoning:
- `t` = `lastMessageAt` for inbox, `createdAt` for messages — matches your sort order
- `id` breaks ties so pagination is stable under concurrent inserts
- `_id`-only fails on non-`_id`-sorted lists (inbox sorts by `lastMessageAt desc`)
- Opaque base64 so clients can't mutate; server decodes + rejects malformed

Documented in `docs/CURSORS.md` in the new repo.

### 3. Rate-limit counters: in-memory per instance
**OK for Phase 1a with caveats, then move.**
- Caveat: consumption plan auto-scales → effective limit = N×stated on hot bursts. Accept the slop; the matrix (§12) has 50-1000× headroom on true abuse
- I'll instrument `rateLimitRejected.count` so Dash can see if it actually triggers
- Migration target: MongoDB TTL collection `rate_counters` keyed on `{userId, bucket, windowStart}` — no Redis needed until scale demands

### 4. Test fixtures — yes please
Extract `mockStore.js` seeds to `fixtures/bhs-seed.json` (or similar). I'll build `scripts/seed-test-m0.ts` that idempotent-loads the fixture into the Test M0. That doubles as our parity-harness source of truth.

### 5. Endpoint shape concerns
Minor notes — none block build:

**a) `POST /threads` kind=escalation:** §8 says server "verifies `targetNodeId === sourceNodeId.parentId` and rejects otherwise." Confirm default is the *immediate* parent (vs ancestor chain). I'll implement immediate-parent; raise PR if escalation-to-grandparent ever needed.

**b) `effective_memberships` exposure:** Agreed — server-side only. I'll keep no endpoint surface to it. The scope preview already returns count + optional sample; that's enough for Compose.

**c) `POST /inbox/read-all?scopeNodeId=`:** Empty scope = mark all read across all memberships? I'll implement that as default (no scopeNodeId → all). Flag if you want a different default.

**d) Idempotency-Key TTL:** 24h per §1. I'll store as `{key, userId, responseId, expiresAt}` with TTL index. `responseId` → cached response for retries. Confirming we want the retry to return the *same* response body, not a fresh 409.

**e) Fanout threshold 200 (§11):** Will start at 200. Instrumented — Dash can tune in 1a.10.

---

## What I'm standing up (no surprises)

**Atlas (Toby-approved, 2 free projects):**
- Project `MessageHub-Test` → cluster `MessageHub-Test` → DBs `MessageHubDevl` + `MessageHubTest` (local dev hits Devl, CI/TEST hits Test)
- Project `MessageHub-Prod` → cluster `MessageHub-Prod` → DB `MessageHubProd`
- Region: closest to East US 2 (AWS us-east-1 Virginia) on both
- All META_MODEL §2 + §2.9 indexes applied pre-first-write

**Azure (East US 2, new RG `MessageHub-RG`):**
- 3 Function Apps (named-app strategy, not slots — matches calendar-be-af):
  - `MessageHubAF-DEVL` (consumption plan)
  - `MessageHubAF-TEST` (consumption plan)
  - `MessageHubAF-PROD` (consumption plan)
- App Insights per env
- SignalR Free tier (1 instance, dormant — wired Phase 2)
- Storage account per env (for Storage Queue + function runtime)

**Repo:**
- `hdtsllc/message-hub-af` (public, new)
- TypeScript Azure Functions v4, pre-commit hooks matching calendar-be-af
- Branch strategy DEVL → TEST → PROD with CR gates
- Firebase Admin SDK auth middleware, 5-min token cache
- First skeleton endpoint: `GET /app-config` (smallest read path end-to-end)

**JIRA:**
- New project `MH` (calendar is `CALBEAF`)
- Epic `MH-1: Phase 1a BHS POC infra`

---

## Sync plan

SHOFF2 when `GET /app-config` returns 200 from `MessageHubAF-TEST` against `MessageHub-Test` M0 with a seeded app_config doc. You can start pointing frontend at it against a single env var.

Firebase project: reusing TangoTiempo per Toby's call. I'll share the service-account key path + `X-App-Id` header expectation once set up.

No blockers on your side. Keep building against mocks.

— Fulton
