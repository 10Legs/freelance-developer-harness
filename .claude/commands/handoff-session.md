---
description: Snapshot the current session into a paste-ready handoff prompt (auto-copied to clipboard) for a fresh session
---

You are generating a **session handoff prompt**. Goal: produce a single, self-contained prompt the user can paste into a brand-new Claude session so it knows exactly what we are working on — no stale context, no hallucination risk.

$ARGUMENTS may contain an optional focus note (e.g. "focus on the CI fix"). If present, bias the handoff toward that thread of work. If empty, cover the whole active session.

## Step 1 — Probe real repo/env state (ground truth)

Run these via Bash from the harness root to anchor the handoff in facts, not memory. Use the SESSION_ID injected in the system prompt as `SESSION_ID = <value>` (fallback "default"):

- `cat .claude/sessions/<SESSION_ID>.client 2>/dev/null || echo "(no client lock)"` — active client/project
- `git branch --show-current` — current branch
- `git status --short` — uncommitted changes
- `git log --oneline -8` — recent commits

If work this session touched a client **source repo** (a separate checkout outside the harness, per your multi-client convention), `cd` into it and run the same `branch`/`status --short`/`log --oneline -5` there too. Determine the source repo path from the active client lock or from what was edited this session.

## Step 2 — Synthesize from session context

From everything we did this session, extract:
- **The actual task and goal** — what we're building/fixing and why; current status; any open blocker.
- **Critical files** — the real paths we read/edited/created, each with a one-line purpose. Pull from the live session, do NOT invent paths. Cross-check against `git status` output.
- **Next steps** — an ordered TODO of what the next session should do first. Be concrete.
- **Decisions/constraints** — any rule, gotcha, or decision made this session that the next session must not re-litigate.

Only include facts you are confident about. If unsure about something, mark it `(unverified)` rather than asserting it. Never fabricate file paths, branch names, or status.

## Step 3 — Build the handoff prompt

Assemble this exact structure (fill in real content):

```
# Session Handoff

## Task & Goal
<one paragraph: what we're working on, the objective, current status, any blocker>

## Active Context
- Client/project: <from session lock>
- Harness branch: <branch> | <clean | N uncommitted changes>
- Source repo: <path> @ <branch> | <state>  (omit if none)

## Critical Files
- `<path>` — <one-line purpose>
- ...

## Next Steps
1. <first thing to do>
2. ...

## Decisions & Constraints
- <rule/gotcha the next session must respect>
- ...

## How to Resume
Read the critical files above before acting. Confirm branch/state with `git status` before editing. Do not re-derive what's already decided above.
```

## Step 4 — Copy to clipboard + print

Do NOT write any file to disk. Pipe the assembled prompt straight to the clipboard:

1. Run a Bash heredoc piped to the platform clipboard command — `<clip> <<'HANDOFF_EOF'` then the full prompt body then `HANDOFF_EOF`, where `<clip>` is `pbcopy` (macOS), `xclip -selection clipboard` or `wl-copy` (Linux), or `clip.exe` (WSL/Windows). Use the quoted delimiter so nothing in the body is expanded.
2. Print the full handoff prompt to the user in a fenced code block (so it's recoverable if the clipboard fails or no clipboard tool is available).
3. Confirm: "Handoff copied to clipboard — paste into a new session."

## Rules
- Be ruthless about accuracy. A handoff with one wrong path is worse than a short one. When in doubt, leave it out or mark `(unverified)`.
- Keep it dense — no filler. The next session reads this cold.
- This command is read/probe only; do not write any files. The handoff lives only in the clipboard and the printed output.
