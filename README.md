# Freelance Developer Harness

> Where vision meets execution.

A structured agency operating system for Claude Code. Manages multiple client projects through a three-council model with enforced quality gates, session-scoped context locking, and an automated PM-driven workflow.

---

## What This Is

This harness turns Claude Code into a full agency team. Instead of one assistant doing everything ad-hoc, work flows through specialized roles (architects, designers, developers, QA, security) with hard gates that prevent skipping steps. The Product Manager owns the pipeline and delegates to the right agent at each stage.

It is not a code framework. It lives alongside your projects — specs, deliverables, and docs live here; source code lives in separate per-project repos.

---

## How the Pieces Fit Together

```
freelance-developer-harness/      ← this repo (docs, specs, harness config)
│
├── .claude/                      ← Claude Code integration
│   ├── agents/                   ← 16 role definitions (PM, Architect, QA, etc.)
│   ├── commands/                 ← slash commands (/pm, /intake, /kickoff, etc.)
│   ├── hooks/                    ← auto-inject client context on every prompt
│   └── sessions/                 ← per-session client locks (isolated)
│
├── clients/                      ← one folder per client
│   ├── _template/                ← blueprint for new clients
│   ├── example-client/           ← example of a populated workspace
│   └── your-client/              ← created by /onboard-client
│       └── projects/
│           └── your-project/     ← specs, QA, deliverables
│
├── patterns/                     ← reusable patterns (ADR, design system, etc.)
├── templates/                    ← document templates (brief, spec, sprint plan)
├── docs/                         ← SOPs, workflows, onboarding
├── CLAUDE.md                     ← harness operating model (loaded automatically)
└── AGENTS.md                     ← team roster and governance matrix

$SOURCE_ROOT_BASE/                ← source code lives HERE, not in the harness
├── your-project/                 ← actual project repo
└── another-project/
```

The harness and source code are **always separate**. The harness holds intent (specs, briefs, deliverables). The project repo holds implementation.

---

## The Team

Three councils, all directed by the Product Manager.

```
                        ┌─────────────────┐
                        │  Product Manager │  ← organizational lead
                        │  (orchestrator)  │
                        └────────┬────────┘
                                 │
           ┌─────────────────────┼─────────────────────┐
           ▼                     ▼                     ▼
   ┌───────────────┐    ┌────────────────┐    ┌────────────────┐
   │   Creative    │    │   Technical    │    │   Delivery     │
   │   Council     │    │   Council      │    │   Council      │
   ├───────────────┤    ├────────────────┤    ├────────────────┤
   │ Creative Dir  │    │ Solution Arch  │    │ Account Lead   │
   │ Innovation    │    │ Frontend Dev   │    │ Tech Writer    │
   │ UX Researcher │    │ Backend Dev    │    │ QA Specialist  │
   │ UI Designer   │    │ Apple Eng      │    │ GitHub/VC Spec │
   │               │    │ LLM Engineer   │    │                │
   │               │    │ Blockchain Eng │    │                │
   │               │    │ Security Rev   │    │                │
   └───────────────┘    └────────────────┘    └────────────────┘
```

Invoke any agent via `Agent tool` with `subagent_type` matching the role name (e.g. `solution-architect`, `qa-specialist`). The PM does this automatically when you use `/pm`.

---

## Workflow Pipeline

Every piece of work follows this path. The PM drives it automatically — you don't manually advance stages.

```
  Client Need
       │
       ▼
  ┌──────────────────────────────────────────────┐
  │  GATE 1: Account Lead signs brief            │  ← no work starts without this
  └──────────────────┬───────────────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────────────┐
  │  PM: Epic breakdown + delegation plan        │
  └──────────────────┬───────────────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────────────┐
  │  Creative Council                            │
  │  Innovation Lead → UX Researcher → UI Design │
  │                                              │
  │  GATE 2: UX validation before handoff        │  ← blocking
  │  GATE 3: Creative Director approves design   │  ← blocking
  └──────────────────┬───────────────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────────────┐
  │  Technical Council                           │
  │  Solution Architect → Developers             │
  │                                              │
  │  GATE 4: Architecture sign-off               │  ← blocking
  └──────────────────┬───────────────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────────────┐
  │  Delivery Council                            │
  │  Tech Writer → QA → Security → GitHub/VC    │
  │                                              │
  │  GATE 5: QA approval                        │  ← blocking
  │  GATE 6: Security sign-off                  │  ← blocking
  └──────────────────┬───────────────────────────┘
                     │
                     ▼
                   Ship
```

