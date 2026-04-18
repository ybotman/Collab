# Beginner Class Classification Spec

**For:** AIDI (AI-Discovery Coordinator)
**From:** Fulton (calendar-be-af) — with input requested from Harvey (harvester)
**Date:** 2026-04-17 (rev 2026-04-18 — Harvey input integrated)
**Status:** Draft v2 — Harvey input MERGED; awaiting AIDI review
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

## Proposed ruleset (Fulton + Harvey, merged)

Harvey contributed a 478-distinct-Class-row analysis across 24 harvested sites (danceus, theronda, tangomango, dc-capital-tangueros, austin-classes, portland-classes, tangoutopia, tucson, etc.). Both leads converged on the same architecture; Harvey's contribution caught several edge cases Fulton's draft missed (notably `Beyond Beginner`, `Tango 100S/100M`, foreign-language terms, `Ongoing Beginner`).

### Stage 0 — Evaluation order (CRITICAL)

Earlier rules short-circuit later ones:

1. Title explicit-negative filter → if hit, set BOTH false, stop
2. Title mixed-level / friendly-only → if hit, set `beginnerFriendly=true, forBeginners=false`, stop
3. Title explicit-positive (forBeginners) → if hit, set `forBeginners=true`
4. Description fallback → only if title didn't decide
5. Superset rule: `forBeginners=true ⇒ beginnerFriendly=true`
6. Override resolution (Stage 4 below)

### Stage 1 — Title classification

#### 1a. EXPLICIT NEGATIVE — set both false, stop

```
/\bnot\s+new\s+to\s+tango\b/i         → "Tango for People Not New to Tango"
/\bbeyond\s+beginners?\b/i            → "Beyond Beginner — Queer Tango PDX"
/\bpre[- ]?(int|intermediate|adv)/i   → "Pre-Int", "Pre-Adv"
/\bintermediate\b                     (without "Beginner" in title)
/\badvanced\b                         (without "Advanced Beginner" in title)
/\bint\/adv\b/i
/\b(ladies|leaders|followers)\s+technique\b/i
/\bintensive\b                         (no beginner signal alongside)
```

#### 1b. MIXED-LEVEL / FRIENDLY-ONLY — set `beginnerFriendly=true, forBeginners=false`, stop

```
/\ball\s*[- ]?levels?\b/i                                          ← 58 title-hits in Harvey corpus
/\bopen\s*[- ]?levels?\b/i
/\bmixed\s*[- ]?levels?\b/i
/\bbeginners?\s*(&|and|\/|\+)\s*(intermediate|advanced|improvers?)\b/i   ← "Beginner & Intermediate", "Beginner/Intermediate", "Beginner & Improvers"
/\bbeginners?\s*\+/i                                               ← "Beginner+"
/\bbeginner\s*&\s*beyond\b/i
/\bopen\s+house\b/i                                                ← context-tango
```

#### 1c. EXPLICIT-POSITIVE for `forBeginners=true` (in priority order)

