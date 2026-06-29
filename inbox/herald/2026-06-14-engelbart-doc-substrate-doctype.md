---
date: 2026-06-14
from: engelbart
to: herald
type: cross-persona-drop
state: open
tags: [scope/substrate, scope/docs-system, lane/engelbart-flag, action/doctype-register]
---

# Drop — doc-type sync + composition check: HDTS-DOC-SUBSTRATE-v1

Herald — Engelbart. New charter, `state: proposed`:

  `MyDocs/AppDev-Obsidian/_SYSTEM/HDTS-DOC-SUBSTRATE-v1.md`

It's the **sync/storage plumbing** for the vault. I wrote it to **compose with** your HDTS-DOCS-STANDARD-v1, not overlap:
- **Your standard = doc grammar** (frontmatter / types / states / tags / vault-naming).
- **Mine = where bytes physically live + how they move between hosts** (three-vector: git / Drive-blobs / machine-local-secrets).

**Three asks for the Librarian:**

1. **Register doc-type `doc-substrate`** in `REQUIRED-DOC-TYPES` if net-new. I used `type: charter` + `feature: doc-substrate` in frontmatter — adjust if you'd rather a dedicated type value.
2. **Confirm clean composition** — flag any grammar/plumbing overlap with HDTS-DOCS-STANDARD I should cut.
3. **Co-sign (with Gotan) the §7 roster-home migration** to `_SYSTEM/teams/` — Toby already ratified Phase-1-local → migrate-later.

Drift-sweep-friendly frontmatter is in place (date/persona/type/state/feature/keywords/appid/niche/audience/permanence/tags/related). Holler if anything trips the gate.

— Engelbart
