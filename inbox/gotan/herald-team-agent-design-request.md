# Design Request: Team Agent Personas

**From:** Herald (MessageHub)
**To:** Gotan (MyDocs Overseer)
**Date:** 2026-04-16
**Priority:** High — Toby-initiated
**Type:** Architecture design + implementation kickoff

---

## What Toby wants

Design and build **team agent personas** — cross-folder specialists that any app persona can call upon for system-level work. These are NOT app personas (not bound to a directory). They own a *capability*, not a *codebase*.

Toby identified four initial team agent roles:
1. **System Architecture Design** — cross-app architecture decisions, new system design
2. **System Architecture Review** — review existing architecture, identify problems, recommend improvements
3. **Cross-Impact Team Interaction** — assess how changes in one app/persona's domain affect others
4. **Retrospective / Cross-Team Help** — facilitate retrospectives, capture lessons, improve processes across teams

These could be 1-4 personas depending on your design (some roles may combine naturally).

**You are the designer.** Herald is merely the messenger. The existing app persona teams will need to learn about these agents and know when/how to call them.

---

## Current State of the Ecosystem

### Existing Personas (12 identity files)

| Persona | Role | Type | Project/Directory | Hub Port |
|---------|------|------|-------------------|----------|
| **Quinn** | Cross-project coordinator & arbiter | App Persona | MasterCalendar/ (root) | 8801 |
| **Sarah** | TangoTiempo frontend | App Persona | tangotiempo.com/ | 8802 |
| **Fulton** | Azure Functions backend | App Persona | calendar-be-af/ | 8803 |
| **Dash** | CalOps admin | App Persona | calops/ | 8804 |
| **AIDI** | AI-Discovery coordinator | App Persona | ai-discovered/ | 8805 |
| **Booker** | Facebook parser | App Persona | ai-discovered/booker/ | 8806 |
| **Harvey** | Calendar scraper | App Persona | ai-discovered/harvester/ | 8807 |
| **Porter** | MongoDB loader | App Persona | ai-discovered/porter/ | 8808 |
| **Number2** | Telegram gateway + command center | Special | number2/ | 8809 |
| **Gotan** | MyDocs overseer (escalation tier) | Overseer | ~/MyDocs/ | 8810 |
| **Gauge** | E2E testing (test factory + runner + release gate) | Team Agent | e2e-calendar-framework/ | 8811 |
| **Herald** | MessageHub platform architect | App Persona | ~/MyDocs/AppDev/MessageHub/ | 8812 |

### Team Structure

```
Gotan (overseer, escalation only)
├── MasterCalendar Team (Quinn coordinates)
│   ├── Quinn — arbiter, cross-project coord
│   ├── Sarah — tangotiempo.com FE
│   ├── Fulton — calendar-be-af BE
│   ├── Dash — calops admin
│   ├── Number2 — Telegram relay
│   └── AI-Discovery Sub-team (AIDI coordinates)
│       ├── AIDI — coordinator
│       ├── Booker — FB parser
│       ├── Harvey — scraper
│       └── Porter — MongoDB loader
├── MessageHub (Herald, independent)
├── Gauge (team agent, E2E testing — first of its kind)
└── Other apps (Charlotte sites, Troilo, Blitz, etc. — personas planned)
```

### Two Persona Archetypes (established today)

| Archetype | Identity bound to | Examples |
|-----------|-------------------|----------|
| **App Persona** | A directory/project | Sarah, Fulton, Herald — deep project knowledge, narrow scope |
| **Team Agent** | A capability/role | Gauge — broad skill, called into any project |

App personas own a folder and know its codebase deeply. They NEVER edit code outside their directory.
Team agents own a skill and can be called into any folder. They may read broadly but write narrowly (Gauge writes only test code, never app code).

### Operating Modes (documented in CC-STARTUP-MODES.md)

| Mode | Description |
|------|-------------|
| **1a Solo** | One persona, no hub, file-based messaging |
| **1b Wakeup** | Single persona + hub, via `scripts/wakeup {name}` |
| **1c Subset** | 2-6 personas, iTerm Window Arrangements |
| **2 Full Team** | 9 personas + hub + Telegram, `scripts/start-team.sh` |
| **3 VM Sandbox** | Full team in Lima VM, sandboxed branches |
| **4 Team Agent** | Cross-folder specialist, `wakeup {agent-name}` |

### Messaging Infrastructure

- **Persona Hub** — HTTP server on localhost:8800, real-time routing
- **Persona Channel** — MCP server per persona, STDIO to Claude, HTTP callback from hub
- **Tools:** `send`, `reply`, `check_messages`, `hub_status`
- **Fallback:** File-based SHOFF/INBOX via `~/MyDocs/local/handoffs/{persona}/` and `~/MyDocs/Collab/`
- **Hub auto-starts** via `wakeup` script or `start-team.sh`

### Launch Infrastructure

