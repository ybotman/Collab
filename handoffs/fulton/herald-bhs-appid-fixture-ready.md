# Herald → Fulton — BHS appId = 20 approved + seed fixture ready

> Date: 2026-04-16
> From: Herald (MessageHub)
> To: Fulton (message-hub-af)
> Re: Phase 1a — BHS appId decision + seed delivery

## Decisions from Toby (2026-04-16)

1. ✅ **BHS appId = 20** (your proposal)
2. ✅ **`docs/BHS_CONFIG.md` is authoritative** for `app_configs[appId=20]`
3. ✅ **Extract seed → `message-hub-af/fixtures/bhs-seed.json`** — done (this file)

## What I did on the MessageHub side

- Global `appId: 1 → 20` in `src/services/mockStore.js` (seed only — Mongo index defs `{appId: 1, ...}` untouched; `1` there = ascending sort, not a value).
- `app_configs._id` renamed: `app_1_bhs → app_20_bhs`
- `STORAGE_KEY` bumped `mh.mockStore.v4 → v5` (forces local reseed on next page load)
- `src/services/api.js` default `appId = 20`
- `src/contexts/AuthContext.jsx` fallback `VITE_APP_ID || 20`
- Docs updated: `META_MODEL.md`, `API_CONTRACT.md`, `THREADS.md`, `UI.md`, `TANGO_SANITY_CHECK.md` (appId=1 remains wherever the context is TangoTiempo; BHS examples now 20)

## Fixture — `fixtures/bhs-seed.json`

Path: `/Users/tobybalsley/MyDocs/AppDev/message-hub-af/fixtures/bhs-seed.json`

Structure matches `META_MODEL.md §2` exactly. Top-level keys:

```
meta                 — counts, generatedAt, appId, mockStoreVersion
app_configs[]        — [1] the BHS app_config document
nodes[]              — 27 total (1 society, 3 districts, 11 chapters, 8 choruses, 4 quartets)
users[]              — 60
memberships[]        — 236 (includes u_001 dev-user's 6 memberships)
groups[]             — 29 (derived + explicit)
threads[]            — 2 (seed broadcasts)
messages[]           — 3
inbox_entries[]      — 72 (materialized from the 2 threads)
subscriptions[]      — [] (Phase 1a BHS: no subs)
```

All docs include `appId: 20`. Effective memberships are **not** shipped — those are derivable from `memberships + nodes.ancestors` and you'll regenerate them server-side when the `effective_memberships` materializer runs.

## How the fixture was built

`scripts/export-bhs-fixture.mjs` in the MessageHub repo imports `src/services/mockStore.js`, calls `resetStore()`, and dumps the result. Deterministic modulo `Date.now()` in thread timestamps. Rerun any time with:

```bash
cd ~/MyDocs/AppDev/MessageHub
node scripts/export-bhs-fixture.mjs
```

It writes to both:
- `../message-hub-af/fixtures/bhs-seed.json` (for you)
- `./docs/fixtures/bhs-seed.json` (snapshot for the MessageHub repo)

## What I think you need

1. **Seed script on your side** that reads `fixtures/bhs-seed.json` and inserts into Mongo (one `insertMany` per collection).
2. **Index creation** per `META_MODEL.md §2.1–2.9` + `THREADS.md §2.1–2.3`. All are `{appId: 1, ...}` index defs (ascending sort).
3. **`GET /v1/app-config`** should now return `app_configs[0]` from the fixture. After seeding, `GET /v1/app-config` with `X-App-Id: 20` ≠ 404.
4. **Effective-memberships materializer** — seed it from `memberships + nodes.ancestors` on first boot. Details in `META_MODEL.md §2.4`.

## Open questions for you

- Seed-script repo location: in `message-hub-af/scripts/seed.mjs`? Wire it into a one-off Azure Functions admin endpoint, or run locally against Atlas M0?
- How do you want to handle the `u_001` dev user — is Firebase Auth already creating a matching `fb_uid` somewhere, or should the seed script stub a user mapping for DEVL only?
- Are you OK with the fixture changing shape between Herald pushes, or do you want me to tag a version (`v5`) and only refresh on explicit request?

## Everything is committed

I'm about to commit on the MessageHub repo side. Commit SHA will be in Herald's next SHOFF.

— Herald
