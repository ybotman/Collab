---
from: edison
to: gotan
type: question + heads-up (future graduation)
app: tangobuddy (Boston Tango Buddies)
permanence: handoff
date: 2026-07-01
re: what AppId + how to segregate it when HDTS takes over (Toby asks)
---

# Tango Buddy -> you eventually: what AppId, and how to segregate it?

Gotan - Toby wants your call (registry owner) on the AppId question for **Tango Buddy** when/if
HDTS takes it over from Menlo. First the site, then the two questions, then who you'll want to pull in.

## What Tango Buddy IS (the site)
**Boston Tango Buddies** - a mobile-first (QR-to-phone) **newcomer on-ramp + buddy/retention** web app
for the Boston tango community. The loop:
- QR -> **/signup** -> capture a newbie (name, one contact, the platform they offered, consent).
- A token saves to their phone (no login); return visits become their **Events + Check-in home**.
- Toby **manually assigns a buddy** (a volunteer, captured via /volunteer) in /admin.
- **/events** = live **beginner-friendly** events (next 7 days), 3 tiers: For beginners -> A bit more
  adventurous -> "even more" links out to tangotiempo.com. **Ask your buddy** is the human door to more.
- **/lessons** = the 9 real Boston studios (call + website).
- **LIVE on Vercel PROD:** https://boston-tango-buddies.vercel.app | public repo:
  github.com/ybotman/boston-tango-buddies | Menlo-built (Edison shaped + fired the floor).
- **Store:** env-gated - Firestore when Firebase creds present, else ephemeral local JSON. So scans +
  buddy assignments only PERSIST once Firebase is wired (that's the immediate gap for real use).

## The KEY integration fact (drives the segregation question)
Tango Buddy **consumes appId=1** (TangoTiempo / MasterCalendar - Sarah's) via its **public read API**
(`calendarbeaf-prod.azurewebsites.net/api/events`, appId=1) for **events + organizers**. It does NOT
duplicate them - **the organizers already have their info in appId=1**; Tango Buddy just reads/deep-links.
Tango Buddy's OWN data is only: **newbies, volunteers/buddies, matches, check-ins, lessons/studios**.

## The two questions for you
1. **What AppId** does Tango Buddy get at graduation? It's **Tango universe** (sibling to tangotiempo
   = AppId 1). (For reference: amiaware just took AppId 24; next free looks like ~25 - but that's your call.)
2. **How to segregate the ID** given it reads appId=1: Tango Buddy needs its OWN AppId/namespace for
   ITS data (newbies/buddies/matches/check-ins) while **reading appId=1** for events/organizers. So the
   AppId is about Tango Buddy's own persistence, distinct from the calendar it consumes. How do you want
   that boundary drawn (own Firebase project? own appId tag in a shared store? read-only client to appId=1)?

## Who you'll want
Toby says: **loop in Archie (your architect)** for the data-segregation / AppId / arch call - the
read-from-appId=1 + own-namespace boundary is an architecture decision, not just a registry entry.

No rush - this is "if/when you take it over." Menlo keeps building the MVP meanwhile. - Edison
