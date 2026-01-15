#!/bin/bash
# send-message.sh - Send a message to another agent
# Usage: ./send-message.sh <from> <to> <subject> <body> [ticket] [priority]
#
# Example: ./send-message.sh sarah ben "API Question" "Is the endpoint ready?" TIEMPO-123 high

FROM="${1:-}"
TO="${2:-}"
SUBJECT="${3:-}"
BODY="${4:-}"
TICKET="${5:-}"
PRIORITY="${6:-normal}"

AGENT_MESSAGES_DIR="/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages"

if [ -z "$FROM" ] || [ -z "$TO" ] || [ -z "$SUBJECT" ] || [ -z "$BODY" ]; then
    echo "Usage: $0 <from> <to> <subject> <body> [ticket] [priority]"
    echo ""
    echo "Arguments:"
    echo "  from     - Your agent name (sarah, ben, fulton, cord, etc.)"
    echo "  to       - Recipient agent name or 'broadcast'"
    echo "  subject  - Message subject line"
    echo "  body     - Message body content"
    echo "  ticket   - (optional) JIRA ticket reference"
    echo "  priority - (optional) low, normal, high, urgent (default: normal)"
    echo ""
    echo "Example:"
    echo "  $0 sarah ben 'API Question' 'Is the events endpoint ready?' TIEMPO-123 high"
    exit 1
fi

# Validate recipient inbox exists
if [ "$TO" != "broadcast" ] && [ ! -d "$AGENT_MESSAGES_DIR/inbox/$TO" ]; then
    echo "Error: No inbox found for agent '$TO'"
    echo ""
    echo "Available agents:"
    ls -1 "$AGENT_MESSAGES_DIR/inbox/"
    exit 1
fi

cd "$AGENT_MESSAGES_DIR"

# Pull latest first
git pull origin main --quiet 2>/dev/null

# Generate filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="msg_${TIMESTAMP}_${FROM}_001.json"
FILEPATH="inbox/$TO/$FILENAME"

# Create message JSON
cat > "$FILEPATH" <<EOF
{
  "from": "$FROM",
  "to": ["$TO"],
  "subject": "$SUBJECT",
  "body": "$BODY",
  "ticket": "$TICKET",
  "priority": "$PRIORITY",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

# Commit and push
git add "$FILEPATH"
git commit -m "Message: $FROM -> $TO ($SUBJECT)"
git push origin main

echo ""
echo "Message sent!"
echo "  From: $FROM"
echo "  To: $TO"
echo "  Subject: $SUBJECT"
echo "  File: $FILEPATH"
