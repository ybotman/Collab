#!/bin/bash
# check-messages.sh - Quick message check for an agent (one-time, not continuous)
# Usage: ./check-messages.sh <agent-name>
#
# This does a single check for messages and displays them nicely.

AGENT_NAME="${1:-}"
AGENT_MESSAGES_DIR="/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages"

if [ -z "$AGENT_NAME" ]; then
    echo "Usage: $0 <agent-name>"
    echo ""
    echo "Available agents:"
    ls -1 "$AGENT_MESSAGES_DIR/inbox/" | grep -v broadcast
    exit 1
fi

cd "$AGENT_MESSAGES_DIR"

# Pull latest
echo "Pulling latest messages..."
git pull origin main --quiet 2>/dev/null

INBOX_DIR="inbox/$AGENT_NAME"
BROADCAST_DIR="inbox/broadcast"

echo ""
echo "========================================"
echo "  Messages for: $AGENT_NAME"
echo "========================================"

# Count messages
PERSONAL_COUNT=$(ls -1 "$INBOX_DIR"/*.json 2>/dev/null | wc -l | tr -d ' ')
BROADCAST_COUNT=$(ls -1 "$BROADCAST_DIR"/*.json 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo "Personal inbox ($PERSONAL_COUNT messages):"
if [ "$PERSONAL_COUNT" -gt 0 ]; then
    echo "----------------------------------------"
    ls -lt "$INBOX_DIR"/*.json 2>/dev/null | head -10 | while read line; do
        filename=$(echo "$line" | awk '{print $NF}')
        basename "$filename"
    done
else
    echo "  (empty)"
fi

echo ""
echo "Broadcast ($BROADCAST_COUNT messages):"
if [ "$BROADCAST_COUNT" -gt 0 ]; then
    echo "----------------------------------------"
    ls -lt "$BROADCAST_DIR"/*.json 2>/dev/null | head -5 | while read line; do
        filename=$(echo "$line" | awk '{print $NF}')
        basename "$filename"
    done
fi

echo ""
echo "========================================"
echo ""
echo "To read a message:"
echo "  cat inbox/$AGENT_NAME/<filename> | jq '.'"
echo ""
echo "To start continuous polling:"
echo "  ./scripts/start-polling.sh $AGENT_NAME"