Gates are **stop-the-line**. If QA blocks, nothing ships. If Security blocks, nothing goes live.

---

## Session Context Locking

The harness uses per-session locks to scope every prompt to the right client and project. Without a lock, you're working in global context. With a lock, every agent invocation, every file path, and every spec output automatically targets the correct workspace.

```
  /use-client acme-corp storefront
        │
        ▼
  .claude/sessions/<session-id>.client  ← "acme-corp/storefront"
        │
        ▼
  inject-active-client.sh fires on EVERY prompt
        │
        ├── Harness workspace → clients/acme-corp/projects/storefront/
        └── Source root       → $SOURCE_ROOT_BASE/storefront/
```

Locks are **session-isolated** — multiple terminal sessions can target different clients simultaneously.

```
  Terminal A: /use-client acme-corp storefront  →  works on storefront
  Terminal B: /use-client widgets-inc api       →  works on api
  (no cross-contamination)
```

---

## Claude Code Architecture

The harness is built on four Claude Code primitives that work together. Understanding how they connect explains why the harness behaves the way it does.

```
  User opens Claude Code
         │
         ▼
  ┌─────────────────────────────────────────────────────┐
  │  CLAUDE.md loads automatically                      │
  │  → operating model, team structure, governance      │
  │  → Claude reads this before every session           │
  └──────────────────────────┬──────────────────────────┘
                             │
         User types a prompt │
                             ▼
  ┌─────────────────────────────────────────────────────┐
  │  Hooks fire (UserPromptSubmit event)                │
  │  → inject-active-client.sh reads session lock       │
  │  → injects client/project context into the prompt  │
  │  → pm-status.sh injects PM routing if mode is on   │
  └──────────────────────────┬──────────────────────────┘
                             │
         ┌───────────────────┴──────────────────────┐
         │ plain prompt                              │ /command
         ▼                                           ▼
  ┌──────────────────┐                  ┌────────────────────────┐
  │  Claude responds │                  │  Command file executes │
  │  with context    │                  │  .claude/commands/*.md │
  │  already injected│                  │  → full prompt expands │
  └──────────────────┘                  └────────────┬───────────┘
                                                     │
                                                     ▼
                                        ┌────────────────────────┐
                                        │  Agent(s) spawned      │
                                        │  .claude/agents/*.md   │
                                        │  → persona + rules     │
                                        │  → tools + model       │
                                        │  → reads CLAUDE.md ctx │
                                        └────────────────────────┘
```

### CLAUDE.md — The Brain

`CLAUDE.md` is loaded automatically by Claude Code at the start of every session. It is the harness operating model: team structure, governance rules, workflow gates, multi-client conventions, and the search-first protocol. Every agent and command runs with this context already loaded — you never have to re-explain the rules.

```
CLAUDE.md
├── Organization identity ({{STUDIO_NAME}})
├── Core philosophy (5 principles)
├── Team structure (three councils + roles)
├── Automated workflow pipeline
├── Non-negotiable gates (stop-the-line)
├── Multi-client governance rules
├── Search-first protocol
└── Active clients table
```

### Agents — Specialized Subagents

Files in `.claude/agents/` define the 17 specialized roles. Each file is a subagent definition that Claude Code can spawn via the `Agent` tool with `subagent_type` set to the agent's name.

```
.claude/agents/solution-architect.md
├── name: solution-architect
├── description: when to spawn this agent (used by PM to route)
├── tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch
├── model: sonnet
└── body: persona, non-negotiable rules, standards, gate conditions
```

When the PM receives a task, it reads the `description` field of each agent to decide which ones to spawn and in what order. Agents run in full isolation — they read `CLAUDE.md` for context but don't share memory with each other.

**Blocking vs non-blocking agents:**

| Type | Examples | Behavior |
|---|---|---|
| Blocking gate | Solution Architect, QA Specialist, Security Reviewer | Work halts until they approve |
| Non-blocking | Frontend Dev, Backend Dev, UI Designer | Run in parallel, hand off output |
| Always independent | QA, Security, Creative Director | Never self-review — always spawned fresh |

### Commands — Slash Command Handlers

Files in `.claude/commands/` define slash commands. When you type `/pm build the checkout flow`, Claude Code reads `.claude/commands/pm.md`, substitutes `$ARGUMENTS` with `build the checkout flow`, and executes the resulting prompt.

