---
description: Invoke the Product Manager to marshal and orchestrate work across all councils
---

## Session-scoped PM lock

The PM command is session-scoped.
PM mode state is stored in `.claude/sessions/<SESSION_ID>.pm-mode` (contains "on" or "off").

**Special subcommands — handle these directly without spawning an agent:**

### If $ARGUMENTS is "on":
- The SESSION_ID is injected into the system prompt as `SESSION_ID = <value>`. Read it from there; if not present, use "default".
- Run `mkdir -p .claude/sessions && echo "on" > ".claude/sessions/<SESSION_ID>.pm-mode"` via Bash.
- Confirm: "PM mode enabled. Every prompt will now be routed through the PM."
- Stop here.

### If $ARGUMENTS is "off":
- The SESSION_ID is injected into the system prompt as `SESSION_ID = <value>`. Read it from there; if not present, use "default".
- Run `rm -f ".claude/sessions/<SESSION_ID>.pm-mode" && echo "off"` via Bash.
- Confirm: "PM mode disabled."
- Stop here.

### If $ARGUMENTS is "status" or "list":
- The SESSION_ID is injected into the system prompt as `SESSION_ID = <value>`. Read it from there; if not present, use "default".
- Run `ls .claude/sessions/*.pm-mode 2>/dev/null || echo "(none)"` via Bash to find all sessions with PM mode enabled.
- For each `.pm-mode` file found, print the session ID (filename without `.pm-mode`) and whether mode is on/off.
- Print current session PM mode status: ON or OFF.
- Stop here.

---

## Otherwise — invoke the PM agent

Use the Agent tool to spawn the product-manager subagent with the following task:

**Task:** $ARGUMENTS

**Instructions for the PM agent:**

You are being invoked to lead and orchestrate the following work: $ARGUMENTS

Execute the full automated workflow:

1. **Assess the request** — Is this intake (new project), a sprint (ongoing work), or a targeted delegation (specific epic/feature)?

2. **Load context** — Read the active client lock at `.claude/sessions/<SESSION_ID>.client` if present (contents: `<client>` or `<client>/<project>`). Use it to locate the correct workspace under `clients/<client>/projects/<project>/`. If no lock is set, ask once and run `/use-client` before proceeding — without a lock the client boundary guard is inactive.

3. **Produce a delegation plan** — Break the work into epics, assign each to the correct council and agent, map dependencies, and identify the critical path.

4. **Execute immediately** — Spawn the required agents in parallel where dependencies allow. Do not wait for manual prompting between stages. Collect each agent's output, verify the gate is satisfied, and advance.

5. **Surface blockers** — If a gate is blocked, say so explicitly with the blocker, impact, and your recommended resolution. Do not stall silently.

6. **Write a summary** — When all stages complete, write a PM summary to:
   `clients/{{CLIENT_SLUG}}/projects/{{PROJECT_SLUG}}/specs/pm-summary-{{topic}}-{{date}}.md`

Proceed now without asking for clarification unless a critical piece of information is entirely absent.
