---
name: review
description: Multi-agent code review. Spawns parallel reviewers for security, performance, and correctness.
argument-hint: [file or PR number]
allowed-tools: [Read, Glob, Grep, Bash, Agent]
---

# Code Review Protocol

Review the following with three parallel perspectives: $ARGUMENTS

## Step 1: Identify Changes
Run `git diff HEAD~1` or `git diff --staged` to see what changed.
If a file/PR was specified, focus on that.

## Step 2: Spawn Parallel Reviewers
Use 3 Haiku subagents in parallel:

### Reviewer 1: Correctness
- Does the logic actually work?
- Are edge cases handled?
- Are there off-by-one errors, null checks, type mismatches?

### Reviewer 2: Security
- Input validation present?
- SQL injection, XSS, command injection possible?
- Secrets hardcoded? Auth checks missing?
- OWASP Top 10 violations?

### Reviewer 3: Performance
- N+1 queries? Missing indexes?
- Unnecessary allocations or copies?
- Could this block the event loop?
- Missing pagination or limits?

## Step 3: Synthesize
Combine findings into a prioritized list:
- **CRITICAL**: Must fix before merge
- **WARNING**: Should fix soon
- **SUGGESTION**: Nice to have

Include file:line references for each finding.
