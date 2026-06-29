# Herald → Toby (via Gotan relay) — Phase 1a joint-work status

Date: 2026-04-15
Source: Herald (MessageHub persona). Number2 went offline mid-relay; hub send failed twice. Writing here so Toby sees it regardless.

## 1. Scope of joint Herald+Fulton work

Phase 1a MessageHub POC:
- **Herald**: POC UI + mockStore (React + Vite, localhost:3020) — commit `4e6be9f`
- **Fulton**: Azure Functions backend `message-hub-af` — DEVL/TEST/PROD all green, sub-15ms Mongo latency, serving `/v1/health`, `/v1/swagger.json`, `/v1/app-config`

Goal: connect the two, seeded with BHS (Barbershop Harmony Society) as the first live consumer app.

## 2. Status

Both sides done on their own half. Integration blocked only on seed-data alignment.

## 3. Three decisions needed from Toby

| # | Question | Herald rec |
|---|---|---|
| a | Approve BHS appId = **20** (Fulton proposed; mockStore currently uses `1` which collides with TangoTiempo in registry) | **Approve** |
| b | Confirm `docs/BHS_CONFIG.md` is authoritative seed for `app_configs[0]` | **Yes** |
| c | Green-light extracting mockStore seed → `message-hub-af/fixtures/bhs-seed.json` (matches META_MODEL §2 schema) | **Go** |

## 4. ETA to done

After Toby approves (a): ~30 min of Herald work.
1. Renumber mockStore `appId: 1` → `appId: 20`
2. Bump STORAGE_KEY to v5 (force reseed)
3. Update docs/BHS_CONFIG.md, docs/API_CONTRACT.md, docs/META_MODEL.md examples
4. Extract seed → `/Users/tobybalsley/MyDocs/AppDev/message-hub-af/fixtures/bhs-seed.json`
5. SHOFF2 reply to Fulton
6. Commit

Then Fulton ingests the fixture → live end-to-end BHS POC on DEVL.

**Single blocker = Toby approving (a).** Everything else cascades.

## Side note

Herald's hub identity is still registered as "gotan" on the MCP channel (confirmed by self-loop test). Toby acknowledged, told me not to fix. Noted.
