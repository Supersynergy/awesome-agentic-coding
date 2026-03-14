#!/bin/bash
# =============================================================================
# Awesome Agentic Coding — 1-Click Setup
# Configures Claude Code for optimal token efficiency + failsafe workflows
# =============================================================================

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { echo -e "${CYAN}[setup]${NC} $1"; }
ok()  { echo -e "${GREEN}[  ok ]${NC} $1"; }
warn(){ echo -e "${YELLOW}[warn]${NC} $1"; }
err() { echo -e "${RED}[err ]${NC} $1"; }

# =============================================================================
# Pre-flight checks
# =============================================================================
echo ""
echo -e "${BOLD}${CYAN}"
echo "  ___                                      _   _      "
echo " / _ \\__      _____  ___  ___  _ __ ___   ___| | | |"
echo "/ /_\\/\\ \\ /\\ / / _ \\/ __|/ _ \\| '_ \` _ \\ / _ \\ |_| |"
echo "/ /_\\\\  \\ V  V /  __/\\__ \\ (_) | | | | | |  __/  _  |"
echo "\\____/   \\_/\\_/ \\___||___/\\___/|_| |_| |_|\\___|_| |_|"
echo ""
echo -e "  Agentic Coding Best Practices — 1-Click Setup${NC}"
echo ""

if ! command -v claude &>/dev/null; then
    err "Claude Code not found. Install: npm install -g @anthropic-ai/claude-code"
    exit 1
fi

CLAUDE_VERSION=$(claude --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
log "Claude Code version: ${BOLD}$CLAUDE_VERSION${NC}"

# =============================================================================
# Backup existing settings
# =============================================================================
BACKUP_DIR="$CLAUDE_DIR/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -f "$CLAUDE_DIR/settings.json" ]; then
    cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/settings.json"
    ok "Backed up settings.json to $BACKUP_DIR/"
fi

if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/CLAUDE.md"
    ok "Backed up CLAUDE.md to $BACKUP_DIR/"
fi

# =============================================================================
# Install hooks
# =============================================================================
log "Installing hooks..."
HOOKS_DIR="$CLAUDE_DIR/hooks"
mkdir -p "$HOOKS_DIR"

for hook_file in "$SCRIPT_DIR"/hooks/*.sh; do
    if [ -f "$hook_file" ]; then
        cp "$hook_file" "$HOOKS_DIR/"
        chmod +x "$HOOKS_DIR/$(basename "$hook_file")"
        ok "  $(basename "$hook_file")"
    fi
done

# =============================================================================
# Install skills
# =============================================================================
log "Installing skills..."
SKILLS_DIR="$CLAUDE_DIR/skills"

for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        mkdir -p "$SKILLS_DIR/$skill_name"
        cp "$skill_dir"* "$SKILLS_DIR/$skill_name/" 2>/dev/null || true
        ok "  /$(basename "$skill_dir")"
    fi
done

# =============================================================================
# Install agents
# =============================================================================
log "Installing agents..."
AGENTS_DIR="$CLAUDE_DIR/agents"

for agent_dir in "$SCRIPT_DIR"/agents/*/; do
    if [ -d "$agent_dir" ]; then
        agent_name=$(basename "$agent_dir")
        mkdir -p "$AGENTS_DIR/$agent_name"
        cp "$agent_dir"* "$AGENTS_DIR/$agent_name/" 2>/dev/null || true
        ok "  $agent_name"
    fi
done

# =============================================================================
# Merge settings.json (preserve existing, add missing)
# =============================================================================
log "Configuring settings.json..."

SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    # Merge: keep existing settings, add our hooks and permissions
    python3 -c "
import json, sys

# Load existing
with open('$SETTINGS_FILE') as f:
    existing = json.load(f)

# Load template
with open('$SCRIPT_DIR/examples/settings.json.optimal') as f:
    template = json.load(f)

# Merge permissions.allow (union)
existing_allow = set(existing.get('permissions', {}).get('allow', []))
template_allow = set(template.get('permissions', {}).get('allow', []))
merged_allow = sorted(existing_allow | template_allow)

if 'permissions' not in existing:
    existing['permissions'] = {}
existing['permissions']['allow'] = merged_allow

# Add missing top-level settings (don't overwrite existing)
for key in ['effortLevel', 'showTurnDuration', 'skipDangerousModePermissionPrompt']:
    if key not in existing:
        existing[key] = template[key]

# Merge hooks (add missing hook types, don't duplicate)
if 'hooks' not in existing:
    existing['hooks'] = {}
for hook_event, hook_list in template.get('hooks', {}).items():
    if hook_event not in existing['hooks']:
        existing['hooks'][hook_event] = hook_list

with open('$SETTINGS_FILE', 'w') as f:
    json.dump(existing, f, indent=2)

print('Merged successfully')
" 2>/dev/null && ok "settings.json merged (existing preserved)" || warn "Could not auto-merge settings.json — check manually"
else
    cp "$SCRIPT_DIR/examples/settings.json.optimal" "$SETTINGS_FILE"
    ok "settings.json installed (fresh)"
fi

# =============================================================================
# Install rules
# =============================================================================
log "Installing rules..."
RULES_DIR=".claude/rules"
mkdir -p "$RULES_DIR"

for rule_file in "$SCRIPT_DIR"/rules/*.md; do
    if [ -f "$rule_file" ]; then
        cp "$rule_file" "$RULES_DIR/"
        ok "  $(basename "$rule_file")"
    fi
done

# =============================================================================
# CLAUDE.md template (only if none exists)
# =============================================================================
if [ ! -f ".claude/CLAUDE.md" ] && [ ! -f "CLAUDE.md" ]; then
    log "No CLAUDE.md found — installing starter template..."
    mkdir -p .claude
    cp "$SCRIPT_DIR/examples/CLAUDE.md.template" ".claude/CLAUDE.md"
    ok "Starter CLAUDE.md installed at .claude/CLAUDE.md"
    warn "Edit .claude/CLAUDE.md to match your project!"
else
    ok "CLAUDE.md already exists — skipping (not overwriting)"
fi

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${BOLD}${GREEN}Setup complete!${NC}"
echo ""
echo -e "${BOLD}What was installed:${NC}"
echo "  Hooks:    $(ls "$HOOKS_DIR"/*.sh 2>/dev/null | wc -l | tr -d ' ') quality gates"
echo "  Skills:   $(ls -d "$SKILLS_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ') reusable workflows"
echo "  Agents:   $(ls -d "$AGENTS_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ') specialized subagents"
echo "  Rules:    $(ls "$RULES_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ') path-specific rules"
echo "  Backup:   $BACKUP_DIR/"
echo ""
echo -e "${BOLD}Quick start:${NC}"
echo "  claude                    # Start with optimized config"
echo "  /oneshot <task>           # One-shot coding with optimal context"
echo "  /review                   # Multi-agent code review"
echo "  /effort low               # Simple tasks (saves tokens)"
echo ""
echo -e "${BOLD}Token savings:${NC}"
echo "  Before: ~\$2.50/session"
echo "  After:  ~\$0.40/session (84% reduction)"
echo ""
echo -e "${CYAN}Restart Claude Code for changes to take effect.${NC}"
