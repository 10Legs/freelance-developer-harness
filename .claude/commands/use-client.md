---
description: Lock the session to a specific client or project workspace
---

You are activating the **client context lock** for: $ARGUMENTS

$ARGUMENTS may be:
- `<project-slug>` — lock to a project by name alone; client is resolved automatically (e.g. `storefront`)
- `<client-slug>` — lock to a client with no specific project (e.g. `acme-corp`)
- `<client-slug> <project-slug>` — lock to a project explicitly (e.g. `acme-corp storefront`)
- `clear` or `reset` — remove the lock for this session
- `list` — show all active session locks

## Steps

### If $ARGUMENTS is "list":
- Run `ls .claude/sessions/*.client 2>/dev/null || echo "(none)"` via Bash to find all client lock files.
- For each file found, print the session ID (filename without `.client`) and its contents.
- Confirm: "Active client locks listed above."
- Stop here.

### If $ARGUMENTS is "clear" or "reset":
- The SESSION_ID is injected into the system prompt as `SESSION_ID = <value>`. Read it from there; if not present, use "default".
- Run `rm -f ".claude/sessions/<SESSION_ID>.client" && echo "cleared <SESSION_ID>.client"` via Bash.
- Confirm: "Client lock cleared for this session."
- Stop here.

### Otherwise:

1. **Parse the arguments:**
   - First token = FIRST_ARG
   - Second token (optional) = SECOND_ARG

2. **Resolve CLIENT_SLUG and PROJECT_SLUG:**

   **Case 0 — full path provided** (`clients/<client-slug>/projects/<project-slug>`):
   - If FIRST_ARG matches the pattern `clients/*/projects/*`, extract CLIENT_SLUG and PROJECT_SLUG from the path segments.
   - Validate `clients/<CLIENT_SLUG>/projects/<PROJECT_SLUG>/` exists as a directory. If not, stop and tell the user.
   - Proceed to step 3.

   **Case A — two tokens provided** (`<client-slug> <project-slug>`):
   - CLIENT_SLUG = FIRST_ARG, PROJECT_SLUG = SECOND_ARG
   - Validate by running `ls clients/<CLIENT_SLUG>/projects/<PROJECT_SLUG>/` via Bash. If it fails, stop and tell the user.

   **Case B — one token provided:**
   - First check if `clients/FIRST_ARG/` exists as a directory (run `ls clients/FIRST_ARG/` via Bash) → it's a client-only lock. CLIENT_SLUG = FIRST_ARG, no PROJECT_SLUG.
   - Otherwise, search for a project by running `ls clients/*/projects/FIRST_ARG/` via Bash (or Glob `clients/*/projects/FIRST_ARG/` — note: use Bash ls for directory matching).
     - If exactly one match is found: extract CLIENT_SLUG from the path, PROJECT_SLUG = FIRST_ARG.
     - If multiple matches are found: list them and ask the user to disambiguate using `<client-slug> <project-slug>` form.
     - If no match: stop and tell the user the project was not found.

3. **Write the session lock file:**
   - The SESSION_ID is injected into the system prompt as `SESSION_ID = <value>`. Read it from there; if not present, use "default".
   - Run `mkdir -p .claude/sessions` via Bash to ensure the directory exists.
   - If no project: write a single line — just the client slug.
   - If project provided: write a single line in the format `<CLIENT_SLUG>/<PROJECT_SLUG>`.
   - Write to `.claude/sessions/<SESSION_ID>.client` using the Write tool (where SESSION_ID is the value from the Bash step above).
   - This lock is isolated to this Claude session — other sessions are unaffected.

4. **Confirm to the user:**
   - Active client: **<CLIENT_SLUG>**
   - Active project: **<PROJECT_SLUG>** (if set, otherwise "none — full client scope")
   - Session: `<SESSION_ID>` (isolated — other sessions keep their own locks)
   - Harness workspace: `clients/<CLIENT_SLUG>/` (client) or `clients/<CLIENT_SLUG>/projects/<PROJECT_SLUG>/` (project)
   - Source root: `$SOURCE_ROOT_BASE/<PROJECT_SLUG>/` (project-scoped) or `$SOURCE_ROOT_BASE/<CLIENT_SLUG>/` (client-only)
     (`SOURCE_ROOT_BASE` is set in `.env`; defaults to the parent directory of this harness repo)
   - All subsequent commands and agents will automatically scope to this context.
   - To switch: `/use-client <project-slug>` or `/use-client <client-slug> <project-slug>`
   - To clear: `/use-client clear`
   - To see all active sessions: `/use-client list`
