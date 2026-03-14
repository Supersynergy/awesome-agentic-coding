---
name: refactor
description: Safe refactoring with test verification at each step.
argument-hint: <what to refactor>
allowed-tools: [Read, Edit, Bash, Glob, Grep]
---

# Safe Refactoring Protocol

Target: $ARGUMENTS

## Step 1: Baseline
- Run tests first. If they fail, stop — fix tests before refactoring.
- Note current test count and pass rate.

## Step 2: Plan
List every change you will make. Group into atomic steps where:
- Each step leaves the code in a working state
- Each step can be verified independently
- Steps are ordered by dependency

## Step 3: Execute (one step at a time)
For each step:
1. Make the change
2. Run tests
3. If tests pass: continue to next step
4. If tests fail: undo this step and investigate

## Step 4: Final Verification
- Run full test suite
- Compare test count (should be same or higher, never lower)
- Run linter if available

## Rules
- Never change behavior. Only structure.
- Never delete tests. Never skip tests.
- If a refactoring step breaks tests, it means the refactoring is wrong, not the test.
- Keep the diff minimal. Don't rename things "while you're at it."
