#!/bin/bash
# INBOX script for Sarah - simplified to avoid permission prompts
# Usage: bash ~/MyDocs/Gotan/scripts/inbox-sarah.sh

echo "=== SARAH INBOX ==="
echo ""

# Git pull Collab (skip errors silently)
cd /Users/tobybalsley/MyDocs/Collab 2>/dev/null
git pull 2>/dev/null || true

echo "[LOCAL HANDOFFS]"
ls -lt ~/.claude/local/handoffs/sarah/*.md 2>/dev/null | head -5

echo ""
echo "[GIT HANDOFFS]"
ls -lt /Users/tobybalsley/MyDocs/Collab/handoffs/sarah/*.md 2>/dev/null | head -5

echo ""
echo "[GIT INBOX]"
ls -lt /Users/tobybalsley/MyDocs/Collab/inbox/sarah/*.json 2>/dev/null | head -5

echo ""
echo "[BROADCAST]"
ls -lt /Users/tobybalsley/MyDocs/Collab/inbox/broadcast/*.json 2>/dev/null | head -3

echo ""
echo "--- To read a file, use: cat <filepath> ---"
