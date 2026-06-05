---
description: Run a sprint retrospective and close the active sprint
---

You are facilitating a **Retrospective** for: $ARGUMENTS

## Where this retro lives

Per-project sprint tracking convention (see `CLAUDE.md` → Multi-Client Governance).

The retro **lives inside the sprint file**, not in a separate document.
The active sprint is found via the `CURRENT` symlink:

```
clients/{{CLIENT_SLUG}}/projects/{{PROJECT_SLUG}}/sprints/CURRENT
  -> sprint-NNN.md
```

## Step 0: Resolve the active sprint

1. Read `CLIENT_SLUG` and `PROJECT_SLUG` from the active client lock
   (`.claude/sessions/<SESSION_ID>.client`). If none, stop and ask the user
   to run `/use-client <slug> <project>` first.

2. Set
   `SPRINTS_DIR=clients/<CLIENT_SLUG>/projects/<PROJECT_SLUG>/sprints` and
   `ACTIVE=$SPRINTS_DIR/CURRENT`.

3. Verify `$ACTIVE` exists and is a symlink:

   ```bash
   [ -L "$ACTIVE" ] || { echo "no active sprint — run /sprint-plan first"; exit 1; }
   ACTIVE_FILE=$(readlink "$ACTIVE")          # e.g. sprint-007.md
   ACTIVE_PATH="$SPRINTS_DIR/$ACTIVE_FILE"
   ```

4. Confirm the sprint is `status: active` in its frontmatter. If it is
   already `closed`, ask the user whether to reopen or to start a new
   sprint via `/sprint-plan`.

## Retrospective Format

### 1. What Went Well? (Preserve)
Each council reflects:
- Creative Council
- Technical Council
- Hardware Council *(hardware/hybrid projects only)*
- Delivery Council

### 2. What Didn't Go Well? (Improve)
Each council reflects: friction, delays, rework, broken communication.

### 3. What Did We Learn?
- New patterns worth capturing in `patterns/`
- Process updates worth keeping
- Client-specific insights worth documenting

### 4. Action Items
For each "didn't go well" item:
- Specific action
- Owner
- Target date
- Done-when criterion

### 5. Patterns Library Update
Based on learnings: what should be added, updated, or removed from `patterns/`.

## Output — write the retro back into the sprint file

1. Edit `$ACTIVE_PATH` in place:
   - Set frontmatter `status: closed`
   - Set frontmatter `closed_date: <today, YYYY-MM-DD>`
   - Fill in the `## Retrospective` section with all five subsections above

2. Do **not** create a separate `retro-*.md` file. The retro is part of the
   sprint record.

3. Update the patterns library (`patterns/`) for any new reusable patterns.

4. Advancing `CURRENT`:
   - `CURRENT` continues to point at the just-closed sprint until a new
     sprint is created.
   - `/sprint-plan` is responsible for advancing `CURRENT` to the next
     sprint when it is created. Do not delete or repoint `CURRENT` here.

5. Report to the user:
   - Sprint number closed and its `closed_date`
   - Path of the updated sprint file
   - Any patterns added/updated
   - A reminder that the next sprint can be started with `/sprint-plan`
