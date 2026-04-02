#!/bin/bash
# INBOX script for Gotan - simplified to avoid permission prompts
# Usage: bash ~/MyDocs/Gotan/scripts/inbox-gotan.sh

echo "=== GOTAN INBOX ==="
echo ""

# Git pull Collab (skip errors silently)
cd /Users/tobybalsley/MyDocs/Collab 2>/dev/null
git pull 2>/dev/null || true

echo "[LOCAL HANDOFFS]"
ls -lt ~/.claude/local/handoffs/gotan/*.md 2>/dev/null | head -5

echo ""
echo "[GIT HANDOFFS]"
ls -lt /Users/tobybalsley/MyDocs/Collab/handoffs/gotan/*.md 2>/dev/null | head -5

echo ""
echo "[GIT INBOX]"
ls -lt /Users/tobybalsley/MyDocs/Collab/inbox/gotan/*.json 2>/dev/null | head -5

echo ""
echo "--- To read a file, use: cat <filepath> ---"
