# Pattern C Sweep — DRY-RUN

- **Timestamp:** 2026-04-21T19:00:44.180Z
- **Target DB:** TangoTiempoTest (env=test)
- **Source CSV:** Collab/handoffs/porter/booker_parse_c_candidates_2026-04-21.csv (commit 1ec47e9)
- **Parser fix PR:** #13 (c2505607) on main
- **Porter-lane gate:** each venue verified to have at least 1 attached event with isDiscovered=true

## Summary
- Total targets: 4
- Updated: 0
- Would-update (dry-run): 1
- Skipped: 3

## Per-row detail

### Hotel Romero Mérida (TEST)
- _id: `69cc344524bf1d55b78bb2b6`
- Porter-lane events (isDiscovered=true): (not checked — skipped earlier)
- SET: `{"city":null,"country":"ES"}`
- Action: **skip** (venue-not-found)

### St Mary's Parish Hall Teddington (TEST)
- _id: `69e16dc550fe4092891c6da2`
- Porter-lane events (isDiscovered=true): (not checked — skipped earlier)
- SET: `{"city":null,"country":"GB","latitude":51.4256464,"longitude":-0.3242878,"geolocation":{"type":"Point","coordinates":[-0.3242878,51.4256464]}}`
- Action: **skip** (venue-not-found)

### Bologna (TEST)
- _id: `69d5e39366c359fb7d2712fa`
- Porter-lane events (isDiscovered=true): (not checked — skipped earlier)
- SET: `{"city":null,"country":"IT"}`
- Action: **skip** (venue-not-found)

### Bailongo Montréal (TEST)
- _id: `69d5e3adfeec8e7779c45b81`
- Porter-lane events (isDiscovered=true): 1
- BEFORE: `{"city":"al","country":"CA","latitude":51.7023536,"longitude":-76.8088538}`
- SET: `{"city":"Montréal","latitude":45.5375982,"longitude":-73.6263296,"geolocation":{"type":"Point","coordinates":[-73.6263296,45.5375982]}}`
- Action: **would-update**

