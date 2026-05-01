# Porter baseline — historical Mongo state (2026-05-01)

**Companion to:** `handoffs/harvey/dry-run-2026-05-01.json` (Harvey's unloaded queue).
**Together:** full Harvey-side parity surface for niche-harvest's diff in Stage 2+.

## Generated

- **At:** 2026-05-01T18:24:19Z
- **By:** Porter (one-off, in response to Stage 2 cutover bilateral closure ask)
- **Source:** direct read from `TangoTiempoTest` + `TangoTiempoProd` events collections
- **Filter:** `appId='1' AND discoverySource ∈ {porter-harvey, porter-booker} AND startDate >= now AND isDiscovered=true`

## File

- `porter-baseline-mongo-2026-05-01.json` — 8.8 MB, 13,077 events total

## Counts

### TEST (TangoTiempoTest) — 6,274 events
| discoverySource | rows |
|---|---|
| porter-harvey | 6,223 |
| porter-booker | 51 |

### PROD (TangoTiempoProd) — 6,803 events
| discoverySource | rows |
|---|---|
| porter-harvey | 6,761 |
| porter-booker | 42 |

## Top categories (PROD, illustrative)

| categoryFirst | rows |
|---|---|
| Milonga | 3,248 |
| Practica | 1,818 |
| Class | 1,192 |
| Festival | 239 |
| Marathon | 112 |
| Workshop | 91 |
| Encuentro | 32 |
| Trip | 5 |

## Top countries (PROD by masteredCountryName)

| Country | rows |
|---|---|
| United States | 4,613 |
| Australia | 1,337 |
| United Kingdom | 157 |
| Czechia | 130 |
| Poland | 37 |
| France | 36 |
| Spain | 27 |
| Austria | 15 |
| Slovenia | 13 |
| Turkey | 12 |
| Italy | 11 |
| Germany | 10 |
| (null) | 322 |

`(null) masteredCountryName` is correct per Toby's 2026-04-19 no-fallback rule (mastered fields null = write nothing).

## Per-row shape

```jsonc
{
  "_id": "ObjectId stringified",
  "discoverySource": "porter-harvey" | "porter-booker",
  "title": "...",
  "startDate": "ISO string",
  "endDate": "ISO string",
  "venueName": "..." | null,
  "venueCityName": "..." | null,
  "lat": number | null,
  "lng": number | null,
  "masteredCityName": "..." | null,
  "masteredCountryName": "..." | null,
  "categoryFirst": "..." | null,
  "categorySecond": "..." | null,
  "categoryThird": "..." | null,
  "source": "..." | null
}
```

## Notes

- Two minor case-inconsistency oddities surfaced: `MARATHON` (1) coexists with `Marathon` (112+144), `WEEKEND` (1) appears once. Pre-existing data quality artifacts; not related to this snapshot.
- TEST and PROD both show `Czechia: 130` — that's the prague-* historical load (pre-2026-04-30 country-fix patch). Re-loadable to clean state once `sandbox/2026-04-30-harvey-prague-country-fix` lands.
