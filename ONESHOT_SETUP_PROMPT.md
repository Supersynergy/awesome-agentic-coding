# The 1-Shot Claude Code Setup Prompt

> Copy-paste this entire block into a fresh Claude Code session to configure everything automatically.

---

```
I need you to set up my Claude Code environment for maximum efficiency. Do everything in this exact order:

## Step 1: Install the Awesome Agentic Coding repo

Clone and run the setup script:
```bash
git clone https://github.com/Supersynergy/awesome-agentic-coding.git ~/awesome-agentic-coding
cd ~/awesome-agentic-coding && bash setup.sh
```

## Step 2: Verify the installation

Check that these exist:
- ~/.claude/hooks/quality-gate.sh (Stop hook — runs tests before finishing)
- ~/.claude/hooks/secret-guard.sh (PreToolUse — blocks secret file writes)
- ~/.claude/hooks/context-inject.sh (SessionStart — injects git context)
- ~/.claude/hooks/protect-prod.sh (PreToolUse — blocks production config edits)
- ~/.claude/hooks/syntax-check.sh (PostToolUse — validates syntax after edits)
- ~/.claude/skills/oneshot/SKILL.md
- ~/.claude/skills/review/SKILL.md
- ~/.claude/skills/debug/SKILL.md
- ~/.claude/skills/refactor/SKILL.md
- ~/.claude/agents/researcher/AGENT.md (Haiku, read-only)
- ~/.claude/agents/reviewer/AGENT.md (Haiku, read-only + Bash)
- ~/.claude/agents/architect/AGENT.md (Sonnet, read-only)

## Step 3: Verify settings.json has these hook configurations

Ensure ~/.claude/settings.json contains:
- SessionStart hook → context-inject.sh
- PreToolUse (Write|Edit) → secret-guard.sh + protect-prod.sh
- PostToolUse (Edit|Write) → syntax-check.sh
- Permission allowlist for: Read, Glob, Grep, safe git commands, npm/python test commands

## Step 4: Create/update my project CLAUDE.md

If this project doesn't have a .claude/CLAUDE.md, create one using the template at ~/awesome-agentic-coding/examples/CLAUDE.md.template. Keep it under 200 lines.

## Step 5: Confirm

List everything that was installed and any issues found. Then show me the available skills with /oneshot, /review, /debug, /refactor.

---

RULES FOR SETUP:
- NEVER overwrite existing files — merge or back up first
- NEVER touch API keys, secrets, or git config
- If any hook already exists, compare and keep the better version
- Make all .sh files executable
- Test that hooks work by checking exit codes
```

---

## Why This Works

This prompt succeeds because it follows all 6 context engineering principles:

1. **Structured** — Numbered steps with clear verification
2. **Specific** — Exact file paths, no ambiguity
3. **Verifiable** — Each step has a check
4. **Append-only** — Merges, never overwrites
5. **Minimal** — Only installs what's needed
6. **Progressive** — Each step builds on the previous

## Alternative: Quick Setup (No Clone)

If you don't want to clone the repo, paste this minimal version:

```
Configure my Claude Code for optimal performance:

1. Add these hooks to ~/.claude/settings.json:
   - SessionStart: inject "git log --oneline -3 && git status -s" output
   - PreToolUse (Write|Edit): block files matching *.env, *.pem, *.key, credentials*
   - PostToolUse (Edit|Write): run syntax check (python3 -c "compile(open(f).read(), f, 'exec')" for .py, node --check for .js/.ts)

2. Set permission allowlist: Read, Glob, Grep, Bash(git status*), Bash(git diff*), Bash(git log*), Bash(npm test*), Bash(python3 -m pytest*)

3. Create ~/.claude/agents/researcher/AGENT.md:
   - model: haiku, tools: Read/Glob/Grep only, purpose: fast codebase exploration

4. If this project has no .claude/CLAUDE.md, create a minimal one with:
   - Build/test commands
   - Code style (2 spaces, no semicolons, etc.)
   - Architecture overview (directories + purpose)
   Keep under 150 lines.

Confirm what was set up.
```

## Alternative: Project-Specific Setup

For a specific project, add context:

```
Set up Claude Code for THIS project:

1. Read package.json (or pyproject.toml, Cargo.toml, go.mod) to detect stack
2. Read the existing CLAUDE.md (if any) and suggest improvements
3. Create path-specific rules in .claude/rules/:
   - api.md for API routes (validation, error handling, auth checks)
   - tests.md for test files (no mocks, integration-first)
   - security.md for all files (no hardcoded secrets, input validation)
4. Run the test suite and confirm it passes
5. Generate a .claude/CLAUDE.md optimized for this specific project:
   - Exact build/test commands (copy-pasteable)
   - Architecture map from actual directory structure
   - Key patterns from the codebase
   Keep under 150 lines. Tables over prose.
```
