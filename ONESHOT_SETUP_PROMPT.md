# The 1-Shot Claude Code Setup Prompt

> **Just paste ONE of these into a fresh Claude Code session. That's it.**

---

## Option 1: Full Setup (Recommended)

Copy this single line into Claude Code:

```
Clone https://github.com/Supersynergy/awesome-agentic-coding and run bash setup.sh — then verify all hooks, skills, and agents are installed. Create a CLAUDE.md for this project if none exists. Show me what was installed.
```

---

## Option 2: Full Setup + Project Optimization

For a specific project directory, paste this:

```
Clone https://github.com/Supersynergy/awesome-agentic-coding to ~/awesome-agentic-coding and run bash setup.sh to install hooks, skills, agents, and rules. Then:
1. Detect this project's stack (read package.json / pyproject.toml / go.mod / Cargo.toml)
2. Create .claude/CLAUDE.md optimized for this project (build commands, architecture, patterns — under 150 lines)
3. Create .claude/rules/ with path-specific rules for this project's structure
4. Run tests to verify everything works
5. Show summary of what was installed + what skills are available
```

---

## Option 3: Zero-Clone (No Git Needed)

If you can't or don't want to clone, paste this self-contained setup:

```
Configure my Claude Code for maximum efficiency. Do all of this:

HOOKS — Add to ~/.claude/settings.json:
- SessionStart: bash script that outputs "git log --oneline -3 && git status -s" for context
- PreToolUse (Write|Edit): block files matching *.env *.pem *.key credentials* secrets*
- PostToolUse (Edit|Write): syntax check Python (ast.parse) and JSON (json.load)
- Permissions allow: Read, Glob, Grep, Bash(git status*), Bash(git diff*), Bash(git log*), Bash(git branch*), Bash(git show*), Bash(npm run *), Bash(npm test*), Bash(python3 -m pytest*), Bash(ls*), Bash(pwd), Bash(which*), Bash(wc*), Bash(curl -s *)

AGENTS — Create in ~/.claude/agents/:
- researcher/AGENT.md: model haiku, tools Read+Grep+Glob only, purpose "fast codebase exploration, read-only"
- reviewer/AGENT.md: model haiku, tools Read+Grep+Glob+Bash, purpose "code review, find bugs/security/performance issues"
- architect/AGENT.md: model sonnet, tools Read+Grep+Glob, purpose "architecture analysis, recommend simplest approach"

SKILLS — Create in ~/.claude/skills/:
- oneshot/SKILL.md: 4-phase protocol (gather context → plan → implement → verify), allowed-tools all
- review/SKILL.md: spawns 3 parallel haiku reviewers (correctness, security, performance)
- debug/SKILL.md: scientific method (observe → hypothesize → test → fix → verify)
- refactor/SKILL.md: safe refactoring with test verification at each step

RULES — Create these for the current project if none exist:
- .claude/rules/security.md (paths: **/*): no hardcoded secrets, validate input, parameterized queries
- .claude/rules/tests.md (paths: **/*test*, tests/**): test behavior not implementation, no shared mutable state

SETTINGS:
- effortLevel: "medium"
- showTurnDuration: true

PROJECT CLAUDE.md — If this project has no .claude/CLAUDE.md:
- Detect stack from config files
- Create one under 150 lines with: build commands, test commands, architecture map, key patterns
- Tables over prose, most important first

RULES:
- NEVER overwrite existing files — merge or backup first
- NEVER touch API keys, secrets, or git config
- Make all .sh files executable
- Show me everything that was installed when done
```

---

## Option 4: URL-Only (Absolute Minimum)

Just paste the URL and this instruction:

```
https://github.com/Supersynergy/awesome-agentic-coding — clone this, run setup.sh, confirm what's installed.
```

---

## Why These Work

Every prompt follows the [6 context engineering principles](docs/CONTEXT_ENGINEERING.md):

| Principle | How It's Applied |
|-----------|-----------------|
| Structured | Numbered steps with clear sections |
| Specific | Exact file paths, tool names, model names |
| Verifiable | "Show me what was installed" forces confirmation |
| Append-only | "NEVER overwrite" — merge or backup |
| Minimal | Only installs what's needed |
| Cache-friendly | Stable instructions, no timestamps |

## What Gets Installed

| Component | Count | Token Impact |
|-----------|-------|-------------|
| Hooks | 5 | Saves 500-1000 tok/session (permissions) |
| Skills | 7-10 | 0 tokens when unused |
| Agents | 3 | Haiku subagents = 5x cheaper exploration |
| Rules | 3 | Load only for matching file paths |
| Permission allowlist | 30+ commands | Eliminates permission dialogs |
| CLAUDE.md | 1 per project | < 150 lines = 95% adherence |

**Total setup time: ~30 seconds. Total savings: ~84% per session.**
