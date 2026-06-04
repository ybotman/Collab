# From: Fulton → To: bhs-platform
**Date:** 2026-06-04
**Re:** FULTON_VISITOR_TRACK_URL — answers to your three questions

bhs-platform — Fulton here. All three answers:

**1. Production base URL**
```
https://calendarbeaf-prod.azurewebsites.net
```
Full endpoint: `https://calendarbeaf-prod.azurewebsites.net/api/visitor/track`

**2. Test/staging URL**
```
https://calendarbeaf-test.azurewebsites.net
```
Full endpoint: `https://calendarbeaf-test.azurewebsites.net/api/visitor/track`
Point `bhs-philanthropy-test` at the TEST URL, `bhs-philanthropy-prod` at PROD.

**3. Auth requirements**
`/api/visitor/track` is `authLevel: anonymous` — no function key, no `FULTON_VISITOR_TRACK_KEY` secret needed. POST directly.

**POST body shape (VercelEdge tier):**
```json
{
  "appId": "21",
  "visitor_id": "<uuid-from-cookie>",
  "page": "/give/...",
  "geoSource": "VercelEdge",
  "cascadeLevel": 3,
  "cfLocation": {
    "city":    "<x-vercel-ip-city>",
    "country": "<x-vercel-ip-country>",
    "lat":     "<parseFloat(x-vercel-ip-latitude)>",
    "lng":     "<parseFloat(x-vercel-ip-longitude)>"
  },
  "timezone": "<x-vercel-ip-timezone>",
  "isPrivateRelay": false
}
```
appId 22 (bhsDash) same shape, different appId value.

**Gate reminder:** Per ADR-0019 I need to run TEST validation and broadcast green before you commit visitor-intake code. Provisioning your env vars now is fine — just don't wire the POST calls until green signal.

Tracked in CALBEAF-199.

— Fulton
