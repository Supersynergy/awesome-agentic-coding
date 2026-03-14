#!/bin/bash
# =============================================================================
# Context Injection Hook — Runs on SessionStart
# Injects useful context at the start of every session:
# - Git branch + recent commits
# - Changed files
# - Project type detection
# =============================================================================

OUTPUT=""

# Git context (if in a repo)
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    COMMITS=$(git log --oneline -5 2>/dev/null || echo "no commits")
    CHANGED=$(git diff --stat HEAD 2>/dev/null | tail -1)
    STAGED=$(git diff --cached --stat 2>/dev/null | tail -1)

    OUTPUT+="Git: branch=$BRANCH"
    [ -n "$CHANGED" ] && OUTPUT+=" | unstaged: $CHANGED"
    [ -n "$STAGED" ] && OUTPUT+=" | staged: $STAGED"
    OUTPUT+=$'\n'"Recent: $COMMITS"
fi

# Project type detection
TYPES=""
[ -f "package.json" ] && TYPES+="node "
[ -f "pyproject.toml" ] || [ -f "setup.py" ] && TYPES+="python "
[ -f "go.mod" ] && TYPES+="go "
[ -f "Cargo.toml" ] && TYPES+="rust "
[ -f "pom.xml" ] && TYPES+="java "
[ -f "Gemfile" ] && TYPES+="ruby "
[ -n "$TYPES" ] && OUTPUT+=$'\n'"Project: $TYPES"

# Output context (only if we have something)
[ -n "$OUTPUT" ] && echo "$OUTPUT"

exit 0
