#!/usr/bin/env bash
# PreToolUse guard: block writes that cross a client workspace boundary.
#
# Contract:
#   exit 0 -> allow   (also the no-lock case; see below)
#   exit 2 -> BLOCK   (only exit 2 blocks in Claude Code; any other non-zero
#                      is surfaced as a non-blocking error)
#
# The active client is the session lock at .claude/sessions/<session_id>.client,
# written by /use-client. Contents are "<client>" or "<client>/<project>".
#
# Deliberately fails OPEN when there is no lock: a session that has not run
# /use-client has no declared client, so there is no boundary to cross. Failing
# closed there would make the harness unusable before /use-client runs.
#
# Bash 3.2 compatible (macOS default). No `set -u` / `set -e`: an aborted
# PreToolUse hook is read as ALLOW, so this script must never abort early.

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
[ -z "$HARNESS_DIR" ] && exit 0

INPUT="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  echo "client-boundary-guard: jq not found; boundary NOT enforced" >&2
  exit 0
fi

SESSION_ID="$(printf '%s' "$INPUT" | jq -r '.session_id // ""' 2>/dev/null)"
FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // ""' 2>/dev/null)"

# Nothing path-shaped to check.
[ -z "$FILE_PATH" ] && exit 0
[ -z "$SESSION_ID" ] && exit 0

LOCK_FILE="$HARNESS_DIR/.claude/sessions/$SESSION_ID.client"
[ -f "$LOCK_FILE" ] || exit 0

LOCK="$(tr -d '[:space:]' < "$LOCK_FILE" 2>/dev/null)"
[ -z "$LOCK" ] && exit 0

ACTIVE_CLIENT="${LOCK%%/*}"
[ -z "$ACTIVE_CLIENT" ] && exit 0

# Normalize the target to an absolute path without requiring it to exist.
case "$FILE_PATH" in
  /*) ABS="$FILE_PATH" ;;
  *)  ABS="$HARNESS_DIR/$FILE_PATH" ;;
esac

# Collapse "." and ".." segments textually (the file may not exist yet, so
# realpath/`cd` are not available to us).
CLEAN=""
OLD_IFS="$IFS"
IFS='/'
for seg in $ABS; do
  case "$seg" in
    ''|'.') ;;
    '..')   CLEAN="${CLEAN%/*}" ;;
    *)      CLEAN="$CLEAN/$seg" ;;
  esac
done
IFS="$OLD_IFS"
[ -z "$CLEAN" ] && CLEAN="/"

CLIENTS_ROOT="$HARNESS_DIR/clients"

# Only paths inside this harness's clients/ tree are in scope.
case "$CLEAN" in
  "$CLIENTS_ROOT"/*) ;;
  *) exit 0 ;;
esac

REST="${CLEAN#$CLIENTS_ROOT/}"
TARGET_CLIENT="${REST%%/*}"

# Writes directly into clients/ itself, or into shared registry files, are fine.
[ -z "$TARGET_CLIENT" ] && exit 0
[ "$TARGET_CLIENT" = "$REST" ] && exit 0

if [ "$TARGET_CLIENT" != "$ACTIVE_CLIENT" ]; then
  cat >&2 <<EOF
BLOCKED: client workspace boundary.

  active client : $ACTIVE_CLIENT
  write target  : clients/$TARGET_CLIENT/...

This session is locked to '$ACTIVE_CLIENT'. Client data never crosses workspace
boundaries. To work on '$TARGET_CLIENT', run: /use-client $TARGET_CLIENT
EOF
  exit 2
fi

exit 0
