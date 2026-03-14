#!/bin/bash
# =============================================================================
# Awesome Agentic Coding — Validate Installation
# Checks that all hooks, skills, agents, and settings are properly installed.
# =============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check() {
    if [ -f "$1" ]; then
        echo -e "  ${GREEN}✓${NC} $2"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $2 — missing: $1"
        FAIL=$((FAIL + 1))
    fi
}

check_exec() {
    if [ -x "$1" ]; then
        echo -e "  ${GREEN}✓${NC} $2 (executable)"
        PASS=$((PASS + 1))
    elif [ -f "$1" ]; then
        echo -e "  ${YELLOW}!${NC} $2 — exists but not executable"
        WARN=$((WARN + 1))
    else
        echo -e "  ${RED}✗${NC} $2 — missing: $1"
        FAIL=$((FAIL + 1))
    fi
}

check_json_key() {
    if python3 -c "import json; d=json.load(open('$1')); assert $2" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $3"
        PASS=$((PASS + 1))
    else
        echo -e "  ${RED}✗${NC} $3"
        FAIL=$((FAIL + 1))
    fi
}

echo ""
echo "=== Awesome Agentic Coding — Installation Validator ==="
echo ""

# Hooks
echo "Hooks:"
check_exec "$HOME/.claude/hooks/quality-gate.sh" "quality-gate (Stop)"
check_exec "$HOME/.claude/hooks/secret-guard.sh" "secret-guard (PreToolUse)"
check_exec "$HOME/.claude/hooks/context-inject.sh" "context-inject (SessionStart)"
check_exec "$HOME/.claude/hooks/protect-prod.sh" "protect-prod (PreToolUse)"
check_exec "$HOME/.claude/hooks/syntax-check.sh" "syntax-check (PostToolUse)"
echo ""

# Skills
echo "Skills:"
check "$HOME/.claude/skills/oneshot/SKILL.md" "/oneshot"
check "$HOME/.claude/skills/review/SKILL.md" "/review"
check "$HOME/.claude/skills/debug/SKILL.md" "/debug"
check "$HOME/.claude/skills/refactor/SKILL.md" "/refactor"
check "$HOME/.claude/skills/commit/SKILL.md" "/commit"
check "$HOME/.claude/skills/test/SKILL.md" "/test"
check "$HOME/.claude/skills/plan/SKILL.md" "/plan"
echo ""

# Agents
echo "Agents:"
check "$HOME/.claude/agents/researcher/AGENT.md" "researcher (Haiku)"
check "$HOME/.claude/agents/reviewer/AGENT.md" "reviewer (Haiku)"
check "$HOME/.claude/agents/architect/AGENT.md" "architect (Sonnet)"
echo ""

# Settings
echo "Settings:"
if [ -f "$HOME/.claude/settings.json" ]; then
    check_json_key "$HOME/.claude/settings.json" "'hooks' in d" "hooks section exists"
    check_json_key "$HOME/.claude/settings.json" "'permissions' in d" "permissions section exists"
else
    echo -e "  ${RED}✗${NC} ~/.claude/settings.json not found"
    FAIL=$((FAIL + 1))
fi
echo ""

# CLAUDE.md
echo "CLAUDE.md:"
if [ -f ".claude/CLAUDE.md" ] || [ -f "CLAUDE.md" ]; then
    CLAUDE_MD=$([ -f ".claude/CLAUDE.md" ] && echo ".claude/CLAUDE.md" || echo "CLAUDE.md")
    LINES=$(wc -l < "$CLAUDE_MD" | tr -d ' ')
    if [ "$LINES" -le 200 ]; then
        echo -e "  ${GREEN}✓${NC} $CLAUDE_MD ($LINES lines — optimal)"
    elif [ "$LINES" -le 500 ]; then
        echo -e "  ${YELLOW}!${NC} $CLAUDE_MD ($LINES lines — consider trimming to <200)"
        WARN=$((WARN + 1))
    else
        echo -e "  ${RED}✗${NC} $CLAUDE_MD ($LINES lines — >500 = ~40% adherence)"
        FAIL=$((FAIL + 1))
    fi
else
    echo -e "  ${YELLOW}!${NC} No CLAUDE.md found in this project"
    WARN=$((WARN + 1))
fi
echo ""

# Summary
echo "=== Results ==="
echo -e "  ${GREEN}Passed:${NC}  $PASS"
echo -e "  ${YELLOW}Warnings:${NC} $WARN"
echo -e "  ${RED}Failed:${NC}  $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC} Your Claude Code setup is optimal."
else
    echo -e "${RED}$FAIL checks failed.${NC} Run 'bash setup.sh' to fix."
fi
