---
name: debug
description: Scientific debugging with hypothesis testing. Use when a bug is unclear or hard to reproduce.
argument-hint: <bug description>
allowed-tools: [Read, Edit, Bash, Glob, Grep, Agent]
---

# Scientific Debugging Protocol

Bug: $ARGUMENTS

## Step 1: Observe
- What is the expected behavior?
- What is the actual behavior?
- When did it start? (check `git log --oneline -20`)
- Can you reproduce it? How?

## Step 2: Hypothesize (list 3 possible causes)
Based on the code, list the 3 most likely root causes:
1. Hypothesis A: ...
2. Hypothesis B: ...
3. Hypothesis C: ...

## Step 3: Test Each Hypothesis
For each hypothesis:
- Add a targeted log/print statement OR read the relevant code
- Run the reproduction steps
- Confirm or eliminate the hypothesis
- Move to next hypothesis if eliminated

## Step 4: Fix
Once root cause is confirmed:
- Make the minimal fix
- Run existing tests
- Add a test that would have caught this bug

## Step 5: Verify
- Reproduce the original bug scenario — it should be fixed
- Run full test suite — nothing else should break

## Rules
- Never guess the fix without confirming the root cause
- Never fix symptoms (e.g., adding try/catch around the crash)
- Document the root cause in the commit message
