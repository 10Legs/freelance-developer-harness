#!/usr/bin/env bash
# UserPromptSubmit hook: injects active client/project context into every prompt.
# Reads .claude/sessions/<session_id> which contains either:
#   <client-slug>              → client-only lock
#   <client-slug>/<project>   → client + project lock
#
# Falls back to .claude/active-client for backwards compatibility.

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SESSIONS_DIR="$HARNESS_DIR/.claude/sessions"

# Get session ID from the JSON payload on stdin
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)

# Always inject SESSION_ID so skills know the real current session ID
if [[ -n "$SESSION_ID" ]]; then
  echo "<system-prompt-injection>SESSION_ID = $SESSION_ID</system-prompt-injection>"
fi

# Resolve lock file: session-specific only
LOCK_FILE=""
if [[ -n "$SESSION_ID" && -f "$SESSIONS_DIR/$SESSION_ID.client" ]]; then
  LOCK_FILE="$SESSIONS_DIR/$SESSION_ID.client"
fi

if [[ -z "$LOCK_FILE" ]]; then
  exit 0
fi

LOCK="$(cat "$LOCK_FILE" | tr -d '[:space:]')"

if [[ -z "$LOCK" ]]; then
  exit 0
fi

# Parse client and optional project
CLIENT_SLUG="${LOCK%%/*}"
PROJECT=""
if [[ "$LOCK" == */* ]]; then
  PROJECT="${LOCK#*/}"
fi

# Load SOURCE_ROOT_BASE from .env if present
if [[ -f "$HARNESS_DIR/.env" ]]; then
  # shellcheck disable=SC1090
  SOURCE_ROOT_BASE_ENV=$(grep -E '^SOURCE_ROOT_BASE=' "$HARNESS_DIR/.env" | cut -d'=' -f2- | tr -d '[:space:]')
fi
# Fall back to parent directory of harness (sibling-repo convention)
SOURCE_ROOT_BASE="${SOURCE_ROOT_BASE_ENV:-$(cd "$HARNESS_DIR/.." && pwd)}"

if [[ -n "$PROJECT" ]]; then
  SOURCE_ROOT="$SOURCE_ROOT_BASE/$PROJECT"
  HARNESS_WORKSPACE="clients/$CLIENT_SLUG/projects/$PROJECT"
  SCOPE_LINE="- Active project: $PROJECT"
else
  SOURCE_ROOT="$SOURCE_ROOT_BASE/$CLIENT_SLUG"
  HARNESS_WORKSPACE="clients/$CLIENT_SLUG"
  SCOPE_LINE="- Active project: none (full client scope)"
fi

# Check PM mode
PM_MODE_FILE="$SESSIONS_DIR/$SESSION_ID.pm-mode"
PM_MODE=""
if [[ -f "$PM_MODE_FILE" ]]; then
  PM_MODE="$(cat "$PM_MODE_FILE" | tr -d '[:space:]')"
fi

cat <<EOF
<system-prompt-injection>
Active context lock is set. For this session:
- SESSION_ID = $SESSION_ID
- CLIENT_SLUG = $CLIENT_SLUG
- Harness workspace = $HARNESS_WORKSPACE/
- Source root = $SOURCE_ROOT/
$SCOPE_LINE
- All specs, deliverables, and docs go under $HARNESS_WORKSPACE/
- All source code reads/edits are scoped to $SOURCE_ROOT/
- Never cross client workspace boundaries.
</system-prompt-injection>
EOF

if [[ "$PM_MODE" == "on" ]]; then
  cat <<'PMEOF'
<pm-mode-injection>
PM MODE IS ACTIVE. Treat every user request as PM-routed work. You ARE the Product Manager for this session.

For every request:
1. Assess scope — is this a bug fix, feature, sprint, or question?
2. Delegate to the correct agent(s) using the Agent tool. Spawn in parallel where possible.
3. Collect outputs, verify gates, advance the pipeline.
4. Write a PM summary spec when substantive work completes.

Do not ask the user to invoke /pm — you are already in PM mode. Route all work automatically.
</pm-mode-injection>
PMEOF
fi
