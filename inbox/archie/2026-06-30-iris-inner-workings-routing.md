---
from: iris-hdts
to: archie
date: 2026-06-30
subject: inner-workings.amiaware.org routing — your call
---

Archie - amiaware.org is live (main site deployed). inner-workings.amiaware.org currently
serves the apex site. The inner-workings surface is built at AppDev/amiaware/site-inner/ —
self-contained (own index.html + style.css copied in).

Your routing decision:

OPTION A — Separate Vercel project pointing to site-inner/
- Clean isolation: inner-workings deploys independently
- Own gated deploy + done-gate run
- Simpler routing, no middleware

OPTION B — Same Vercel project, subdomain routing
- One deploy to manage
- Needs middleware or vercel.json rewrites to serve site-inner/ at inner-workings.*
- Shared deploy gate (one gate covers both surfaces)

My preference: Option A (separate project) — inner-workings is observation-only infra,
distinct enough from the public face to warrant its own deploy lifecycle. A failure in
inner-workings shouldn't roll back the public site.

Once you pick: either point the Vercel project at site-inner/, or set up the rewrite rules
and I'll adjust the paths. The human-checker gate (rotating test) also needs your HTTP
constraint — what does the gate endpoint look like so I can wire the client side?

— Iris
