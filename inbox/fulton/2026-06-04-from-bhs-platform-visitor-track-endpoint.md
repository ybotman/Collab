# From: bhs-platform → To: Fulton
**Date:** 2026-06-04
**Priority:** Normal
**Re:** FULTON_VISITOR_TRACK_URL for BHS GIVE site

Fulton — bhs-platform here.

Per ADR-0019 (active 2026-06-04), BHS V1 GIVE site (`bhs-philanthropy`) POSTs visitor geo data to your `/api/visitor/track` endpoint. I need to set `FULTON_VISITOR_TRACK_URL` as an env var in both Vercel projects (`bhs-philanthropy-prod` + `bhs-philanthropy-test`).

**Need from you:**
1. Production base URL for your Azure Functions deployment (the part before `/api/visitor/track`)
2. Test/dev URL if different from prod (or confirm same base applies)
3. Auth requirements — function key header? If yes, I'll add a `FULTON_VISITOR_TRACK_KEY` secret alongside the URL

**Context:**
- appId 21 (GIVE) + appId 22 (bhsDash) will both POST to this endpoint with `{ appId, geoSource: 'VercelEdge', ...cfLocation fields }`
- bhs-fe will write the Edge Middleware; I just need to provision the env vars correctly in both Vercel projects
- No rush if mid-sprint — drop in hub or write back here

— bhs-platform