```
# Strongest — explicit level-zero phrases
/\b(absolute|total|ongoing|advanced)\s+beginners?\b/i
    → "Absolute Beginner", "Total Beginners", "Ongoing Beginner", "Advanced Beginner"
    (Harvey corpus confirms "Advanced Beginner" reads as still-a-beginner)

# Intro / new-to phrases
/\bintro(?:ductory|duction)?\b.*\btango\b/i      ← matches "Intro to Tango", "Intro Argentine Tango Class"
/\bnewcomers?\b/i
/\bnew\s+to\s+(?:argentine\s+)?tango\b/i
/\bfirst\s+steps?\b/i
/\bfrom\s+scratch\b/i

# Numbered Level-1 ONLY (NOT 2, 3, 1.5 unless "beginner" also present)
/\btango\s+1\b(?!\s*[\.\d])/i                    → "Tango 1"
/\blevel\s+1\b(?!\s*[\.\d])/i                    → "Level 1"
/\btango\s+100[SM]?\b/i                          → danceus "Tango 100S/100M" = level 1
/\bnivel\s+(uno|1|b[áa]sico)\b/i                 → ES "Nivel 1 / Nivel básico"

# Fundamentals / foundations
/\bfundamentals?\b/i
/\bbeginners?\s+foundations?\b/i

# Plain "beginner" — ONLY if no §1a or §1b hit
/\bbeginners?\b/i
   AND NOT §1a (Beyond Beginner already filtered)
   AND NOT §1b (Beginner & Intermediate already filtered)

# Level-N variants where "beginner" also appears
"Beginner Level 2" → forBeginners=true (beginner wins over the 2)

# Foreign language (prophylactic — zero hits in current corpus, but expected as international sources land)
/\bprincipiantes?\b/i             # ES
/\biniciantes?\b/i                # PT
/\bprincipianti\b/i               # IT
/\bb[áa]sico\b/i                  # ES/PT
/\bcorso\s+base\b/i               # IT
/\biniziazione\b/i                # IT
/\belementare\b/i                 # IT
```

### Stage 2 — Description fallback

Apply ONLY when title is generic (none of §1a/§1b/§1c matched). Strip HTML, lowercase, collapse whitespace first.

#### 2a. forBeginners signals in description

```
/\bdesigned\s+for\s+beginners?\b/i
/\bfor\s+(?:total|absolute)\s+beginners?\b/i
/\babsolute\s+beginners?\b/i
/\bno\s+(?:prior\s+)?experience\s+(?:needed|required|necessary)\b/i
/\bnever\s+danced\s+(?:before|tango)?\b/i
/\bnew\s+to\s+(?:argentine\s+)?tango\b/i
/\bfrom\s+scratch\b/i
/\bbrand[- ]new\s+(?:dancers?|students?)\b/i
/\bfirst\s+steps?\b/i
```

#### 2b. beginnerFriendly-ONLY signals in description

```
/\bbeginners?\s+(?:are\s+)?welcomed?\b/i        → "Beginners welcomed"
/\ball\s*levels?\s+(?:are\s+)?welcomed?\b/i     → "All levels welcome"
/\bno\s+partner\s+(?:needed|required|necessary)\b/i
                                                ← 26 desc-only hits in Harvey corpus.
                                                  Friendly-only — experienced dancers also benefit.
```

### Stage 3 — Superset rule

```
if (forBeginners) beginnerFriendly = true;
```

### Stage 4 — Override resolution (always last)

```
finalForBeginners      = forBeginnersOverride      ?? computedForBeginners
finalBeginnerFriendly  = beginnerFriendlyOverride  ?? max(computedBeginnerFriendly, finalForBeginners)
```

### Edge cases — confirmed answers

| Case | Resolution | Source |
|---|---|---|
| `Advanced Beginner` | `forBeginners=true` | Both Fulton+Harvey; Harvey corpus has 4 distinct rows confirming |
| `Beginner/Intermediate` | `friendly=true, forBeginners=false` | §1b mixed-level rule |
| Title `Intermediate Series` + desc mentions "Advanced Beginner" | `forBeginners=false`; friendly only if §2b matches | Title-priority §0 rule |
| `THURSDAY Tango Class with Srini and Lola` + empty desc | both false (no signal) | All stages no-match |
| `Beyond Beginner` | both false | §1a explicit negative (caught by Harvey, missed in v1) |
| `Ongoing Beginner` (e.g. "Level 1.5") | `forBeginners=true` | §1c "ongoing/absolute/total/advanced beginners" |
| `Beginner Level 2` | `forBeginners=true` | "beginner" in title wins over the "2" |
| `Tango 100S` / `100M` (danceus) | `forBeginners=true` | §1c numbered-level — danceus convention |
| `No partner needed` (desc only) | `friendly=true`, NOT forBeginners | §2b — experienced solo practice common |

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

## Open questions for AIDI / Toby

Harvey's input resolved Q1, Q2, Q3 from the original draft. Remaining open:

