# Collab - Cross-Persona Messaging & Handoffs

**Repo**: https://github.com/ybotman/Collab
**Local Path**: `/Users/tobybalsley/MyDocs/Collab`
**Status**: Active

---

## What This Is

Git-based messaging and handoff system for AI-GUILD personas to communicate across projects and machines.

## 5-Command System

| Command | Type | Tier | Action |
|---------|------|------|--------|
| **INBOX** | Startup | Local | Read `~/.claude/local/handoffs/{me}/` |
| **INBOX2** | Startup | Git | git pull + check Collab handoffs + inbox |
| **SHOFF** | Self-handoff | Local | Write to `~/.claude/local/handoffs/{me}/` |
| **SHOFF2** | Self-handoff | Git | Write to `Collab/handoffs/{me}/` + push |
| **MSG {to}** | Message | Git | Write to `Collab/inbox/{to}/` + push |

## 4-Tier Model

```
┌─────────────────────────────────────────────────────────────┐
│  JIRA                          (permanent, tracked work)    │
├─────────────────────────────────────────────────────────────┤
│  Collab (git)                  (cross-machine, days/weeks)  │
│  └── SHOFF2, MSG                                            │
├─────────────────────────────────────────────────────────────┤
│  Local                         (same machine, ephemeral)    │
│  └── SHOFF                                                  │
├─────────────────────────────────────────────────────────────┤
│  Copy/Paste                    (human-mediated, instant)    │
└─────────────────────────────────────────────────────────────┘
```

---

## Personas

| Persona | Project | Role |
|---------|---------|------|
| **gotan** | MyDocs | Overseer |
| **quinn** | MasterCalendar | Cross-Project Coordinator |
| **sarah** | tangotiempo.com | Frontend (appId=1) |
| **fulton** | calendar-be-af | Azure Functions Backend |
| **harmony/cord** | harmonyjunction.org | Frontend (appId=2) |
| **dash** | calops | Operations Dashboard |
| **tempo** | NTTT | Developer |
| **atlas** | MasterCalendar | System Architect |
| **claw** | fb-conditioner | Pipeline Developer |
| **porter** | ai-discovered | Event Runner |

---

## Directory Structure

```
/Users/tobybalsley/MyDocs/Collab/
├── config/
│   ├── messaging-strategy.md   # Full system documentation
│   ├── commands.md             # Command reference
│   └── personas.json           # Persona registry
├── handoffs/{persona}/         # SHOFF2 writes here
├── inbox/{persona}/            # MSG writes here
└── archive/                    # Processed messages
```

**Local (not git):**
```
~/.claude/local/
├── handoffs/{persona}/         # SHOFF writes here
└── inbox/{persona}/            # Reserved
```

---

## Quick Reference

### Session Start
```bash
# Local only (fast)
INBOX

# Full sync (cross-machine)
INBOX2
```

### Session End
```bash
# Same machine tomorrow
SHOFF

# Different machine or long break
SHOFF2
```

### Send Message
```bash
MSG fulton    # Send to Fulton
MSG broadcast # Send to all
```

---

## Message Format

```json
{
  "from": "persona-name",
  "to": ["recipient"],
  "subject": "Brief subject",
  "body": "Full message content",
  "priority": "normal",
  "timestamp": "ISO 8601"
}
```

---

**Updated**: 2026-02-22
**Maintained By**: Gotan (Overseer)