```
/pm build the checkout flow
      │
      ▼
.claude/commands/pm.md  (with $ARGUMENTS = "build the checkout flow")
      │
      ▼
Spawns product-manager agent with full delegation instructions
      │
      ├── Spawns solution-architect (parallel)
      ├── Spawns ux-researcher (parallel)
      └── Waits for gates, advances pipeline
```

Commands are plain markdown files — no code. The entire command logic is a structured natural language prompt that tells Claude exactly what to do, in what order, and when to stop.

### Hooks — Automatic Context Injection

Files in `.claude/hooks/` are shell scripts wired to Claude Code events in `.claude/settings.json`. They run automatically — the user never invokes them.

```json
// .claude/settings.json
{
  "hooks": {
    "UserPromptSubmit": [
      { "command": "bash .claude/hooks/inject-active-client.sh" },
      { "command": "bash .claude/hooks/pm-status.sh" }
    ]
  }
}
```

**`inject-active-client.sh`** — On every prompt, reads `.claude/sessions/<session-id>.client` and injects a `<system-prompt-injection>` block telling Claude:
- Which client and project are active
- Where the harness workspace is (`clients/<client>/<project>/`)
- Where source code lives (`$SOURCE_ROOT_BASE/<project>/`)
- Never to cross client boundaries

**`pm-status.sh`** — If PM mode is on (`.claude/sessions/<session-id>.pm-mode` = `on`), injects PM routing instructions so every prompt is automatically delegated without needing `/pm`.

Hooks are also how `SESSION_ID` flows into every prompt — the inject script reads it from the JSON payload and re-injects it so commands like `/use-client` and `/pm on` can write the right session file.

### Settings — Wiring and Permissions

`.claude/settings.json` does two things:

**1. Wires hooks to events** (shown above)

**2. Sets tool permissions** — what agents are allowed to do without prompting the user:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",        // git operations always allowed
      "Read(**)",           // read any file
      "Write(clients/**)",  // write inside client workspaces
      "Write(.claude/sessions/*)"  // session state
    ],
    "deny": [
      "Bash(rm -rf *)",     // no destructive shell ops
      "Write(.env)"         // never overwrite secrets
    ]
  }
}
```

### How It All Connects

A full `/pm` invocation flows through all four primitives:

```
1. User types: /pm build the checkout flow

2. Hook fires → inject-active-client.sh injects:
   CLIENT=acme-corp, PROJECT=storefront,
   WORKSPACE=clients/acme-corp/projects/storefront/,
   SOURCE_ROOT=$SOURCE_ROOT_BASE/storefront/

3. Command executes → .claude/commands/pm.md expands with
   $ARGUMENTS = "build the checkout flow"
   → Instructions: assess scope, load context, build delegation plan

4. PM agent spawns (product-manager.md):
   → Reads CLAUDE.md: knows the gates, councils, governance
   → Reads client workspace: loads existing specs, ADRs
   → Spawns solution-architect + ux-researcher in parallel
   → Waits for arch sign-off (gate)
   → Spawns frontend-developer + backend-developer
   → Spawns qa-specialist (blocking gate)
   → Spawns security-reviewer (blocking gate)
   → Writes PM summary to clients/acme-corp/projects/storefront/specs/

