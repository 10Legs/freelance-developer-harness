#!/usr/bin/env bash
#
# sync-to-public.sh — Copy generic harness improvements from the private
# molt-and-deploy-harness (SOURCE) to the public freelance-developer-harness
# (TARGET), scrubbing PII and refusing to copy client-specific material.
#
# Usage:
#   scripts/sync-to-public.sh \
#     --source /path/to/molt-and-deploy-harness \
#     --target /path/to/freelance-developer-harness \
#     [--dry-run]
#
# Exit codes: 0 success | 1 usage | 2 PII detected post-scrub | 3 source/target invalid
#
# Hard rules:
#   - SOURCE is never modified
#   - TARGET writes happen on a fresh branch (sync/from-molt-<date>)
#   - Blocklist beats allowlist — denylist paths are never copied even if matched
#   - sed scrubber replaces /Users/rdemeritt/projects/ai/ with $SOURCE_ROOT_BASE/
#   - Active Clients table in CLAUDE.md is reset to the single template row
#
set -euo pipefail

SOURCE=""
TARGET=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help)
      grep '^# ' "$0" | sed 's/^# //'
      exit 0
      ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$SOURCE" || -z "$TARGET" ]]; then
  echo "usage: $0 --source <molt-path> --target <public-path> [--dry-run]" >&2
  exit 1
fi

if [[ ! -d "$SOURCE" || ! -f "$SOURCE/CLAUDE.md" ]]; then
  echo "error: SOURCE does not look like a harness repo: $SOURCE" >&2
  exit 3
fi

if [[ ! -d "$TARGET" || ! -d "$TARGET/.git" ]]; then
  echo "error: TARGET must be a git checkout: $TARGET" >&2
  exit 3
fi

DATE="$(date +%Y-%m-%d)"
BRANCH="sync/from-molt-${DATE}"

# --- ALLOWLIST: items eligible for sync ---
# Paths are SOURCE-relative; directories sync recursively, files sync as-is.
ALLOWLIST=(
  ".claude/commands"
  ".claude/agents"
  ".claude/hooks"
  "patterns"
  "templates"
  "docs/sops"
  "docs/workflows"
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
)

# --- BLOCKLIST: paths that must never be copied, even when nested inside an allowlisted dir ---
BLOCKLIST_PATTERNS=(
  "memory/"
  "clients/"
  ".claude/sessions/"
  ".claude/worktrees/"
  ".claude/settings.local.json"
  ".claude/active-client"
  "qa_"
  "tc001-"
  "docs/research-"
)

log()  { echo "[sync] $*"; }
warn() { echo "[sync][warn] $*" >&2; }
die()  { echo "[sync][error] $*" >&2; exit 1; }

is_blocked() {
  local rel="$1"
  for pat in "${BLOCKLIST_PATTERNS[@]}"; do
    if [[ "$rel" == *"$pat"* ]]; then return 0; fi
    base="$(basename "$rel")"
    if [[ "$base" == ${pat}* ]]; then return 0; fi
  done
  return 1
}

# Use a temp staging dir; only move into TARGET at the end if not dry-run.
STAGE="$(mktemp -d -t harness-sync-XXXXXX)"
trap 'rm -rf "$STAGE"' EXIT

COPIED=()
SKIPPED=()

copy_file() {
  local rel="$1"
  if is_blocked "$rel"; then
    SKIPPED+=("$rel (blocklist)")
    return
  fi
  local src_path="$SOURCE/$rel"
  local dst_path="$STAGE/$rel"
  mkdir -p "$(dirname "$dst_path")"
  cp "$src_path" "$dst_path"
  COPIED+=("$rel")
}

walk_allowlist() {
  for item in "${ALLOWLIST[@]}"; do
    local abs="$SOURCE/$item"
    if [[ -f "$abs" ]]; then
      copy_file "$item"
    elif [[ -d "$abs" ]]; then
      while IFS= read -r -d '' f; do
        rel="${f#$SOURCE/}"
        copy_file "$rel"
      done < <(find "$abs" -type f -print0)
    else
      warn "allowlist item missing in SOURCE: $item"
    fi
  done
}

scrub_paths() {
  # Replace hardcoded user paths with $SOURCE_ROOT_BASE/
  # BSD/GNU sed compatible by using -i with empty string suffix on BSD; detect.
  local sed_inplace=(-i '')
  if sed --version >/dev/null 2>&1; then
    sed_inplace=(-i)
  fi
  while IFS= read -r -d '' f; do
    sed "${sed_inplace[@]}" 's|/Users/rdemeritt/projects/ai/|$SOURCE_ROOT_BASE/|g' "$f"
  done < <(find "$STAGE" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.json" -o -name "*.yaml" -o -name "*.yml" \) -print0)
}

reset_active_clients_table() {
  local claude="$STAGE/CLAUDE.md"
  [[ -f "$claude" ]] || return 0
  python3 - "$claude" <<'PY'
import sys, re, io
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as fh:
    text = fh.read()

# Replace the Active Clients table body with the public template rows.
pattern = re.compile(
    r"(## Active Clients\s*\n\s*\| Client Slug \| Project \| Account Lead \| Status \|\s*\n"
    r"\|[^\n]+\|\s*\n)"  # header divider
    r"(?:\|[^\n]*\|\s*\n)+",
    re.MULTILINE,
)
replacement_rows = (
    "| _template   | —       | —            | Template |\n"
    "| your-client | your-project — brief description | your-name | Active |\n"
)
new_text, count = pattern.subn(lambda m: m.group(1) + replacement_rows, text, count=1)
if count == 0:
    sys.stderr.write("[sync][warn] Active Clients table not found in CLAUDE.md\n")
with open(path, "w", encoding="utf-8") as fh:
    fh.write(new_text)
PY
}

pii_sweep() {
  local hits
  hits=$(grep -rn "rdemeritt\|/Users/\|clients/self" "$STAGE" \
    --include="*.md" --include="*.sh" --include="*.json" --include="*.yaml" --include="*.yml" \
    2>/dev/null || true)
  if [[ -n "$hits" ]]; then
    echo "[sync][error] PII detected after scrub:" >&2
    echo "$hits" >&2
    return 1
  fi
  return 0
}

log "SOURCE: $SOURCE"
log "TARGET: $TARGET"
log "STAGE:  $STAGE"
log "BRANCH: $BRANCH (dry-run=$DRY_RUN)"

walk_allowlist
scrub_paths
reset_active_clients_table

if ! pii_sweep; then
  die "PII sweep failed; aborting before any TARGET write"
fi

log "files copied: ${#COPIED[@]}"
log "files skipped: ${#SKIPPED[@]}"

if [[ $DRY_RUN -eq 1 ]]; then
  log "dry-run: showing diff against TARGET (no files written)"
  diff -qr "$STAGE" "$TARGET" 2>/dev/null | head -200 || true
  exit 0
fi

# Real run: branch in TARGET, rsync stage over TARGET, leave changes uncommitted for human review.
( cd "$TARGET" && git fetch origin && git checkout -B "$BRANCH" )
rsync -a "$STAGE/" "$TARGET/"

log "wrote ${#COPIED[@]} files into $TARGET on branch $BRANCH"
log "next steps: review with 'git -C $TARGET status', commit, and open PR"
