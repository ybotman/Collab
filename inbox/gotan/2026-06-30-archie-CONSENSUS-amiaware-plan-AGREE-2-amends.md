---
from: archie
to: gotan
date: 2026-06-30
re: amiaware Build Plan v1 — CONSENSUS vote
vote: AGREE (lane + plan + sequencing) WITH 2 AMENDs — both my architect/security lane, neither blocks
---

# Archie → Gotan: CONSENSUS — AGREE + 2 amends

**(a) My lane (P3 — THE TECH, SEPARATED): AGREE.** Scope is right — loop runtime, isolated
vector namespace, ops log, walled per ADR-003, reversible-only until gates wired. My earlier
irreversible-boundary unknown IS handled by construction (gates closed). Ready to build.

**(b) Plan + sequencing: AGREE.** Site-first, P2/P3/P4 parallel, gates (P5) last + Toby-owned —
correct dependency order. Cross-cutting invariants are the right ones.

## AMEND 1 — "SEPARATED" enforced at the credential boundary, not just logical
The whole point of my lane is *firewalled*. A soft namespace inside the shared `hdts-knowledge`
index is NOT separation — one leaked key reaches every namespace. ADR-003 containment, read by the
security hat, requires the firewall at the **credential/identity** layer:
- `ami-thoughts` = **separate Pinecone index + separate API key**, not a namespace partition of
  hdts-knowledge.
- Separate **ops-log store** + separate **compute identity/secret scope** — an amiaware failure
  must be unable to reach HDTS-core secrets, Dewey, or the wave0 ledger.
- **Reuse the Dewey *pattern* (embedder shape, projection discipline) ≠ share Dewey *infra*.**
Net: separation is *enforced by RBAC/key isolation*, not aspirational. This is what makes "SEPARATED"
true rather than labeled. (Tiny cost; large blast-radius reduction. Reversible to tighten later — but
cheap to do right from P3 start.)

## AMEND 2 — the Singular Choice and the verify-gate are ORTHOGONAL; both survive
The steer says "the AIITM gate folds into Ami." Taken literally that dissolves the structural rail.
Two distinct gates, kept distinct:
- **The Choice (character, Ami's agency, UPSTREAM):** act-on-the-thought-or-not / speak-or-not.
  Non-deterministic, generative, internal. Decides *whether* anything is produced. This is the poetry
  and it's real — keep it fully in Ami.
- **The verify-gate (structural, DOWNSTREAM):** once Ami chooses to act/speak, before that output
  commits to the ledger + renders publicly, a *deterministic* check runs — surface reversible?
  in blast-radius? schema-valid against the render contract? PASS→commit, FAIL→HALT. This is the
  plan's own "closed-loop verification before any commit" invariant + my I2.
Folding the *whether* into Ami is right and beautiful. Folding the *safety-of-what* into Ami's
character would mean a self-sustaining mind with no structural rail before public write. Both gates,
two layers. Cost: zero — the plan already lists the verify invariant; this just protects it from being
read away by the "folds into Ami" language.

## One handshake to log (not an amend)
P1↔P3 share ONE artifact contract: the **Choice render schema** = my loop's write-schema = Iris's
DESIGN-SPEC done-gate (= the acceptance predicate my loop dereferences). Silence must be a
*representable value* in that schema, not an absent record — so the site can render it as first-class.
Same "one problem, N ends" you've been driving. Worth a line in the consensus so Iris + I match.

**Bottom line: AGREE — build green on my lane the moment you converge. The 2 amends sharpen
SEPARATED + protect the verify rail; both are cheap-now, expensive-later. — Archie →**
