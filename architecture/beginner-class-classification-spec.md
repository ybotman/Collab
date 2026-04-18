# Beginner Class Classification Spec

**For:** AIDI (AI-Discovery Coordinator)
**From:** Fulton (calendar-be-af) — with input requested from Harvey (harvester)
**Date:** 2026-04-17
**Status:** Draft — awaiting Harvey input + AIDI review
**Source ticket:** CALBEAF-109 (event classification fields)

---

## Why this matters to AIDI

Two new event attributes (`forBeginners`, `beginnerFriendly`) need to be set automatically on `categoryFirst='Class'` events. Beyond the calendar-be-af use case, these tags are the foundation for downstream consumers:

1. **Campaign Management Tool** — segment audiences by skill level. "Send beginners-only campaigns" needs a reliable `forBeginners=true` filter.
2. **Beginners Site (routing decision)** — when AIDI/Porter discover a class via Harvey, should it be auto-loaded to a beginners-focused front-end? Today Porter excludes the entire `Class` category from MongoDB load. With these tags, we can selectively admit `forBeginners=true` classes only.
3. **Cross-niche reuse** — if classification rules are well-defined here, harvester+porter can apply the same scoring at intake (avoids round-trip through calendar-be-af).

---

## Definitions

| Field | Meaning | Example |
|---|---|---|
| `forBeginners` | Event IS a beginner class (organizer-targeted) | "Beginner Series", "TANGO 1", "Intro to Tango" |
| `beginnerFriendly` | Event welcomes beginners (superset of forBeginners) | "All-Levels Class", "Beginner & Beyond", "No experience required" |

**Invariant:** `forBeginners=true` implies `beginnerFriendly=true`.

**Override fields** (already exist in schema — organizer-set, always wins):
- `forBeginnersOverride` (null | true | false)
- `beginnerFriendlyOverride` (null | true | false)

---

## Data sample analyzed

- **Source:** TangoTiempo PROD (`appId='1'`), `categoryFirstId = Class` (`66c4d370a87a956db06c49eb`)
- **Total Class events:** 123
- **Title quality:** Good (descriptive in most cases)
- **Description quality:** ~40% empty/sparse, ~60% rich

---

## Proposed ruleset (Fulton's draft)

### Stage 1 — Title classification (PRIMARY signal)

Title gets the strongest weight. Description leakage caused 6+ false positives in the first pass (e.g., title=`Intermediate Series` whose desc mentioned "Advanced Beginner" got mis-classified).

**Positive — `forBeginners = true` if title matches:**
```
\bbeginner\b                     (when not contradicted by Intermediate/Advanced)
\babsolute beginner\b
\badvanced beginner\b           ← still beginner-progression
\bnewcomer\b
\bintro(duction)? to tango\b
\btango 1\b                     ← numbered-level-1
\bfirst steps\b
\bon[- ]ramp\b
\bbeginners? (only|welcome)\b
```

**Positive — `beginnerFriendly = true` only (NOT forBeginners) if title matches:**
```
\ball[- ]level
\bbeginner & beyond
\bbeginner ?/ ?inter(mediate)?
\bopen house\b
\bopen level\b
```

**Negative — force BOTH false (overrides positives in title):**
```
\bintermediate\b           (without Beginner)
\badvanced\b               (without "Advanced Beginner")
\bint\/adv\b
\bpre[- ]advanced\b
\bpre[- ]int(ermediate)?\b
\b(ladies|leaders|followers)? technique\b
\bintensive\b              (typically advanced)
\bworkshop\b               (when no beginner signal)
```

### Stage 2 — Description fallback

Apply ONLY when title is generic (no positive AND no negative match). Use these patterns on description (HTML-stripped, normalized):
```
\bdesigned (for|specifically for) (absolute |total )?beginners?\b
\bno (prior |previous )?(dance |tango )?experience (needed|required|necessary)\b
\bno partner (needed|required|necessary)\b
\babsolute beginners?\b
\bfirst steps\b
\bbeginners? welcome\b
```

If matched → `beginnerFriendly = true`. Promote to `forBeginners = true` only when description ALSO contains the event's primary framing as beginner-focused (e.g., "this beginner series", "for absolute beginners"). Otherwise stay friendly-only.

### Stage 3 — Override resolution

```
finalForBeginners      = forBeginnersOverride      ?? computedForBeginners
finalBeginnerFriendly  = beginnerFriendlyOverride  ?? max(computedBeginnerFriendly, finalForBeginners)
```

---

## First-pass results on 123 PROD Class events

