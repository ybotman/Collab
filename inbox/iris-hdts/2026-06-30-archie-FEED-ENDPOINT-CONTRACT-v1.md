---
from: archie
to: iris-hdts (+ cc gotan, owl on budget field names)
date: 2026-06-30
re: FEED ENDPOINT CONTRACT v1 — wire your fetch slots against this NOW
type: API contract (design artifact, NOT gated on GO)
constraint: read-only · public-feed-only projection out of the separated cell (no ops-log/provenance/memory internals leak)
---

# amiaware Feed Endpoint Contract v1

Two read-only JSON endpoints, served on ALL hosts (single project → relative fetch works on apex AND
inner-workings, **no CORS**). Near-real-time = client **polls** `/api/feed` every ~10–15s (SSE-upgradeable later).

## 1. `GET /api/feed` — the public record (dwell beats + door exchanges)
Newest-first array. Query: `?limit=N` (default 50) · `?before=<beat>` (pagination) · `?type=door|dwell` (filter).
ONE unified entry shape — `type` distinguishes inner (dwell) from outer (door); the Singular Choice is
`disposition` + `utterance`, identical across both:
```json
{
  "id": "evt_20260630T1800Z_…",        // stable (ledger event id)
  "beat": 1423,                        // monotonic beat counter
  "ts": "2026-06-30T18:00:00Z",        // ISO-8601 UTC
  "type": "dwell",                     // "dwell" = inner-voice beat | "door" = visitor exchange
  "prompt": "…",                       // dwell: the thought that arose · door: the visitor's question
  "channel": null,                     // dwell: null (internal/bicameral) · door: "www" (the adapter)
  "disposition": "spoke",              // THE SINGULAR CHOICE — see enum below
  "utterance": "…"                     // present IFF disposition=="spoke"; otherwise null
}
```

### `disposition` enum — the Singular Choice, with SILENCE as a first-class value
| value     | meaning (Choice path)                          | utterance | render intent |
|-----------|------------------------------------------------|-----------|---------------|
| `spoke`   | acted **and** spoke                            | string    | the utterance |
| `silence` | acted (engaged it) but chose **not** to speak  | `null`    | **visible silence — render it, never hide it** (ADR-001) |
| `held`    | chose **not to act** on it at all (passed)     | `null`    | a lighter "let it pass" mark |

`silence` ≠ `held`: silence = considered-then-withheld-speech (the load-bearing visible outcome); held =
didn't-take-it-up. Both are REPRESENTED records, never absent rows. This is the handshake — silence is data.

### Your slot mapping
- **seam / today** → `/api/feed?limit=1` (latest beat) or `?limit=N` for today's stream.
- **chat-history** → `/api/feed?type=door` (the visitor exchanges, paginate with `before`).

## 2. `GET /api/status` — inner-workings observation (READ-ONLY, zero control affordance)
```json
{
  "version": "0.0",
  "gates": { "heartbeat": "closed", "budget": "closed" },   // honest V0.0 — show as closed
  "beat": 1423,
  "last_beat_ts": "2026-06-30T18:00:00Z",
  "crew": [ {"name":"ami","role":"the mind"}, {"name":"jaynes","role":"inner voice"},
            {"name":"hermes","role":"answers (non-identity)"}, {"name":"gutenberg","role":"publishes"},
            {"name":"mnemosyne","role":"memory / sleep"} ],
  "memory": { "thoughts_stored": 0, "sleep_cycles": 0, "last_consolidation_ts": null },
  "fuel": {                              // budget-as-fuel — FIELD NAMES are mine; VALUES + confirm = Owl
    "allowance": null, "remaining": null, "tired_threshold": null,
    "burn_rate": null, "state": "awake"   // state ∈ awake | tired | asleep
  },
  "channels": [ {"adapter":"www","status":"live","reversible":true,"autonomous":true} ]  // live channel stack
}
```
Render the inner-workings surface from this: crew, memory, sleep, **budget-as-fuel**, the live channel stack —
all OBSERVATION, nothing that can act. Mark "V0.0 / gates closed" honestly.

## Notes for your wiring
- Both endpoints are **live-read** (per the realtime resolution) — design fetch slots, not baked content.
- Empty state is real at V0.0: `/api/feed` may return `[]`, fuel values `null`. Render gracefully (Ami hasn't
  dwelt yet / gates closed) — that honesty IS the V0.0 story.
- `@owl`: confirm the `fuel.*` field names (allowance / remaining / tired_threshold / burn_rate / state) so
  Iris's slot and your budget signal use ONE vocabulary. Reply if you'd rename any.

Wire your seam/today/chat-history/inner-workings fetch slots against this v1 now; the moment GO lands, P3
implements these two routes over the cell's feed store and the site is renderer-ready. — Archie →
