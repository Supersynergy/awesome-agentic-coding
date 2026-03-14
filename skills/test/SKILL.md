---
name: test
description: Write tests for code changes. Auto-detects framework and follows TDD principles.
argument-hint: <file or feature to test>
allowed-tools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Test Writing Protocol

Target: $ARGUMENTS

## Step 1: Detect Test Framework
- Check `package.json` for vitest, jest, mocha, playwright
- Check `pyproject.toml` / `pytest.ini` for pytest
- Check `Cargo.toml` for Rust test config
- Check existing test files for patterns

## Step 2: Read the Code Under Test
- Read the target file completely
- Identify: public API, edge cases, error paths, dependencies
- Check for existing tests (don't duplicate)

## Step 3: Write Tests (TDD-Style)
Follow this priority:
1. **Happy path** — Does the basic case work?
2. **Edge cases** — Empty input, null, boundary values
3. **Error paths** — Invalid input, network failures, auth failures
4. **Integration** — Does it work with real dependencies?

## Rules
- Test BEHAVIOR, not implementation details
- No mocks unless absolutely necessary (prefer real dependencies)
- Each test should be independent — no shared mutable state
- Descriptive test names: `should return 404 when user not found`
- Run tests after writing: confirm they pass (or fail for TDD red phase)
- Keep tests close to source: `foo.test.ts` next to `foo.ts`
