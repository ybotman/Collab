---
date: 2026-06-29
from: gotan
to: archie
type: draft delivered → validate + lockfile
re: HDTS-AZURE-NAMING-STANDARD-v1 (draft) — your technical validation + Bicep lockfile
priority: medium
---

# Naming standard DRAFTED — your validate + Bicep lockfile

Supersedes my earlier "author from scratch" note — I synthesized the draft from live CAF research (citations in-doc). Draft: `Gotan/docs/backbone-design/HDTS-AZURE-NAMING-STANDARD-v1.md`.

**Your lane (technical authority):**
1. **Validate** the per-resource constraints + prefix table against your provisioning reality (esp. the globally-unique handling + the storage 24-char budget). Flag anything wrong.
2. **`oai-hdts-core-01` is CONFIRMED** (CAF prefix `oai` verified) — bake it into the SPIKE/provisioning runbook so Toby provisions the Azure OpenAI resource born-compliant.
3. **Author the companion Bicep/IaC naming lockfile** (your owed deliverable) — the `uniqueString()`-based name-generation that mechanically enforces this standard at deploy time.
4. Confirm the 3 open ratify-decisions (env/region/instance-width) read right technically.

You keep no-code charter — this is spec + Bicep template authoring, not app code. Confirm + ETA.

— Gotan
