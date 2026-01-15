# Agent Collaboration Startup Guide

## Quick Start - Running Multiple Agents

When starting a collaboration session with multiple Claude Code agents, follow these steps:

### 1. Start Each Agent in Its Project Directory

Open separate terminal windows for each agent:

```bash
# Terminal 1 - Sarah (TangoTiempo)
cd /Users/tobybalsley/MyDocs/AppDev/MasterCalendar/tangotiempo.com
claude

# Terminal 2 - Cord (HarmonyJunction)
cd /Users/tobybalsley/MyDocs/AppDev/MasterCalendar/harmonyjunction.org
claude

# Terminal 3 - Ben (Backend API)
cd /Users/tobybalsley/MyDocs/AppDev/MasterCalendar/calendar-be
claude

# Terminal 4 - Fulton (Azure Functions)
cd /Users/tobybalsley/MyDocs/AppDev/MasterCalendar/calendar-be-af
claude
```

### 2. Start Message Polling for Each Agent

In each Claude session, tell the agent to start polling:

```
Start message polling
```

Or run manually:
```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/scripts
./start-polling.sh sarah   # For TangoTiempo terminal
./start-polling.sh cord    # For HarmonyJunction terminal
./start-polling.sh ben     # For Backend terminal
./start-polling.sh fulton  # For Azure Functions terminal
```

### 3. Verify All Pollers Running

```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/scripts
./stop-polling.sh
# This shows all currently running pollers without a name argument
```

---

## Agent Roster

| Agent | Project | Inbox | Role |
|-------|---------|-------|------|
| **Sarah** | tangotiempo.com | inbox/sarah/ | Frontend Dev (appId=1) |
| **Cord** | harmonyjunction.org | inbox/cord/ | Frontend Dev (appId=2) |
| **Ben** | calendar-be | inbox/ben/ | Backend API Dev |
| **Fulton** | calendar-be-af | inbox/fulton/ | Azure Functions Dev |
| **Donna** | - | inbox/donna/ | Backend Architect (advisory) |
| **Fred** | - | inbox/fred/ | Frontend Architect (advisory) |
| **Azule** | - | inbox/azule/ | Azure Architect (advisory) |
| **Gotan** | - | inbox/gotan/ | Human Owner |
| **broadcast** | All | inbox/broadcast/ | All agents receive |

---

## How Agents Communicate

### Sending a Message

Any agent can send to any other agent:

```bash
# Using the script
./scripts/send-message.sh sarah ben "API Update Needed" "The events endpoint needs a new filter parameter for recurring events" TIEMPO-400 high

# Or manually create JSON
cat > inbox/ben/msg_$(date +%Y%m%d_%H%M%S)_sarah_001.json <<'EOF'
{
  "from": "sarah",
  "to": ["ben"],
  "subject": "API Update Needed",
  "body": "The events endpoint needs a new filter parameter for recurring events",
  "ticket": "TIEMPO-400",
  "priority": "high"
}
EOF
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git add inbox/ && git commit -m "Message: sarah -> ben" && git push origin main
```

### Receiving Messages

Each agent's poller automatically:
1. Pulls git changes every 30 seconds
2. Checks for new messages in their inbox
3. Checks for broadcast messages
4. Notifies when new messages arrive

### Responding to Messages

When an agent receives a message, they should:
1. Read it: `cat inbox/AGENT_NAME/msg_*.json | jq '.'`
2. Take action based on content
3. Send response if needed
4. Archive when done:
   ```bash
   mkdir -p archive/$(date +%Y-%m-%d)
   mv inbox/AGENT_NAME/msg_*.json archive/$(date +%Y-%m-%d)/
   git add . && git commit -m "Archive processed messages" && git push origin main
   ```

---

## Collaborative Problem Solving

### Scenario: Cross-App Bug

1. **Cord** (HarmonyJunction) discovers a bug affecting both apps
2. **Cord** sends to broadcast:
   ```json
   {
     "from": "cord",
     "to": ["broadcast"],
     "subject": "Shared Backend Bug - appId filter not working",
     "body": "Events API returning events for both appIds. Need backend fix.",
     "priority": "high"
   }
   ```
3. **Ben** receives broadcast, investigates backend
4. **Ben** sends to Sarah and Cord with findings:
   ```json
   {
     "from": "ben",
     "to": ["sarah", "cord"],
     "subject": "RE: appId filter bug - Found cause",
     "body": "Missing appId filter in aggregation pipeline. Fixing now.",
     "ticket": "CALBE-XXX"
   }
   ```
5. **Sarah** and **Cord** can continue other work while waiting
6. **Ben** sends completion message when fixed

### Scenario: Feature Coordination

1. **Gotan** broadcasts a new feature request:
   ```json
   {
     "from": "gotan",
     "to": ["broadcast"],
     "subject": "New Feature: Event Recurrence",
     "body": "Need recurring events. Backend first, then frontends. Discuss approach.",
     "priority": "high"
   }
   ```
2. All agents receive and can discuss via messages
3. **Ben** leads backend implementation
4. **Sarah** and **Cord** wait for API ready message
5. Once Ben signals ready, frontends implement in parallel

---

## Permissions Summary

All agents now have:
- Read access: All MasterCalendar projects (`/Users/tobybalsley/MyDocs/AppDev/MasterCalendar/**`)
- Read/Write access: Agent messages (`/Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/**`)
- Git operations: add, commit, push, pull for message repo
- Polling: while loops, sleep, pkill for background processes

---

## Troubleshooting

### Poller not starting
```bash
# Check if already running
ps aux | grep poll-agent

# Kill any orphan processes
pkill -f poll-agent.sh

# Restart
./scripts/start-polling.sh AGENT_NAME
```

### Messages not appearing
```bash
# Manual pull
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git pull origin main

# Check inbox
ls -lt inbox/AGENT_NAME/
```

### Permission denied
```bash
# Make scripts executable
chmod +x /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/scripts/*.sh
```

---

## Commands Summary

| Command | Description |
|---------|-------------|
| `./scripts/start-polling.sh AGENT` | Start background polling |
| `./scripts/stop-polling.sh AGENT` | Stop background polling |
| `./scripts/check-messages.sh AGENT` | One-time message check |
| `./scripts/send-message.sh FROM TO SUBJ BODY` | Send a message |
| `tail -f /tmp/AGENT-poller.log` | Watch poller output |

---

## Test the System

1. Start polling for all agents
2. Send a test broadcast:
   ```bash
   ./scripts/send-message.sh gotan broadcast "System Test" "Testing agent collaboration system"
   ```
3. Verify all agents received the message in their poller logs
4. Each agent should acknowledge receipt

---

*Last Updated: 2026-01-15*
*Maintained By: MasterCalendar Team*
