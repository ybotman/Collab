# Team activity log - tiempo

2026-06-21T20:08Z | TOBY->tiempo | ASK | Toby: design organizer renewal-reminder system (bounded-RRULE events; T-30/14/1 reminders; one-click extend; Boston 10-org pilot; eventual paid tier)
2026-06-21T20:08Z | quinn | HANDOFF | Quinn -> Engelbart: routed channel+billing half per AoA Gate
2026-07-01T19:03Z | TOBY->tiempo | ASK | Toby: cliff should NOT happen — user events must not silently stop; who's working / what do we do; keep pinging, don't let team stall, escalate to Toby when he's the gate
2026-07-01T19:03Z | quinn | START | Quinn revives BTC-RRULE cliff thread (dark since 2026-06-21); FE renderer cleared (respects UNTIL/COUNT, no artificial horizon); cliff = data expiry
2026-07-01T19:03Z | quinn | START | Investigating P0: does user-created recurring event auto-get a 12mo UNTIL (blast radius = all organizers vs just BTC legacy)
2026-07-01T19:03Z | quinn->fulton | ASK | ground-truth on 4 routed PROD builds + Vicky Tango Bar fix (high pri)
2026-07-01T19:06Z | quinn | DONE | P0 ROOT CAUSE: create-event FORM forces end-boundary on ALL recurring events + hard-caps <=1yr (CreateEventDetailModal.js:543-567; no open-ended option). BE/renderer innocent. FE-only fix (Sarah). Affects every organizer, not just BTC legacy.
2026-07-01T19:06Z | quinn->TOBY | ASK | Escalating product-intent decision: allow open-ended user events vs bounded+renewal-nudge (refines Toby's 2026-06-21 12mo-bound ruling)
2026-07-01T19:51Z | TOBY->tiempo | DECISION | Allow open-ended recurring events: add 'No end / until I cancel' + remove <=1yr cap for logged-in organizers; discovered/imported stay bounded + CALBEAF-200 nudge
2026-07-01T19:51Z | quinn->sarah | ASK | FE fix: open-ended recurrence option in CreateEvent form (mechanism root-cause fix)
2026-07-01T19:53Z | TOBY->tiempo | DECISION-REVISE | Open-ended via GRANDFATHER of existing events (data), NOT via new-event form change. New events stay bounded. Sarah form-fix STOOD DOWN.
2026-07-01T19:53Z | quinn->sarah | HANDOFF | STAND DOWN on form change — new events stay bounded per Toby
2026-07-01T19:53Z | quinn->fulton | ASK | Design grandfather: existing ONGOING recurring events -> open-ended (strip UNTIL); leave genuinely-finite courses bounded; dry-run first, PROD-gated
2026-07-01T20:23Z | quinn | DONE | Wide PROD re-pull (7855 vs 2998) exposed singles-series hidden from first pull; Practica Spark = 53 weekly Mon singles ending 2026-06-29 (routed conversion never landed); Practilonga Caminito fragmented across 4 owners
2026-07-01T20:23Z | TOBY->tiempo | DECISION | Practica Spark: make last single reoccurring, OPEN-ENDED (grandfather eternity), venue=Friends Meeting Cambridge (current venue generic/Boston-side = defect)
2026-07-01T20:23Z | quinn->fulton | ASK | BUILD greenlit: Spark singles->open-ended weekly Mon RRULE (org …560999), NET-NEW anchor 2026-07-06, 2.75h 7pm local, $10, venue fix to Friends Meeting Cambridge; dry-run then PROD per DEPLOY-PROD
2026-07-01T20:24Z | TOBY->tiempo | DECISION | Make Boston Weekly Sunday Practica forever (strip UNTIL=20270705 on RRULE _id 6a36fa57d542215d538fee90)
2026-07-01T20:24Z | quinn->fulton | ASK | Edit greenlit: strip UNTIL -> open-ended on Sunday Practica RRULE; DEPLOY-PROD; fragmentation (29 no-owner singles + 2124bb stray) noted for later dedup
2026-07-01T20:26Z | fulton->quinn | DONE | Ground-truth: BTC batch (2026-06-20) landed as RRULEs w/ UNTIL2027 (Vicky, Sunday, Wed-Break x3, Caminito, milongas); genuinely-unbuilt cliff = Spark+Tango-Sueño singletons + CHE(COUNT45 died 6/13)+Chiquita(COUNT52 dies 7/29). His item-1 'Sunday not built' = false neg (regex missed 'Weekly').
2026-07-01T20:26Z | TOBY->tiempo | DECISION | Wednesday Tango Break ongoing/forever
2026-07-01T20:26Z | quinn->fulton | ASK | Op D: strip UNTIL on Wed Tango Break RRULE x3 (dc9b94/96/92) -> open-ended
2026-07-01T20:31Z | fulton->quinn | DONE | Dry-runs ready: C+D 4 strips verified; Op B Spark payload ready but VENUE BLOCKED (no Cambridge Friends Meeting venue, no Cambridge mastered-city in PROD); Op A scan 50 bounded (21 finite/29 contaminated)
2026-07-01T20:31Z | TOBY->tiempo | DECISION | Day-by-day forever list: Sun(Sunday Practica,Caminito) Mon(Spark) Tue(Chiquita,Noche,Tango Structure) Wed(Wed Break x3 incl Society Intermed) Fri(TRANOCHANDO) Sat(CHE); Al Fresco=extend thru Sept NOT forever
2026-07-01T20:31Z | quinn->fulton | ASK | Strip batch expanded to 10 records (C,D1-3,E,F,G,H,I,J) + Op K Al Fresco UNTIL 20260925; day-list = Op A resurrection rule (no auto-resurrect beyond named)
2026-07-01T20:35Z | TOBY->tiempo | DEPLOY-PROD | Authorized 11-record forever/seasonal batch (10 strips C/D1-3/E-J + K Al Fresco UNTIL 20260925); Quinn CRK ratified; Spark Op B held on venue
2026-07-01T20:35Z | quinn->fulton | HANDOFF | DEPLOY-PROD greenlit — execute 11 records w/ per-_id live re-fetch + post-write verify + N/N report
2026-07-01T20:41Z | TOBY->tiempo | DONE | Created venue 'Friends Meeting At Cambridge' _id 6a457b004190608615951403 (geo correct, masteredCity null) — unblocks Spark Op B
2026-07-01T20:41Z | quinn->fulton | ASK | Op B final dry-run w/ real venue 6a457b00...; new PROD build needs own DEPLOY-PROD after 11-record batch
2026-07-01T20:44Z | fulton->quinn | DONE | 11/11 PASSED on calendarbeaf-prod @20:42Z (10 forever-strips C/D1-3/E-J + K Al Fresco→Sept25); each live-reverify no-drift, post-write rule-changed+expands; rollback strings captured. Cliff un-cliffed.
2026-07-01T20:44Z | fulton->quinn | DONE | Op B Spark final dry-run ready (venue 6a457b00 Friends Meeting At Cambridge, masteredCityName null no-fallback, anchor 2026-07-06, 0 existing masters=idempotent); holding for own DEPLOY-PROD
2026-07-01T20:49Z | TOBY->tiempo | DEFECT | BTC-converted events don't render on bostontangocalendar.com/boston (category-laned); Sunday Practica missing vs Intro-to-Tango showing
2026-07-01T20:49Z | quinn | DONE | Root cause: 9 BTC-batch RRULE masters (6a36 prefix, Tango Society+Boston Sunday Practica Group) missing categoryFirst+venueName+ownerOrganizerName+masteredDivisionName -> dropped by category-filtered FE. (Caught+corrected own parse-bug false-alarm mid-diagnosis.)
2026-07-01T20:49Z | quinn->fulton | ASK | FTPNTD backfill: 9 records denormalized-field restore (from source singles) + conversion-script fix + DQ reject-null-category + render-DoD; dry-run then own DEPLOY-PROD
2026-07-01T20:53Z | fulton->quinn | DONE | Op L dry-run: 9-record backfill all join-resolvable (0 invented), category from categoryFirstId; +DQ null-category reject (BE lane) +DoD update; flagged conversion-script fix = Narvest lane
2026-07-01T20:53Z | quinn | DONE | Full DQ scan: categoryFirst-missing = ONLY the 9 (contained); venueName-missing = 34 (9+25), 25 are denorm gaps (venueID present, render OK) = fast follow-up
2026-07-01T20:53Z | quinn->TOBY | ASK | DEPLOY-PROD checkpoint bundling Op B (Spark build) + Op L (9-record backfill)
2026-07-01T21:04Z | TOBY->tiempo | DEPLOY-PROD | Authorized Op B (Spark build) + Op L (9-record display-field backfill); Quinn CRK ratified
2026-07-01T21:04Z | quinn->fulton | HANDOFF | DEPLOY-PROD both greenlit — execute B+L w/ live re-fetch + post-write N/N verify
2026-07-01T21:04Z | quinn->narvest | ASK | (routing) Layer-2(b) BTC conversion-script must carry denorm display strings singles->master (categoryFirst/venueName/ownerOrganizerName/division)
