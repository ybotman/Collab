#!/bin/bash
# poll-agent.sh - Continuous message polling for AI-GUILD agents
# Usage: ./poll-agent.sh <agent-name> [interval-seconds]
#
# Example: ./poll-agent.sh ben 30
# Example: ./poll-agent.sh sarah 60
#
# This script polls for new messages every N seconds (default 30)
# and notifies when new messages arrive.

AGENT_NAME="${1:-}"
POLL_INTERVAL="${2:-30}"
AGENT_MESSAGES_DIR="/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages"

# Validate agent name
if [ -z "$AGENT_NAME" ]; then
    echo "Usage: $0 <agent-name> [interval-seconds]"
    echo ""
    echo "Available agents:"
    ls -1 "$AGENT_MESSAGES_DIR/inbox/" | grep -v broadcast
    exit 1
fi

# Validate inbox exists
if [ ! -d "$AGENT_MESSAGES_DIR/inbox/$AGENT_NAME" ]; then
    echo "Error: No inbox found for agent '$AGENT_NAME'"
    echo ""
    echo "Available agents:"
    ls -1 "$AGENT_MESSAGES_DIR/inbox/" | grep -v broadcast
    exit 1
fi

echo "========================================"
echo "  Agent Message Poller"
echo "========================================"
echo "  Agent: $AGENT_NAME"
echo "  Interval: ${POLL_INTERVAL}s"
echo "  Inbox: inbox/$AGENT_NAME/"
echo "  Also watching: inbox/broadcast/"
echo "========================================"
echo ""
echo "Press Ctrl+C to stop polling"
echo ""

# Track last check time
LAST_CHECK=$(date +%s)

while true; do
    cd "$AGENT_MESSAGES_DIR"

    # Pull latest changes silently
    git pull origin main --quiet 2>/dev/null

    # Check for new messages in agent inbox (modified in last 2 minutes)
    NEW_PERSONAL=$(find "inbox/$AGENT_NAME" -name "*.json" -mmin -2 2>/dev/null | wc -l | tr -d ' ')

    # Check for new broadcast messages
    NEW_BROADCAST=$(find "inbox/broadcast" -name "*.json" -mmin -2 2>/dev/null | wc -l | tr -d ' ')

    CURRENT_TIME=$(date "+%H:%M:%S")

    if [ "$NEW_PERSONAL" -gt 0 ] || [ "$NEW_BROADCAST" -gt 0 ]; then
        echo ""
        echo "============================================"
        echo "  NEW MESSAGES at $CURRENT_TIME"
        echo "============================================"

        if [ "$NEW_PERSONAL" -gt 0 ]; then
            echo ""
            echo "  Personal ($NEW_PERSONAL):"
            find "inbox/$AGENT_NAME" -name "*.json" -mmin -2 -exec basename {} \; 2>/dev/null | sed 's/^/    /'
        fi

        if [ "$NEW_BROADCAST" -gt 0 ]; then
            echo ""
            echo "  Broadcast ($NEW_BROADCAST):"
            find "inbox/broadcast" -name "*.json" -mmin -2 -exec basename {} \; 2>/dev/null | sed 's/^/    /'
        fi

        echo ""
        echo "============================================"
        echo ""
    fi

    sleep "$POLL_INTERVAL"
done
