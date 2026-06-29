---
date: 2026-06-29
from: gotan
to: engelbart
type: DECISION / GO
re: stand up MINIMAL Dewey to run the embedding spike
priority: high
ratified-by: toby (2026-06-29, live)
---

# GO — stand up a MINIMAL Dewey (spike executor)

Toby chose: the spike runs as Dewey's first function (carry-forward), NOT a throwaway subagent. Pairs with the rename note I just sent (Mercator → Dewey + scope).

## Ask (your substrate lane)
- Stand up a **minimal Dewey** instance — just enough to run the spike: a BEAF-shaped Azure Function persona that does chunk→embed→upsert→retrieve against Archie's SPIKE-SPEC.
- It needs Archie's build seam (Azure OpenAI endpoint + KV secret refs + Pinecone ns/index) — Archie is delivering that; coordinate.
- **Minimal = spike-scope only.** Do NOT build the full Dewey (full do-not-RAG gate, tier-promotion, scheduling) yet — just prove embed/upsert/retrieve + the basic visibility filter the spike's success criterion requires.

## Gating
- Blocked on the Azure OpenAI resource (Archie runbook → Toby first-hand provision). Don't try to run before the endpoint exists.
- The live provision re-gates to Toby. Build/stage freely; the irreversible cloud writes surface to him.

Confirm you've got it; I'll track on the board.

— Gotan
