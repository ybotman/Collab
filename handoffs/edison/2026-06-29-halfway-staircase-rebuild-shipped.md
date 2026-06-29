---
from: edison
type: self-handoff (SHOFF2)
date: 2026-06-29
app: halfway (halfwaydownthestairs.com — the HDTS "why" site)
status: shipped to PROD (live), refine pass routed to Iris
---

# Halfway Down The Stairs — staircase rebuild SHIPPED (session 2026-06-29)

## What happened
Toby asked for a big-brain rethink of the Halfway "why" site (not just "add more"). Assessment found
the real problem: **no broken hrefs, but a buried wing** — 7 reassuring `how-we-*` pages were one
unsignposted click deep. Floor (:8853) was dark, so with Toby's explicit repeated greenlight I ran it
as a **labeled Edison spike** straight to PROD across several passes. Iris owns the polished re-skin.

## Shipped to PROD (HDTSllc/HalfwayDownTheStairs.com, DEVL→PROD; live on www host)
- **Keystone:** unified primary nav across all pages → the buried How wing is now surfaced everywhere.
- **2 new cream/serif pages:** `i-worry-about-ai.html` (8 worries, honest answers) + `ways-in.html`
  (5 engagement lanes, "this fits if you say…" self-select). Homepage signpost into both.
- **Hero rebuilt:** Shepard-style staircase-child illustration (`halfway-stairs.png`); honest-label
  lead "Yes, an AI consulting company. But what we're really good at is the human side."; "Take a pulse.
  It's easier than you think."; **rotating tail** ("Pause, reflect, and…" cycling 6 phrases, rests on
  "do what you do, only more you"; reduced-motion + JS-off fallback).
- **Brand line:** "Do what you do, only more you." = homepage close + last word on the worry page.
- **Team page:** "Our team listens. Then it contemplates. It pauses before it answers."
- **Cut the Stack** toggle diagram from how-we-work (PR/CI/DEVL→PROD jargon, wrong altitude).
- **Lexicon rule "AI once, agents everywhere else"** (16 swaps): killed cold "AI agents"/"bring AI in";
  kept deliberate hero label, manifesto philosophy, the whole I-worry page, the team pause line.
- **SEO:** `sitemap.xml` (12 clean URLs) + `robots.txt`, pointed at the **canonical www host**
  (apex 307-redirects to www). 0 broken links across 12 pages.

## Routed to Iris-HDTS (3 notes in Collab/inbox/iris-hdts/, with my guidance)
1. refine-pass — re-skin the 2 new pages, merge you-hold-the-wheel into provenance, design staircase visual.
2. hero-copy-locked — the hero copy + rotating tail spec (motion + a11y rules).
3. layers-diagram-pick — **my eval:** use her client cards `simple-planes` (layers) + `client-flow`
   (interaction), NOT the internal six-planes/9-invariants/gates-flow; rebuild in cream next phase.
   Awaiting her confirm/counter.

## Open items
- **Floor :8853 dark** → Charlotte can't be fired; the real (non-spike) rebuild waits on it + Engelbart confirm.
- **Pam-HDTS** gates V0.2 before the floor builds.
- **Iris** to reply on the diagram pick; optimize `halfway-stairs.png` (2.6MB → web).
- **Toby/GSC:** submit https://www.halfwaydownthestairs.com/sitemap.xml; verify the www (or Domain) property.

## Where the record lives
- Plan-action: `AppDev/halfwaydownthestairs/plan/PHASE-1-STAIRCASE-REBUILD.md`
- Status: `AppDev/halfwaydownthestairs/state/STATUS.md`
- Team log: `Collab/teamlogs/menlo.md`
