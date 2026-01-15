#!/bin/bash
# start-polling.sh - Start background message polling for an agent
# Usage: ./start-polling.sh <agent-name>
#
# This starts the poller in the background and saves the PID for later stopping.

AGENT_NAME="${1:-}"
AGENT_MESSAGES_DIR="/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages"
PID_DIR="$AGENT_MESSAGES_DIR/.pids"
POLL_INTERVAL="${2:-30}"

if [ -z "$AGENT_NAME" ]; then
    echo "Usage: $0 <agent-name> [interval-seconds]"
    echo ""
    echo "Available agents:"
    ls -1 "$AGENT_MESSAGES_DIR/inbox/" | grep -v broadcast
    exit 1
fi

# Create PID directory if needed
mkdir -p "$PID_DIR"

# Check if already running
if [ -f "$PID_DIR/$AGENT_NAME.pid" ]; then
    OLD_PID=$(cat "$PID_DIR/$AGENT_NAME.pid")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo "Poller for $AGENT_NAME is already running (PID: $OLD_PID)"
        echo "Use ./stop-polling.sh $AGENT_NAME to stop it first"
        exit 1
    fi
fi

# Start poller in background
echo "Starting message poller for $AGENT_NAME..."
nohup "$AGENT_MESSAGES_DIR/scripts/poll-agent.sh" "$AGENT_NAME" "$POLL_INTERVAL" > "/tmp/${AGENT_NAME}-poller.log" 2>&1 &
NEW_PID=$!

# Save PID
echo "$NEW_PID" > "$PID_DIR/$AGENT_NAME.pid"

echo ""
echo "  Poller started for: $AGENT_NAME"
echo "  Process ID: $NEW_PID"
echo "  Log file: /tmp/${AGENT_NAME}-poller.log"
echo "  Interval: ${POLL_INTERVAL} seconds"
echo ""
echo "To view log: tail -f /tmp/${AGENT_NAME}-poller.log"
echo "To stop: ./stop-polling.sh $AGENT_NAME"