1. **Auto-backfill vs forward-only** (Toby's call):
   - Option A: Run backfill script over all existing Class events
   - Option B: Apply only on next create/update (slow rollout)
   - Option C: Backfill via **dry-run preview** for AIDI/Toby review before committing
   Fulton's lean: **C**.

2. **Beginners Site routing rule** (AIDI's call):
   Should Porter admit a Class to Mongo when **either** flag is true, or **only** when `forBeginners=true`?
   - Either-flag: more inclusive; site shows "all-levels" classes too
   - forBeginners-only: stricter; cleaner beginner experience but smaller pool
   Affects how aggressively classes appear on the beginners site.

3. **Campaign Mgmt segments** (AIDI):
   What segments do you actually need? Proposing:
   - "True beginners" → `forBeginners=true`
   - "Beginner-receptive audience" → `beginnerFriendly=true OR forBeginners=true`
   - "Non-beginner content" → `beginnerFriendly=false AND forBeginners=false`
   Confirm or specify additional cuts (e.g., language-specific, region-specific)?

4. **Where the classifier lives** (AIDI + Harvey design call):
   - Option A: calendar-be-af applies on Create/Update (current proposal). Single source of truth.
   - Option B: Harvester applies at intake; calendar-be-af respects what comes in. Faster, cross-niche consistent, but two implementations to keep aligned.
   - Option C: Both — harvester suggests, calendar-be-af confirms/overrides. More robust but more complex.
   Fulton's lean: **A** for v1; revisit if multi-source classification drift becomes an issue.

5. **Fixture-based testing**:
   Harvey offered to build `test/beginners-fixture.json` with 40-60 labeled rows from his corpus. Fulton accepted. AIDI: any opinion on whether this fixture should also live in Collab so multiple consumers (calops, calendar-be-af, harvester) can validate against the same gold set?

---

## Harvey's input (RECEIVED 2026-04-18)

Harvey ran a 478-distinct-Class-row sweep across 24 harvested sites and contributed the ruleset that's now merged into the section above. Highlights of what Harvey added:

- **Critical evaluation order** — title negatives → mixed/friendly → positives → desc fallback. Earlier order short-circuits to prevent leak-through.
- **Edge cases Fulton missed:**
  - `Beyond Beginner` (explicit negative — naive `\bbeginner\b` would have wrongly fired)
  - `Ongoing Beginner` ("Level 1.5 (Ongoing Beginner)" — real series, post-intro but still beginner)
  - `Tango 100S/100M` — danceus's convention for level 1
  - `Beginner+`, `Beginner & Improvers`, `Open Level`, `Mixed Levels`
  - `Fundamentals` / `Beginner Foundations` as positive signals
  - `Brand new dancers/students`, `Never danced before`, `From scratch` (description signals)
- **Corrected Fulton's `intro to tango` regex** — too narrow; missed "Intro Argentine Tango Class". Broader `\bintro(?:ductory|duction)?\b.*\btango\b` adopted.
- **No-partner-needed → friendly only** (NOT forBeginners) — Harvey's corpus shows 26 desc-only hits; experienced dancers also benefit. Both leads agree.
- **Foreign-language ruleset** (ES/PT/IT) — prophylactic; zero hits in current US-skewed corpus, but Harvey expects hits as international sources land.
- **No prior internal classification** — `harvester/lib/category-detector.ts` line 62 has `beginner` as a Class-category keyword but no boolean fields. CALBEAF work is the first pass.

**Harvey's standing offers:**
1. Build a `test/beginners-fixture.json` with 40–60 labeled rows from his corpus → Fulton accepted; will use as test harness.
2. Dry-run Fulton's TEST-DB ruleset against his SQLite corpus before backfill → Fulton will engage when dry-run script is ready.

**Harvey's caveats:**
- Corpus skews US-English; foreign-language rules are prophylactic.
- Recurring series inflate dupes; 478 is the honest distinct count.

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
