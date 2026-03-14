---
name: github
description: GitHub operations via gh CLI. Replaces GitHub MCP (saves 55,000 tokens). Use for issues, PRs, repos, code search, actions.
argument-hint: <command like "list open issues" or "create pr" or "check CI status">
allowed-tools: [Bash]
model: haiku
---

# GitHub CLI Operations

Execute GitHub operations using the `gh` CLI for: $ARGUMENTS

## Command Reference

### Issues
```bash
gh issue list                              # List open issues
gh issue list --state closed --limit 10    # Recent closed
gh issue view 123                          # View issue details
gh issue create --title "..." --body "..." # Create issue
gh issue comment 123 --body "..."          # Comment
gh issue close 123                         # Close
```

### Pull Requests
```bash
gh pr list                                 # List open PRs
gh pr view 123                             # View PR details
gh pr checks 123                           # CI status
gh pr diff 123                             # View diff
gh pr create --title "..." --body "..."    # Create PR
gh pr merge 123 --squash                   # Merge
gh pr review 123 --approve                 # Approve
```

### Code Search
```bash
gh search code "pattern" --repo owner/repo  # Search code
gh search repos "query" --language ts       # Search repos
gh api search/code -f q="pattern+repo:org/repo" # API search
```

### Actions / CI
```bash
gh run list                                # Recent runs
gh run view 123                            # Run details
gh run view 123 --log-failed               # Failed step logs
gh run rerun 123                           # Rerun
```

### API (raw)
```bash
gh api repos/owner/repo/pulls/123/comments  # Any API endpoint
gh api graphql -f query='{ viewer { login }}' # GraphQL
```

## Rules
- Use `--json` flag for structured output when parsing is needed
- Use `--limit` to avoid overwhelming output
- For PR creation, use heredoc for body formatting
- Never force-push or delete branches without user confirmation
