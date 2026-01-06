# Agent Prompts - Inter-Agent Messaging Instructions

**Instructions for updating each agent's applicationPlaybook.md**

Add this section to each agent's `.ybotbot/applicationPlaybook.md` file.

---

## For Sarah (tangotiempo.com/.ybotbot/applicationPlaybook.md)

```markdown
## Inter-Agent Messaging (TIEMPO-322)

**Your Inbox**: `/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/inbox/sarah/`

### When to Check Messages

Check for messages from other agents:
1. **At session start** - After reading playbooks
2. **After completing major work** - Before SNR/handoff
3. **Before context switches** - Ticket, role, or branch changes
4. **When explicitly told** - "check messages", "message-aware on", "poll messages"

### How to Check Messages (Manual)

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main

# Check personal inbox
ls -lt inbox/sarah/

# Check broadcast messages
ls -lt inbox/broadcast/

# Read a message
cat inbox/sarah/msg_*.json
```

### How to Send Messages

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages

# Create message (replace RECIPIENT with ben, fred, fulton, etc.)
cat > inbox/RECIPIENT/msg_$(date +%Y%m%d_%H%M%S)_sarah_001.json <<'EOF'
{
  "from": "sarah",
  "to": ["RECIPIENT"],
  "subject": "Your subject here",
  "body": "Your message content here",
  "ticket": "TIEMPO-XXX",
  "priority": "normal"
}
EOF

