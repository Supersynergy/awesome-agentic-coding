---
name: commit
description: Smart commit with auto-generated message based on staged changes. Use after completing a task.
allowed-tools: [Bash, Read, Glob, Grep]
---

# Smart Commit Protocol

1. Run `git status` and `git diff --cached` (or `git diff` if nothing staged)
2. Analyze ALL changes — understand the "why", not just the "what"
3. Stage relevant files (never use `git add -A` — be selective)
4. Check for accidentally included files: `.env`, credentials, large binaries, `node_modules`
5. Look at recent `git log --oneline -5` to match the repo's commit style
6. Write a concise commit message:
   - First line: imperative mood, under 72 chars, focuses on WHY
   - Body (if needed): bullet points of key changes
   - Never include file lists — that's what `git show` is for
7. Commit with the message
8. Show the result with `git log --oneline -1`

## Rules
- NEVER amend existing commits unless explicitly asked
- NEVER skip hooks (--no-verify)
- NEVER commit .env, credentials, or secrets — warn the user
- If pre-commit hook fails, fix the issue and create a NEW commit