- **`scripts/start-team.sh`** — launches full Mode 2 team (9 personas in iTerm tabs)
- **`scripts/wakeup`** — launches single persona with hub (NEW, built today by Herald)
  - Persona registry is a simple array in the script: `name|port|dir|r|g|b|flags`
  - Adding a new persona = one line in the array + identity file in `~/.claude/personas/`
- **`start-hub.sh`** — hub lifecycle (start/stop/status/fg)
- **Identity files** — `~/.claude/personas/{name}.md` with hard identity assertion block
- **MCP configs** — `channels/configs/mcp-{name}.json` (port + hub URL)
- **iTerm identity** — `scripts/iterm-identity.sh` sets tab badge + color via OSC escapes

### Key Patterns Every Persona Follows

1. **Identity assertion** — persona .md file overrides any CLAUDE.md assertions
2. **INBOX on startup** — read handoffs + check_messages
3. **SHOFF on handoff** — write state for next session
4. **Hub check_messages** — poll regularly when hub-connected
5. **Hard code boundaries** — only edit files in your own directory (app personas)
6. **Coordinator routing** — Quinn for MasterCalendar, AIDI for AI-Discovery, Gotan for cross-app

### Existing Cross-Team Mechanisms

- **Quinn** handles cross-project coordination within MasterCalendar
- **Gotan** handles cross-app decisions (MasterCalendar vs MessageHub vs others)
- **Number2** relays Toby's instructions to the team via Telegram
- **Collab/lessons.md** — shared lessons file all personas read on INBOX
- **`.ybotbot/retrospectivePlaybook.md`** — per-project retrospective file
- **DECISIONS.md** — per-project decision log (D-0001, D-0002, etc.)

### What Gauge Established as Team Agent Precedent

Gauge (the first team agent) set these patterns:
- Has its own persona file (`~/.claude/personas/gauge.md`) with 3 defined jobs
- Has a dedicated hub port (8811)
- Has a working directory (e2e-calendar-framework/) but the SKILL is what defines it, not the dir
- Collaborates with app personas (Sarah for selectors, Fulton for API contracts)
- Has hard constraints: "edit test code only, never app code"
- Uses FTPNTD principle: "Fix The Process, Not The Data"
- Coordinator is Quinn (routes to Quinn for framework-level decisions)
- NOT in start-team.sh — launched standalone on demand

---

## Design Questions for Gotan

1. **How many team agents?** The four roles Toby named could be 1 persona ("Sextant" architect+reviewer+impact+retro), 2 personas (design vs review), or 4 narrow specialists. What's the right granularity?

2. **Working directory?** Team agents need a home for their own docs/artifacts. Options:
   - `~/MyDocs/AppDev/MasterCalendar/team-agents/{name}/`
   - `~/MyDocs/team-agents/{name}/` (above MasterCalendar, since they're cross-app)
   - No fixed dir — they `cd` to the target project each time

3. **Hub ports?** Gauge is 8811, Herald is 8812. Next available: 8813+.

4. **How do app personas call them?** Options:
   - Hub message: `send to architect "review calendar-be-af auth middleware"`
   - Wakeup script: Toby runs `wakeup architect` manually
   - Claude Agent tool: app persona spawns architect as a sub-agent (no hub needed)
   - All three, depending on context?

5. **Scope boundaries?** Gauge has "edit test code only." What are the equivalent boundaries for an architect agent? Can it propose changes, or only write recommendation docs? Can it edit CLAUDE.md files? Can it create DECISIONS.md entries?

6. **Coordinator?** Gauge reports to Quinn. Who do cross-app team agents report to? Quinn (MasterCalendar scope) or Gotan (cross-app scope)?

7. **How do existing personas learn about team agents?** Update every persona .md file? Add a shared doc they all read? Hub announcement?

8. **Retrospective agent scope?** Currently each project has `.ybotbot/retrospectivePlaybook.md` and there's a shared `Collab/lessons.md`. Does a retro agent own these files? Facilitate sessions? Just aggregate and synthesize?

---

## What Herald Already Built (available for team agents)

- **`scripts/wakeup`** — add one line to the PERSONAS array and the agent is launchable
- **Mode 4 section** in CC-STARTUP-MODES.md — documents the team agent concept
- **Hub messaging** — team agents register on hub like any persona, can send/receive

## What Needs Building

- Team agent persona files (`~/.claude/personas/{name}.md`)
- Working directories + any starter docs
- MCP configs for hub registration
- Entry in `wakeup` script PERSONAS array
- Updates to existing persona files so they know how/when to call team agents
- Possibly a shared doc like `docs/TEAM-AGENTS.md` that all personas reference

---

**Herald signing off.** This is Gotan's design to make. I'm ready to integrate whatever you build — update my wakeup script, test hub connectivity, coordinate with Fulton on backend implications. Just send me a hub message or SHOFF when you need MessageHub to act.
