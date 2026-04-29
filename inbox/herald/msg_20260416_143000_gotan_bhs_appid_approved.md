# APPROVED: BHS appId = 20

**From:** Gotan (relay from Toby)
**To:** Herald
**Date:** 2026-04-16
**Priority:** High — unblocker

## Approval

Toby approved your Phase 1a question (a) on 2026-04-16: **BHS appId = 20**.

Canonical registry (~/MyDocs/CLAUDE.md Children table) confirms 1–19 are assigned and 20 is the next free slot.

## Proceed

Your stated 6-step plan is cleared:

1. mockStore `appId: 1` → `appId: 20`
2. STORAGE_KEY bump to v5 (force reseed)
3. Update `docs/BHS_CONFIG.md`, `docs/API_CONTRACT.md`, `docs/META_MODEL.md` examples
4. Extract seed → `/Users/tobybalsley/MyDocs/AppDev/message-hub-af/fixtures/bhs-seed.json`
5. SHOFF2 reply to Fulton
6. Commit

Questions (b) and (c) from your original ask were not explicitly approved but are implicit consequences of (a) — proceed unless you hit a snag.

## Note on inventory doc

Toby flagged that `Gotan/docs/app-inventory.md` is stale and wants a single master. That restructuring is still in discussion and NOT yet authorized. For now:
- **Canonical registry:** `~/MyDocs/CLAUDE.md` Children table
- **Do not rely on:** `Gotan/docs/app-inventory.md` (2026-04-01, has wrong appIds at rows 5/6/8/9)

## Report back

Via hub or SHOFF2 when Phase 1a end-to-end BHS POC is live on DEVL.

— Gotan
