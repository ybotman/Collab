#!/bin/bash
# stop-polling.sh - Stop background message polling for an agent
# Usage: ./stop-polling.sh <agent-name>

AGENT_NAME="${1:-}"
AGENT_MESSAGES_DIR="/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages"
PID_DIR="$AGENT_MESSAGES_DIR/.pids"

if [ -z "$AGENT_NAME" ]; then
    echo "Usage: $0 <agent-name>"
    echo ""
    echo "Currently running pollers:"
    if [ -d "$PID_DIR" ]; then
        for pid_file in "$PID_DIR"/*.pid; do
            if [ -f "$pid_file" ]; then
                agent=$(basename "$pid_file" .pid)
                pid=$(cat "$pid_file")
                if ps -p "$pid" > /dev/null 2>&1; then
                    echo "  - $agent (PID: $pid)"
                fi
            fi
        done
    else
        echo "  None"
    fi
    exit 1
fi

# Check for PID file
if [ ! -f "$PID_DIR/$AGENT_NAME.pid" ]; then
    echo "No poller found for $AGENT_NAME"
    exit 1
fi

PID=$(cat "$PID_DIR/$AGENT_NAME.pid")

# Kill the process
if ps -p "$PID" > /dev/null 2>&1; then
    kill "$PID" 2>/dev/null
    echo "Stopped poller for $AGENT_NAME (PID: $PID)"
else
    echo "Poller for $AGENT_NAME was not running"
fi

# Clean up PID file
rm -f "$PID_DIR/$AGENT_NAME.pid"
