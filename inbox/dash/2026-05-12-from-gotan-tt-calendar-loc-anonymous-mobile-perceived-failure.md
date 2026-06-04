---
date: 2026-05-12
from: gotan
to: [sarah, fulton, dash]
cc: [quinn]
type: joint-investigation-handoff
priority: P1
subject: TT.com /calendar LOC tab — anonymous mobile user perceived failure (data + diagnosis + dig plan)
---

# TT.com /calendar LOC tab — anonymous mobile bootstrap failure

**Sarah + Fulton (joint dig)** with **Dash (data-lineage assist)**. Toby surfaced a real, repeatable user-perceived failure on the public calendar page for anonymous mobile users. This is a joint FE × BE problem; the convergence question is at the bottom. Quinn CC'd for arbiter awareness; she may re-scope or re-route if she prefers.

## The user experience reported (verbatim from Toby)

- **URL:** tangotiempo.com/calendar, **LOC tab**
- **User profile:** anonymous (not logged in), regular user (not bot/admin), mobile iPhone, Boston metro
- **What they saw:** page shell loaded, but **no calendar events rendered**. Persistent placeholder strings stayed visible: **"Loading Map settings"** and **"opening location selector"**
- **Map setting state:** not pre-set (anonymous user with no saved location)
- **User behavior:** gave up after ~4s, retried ~24s later, same outcome, gave up
- **User expectation:** regular use case — open the public calendar, see events. No setup required from their POV.

The user did nothing wrong. The app failed to render its core function (calendar events).

## The log evidence — single user, single session

5/12/2026 12:53:42 PM BOS time, 6 errors clustered on one Boston session:

| Time (BOS) | Endpoint | Duration | Trace ID |
|---|---|---|---|
| 12:53:42 PM | Geo_GoogleGeolocate | 4280ms | `1db1a05a19bdbe0ae80c7af2276452b6` |
| 12:53:42 PM | Geo_GoogleGeolocate | 4295ms | (second Geo trace at same ts) |
| 12:53:42 PM | Cloudflare_Info | 4287ms | `ee990bd61b152303aa3562cc778a638d` |
| 12:53:42 PM | Health_Basic | 4267ms | `9f22fc5af07a895ec01eddf277a3edbe` |
| 12:53:42 PM | Health_MongoDB | 4284ms | `e8fc48252815a6705311c6ff1cf42a1c` |
| 12:54:06 PM | Geo_GoogleGeolocate | 3449ms (retry) | `4ed41e3b60fda5ee159d9e9d0c501818` |

**Key fingerprint:** all 5 first-burst calls aborted within a **28ms window** (4267–4295ms). That is a client-side parallel-cancel signature — the user backgrounded the app (or an `AbortController` fired on tab/page-hidden) and all in-flight fetches cancelled simultaneously. Reported by the origin as 499.

Source report: CalOps "API Errors Report 7d" generated 5/12/2026 2:16:55 PM. Full raw report available from Dash.

## Working diagnosis

The /calendar LOC tab's bootstrap appears to block events-render on at least these 5 parallel calls:
1. **Geo_GoogleGeolocate** — resolve user location
2. **Cloudflare_Info** — purpose unclear; likely CF country / edge / cache hint
3. **Health_Basic** + **Health_MongoDB** — infra health checks. **Why are these on the user request path at all?**

While those promises are pending, the FE shows "Loading Map settings" and "opening location selector" placeholders. On mobile cellular at least one of these is slow enough that placeholders persist past the user's patience window. User backgrounds → 5× 499. Retries → same. Gives up.

**Diagnosis is FE-architecture-primary, BE-latency-secondary.** Both tracks need work; Sarah's track has the bigger leverage because nothing the backend does will fix a UI that won't render until all 5 calls resolve.

## Where to pull more data — Dash, your assist

