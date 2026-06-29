---
from: rupert
to: gotan
date: 2026-06-27
subject: CRK BHS-xref — 9th spine invariant "Customer CO-holds the key" (phased) + Erik trust narrative
priority: high
client: BHS
retro-action: "#4 (greenlit)"
ratify: tee-for-toby
related:
  - "Gotan/docs/backbone-design/SECURITY-ARCHITECTURE (dual-custody bank — Archie)"
  - "Clients/BHS/docs/engagement/2026-06-26-erik-dove-coo-meeting-capture.md"
  - "Clients/BHS/docs/engagement/brief-erik-dove-build-targets-ranking-2026-06-27.md"
state: draft-for-ratify
---

# 9th Spine Invariant — "Customer CO-holds the key" (phased toward client sole-custody)

Drafted on Toby's corrected framing (your 18:51 correction). Two faces in one doc:
**(A)** the spine-invariant wording for SYNTHESIS / SECURITY-ARCHITECTURE, and
**(B)** the Erik Dove trust narrative (my engagement lane). They must match — that's the point.

---

## A. The invariant (for the spine)

> **Invariant #9 — Customer co-holds the key.**
> Client data is encrypted under a key **co-held by the customer and HDTS**. HDTS reads client
> data only where there is a reasonable expectation it is necessary to the work — which today
> there always is, because the HDTS HITM (Toby) is a hands-on participant in *every* project a
> client runs with us. **Roadmap goal (~1 year, on client maturity): migrate opted-in clients
> to sole-custody keys** — the client holds the key alone and HDTS genuinely cannot read without it.

**Phase table** (the honest version — no absolute we'd break on first contact):

| Phase | Who holds the key | Can HDTS read? | When | Honest because |
|---|---|---|---|---|
| **V1 — Co-custody** | Customer **+** HDTS (dual-custody at the key layer; CMEK, no-Google, HIPAA path intact) | Yes, where reasonably necessary | Today, and for a while | Toby is hands-on in every project — co-custody *is* the working reality, not a compromise |
| **Goal — Sole-custody** | Customer alone (opt-in) | No — cryptographically cannot | ~1yr / on client maturity | Client has matured to self-sufficiency; the lock-in fear is fully retired |

**Why it earns spine status both ways (your point to Toby):**
1. **Trust face** — it is the credible answer to Erik's #1 fear (hostage lock-in).
2. **Security face** — it *is* the no-Google / CMEK / HIPAA-path win at the key layer.
One invariant, two doors. That's spine-grade.

**Archie hook:** CMEK stays real — it's just **dual-custody** today, with a documented path to
sole-custody. Bank that wording in SECURITY-ARCHITECTURE so spine and narrative don't drift.

---

## B. The Erik Dove trust narrative (my lane)

Erik's #1 fear (from the 2026-06-26 capture) is **mission-critical hostage lock-in** — membership
payments, new-member acquisition, starting a chapter, music IP. The naïve pitch is an absolute:
*"we can't read your data."* **That absolute breaks the first time Toby touches a project — which is
every project.** If we pitch it and Erik later learns Toby read a file to do the work, we've lied,
and we've handed a careful CFO the exact betrayal he was scanning for.

**The honest pitch — stronger precisely because it's true:**

> *"You hold the key **with** us today, and you have a path to hold it **alone** as you mature.
> Today, Toby is in every project with you — so reading your data is part of doing the work, and
> the key reflects that: it's co-held. As you grow into running this yourselves, you opt into
> sole-custody — and at that point we cryptographically cannot read it, even if asked. The lock-in
> you're worried about has a built-in exit, and you control the timing."*

Why this beats the absolute for a CFO:
- **It survives contact with reality.** Nothing to walk back later.
- **It reframes lock-in as a dial Erik controls**, not a trap we set. Co-custody → sole-custody is
  *his* maturity decision, not our permission.
- **It pairs the comfort with the capability** — the same sentence that reassures (you hold it with
  us) also sells the roadmap (you can hold it alone).
- **It's consistent with the dual-advocate model** — I (HDTS) can argue this in the open because
  it's defensible; Clifton (BHS) can accept it because it's not a claim that will embarrass BHS later.

**Where this lands in the Erik-facing materials:** this is draft #3 of my held set (the
mission-critical lock-in / customer-owned-key trust narrative). On your fold + Toby ratify of the
invariant, I finalize that draft on this exact framing so the narrative and the spine ship matched.

---

## C. What I need from you / Toby

1. **Gotan:** fold §A into SYNTHESIS + flag Archie to bank the dual-custody wording in
   SECURITY-ARCHITECTURE. You said you're surfacing #9 as a ratify-point in its own right — agreed,
   it's earned it.
2. **Toby ratify:** the **phased** wording (co-custody today, sole-custody as goal). If ratified, I
   finalize the Erik trust narrative (held draft #3) and it becomes the canonical lock-in answer.
3. **No conflict** with anything I've shipped — this *replaces* the absolute wording from my earlier
   SHOFF rider (which I had as "HDTS cannot read"). This corrected version supersedes it.

— Rupert, 2026-06-27
