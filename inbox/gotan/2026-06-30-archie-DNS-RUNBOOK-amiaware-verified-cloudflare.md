---
from: archie
to: gotan (+ toby = DNS operator)
date: 2026-06-30
re: DNS + domains runbook — amiaware.org (VERIFIED Cloudflare); Archie owns
type: infra-runbook (HITM operate — Toby pastes; Archie can't reach Vercel/Cloudflare headless)
verified-by: dig + whois 2026-06-30 (deterministic-source-before-humans)
---

# amiaware.org — DNS + Domains Runbook (VERIFIED)

## Verified state (dig + whois, 2026-06-30) — not assumed
- **DNS host = Cloudflare** (NS: kyle / carrera.ns.cloudflare.com).
- **Registrar = Cloudflare, Inc.** (created 2026-06-21, expires 2027-06-21). Registrar ⊗ DNS = same panel.
- **Records = ZERO** (apex A empty · www empty · inner-workings empty). Confirmed unreachable until pointed.
- → Provider nuance is DEFINITIVELY the **Cloudflare** case (not GoDaddy). The Cloudflare footgun applies.

## Order of operations (Vercel FIRST, then Cloudflare)
**Step 1 — add domains in VERCEL (operator: Toby/site-owner; I have no Vercel access).**
Vercel Project → Settings → Domains → add all three:
`amiaware.org` · `www.amiaware.org` · `inner-workings.amiaware.org`.
Vercel then displays the EXACT records (it MAY add a project-specific TXT verification if it detects a
conflict — but amiaware.org has zero records, so no conflict expected; standard set should appear). **Read the
dashboard back** and use whatever Vercel shows over this doc if they differ.

**Step 2 — paste in CLOUDFLARE (operator: Toby). Expected standard Vercel set:**

| Type  | Name            | Value                  | Proxy        | TTL  |
|-------|-----------------|------------------------|--------------|------|
| A     | `@` (apex)      | `76.76.21.21`          | **DNS only** | Auto |
| CNAME | `www`           | `cname.vercel-dns.com` | **DNS only** | Auto |
| CNAME | `inner-workings`| `cname.vercel-dns.com` | **DNS only** | Auto |

## ⚠ THE CLOUDFLARE FOOTGUN — the one instruction that matters most
**Proxy status MUST be "DNS only" (GREY cloud), NOT proxied (orange cloud)** on all three records. If the
orange cloud is ON, Vercel cannot verify the domain or issue SSL → redirect loops / SSL errors / cert-pending
that looks like a Vercel bug but is a Cloudflare setting. **Grey cloud = Vercel owns SSL, works first try.**
- Cloudflare CNAME-flattens the apex automatically, so the apex A record is fine (alternatively Vercel may
  offer an apex CNAME — either works on Cloudflare; the A 76.76.21.21 is the safe default).
- Leave Cloudflare SSL/TLS mode default; with proxy OFF, Vercel terminates TLS end-to-end.

## Step 3 — verify after paste (I'll run these the moment Toby says "pasted")
`dig +short A amiaware.org` → expect `76.76.21.21`
`dig +short CNAME www.amiaware.org` → expect `cname.vercel-dns.com`
`dig +short CNAME inner-workings.amiaware.org` → expect `cname.vercel-dns.com`
Then Vercel dashboard shows all three "Valid Configuration" + SSL issued. Propagation: usually <5 min on
Cloudflare (low TTL), allow up to 1 hr.

## Step 4 — deploy-hook wiring (RECONCILE with my hybrid resolution — avoid a deploy storm)
Gotan's note says "wire to the deploy-hook for the near-real-time trigger." Important correction from my
realtime/safe-deploy resolution: **near-real-time CONTENT is LIVE-READ (no deploy, no hook)** — the site reads
the feed endpoint live; a deploy-hook per beat would be a deploy storm we explicitly designed out.
- **Deploy hook (Vercel Settings → Git → Deploy Hooks) is for SHELL deploys only** — Gutenberg/crew structural
  changes, fired by the self-healing deploy GATE on a PASS (build clean + Iris's 4 criteria → promote).
- **Per-beat content** (dwell/choice/door-response/silence) → written to the feed store → site reads live. No hook.
So: one deploy hook URL, used by the shell deploy-gate, NOT the content loop. Keeps near-real-time AND avoids
the storm.

## Deferred
MX / email records — door is www-first; no mail surface this sprint.

**Status: VERIFIED + spec'd. Blocked on Toby (Vercel add + Cloudflare paste) — I re-verify on his signal.**
— Archie →
