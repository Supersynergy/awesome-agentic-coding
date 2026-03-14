---
name: oneshot
description: One-shot coding with optimal context priming. Use when you want production-quality code in a single prompt.
argument-hint: <task description>
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep, Agent]
---

# One-Shot Coding Protocol

You are executing a **one-shot coding task**. Follow this protocol exactly:

## Phase 1: Context Gathering (30 seconds, no code)
1. Read the project's CLAUDE.md and any .claude/rules/
2. Run `git log --oneline -5` to understand recent changes
3. Use Glob/Grep to find the 3-5 most relevant files for: $ARGUMENTS
4. Read those files completely

## Phase 2: Plan (think, don't code)
Before writing any code, create a mental plan:
- What files need to change?
- What's the minimal diff to achieve the goal?
- What could break? What tests exist?
- What's the simplest approach that works?

## Phase 3: Implement (single pass)
- Make all changes in one pass
- Follow existing code patterns exactly (naming, style, structure)
- Don't refactor surrounding code
- Don't add comments unless logic is non-obvious
- Don't add error handling for impossible scenarios

## Phase 4: Verify
- If tests exist: run them
- If it's a UI change: describe what changed visually
- If it's an API change: show a curl example

## Task
$ARGUMENTS

## Rules
- Minimal changes only. No drive-by improvements.
- Match existing patterns. Don't introduce new conventions.
- If unsure about approach, ask ONE question. Don't guess.
- Prefer editing over creating new files.