5. Result surfaces to user: summary of what was built, what gates passed
```

---

## Slash Commands

| Command | What it does |
|---|---|
| `/use-client <slug>` | Lock session to client or project |
| `/pm <task>` | Invoke PM to orchestrate work end-to-end |
| `/pm on` / `/pm off` | Enable persistent PM mode (auto-routes all prompts) |
| `/intake` | Run intake for a new piece of work |
| `/kickoff` | Run full project kickoff (PM leads discovery) |
| `/sprint-plan` | Plan a sprint |
| `/arch-review` | Architecture review with Solution Architect gate |
| `/design-review` | Design review with Creative Director + UX gates |
| `/ideate` | Structured ideation session |
| `/client-report` | Generate client status report |
| `/retro` | Run sprint/project retrospective |
| `/onboard-client` | Onboard a new client (creates workspace) |

---

## Hooks

Two hooks run automatically on every prompt:

**`inject-active-client.sh`** — Reads the session lock file and injects client/project context into every prompt. Agents automatically know which workspace and source root to use.

**`pm-status.sh`** — When PM mode is on, injects PM routing instructions so all work is automatically delegated without needing to invoke `/pm` explicitly.

These hooks are what make the session locking "sticky" — you set it once per session, and it follows every subsequent message.

---

## Multi-Client Governance

```
clients/
├── _template/                  ← copy this to onboard new client
├── <client-slug>/
│   ├── README.md               ← client overview
│   ├── brief.md                ← signed client brief (Account Lead owns)
│   ├── requirements.md
│   └── projects/
│       └── <project-slug>/
│           ├── specs/          ← ADRs, PM summaries, architecture docs
│           ├── design/         ← design assets and briefs
│           ├── deliverables/   ← client-facing outputs
│           └── qa/             ← test plans, QA reports
```

Rules:
- Client data **never crosses boundaries** — `acme-corp/storefront` content never appears in `widgets-inc`
- Source code lives in `$SOURCE_ROOT_BASE/<project-slug>/` — **never** inside the harness
- Shared reusable work goes in `patterns/` only
- All architectural decisions → ADR in `specs/`

---

## Search-First Protocol

Agents have no persistent memory across sessions. Every session starts cold. The search-first protocol is how agents avoid re-doing, re-litigating, or contradicting work that already happened.

Before building anything:

```
1. patterns/                                        ← reusable cross-project patterns
2. clients/<client>/projects/<project>/specs/       ← this project's decisions and history
3. templates/                                       ← document scaffolding
4. Solution Architect sign-off                      ← validate before building net-new
```

### What lives in `specs/`

`clients/<client>/projects/<project>/specs/` is the project's written memory:

```
specs/
├── adr-001-system-architecture.md     ← Architecture Decision Records
├── adr-002-database-choice.md         ← one ADR per significant decision
├── pm-summary-sprint-1.md             ← PM writes this after every major task
├── pm-summary-checkout-feature.md     ← what shipped, what gates passed
├── arch-review.md                     ← Solution Architect sign-off record
├── innovation-brief-payment-ux.md     ← Innovation Lead output
└── security-review.md                 ← Security Reviewer findings
```

**ADRs (Architecture Decision Records)** capture what was decided, why, what alternatives were rejected, and what the consequences are. Once written, they are binding. An agent proposing something that contradicts an ADR must justify the change — it cannot simply ignore it.

**PM summaries** are written by the PM after completing substantive work. They record what was built, which agents ran, what gates were hit, and what the outcome was. A new session reads these to understand project state without needing to re-derive it from code.

Why this matters: an agent asked to add a Redis cache might propose it confidently — until it reads `adr-003-no-external-cache.md` and learns it was ruled out three sprints ago for a specific reason. Without that read, it would propose rejected work. With it, it builds on settled decisions instead of reopening them.

---

## Getting Started

### First time setup

```bash
bash scripts/setup.sh
# interactive wizard — configures .env and patches CLAUDE.md
```

### Start working on a project

```bash
# in Claude Code, lock to your project
/use-client acme-corp storefront

# now all agents and file paths auto-scope to that project
# source code edits go to $SOURCE_ROOT_BASE/storefront/
# specs and docs go to clients/acme-corp/projects/storefront/
```

### Kick off new work

```bash
# let the PM orchestrate everything
/pm build the checkout flow for storefront

# or run structured intake
/intake
```

### Enable persistent PM routing

```bash
/pm on
# every subsequent prompt is automatically PM-routed
# PM delegates to the right agents without you having to invoke /pm each time
```

### Onboard a new client

```bash
/onboard-client acme-corp
# creates clients/acme-corp/ from template
# Account Lead runs brief intake
# workspace is ready for work
```

---

## Effective Usage

**Lock your session first.** Without `/use-client`, agents guess context. With it, everything is automatic.

**Use `/pm` for anything non-trivial.** Single-file edits you can do directly. A new feature, a sprint, an architecture change — route through PM so gates get hit.

**Let gates block you.** When QA or Security blocks, that's the system working correctly. Fix the blocker, don't route around it.

**Write ADRs for architecture decisions.** Memory is unreliable. The ADR template is in `templates/adr.md`. Solution Architect writes them during arch review.

**Check `patterns/` before building.** The patterns library exists to prevent re-inventing the wheel across client projects.

---

## Active Clients

| Client | Project | Status |
|---|---|---|
| your-client | your-project — brief description | Active |
| example-client | storefront — example populated workspace | Example |

---

## Key Files

| File | Purpose |
|---|---|
| `CLAUDE.md` | Complete operating model — loaded automatically by Claude Code |
| `AGENTS.md` | Full team roster, authorities, gates, governance matrix |
| `docs/onboarding.md` | Team setup and philosophy |
| `patterns/` | Reusable architecture and design patterns |
| `templates/` | ADR, brief, spec, sprint plan templates |
| `docs/workflows/` | Detailed workflow docs per stage |
| `docs/sops/` | Standard operating procedures |
