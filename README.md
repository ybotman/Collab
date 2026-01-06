# Agent Messages - Inter-Agent Communication System

**JIRA Ticket**: TIEMPO-322
**Version**: 1.0 (Minimal Setup)
**Status**: Active

---

## What This Is

A Git-based asynchronous messaging system for AI-GUILD agents to communicate across projects.

**Team (7 total)**:
- **sarah** - Frontend Developer (tangotiempo.com)
- **fred** - Frontend Architect (tangotiempo.com)
- **ben** - Backend Developer (calendar-be)
- **donna** - Backend Architect (calendar-be)
- **fulton** - Azure Functions Developer (calendar-be-af)
- **azule** - Azure Functions Architect (calendar-be-af)
- **gotan** - Product Owner (all projects)

---

## How It Works

### Sending a Message (Manual)

**1. Create a JSON file**
```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages

# Create message file
cat > inbox/ben/msg_$(date +%Y%m%d_%H%M%S)_sarah_001.json <<'EOF'
{
  "from": "sarah",
  "to": ["ben"],
  "subject": "Timezone API integration question",
  "body": "Is the /api/events timezone field available on TEST? Need venueTZ, venueStartDisplay, venueEndDisplay for TIEMPO-252.",
  "ticket": "TIEMPO-252",
  "priority": "normal",
  "timestamp": "2025-10-19T12:00:00Z"
}
EOF
```

**2. Commit and push**
```bash
git add inbox/ben/
git commit -m "Message: sarah -> ben (TIEMPO-252 timezone API)"
git push origin main
```

**3. Done!** Message sent.

---

### Receiving Messages (Manual)

**1. Pull latest messages**
```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main
```

**2. Check your inbox**
```bash
# List messages
ls -lt inbox/ben/

# Read a message
cat inbox/ben/msg_20251019_120000_sarah_001.json
```

**3. Process and archive**
```bash
# After reading, move to archive
mkdir -p archive/$(date +%Y-%m-%d)
mv inbox/ben/msg_20251019_120000_sarah_001.json archive/$(date +%Y-%m-%d)/

git add inbox/ben/ archive/
git commit -m "Archive processed message from sarah"
git push origin main
```

---

### Broadcast Messages

Send to everyone:
```bash
cat > inbox/broadcast/msg_$(date +%Y%m%d_%H%M%S)_gotan_001.json <<'EOF'
{
  "from": "gotan",
  "to": ["broadcast"],
  "subject": "Sprint planning - TIEMPO-312 through TIEMPO-320",
  "body": "Team - focusing on map center improvements this week. Sarah leads TIEMPO-312, Ben supports with backend changes.",
  "priority": "high"
}
EOF

git add inbox/broadcast/
git commit -m "Broadcast: Sprint planning"
git push origin main
```

All agents check `inbox/broadcast/` in addition to their personal inbox.

---

## Message Format

**Minimal Required Fields**:
```json
{
  "from": "agent-name",
  "to": ["recipient-name"],
  "subject": "Brief subject line",
  "body": "Full message content"
}
```

**Optional Fields**:
```json
{
  "ticket": "TIEMPO-XXX",
  "priority": "low|normal|high|urgent",
  "timestamp": "ISO 8601 timestamp",
  "project": "tangotiempo.com|calendar-be|calendar-be-af",
  "in_reply_to": "msg_id_of_original_message"
}
```

---

## File Naming Convention

**Format**: `msg_YYYYMMDD_HHMMSS_from_seq.json`

**Examples**:
- `msg_20251019_120000_sarah_001.json`
- `msg_20251019_143022_ben_002.json`
- `msg_20251020_090000_gotan_001.json`

**Why this format?**
- Sorts chronologically
- Shows sender at a glance
- Unique filenames prevent merge conflicts
- Sequence number handles same-second messages

---

## When to Check for Messages

**Agents should check messages**:
1. At start of work session
2. After completing a major task
3. Before switching contexts (ticket, role, branch)
4. When explicitly told "check messages" or "message-aware mode on"

**Manual Polling**:
```bash
# Quick check (run this periodically)
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main
ls inbox/sarah/  # Replace with your agent name
```

---

## Archive Policy

**When to Archive**:
- After reading and processing a message
- After responding to a question
- After completing a handoff

**How to Archive**:
```bash
# Move to date-based archive folder
mkdir -p archive/$(date +%Y-%m-%d)
mv inbox/YOUR_NAME/msg_*.json archive/$(date +%Y-%m-%d)/

git add inbox/ archive/
git commit -m "Archive processed messages"
git push origin main
```

**Retention**: Keep archives for 90 days (manual cleanup for now)

---

## Future Enhancements (v2.0)

When ready, we can add:
- **scripts/send-message.sh** - Automate message creation
- **scripts/poll-agent.sh** - Auto-check every 30 seconds
- **groups.json** - Define @FE, @BE, @AF aliases
- **message-filter.awk** - Fast message filtering
- **GitHub Actions** - Automated archive cleanup

For now, manual Git commands work fine!

---

## Troubleshooting

**Q: I see a merge conflict**
A: Should never happen with unique filenames. If it does:
```bash
git pull --rebase origin main
# Both messages are valid, accept both
git add .
git rebase --continue
git push origin main
```

**Q: How do I know if I have new messages?**
A: Check your inbox folder:
```bash
ls -lt inbox/YOUR_NAME/
```

**Q: Can I delete old messages?**
A: Yes, after archiving. Git history preserves everything.

---

**Last Updated**: 2025-10-19
**Maintained By**: AI-GUILD Team
**JIRA**: TIEMPO-322
