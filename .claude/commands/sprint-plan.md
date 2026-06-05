---
description: Plan a sprint for the active client project (writes to sprints/sprint-NNN.md and updates CURRENT)
---

You are running **Sprint Planning** for: $ARGUMENTS

## Where this sprint lives

Per-project sprint tracking convention (see `CLAUDE.md` → Multi-Client Governance).

All sprint files live under:

```
clients/{{CLIENT_SLUG}}/projects/{{PROJECT_SLUG}}/sprints/
  sprint-001.md
  sprint-002.md
  ...
  CURRENT -> sprint-NNN.md      (symlink to the active sprint)
```

Sprints are **per-project only**. Never write sprint files to `specs/`,
to the client root, or anywhere shared across projects.

## Step 0: Resolve the sprint directory and next number

1. Read `CLIENT_SLUG` and `PROJECT_SLUG` from the active client lock
   (`.claude/sessions/<SESSION_ID>.client`). If none, stop and tell the user
   to run `/use-client <slug> <project>` first.

2. Set `SPRINTS_DIR=clients/<CLIENT_SLUG>/projects/<PROJECT_SLUG>/sprints`.
   Create it if missing:

   ```bash
   mkdir -p "$SPRINTS_DIR"
   ```

3. Auto-detect the next sprint number by scanning existing files:

   ```bash
   last=$(ls "$SPRINTS_DIR"/sprint-*.md 2>/dev/null \
          | sed -E 's/.*sprint-0*([0-9]+)\.md/\1/' \
          | sort -n | tail -1)
   next=$(( ${last:-0} + 1 ))
   printf -v NUMBER 'sprint-%03d' "$next"
   ```

   So the new file path is `$SPRINTS_DIR/$NUMBER.md` (e.g. `sprint-007.md`).

4. Refuse to overwrite an existing file. If `$SPRINTS_DIR/$NUMBER.md`
   exists, stop and ask the user how to proceed.

## Step 1: Account Lead — Client Commitments
Define:
- Client commitments this sprint
- Non-negotiables and hard deadlines

## Step 2: Product Manager — Sprint Goal & Backlog Selection
PM owns prioritization:
- Sprint goal (one sentence: what will be true when sprint ends?)
- Review open items in `clients/{{CLIENT_SLUG}}/projects/{{PROJECT_SLUG}}/specs/`,
  prior sprints in `$SPRINTS_DIR/`, and the GitHub issue tracker
- Select sprint backlog based on: priority, dependencies, team capacity,
  sprint goal alignment
- Write user stories for each selected item if not already written
- Group backlog into **milestones** — coherent deliverables the team commits
  to inside this sprint

## Step 3: Tasking by Council
PM assigns each backlog item to the appropriate council and owner.

**Creative Council:** Innovation Lead, UX Researcher, UI Designer, Creative Director
**Technical Council:** Solution Architect, Frontend, Backend, Apple Platform, LLM, Blockchain, Security
**Hardware Council** *(hardware/hybrid only)*: Hardware PM, EE, ME, Firmware, Industrial Designer, Manufacturing, Supply Chain, Certification, Hardware Security
**Delivery Council:** Technical Writer, QA Specialist, GitHub & VC Specialist

## Step 4: Dependency Mapping
Identify cross-council dependencies and the critical path.

## Step 5: Risk Assessment
For each high-complexity item: what could go wrong, what is the mitigation.

## Output

1. Copy `templates/sprint-plan.md` to `$SPRINTS_DIR/$NUMBER.md` and fill in:
   - frontmatter (`sprint_number`, `status: active`, `start_date`,
     `end_date`, `client`, `project`, `goal`)
   - Milestones table
   - Sprint Backlog table (one row per task, with PR column left blank)
   - Critical Path
   - Risks
   - Definition of Done

   Leave the `## Retrospective` section empty — `/retro` fills it on close.

2. Update the `CURRENT` symlink to point at the new file:

   ```bash
   ( cd "$SPRINTS_DIR" && ln -sfn "$NUMBER.md" CURRENT )
   ```

   On macOS/Linux `ln -sfn` atomically replaces an existing symlink. Do not
   commit a regular file named `CURRENT` — it must be a symlink.

3. Report to the user:
   - Path of the new sprint file
   - Sprint number and goal
   - Confirmation that `CURRENT` now points at it
