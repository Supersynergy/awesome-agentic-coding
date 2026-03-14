---
name: plan
description: Create an implementation plan before coding. Use for complex features to align before writing code.
argument-hint: <feature or task description>
allowed-tools: [Read, Glob, Grep, Agent]
---

# Planning Protocol

Task: $ARGUMENTS

## Phase 1: Research (Parallel Haiku Agents)
Launch 2-3 parallel researcher agents to:
- Find existing code relevant to this task
- Find test patterns used in this project
- Find similar implementations in the codebase

## Phase 2: Plan
Based on research, create a structured plan:

```
## Goal
[1 sentence: what does "done" look like?]

## Approach
[Which files to create/modify and why]

## Steps
1. [First change — most foundational]
2. [Second change — builds on first]
3. [Tests — verify behavior]

## Edge Cases
- [What could go wrong?]
- [What inputs are unexpected?]

## Not Doing
- [What's explicitly out of scope?]
```

## Phase 3: Review
Present the plan and wait for user feedback before proceeding.

## Rules
- NEVER write code during planning — plan ONLY
- Keep plans under 50 lines — if longer, the task should be split
- Include "Not Doing" to prevent scope creep
- Surface assumptions early — better to ask than guess wrong