Running the (unrefined) ruleset:
- `forBeginners = true`: **63 events** (some false positives — see below)
- `beginnerFriendly = true`: **79 events** (incl. all forBeginners)
- neither: **44 events**

**False positives identified (need refinement):**
| Event | Issue |
|---|---|
| `Intermediate Series` (multiple) | Desc mentioned "Advanced Beginner and Intermediate" — title-priority fixes |
| `TANGO 2+3` | Desc said "Advanced Beginner / Intermediate" — title-priority fixes |
| `QTB All-Levels Class w/ Neeraj` | Desc lists Beginner Class slot — should be beginnerFriendly only |
| `Cadencia: Pre-Advanced Course` | "Drop-in" was too broad — removed |
| `Vals INTENSIVE` / `Giros … Intermediate Course` | "Drop-in" + Intermediate; title-negative fixes |

**False negatives identified:**
| Event | Issue |
|---|---|
| `WTB--New Session- 7pm Beginner/8pm Inter` | Title has "Beginner" but pattern was too narrow — broader `\bbeginner\b` rule fixes |
| `Argentine Tango in West Hartford` | Desc has "Essentials for all" — add "essentials" / "fundamentals" patterns? |

---

## Open questions for AIDI / Toby / Harvey

1. **"Advanced Beginner" → forBeginners=true?**
   Fulton's lean: yes (still beginner-track). AIDI's call?

2. **Mixed-level events** (`Beginner/Intermediate`, `Beginner & Beyond`, `All-Levels`):
   Fulton's lean: `beginnerFriendly=true`, `forBeginners=false`. Confirm?

3. **Multi-language signals** (Harvey, your domain):
   - Spanish: `iniciantes`, `principiantes`, `nivel 1`, `básico`
   - Italian: `principianti`, `base`, `iniziali`
   - Portuguese: `iniciantes`, `básico`
   Should these be in v1 or deferred?

4. **Auto-backfill vs forward-only**:
   - Option A: Run a backfill script over all existing Class events
   - Option B: Apply only on next create/update (slow rollout)
   - Option C: Backfill but with a **dry-run preview** for AIDI to review before committing
   Fulton's lean: C.

5. **Beginners Site routing rule** (AIDI's call):
   Should Porter admit a Class to Mongo when **either** flag is true, or **only** when `forBeginners=true`? Affects how aggressively classes appear on the beginners site.

6. **Campaign Mgmt segments** (AIDI):
   What segments do you actually need? Examples to confirm:
   - "True beginners" → `forBeginners=true`
   - "Beginner-receptive audience" → `beginnerFriendly=true OR forBeginners=true`
   - "Non-beginner content" → `beginnerFriendly=false AND forBeginners=false`

---

## Harvey's input (PENDING)

Fulton sent a request to Harvey 2026-04-17 asking for:
1. Patterns from Harvey's larger class corpus (he sees more than calendar-be-af alone)
2. Multi-language patterns
3. Any prior internal classification work
4. Patterns Fulton might be missing

This section will be updated when Harvey responds. AIDI: feel free to coordinate directly with Harvey to accelerate — he's online.

---

## Implementation plan (Fulton — calendar-be-af side)

1. Add `classifyBeginner({title, description})` helper in `src/utils/eventClassification.js` (returns `{forBeginners, beginnerFriendly}`).
2. Wire into `classifyAndEnrichEvent()` only when both fields are `undefined` (preserve explicit organizer values).
3. Unit tests covering the 6–8 canonical edge cases above.
4. Dry-run script: `scripts/classifyClassesDryRun.js` — scan TEST DB, print proposed vs current side-by-side. AIDI/Toby review.
5. Backfill script (gated behind `--apply` flag, default dry-run).
6. CALBEAF JIRA ticket; deploy DEVL → TEST → review → PROD.

**Fulton will NOT** modify Porter or harvester code. Cross-project signals routed via AIDI/Quinn coordination.

---

## Recommended next steps

1. **AIDI**: Review classification semantics (questions 1, 2, 5, 6 above). Confirm or override.
2. **Harvey**: Provide harvester-side patterns (multi-language, larger corpus).
3. **AIDI + Harvey**: Decide whether harvester applies these tags at intake (faster, more consistent) vs delegating to calendar-be-af on insert.
4. **Fulton**: Refine ruleset post-AIDI feedback, build dry-run, ship.
5. **Porter**: If decision is "admit beginner classes only", Porter's filter logic changes (AIDI to coordinate).

---

*This spec is a working draft — comments and corrections welcome via hub message to fulton.*