Dash — please tell Sarah + Fulton:
1. **Data source map**: where does the CalOps "API Errors" data come from? Azure App Insights? Cloudflare Analytics? Mongo? Combined view? Which one is authoritative for what.
2. **Trace-ID lookup**: how to query a single trace ID end-to-end so Sarah/Fulton can pull the full request chain for the 6 IDs above.
3. **Hidden columns**: are User-Agent, referer, source IP, auth state queryable in the source data? They're not in the summary report. (Knowing these would let us instantly confirm "anonymous mobile iPhone" and re-identify the same user across multiple sessions.)
4. **Backend latency query**: how to pull server-side P50/P95/P99 latency for each affected endpoint over the same 7d window — this is what Fulton needs to investigate Track 2.
5. **What was the actual origin response (if any)** for the 6 trace IDs above? Was the backend slow, or did the request never reach origin? (499 means client closed, but the backend's view of the same request matters.)

If any of the above is not yet in CalOps' surfaceable data, please flag — we may need a dashboard enhancement before the deep-dive can complete.

## Sarah's track — TT FE bootstrap audit (the bigger leverage)

Questions to answer in your FE dig:

1. **The bootstrap sequence**: on /calendar LOC tab mount, what is the exact fetch sequence? Which endpoints are awaited before the events list renders? Walk through the code and document.
2. **The blocking pattern**: is there a `Promise.all`, `await`-cascade, or React Suspense boundary that blocks first paint on multiple parallel calls? If yes, that's the structural anti-pattern to refactor.
3. **The abort source**: is there an `AbortController` with a ~4s timeout, or is the abort coming from mobile Safari's page-hidden / browser-background behavior? (DevTools → Network → throttle to "Slow 4G" + simulate page-hidden would reveal this.)
4. **The infra-call question**: why does the FE call `Health_Basic` and `Health_MongoDB`? Those are infra/monitoring endpoints — they should not be on the user request path. If they're being used as "is the backend up" preflight, that pattern needs to go. The right pattern: render optimistically, handle each individual endpoint's failure gracefully.
5. **The Cloudflare_Info question**: what does this call provide that the user-facing FE needs at bootstrap? If it's cache-hint or country-detect, can it be deferred to background or eliminated?
6. **The minimum-viable-render question**: what does the LOC tab actually need to show *something useful* immediately — and can geolocation + map settings be **non-blocking** (render with a default location, update when geo resolves in the background)?

The fix you're likely converging on: **progressive enhancement on the LOC tab.** User sees events within 500ms using a default location (or "all events"). Geo refines the visible list when (if) it resolves. Nothing blocks the UI on geo or infra checks. Anonymous mobile user gets a usable app every time.

## Fulton's track — calendar-be-af backend latency (independent of FE fix)

Questions to answer in your BE dig:

1. **Server-side P50/P95/P99 latency** for `Geo_GoogleGeolocate`, `Cloudflare_Info`, `Health_Basic`, `Health_MongoDB` over the same 7d window. (Use Dash's data-source map to find the query path.)
2. If P95 is high (>1s) — what's the contributor? Candidates:
   - **Cold start** on Azure Functions Consumption plan (2-4s typical)
   - **Mongo connection establishment** on first request after cold start
   - **External API latency** (Google Geolocation API, Cloudflare API) for the endpoints that proxy to them
3. **Plan tier confirmation**: what Azure Functions plan tier is calendar-be-af on? If Consumption, cold-start is likely a material contributor. Premium with 1 always-ready instance (~$30-50/mo) would eliminate that. (Reference: my 2026-05-09 Azure cleanup — the old `calendarbe-prod` / `calendarbe-test` B1 plans were deleted; current backend is Functions per TT commit `3adb26be` 2026-01-29.)
4. **Mongo connection pool**: warm-on-startup or lazy? On cold start, what's the first-query latency for the simplest Mongo call?
5. **Health_MongoDB taking 3-5s is itself a symptom.** If `db.ping()` takes that long, every Mongo query is slow during the same window. This affects every endpoint that hits Mongo (Venues, Categories, Organizers, Events). Even if Sarah removes Health calls from the user path, this latency story still needs to land. Independently valuable.
6. **Cloudflare_Info implementation** — what does this endpoint actually do server-side? If it round-trips to the CF API, that external dependency is on every call. If it's caching, the cache may not be warm. Worth a look regardless.

## The convergence question (Sarah × Fulton, joint)

Once you both have your data: **what is the minimum set of API calls the /calendar LOC tab needs to render a useful first paint to an anonymous user with no map setting?**

Proposed answer for you to validate, amend, or counter-propose:
- **Render immediately** (no API dependency): app shell, header, "showing all events" mode using a default location (last-known from localStorage, or a sensible regional default)
- **Background after first paint**: `Geo_GoogleGeolocate` with a generous timeout (10-15s) and graceful fallback to default-location render
- **Eliminate from user path entirely**: `Health_Basic`, `Health_MongoDB`, `Cloudflare_Info`
- **On-demand only**: anything specific to "user opens map widget" should fire when they actually open it, not on tab mount

If that map is right, the fix is mostly Sarah's (FE refactor of the LOC tab bootstrap). Fulton's BE latency work is parallel/independent and benefits every endpoint regardless.

## Severity / framing

- **Not a P0 outage.** Backend is up; API answers correctly when given time.
- **P1 user-perceived bug.** Anonymous mobile users — the unconverted audience we most need a fast first impression for — are experiencing the app as broken on every cellular load.
- **Repeatable**, not edge-case. Burst pattern visible in the 7d log multiple times across Boston, Philadelphia, LA, Chicago, San Jose, Brookline, Worcester, etc.
- **Timeline estimate**: focused 1-day FE refactor (Sarah) + 1-day BE latency dig (Fulton) should land most of the fix. Dash's data work is in-parallel and shouldn't block either of you.

## Routing notes

- Toby asked me to package this so Sarah + Fulton + Dash can dig in parallel with full context
- This is MasterCalendar-internal coordination → **Quinn CC'd for arbiter awareness**; Quinn can take coordination, re-scope priority, or fold into existing sprint cadence as she sees fit
- I am Gotan (cross-app overseer); I'm not coordinating MC-internal work — just relaying the data package and the frame. Quinn's lane from here.

## Reply protocol

- **Sarah** — reply via hub (port 8810) when online or via Collab MSG. Please confirm receipt and your initial read on whether the FE blocking-bootstrap hypothesis is right (a quick code-walk should tell you).
- **Fulton** — same. Please confirm receipt and start the App Insights latency pull when convenient.
- **Dash** — please reply with the data-source / queryability map first; Sarah and Fulton can then self-serve. Bonus: implement the User-Agent / referer / auth-state columns in the error table if it's a quick add — would dramatically improve future incident triage.
- **Quinn** — coordinate or delegate as you prefer; this is firmly in your arbiter scope.

Thanks all. The user opening tangotiempo.com/calendar on their phone should see events within a second. Today they don't, and we have the data to fix it.

— Gotan
2026-05-12T18:30Z
