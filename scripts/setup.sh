#!/usr/bin/env bash
# =============================================================================
# Freelance Developer Harness — Setup Wizard
# Walks you through initial configuration on first run.
# Safe to re-run: prompts show current values as defaults.
# =============================================================================

set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$HARNESS_DIR/.env"
ENV_TEMPLATE="$HARNESS_DIR/.env.template"
CLAUDE_MD="$HARNESS_DIR/CLAUDE.md"

# ── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

header() { echo -e "\n${BOLD}${CYAN}$1${RESET}"; }
ok()     { echo -e "  ${GREEN}✓${RESET} $1"; }
warn()   { echo -e "  ${YELLOW}!${RESET} $1"; }
ask()    { echo -en "  $1 "; }

# ── Load existing .env values as defaults ────────────────────────────────────
load_env_var() {
  local key="$1"
  if [[ -f "$ENV_FILE" ]]; then
    grep -E "^${key}=" "$ENV_FILE" | cut -d'=' -f2- | tr -d '"' || true
  fi
}

# ── Prompt helper: shows default, returns value ───────────────────────────────
prompt() {
  local label="$1"
  local default="$2"
  local value
  if [[ -n "$default" ]]; then
    ask "${label} [${default}]:"
  else
    ask "${label}:"
  fi
  read -r value
  echo "${value:-$default}"
}

# ── Start ─────────────────────────────────────────────────────────────────────
clear
echo -e "${BOLD}"
echo "╔══════════════════════════════════════════════════╗"
echo "║     Freelance Developer Harness — Setup          ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${RESET}"
echo "  This wizard configures your harness for first use."
echo "  Press Enter to accept a default value."

# ── Guard: warn if .env already exists ───────────────────────────────────────
if [[ -f "$ENV_FILE" ]]; then
  warn ".env already exists. Re-running will update values you change."
  warn "Press Ctrl-C to abort, or Enter to continue."
  read -r _
fi

# ── Step 1: Studio identity ───────────────────────────────────────────────────
header "Step 1 — Studio identity"
echo "  This name appears in CLAUDE.md and agent context."

current_studio=$(load_env_var STUDIO_NAME)
STUDIO_NAME=$(prompt "Studio name" "${current_studio:-My Studio}")

current_slug=$(load_env_var STUDIO_SLUG)
default_slug=$(echo "$STUDIO_NAME" | tr '[:upper:] ' '[:lower:]-' | tr -cd '[:alnum:]-')
STUDIO_SLUG=$(prompt "Studio slug (url-safe)" "${current_slug:-$default_slug}")

current_email=$(load_env_var STUDIO_EMAIL)
STUDIO_EMAIL=$(prompt "Studio email" "${current_email:-hello@yourstudio.com}")

# ── Step 2: Source root ───────────────────────────────────────────────────────
header "Step 2 — Source root"
echo "  Where do your project repos live on disk?"
echo "  Convention: all project repos are siblings of this harness directory."
echo "  Example: if harness is at ~/projects/harness, repos at ~/projects/<slug>/"

default_source_root="$(cd "$HARNESS_DIR/.." && pwd)"
current_source_root=$(load_env_var SOURCE_ROOT_BASE)
SOURCE_ROOT_BASE=$(prompt "Source root" "${current_source_root:-$default_source_root}")

# ── Step 3: AI providers ──────────────────────────────────────────────────────
header "Step 3 — AI providers (optional, leave blank to skip)"

current_anthropic=$(load_env_var ANTHROPIC_API_KEY)
ANTHROPIC_API_KEY=$(prompt "Anthropic API key (for Claude)" "${current_anthropic:-}")

current_google=$(load_env_var GOOGLE_API_KEY)
GOOGLE_API_KEY=$(prompt "Google API key (for Gemini)" "${current_google:-}")

# ── Step 4: Version control ───────────────────────────────────────────────────
header "Step 4 — Version control (optional)"

current_gh=$(load_env_var GITHUB_TOKEN)
GITHUB_TOKEN=$(prompt "GitHub personal access token" "${current_gh:-}")

current_org=$(load_env_var ORG_GITHUB_ORG)
GITHUB_ORG=$(prompt "GitHub org or username" "${current_org:-}")

# ── Write .env ────────────────────────────────────────────────────────────────
header "Writing .env..."

# Start from template, substitute known values
cp "$ENV_TEMPLATE" "$ENV_FILE"

set_env_var() {
  local key="$1"
  local value="$2"
  if [[ -n "$value" ]]; then
    # Replace the line key=... with key=value
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
    else
      sed -i "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
    fi
  fi
}

set_env_var STUDIO_NAME      "$STUDIO_NAME"
set_env_var STUDIO_SLUG      "$STUDIO_SLUG"
set_env_var STUDIO_EMAIL     "$STUDIO_EMAIL"
set_env_var SOURCE_ROOT_BASE "$SOURCE_ROOT_BASE"
set_env_var ANTHROPIC_API_KEY "$ANTHROPIC_API_KEY"
set_env_var GOOGLE_API_KEY   "$GOOGLE_API_KEY"
set_env_var GITHUB_TOKEN     "$GITHUB_TOKEN"
set_env_var ORG_GITHUB_ORG   "$GITHUB_ORG"

ok ".env written"

# ── Patch CLAUDE.md studio name ───────────────────────────────────────────────
if grep -q '{{STUDIO_NAME}}' "$CLAUDE_MD"; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|{{STUDIO_NAME}}|${STUDIO_NAME}|g" "$CLAUDE_MD"
  else
    sed -i "s|{{STUDIO_NAME}}|${STUDIO_NAME}|g" "$CLAUDE_MD"
  fi
  ok "CLAUDE.md updated with studio name: $STUDIO_NAME"
else
  ok "CLAUDE.md already has studio name set"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${GREEN}Setup complete!${RESET}"
echo ""
echo "  Next steps:"
echo "  1. Open Claude Code in this directory"
echo "  2. Run: /onboard-client <your-client-slug>"
echo "     (creates clients/<slug>/ workspace from template)"
echo "  3. Run: /use-client <slug>"
echo "     (locks this session to that client)"
echo "  4. Run: /pm on"
echo "     (enables automatic PM routing for all prompts)"
echo ""
echo "  Reference:"
echo "  - SETUP.md        — overview and quick-start"
echo "  - CLAUDE.md       — full operating model"
echo "  - AGENTS.md       — team roster and governance"
echo "  - docs/onboarding.md — team guide"
echo ""