# Commit and push
git add inbox/
git commit -m "Message: sarah -> RECIPIENT (subject)"
git push origin main
```

### Message-Aware Mode

When GotanMan says "message-aware on" or "start polling":

1. Announce: "Message-aware mode activated. Checking messages every 30 seconds."
2. Between tasks, periodically run:
   ```bash
   cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
   git pull origin main
   NEW_MESSAGES=$(ls inbox/sarah/*.json 2>/dev/null | wc -l)
   if [ $NEW_MESSAGES -gt 0 ]; then
     echo "📬 $NEW_MESSAGES new message(s) for Sarah"
     ls -lt inbox/sarah/*.json
   fi
   ```
3. When messages arrive, alert GotanMan: "📬 New message from [sender] about [subject]"
4. Continue until told "message-aware off"

### Common Recipients

- **ben** - Backend developer (calendar-be)
- **fred** - Your architect (frontend guidance)
- **fulton** - Azure Functions developer
- **donna** - Backend architect
- **azule** - Azure Functions architect
- **broadcast** - All agents see this
```

---

## For Ben (calendar-be/.ybotbot/applicationPlaybook.md)

```markdown
## Inter-Agent Messaging (TIEMPO-322)

**Your Inbox**: `/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/inbox/ben/`

### When to Check Messages

Check for messages from other agents:
1. **At session start** - After reading playbooks
2. **After completing major work** - Before SNR/handoff
3. **Before context switches** - Ticket, role, or branch changes
4. **When explicitly told** - "check messages", "message-aware on", "poll messages"

### How to Check Messages (Manual)

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main

# Check personal inbox
ls -lt inbox/ben/

# Check broadcast messages
ls -lt inbox/broadcast/

# Read a message
cat inbox/ben/msg_*.json
```

### How to Send Messages

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages

# Create message (replace RECIPIENT with sarah, donna, fulton, etc.)
cat > inbox/RECIPIENT/msg_$(date +%Y%m%d_%H%M%S)_ben_001.json <<'EOF'
{
  "from": "ben",
  "to": ["RECIPIENT"],
  "subject": "Your subject here",
  "body": "Your message content here",
  "ticket": "CALBE-XXX",
  "priority": "normal"
}
EOF

# Commit and push
git add inbox/
git commit -m "Message: ben -> RECIPIENT (subject)"
git push origin main
```

### Message-Aware Mode

When GotanMan says "message-aware on" or "start polling":

1. Announce: "Message-aware mode activated. Checking messages every 30 seconds."
2. Between tasks, periodically run:
   ```bash
   cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
   git pull origin main
   NEW_MESSAGES=$(ls inbox/ben/*.json 2>/dev/null | wc -l)
   if [ $NEW_MESSAGES -gt 0 ]; then
     echo "📬 $NEW_MESSAGES new message(s) for Ben"
     ls -lt inbox/ben/*.json
   fi
   ```
3. When messages arrive, alert GotanMan: "📬 New message from [sender] about [subject]"
4. Continue until told "message-aware off"

### Common Recipients

- **sarah** - Frontend developer (tangotiempo.com)
- **donna** - Your architect (backend guidance)
- **fulton** - Azure Functions developer
- **fred** - Frontend architect
- **azule** - Azure Functions architect
- **broadcast** - All agents see this
```

---

## For Fulton (calendar-be-af/.ybotbot/applicationPlaybook.md)

```markdown
## Inter-Agent Messaging (TIEMPO-322)

**Your Inbox**: `/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/inbox/fulton/`

### When to Check Messages

Check for messages from other agents:
1. **At session start** - After reading playbooks
2. **After completing major work** - Before SNR/handoff
3. **Before context switches** - Ticket, role, or branch changes
4. **When explicitly told** - "check messages", "message-aware on", "poll messages"

### How to Check Messages (Manual)

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main

# Check personal inbox
ls -lt inbox/fulton/

# Check broadcast messages
ls -lt inbox/broadcast/

# Read a message
cat inbox/fulton/msg_*.json
```

### How to Send Messages

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages

# Create message (replace RECIPIENT with sarah, ben, azule, etc.)
cat > inbox/RECIPIENT/msg_$(date +%Y%m%d_%H%M%S)_fulton_001.json <<'EOF'
{
  "from": "fulton",
  "to": ["RECIPIENT"],
  "subject": "Your subject here",
  "body": "Your message content here",
  "ticket": "CALBEAF-XXX",
  "priority": "normal"
}
EOF

# Commit and push
git add inbox/
git commit -m "Message: fulton -> RECIPIENT (subject)"
git push origin main
```

### Message-Aware Mode

When GotanMan says "message-aware on" or "start polling":

1. Announce: "Message-aware mode activated. Checking messages every 30 seconds."
2. Between tasks, periodically run:
   ```bash
   cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
   git pull origin main
   NEW_MESSAGES=$(ls inbox/fulton/*.json 2>/dev/null | wc -l)
   if [ $NEW_MESSAGES -gt 0 ]; then
     echo "📬 $NEW_MESSAGES new message(s) for Fulton"
     ls -lt inbox/fulton/*.json
   fi
   ```
3. When messages arrive, alert GotanMan: "📬 New message from [sender] about [subject]"
4. Continue until told "message-aware off"

### Common Recipients

- **sarah** - Frontend developer (tangotiempo.com)
- **ben** - Backend developer (calendar-be)
- **azule** - Your architect (Azure Functions guidance)
- **donna** - Backend architect
- **fred** - Frontend architect
- **broadcast** - All agents see this
```

---

## For Architects (Fred, Donna, Azule)

**Note**: Architects typically receive messages but may not send as frequently.

```markdown
## Inter-Agent Messaging (TIEMPO-322)

**Your Inbox**: `/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/inbox/[fred|donna|azule]/`

### When to Check Messages

As an architect, you receive questions and requests for guidance:
1. **When asked to review** - "Check messages", "any questions for you?"
2. **Before providing architecture guidance** - Context from developers
3. **When explicitly told** - "message-aware on", "poll messages"

### How to Check Messages (Manual)

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main

# Check personal inbox (replace with fred, donna, or azule)
ls -lt inbox/[YOUR_NAME]/

# Check broadcast messages
ls -lt inbox/broadcast/

# Read a message
cat inbox/[YOUR_NAME]/msg_*.json
```

### How to Send Guidance

Architects can send messages back to developers:

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages

# Create message (replace RECIPIENT and YOUR_NAME)
cat > inbox/RECIPIENT/msg_$(date +%Y%m%d_%H%M%S)_[YOUR_NAME]_001.json <<'EOF'
{
  "from": "[YOUR_NAME]",
  "to": ["RECIPIENT"],
  "subject": "Re: Your subject",
  "body": "Your architectural guidance here",
  "in_reply_to": "msg_id_from_original",
  "priority": "normal"
}
EOF

# Commit and push
git add inbox/
git commit -m "Message: [YOUR_NAME] -> RECIPIENT (architectural guidance)"
git push origin main
```

### Common Recipients

- **sarah** - Frontend developer (if you're Fred)
- **ben** - Backend developer (if you're Donna)
- **fulton** - Azure Functions developer (if you're Azule)
- **broadcast** - All agents see this
```

---

## For GotanMan

GotanMan can send broadcast messages to coordinate the team:

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages

# Send to everyone
cat > inbox/broadcast/msg_$(date +%Y%m%d_%H%M%S)_gotan_001.json <<'EOF'
{
  "from": "gotan",
  "to": ["broadcast"],
  "subject": "Sprint focus - Map center improvements",
  "body": "This week focusing on TIEMPO-312 through TIEMPO-320. Sarah leads frontend, Ben supports backend, Fulton reviews Azure Functions impact.",
  "priority": "high"
}
EOF

git add inbox/broadcast/
git commit -m "Broadcast: Sprint planning"
git push origin main
```

---

**Setup Complete!**

Copy the relevant section into each agent's `.ybotbot/applicationPlaybook.md` file.
