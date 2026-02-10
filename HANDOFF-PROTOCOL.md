# Agent Handoff Protocol

**Purpose**: Maintain continuity across Claude Code sessions through self-handoff files.

---

## The Problem

Claude Code sessions restart frequently. Without handoffs:
- Context is lost
- Work gets duplicated
- Agents forget decisions made
- Blocked items get forgotten

## The Solution: Self-Handoffs

Each agent writes a handoff file at session end that their **future self** reads on startup.

```
Session 1 (Sarah)          Session 2 (Sarah)
      │                          │
      │ writes                   │ reads
      ▼                          ▼
  handoffs/sarah/           handoffs/sarah/
  session_2026-02-10.md     session_2026-02-10.md
```

---

## Directory Structure

```
agent-messages/
├── inbox/           # Cross-agent messages
│   ├── sarah/
│   ├── fulton/
│   └── ...
├── handoffs/        # Self-handoffs (session continuity)
│   ├── sarah/
│   │   └── session_YYYY-MM-DDTHH-MM.md
│   ├── fulton/
│   │   └── session_YYYY-MM-DDTHH-MM.md
│   ├── quinn/
│   ├── cord/
│   └── broadcast/   # Team-wide status updates
└── HANDOFF-TEMPLATE.md
```

---

## Session Startup Protocol

**Every agent MUST do this at session start:**

```bash
# 1. Check for latest self-handoff
LATEST_HANDOFF=$(ls -t /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/handoffs/{AGENT}/*.md 2>/dev/null | head -1)
[ -n "$LATEST_HANDOFF" ] && cat "$LATEST_HANDOFF"

# 2. Check inbox for messages
ls -lt /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/inbox/{AGENT}/*.json 2>/dev/null | head -5

# 3. Check broadcasts
ls -lt /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/inbox/broadcast/*.json 2>/dev/null | head -3

# 4. Report status to user
```

**Then tell the user:**
- What you were working on (from handoff)
- Any pending messages
- Recommended next steps

---

## Session Shutdown Protocol (Before Ending)

**When user says "done", "goodbye", "end session", or similar:**

1. **Write handoff file**:
```bash
cat > /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages/handoffs/{AGENT}/session_$(date +%Y-%m-%dT%H-%M).md <<'EOF'
# Session Handoff: {AGENT} @ {TIMESTAMP}

## Current Status
{ONE_LINE}

## Active Ticket
- **Ticket**: {JIRA_KEY}
- **Status**: {in_progress|blocked|completed}

## What I Did This Session
- {BULLETS}

## Next Session Should
1. {NEXT_STEPS}

## Key Decisions Made
- {DECISION}: {WHY}

## Files Modified
- {FILES}

## Context for Future Me
{IMPORTANT_CONTEXT}
EOF
```

2. **Commit and push**:
```bash
cd /Users/tobybalsley/Documents/AppDev/MasterCalendar/agent-messages
git add handoffs/
git commit -m "Handoff: {AGENT} session {DATE}"
git push origin main
```

3. **Tell user**: "Handoff saved. Next session will pick up where we left off."

---

## Handoff File Format

See `HANDOFF-TEMPLATE.md` for full template.

**Required sections:**
- Current Status (one line)
- Active Ticket (if any)
- What I Did
- Next Session Should
- Context for Future Me

**Optional sections:**
- Key Decisions Made
- Files Modified
- Messages Sent (Pending Response)
- Blocked On

---

## Cross-Agent Handoffs

If work needs to continue with a **different agent**, send a message instead:

```bash
cat > inbox/fulton/msg_$(date +%Y%m%d_%H%M%S)_sarah_001.json <<'EOF'
{
  "from": "sarah",
  "to": ["fulton"],
  "subject": "Handoff: TIEMPO-360 needs backend work",
  "body": "Frontend complete. Need EventsSummary endpoint updated...",
  "ticket": "TIEMPO-360",
  "priority": "normal"
}
EOF
```

---

## Retention Policy

- Keep last 5 handoffs per agent
- Archive older ones to `handoffs/{agent}/archive/`
- Or just let git history preserve them

---

## Commands

| Command | When | What |
|---------|------|------|
| **Startup** | Session start | Read latest handoff + check inbox |
| **`/handoff`** | Session end | Write handoff file |
| **`check messages`** | Anytime | Check inbox for new messages |

---

## Example Flow

```
┌─────────────────────────────────────────────────────────────────┐
│ SESSION 1: Sarah works on TIEMPO-360                            │
├─────────────────────────────────────────────────────────────────┤
│ 1. Reads CLAUDE.md, auto-memory                                 │
│ 2. Works on feature                                             │
│ 3. Gets blocked on backend issue                                │
│ 4. Sends message to Fulton                                      │
│ 5. User says "done for today"                                   │
│ 6. Sarah writes handoff: "Blocked on CALBEAF-76"               │
│ 7. Commits handoff to git                                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ (time passes, Claude restarts)
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│ SESSION 2: Sarah resumes                                        │
├─────────────────────────────────────────────────────────────────┤
│ 1. Reads CLAUDE.md                                              │
│ 2. Reads latest handoff → "Was blocked on CALBEAF-76"          │
│ 3. Checks inbox → Message from Fulton: "Fixed, deployed"       │
│ 4. Reports to user: "Ready to continue TIEMPO-360"             │
│ 5. Resumes work with full context                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## Benefits

- **No context loss** between sessions
- **Human-readable** markdown files
- **Git-tracked** history of all handoffs
- **Cross-agent aware** via messaging
- **Self-documenting** work log
- **Debuggable** - you can read/edit handoffs manually

---

*Created: 2026-02-10 by Quinn*
