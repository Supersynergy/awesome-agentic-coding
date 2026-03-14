# Zero-MCP Workflow: 97% Token Savings

> Every MCP server you disable saves 5,000–55,000 tokens per session. This guide shows how to get the same capabilities without MCP.

## The Problem: MCP Token Math

Every MCP server injects its **full tool schema** into your context window — on every single message.

### Real Measurements

| MCP Server | Tools | Tokens | What It Does |
|-----------|-------|--------|-------------|
| GitHub | 93 | 55,000 | Issues, PRs, repos, code search |
| Slack | 25+ | 15,000 | Messages, channels, threads |
| Sentry | 15+ | 10,000 | Error tracking, alerts |
| Grafana | 10+ | 8,000 | Dashboards, queries |
| Context7 | 2 | 5,000–8,000 | Library documentation |
| Filesystem | 10+ | 5,000 | File read/write |
| Postgres | 5+ | 3,000 | Database queries |
| **Total (7 servers)** | **160+** | **~100,000** | **50% of 200K context burned** |

**With 1M context:** Still 100K wasted — that's context you could use for actual code.

### The Hidden Cost

MCP tokens are **input tokens** — they're read on **every single message**. In a 20-message conversation:
- 100,000 × 20 = **2,000,000 input tokens** just for tool definitions
- At Sonnet rates ($3/MTok): **$6.00 per conversation** just for MCP overhead
- At 10 conversations/day: **$60/day** = **$1,800/month**

---

## The Solution: CLI + Skills + Hooks

Claude Code already has everything you need built-in:

### Built-in Tools (0 Token Overhead)

| Tool | Replaces MCP |
|------|-------------|
| `Read`, `Write`, `Edit` | Filesystem MCP |
| `Glob`, `Grep` | Search MCP |
| `Bash` | Any CLI-based MCP |
| `WebFetch` | HTTP/API MCPs |
| `Agent` (subagents) | Multi-tool MCPs |

### CLI Tools (Already Installed, 0 Overhead)

| CLI | Replaces MCP | Install |
|-----|-------------|---------|
| `gh` | GitHub MCP (55K tokens) | `brew install gh` |
| `psql` | Postgres MCP (3K tokens) | `brew install postgresql` |
| `surreal` | SurrealDB MCP | `brew install surrealdb` |
| `nats` | NATS MCP | `brew install nats-io/nats-tools/nats` |
| `aws` | AWS MCP | `brew install awscli` |
| `gcloud` | GCP MCP | `brew install google-cloud-sdk` |
| `kubectl` | Kubernetes MCP | `brew install kubectl` |
| `docker` | Docker MCP | Already installed |
| `sentry-cli` | Sentry MCP (10K tokens) | `npm i -g @sentry/cli` |
| `vercel` | Vercel MCP | `npm i -g vercel` |

---

## Replacement Skills (0 Tokens When Not Invoked)

### /github (replaces GitHub MCP — saves 55,000 tokens)

```yaml
# ~/.claude/skills/github/SKILL.md
---
name: github
description: GitHub operations via gh CLI. Use for issues, PRs, repos, code search.
argument-hint: <command like "list open issues" or "create pr">
allowed-tools: [Bash]
model: haiku
---

Execute GitHub operations using the `gh` CLI.

## Common Commands
- Issues: `gh issue list`, `gh issue create`, `gh issue view 123`
- PRs: `gh pr list`, `gh pr create`, `gh pr view 123`, `gh pr checks 123`
- Repos: `gh repo view`, `gh repo clone org/repo`
- Search: `gh search code "pattern" --repo org/repo`
- API: `gh api repos/org/repo/pulls/123/comments`
- Actions: `gh run list`, `gh run view 123`

Translate the user's request ($ARGUMENTS) into the appropriate gh command.
Always use `--json` flag for structured output when available.
```

### /docs (replaces Context7 MCP — saves 5,000–8,000 tokens)

```yaml
# ~/.claude/skills/docs/SKILL.md
---
name: docs
description: Fetch live library documentation. Use when you need up-to-date API docs for any library.
argument-hint: <library name, e.g. "react hooks" or "drizzle orm">
allowed-tools: [WebFetch, Bash]
model: haiku
---

Fetch documentation for: $ARGUMENTS

## Strategy
1. Identify the official documentation URL for the library
2. Use WebFetch to retrieve the relevant page
3. Extract only the relevant sections (API signatures, examples, gotchas)
4. Return a concise summary — not the entire page

## Common Documentation URLs
- React: https://react.dev/reference/react
- Next.js: https://nextjs.org/docs
- Drizzle: https://orm.drizzle.team/docs
- Hono: https://hono.dev/docs
- Zod: https://zod.dev
- Tailwind: https://tailwindcss.com/docs
- SurrealDB: https://surrealdb.com/docs
- NATS: https://docs.nats.io

## Rules
- Fetch the SPECIFIC page, not the index
- Return code examples, not prose
- If the library version matters, note which version the docs cover
- Max 500 tokens of output — be concise
```

### /db (replaces Postgres/SurrealDB MCP — saves 3,000–8,000 tokens)

```yaml
# ~/.claude/skills/db/SKILL.md
---
name: db
description: Database operations via CLI. Supports PostgreSQL (psql), SurrealDB (surreal), SQLite.
argument-hint: <query or operation, e.g. "show all users" or "list tables">
allowed-tools: [Bash, Read]
model: haiku
---

Execute database operations for: $ARGUMENTS

## Auto-detect database
1. Check for `.env` or `docker-compose.yml` to find connection strings
2. Check for `drizzle.config.ts`, `prisma/schema.prisma`, `surreal.toml`
3. Default to project's primary database

## Commands by database
### PostgreSQL
- `psql $DATABASE_URL -c "SELECT ..."`
- `psql $DATABASE_URL -c "\dt"` (list tables)
- `psql $DATABASE_URL -c "\d tablename"` (describe table)

### SurrealDB
- `surreal sql --endpoint http://localhost:8000 --ns app --db main --username root --password root`
- Or via HTTP: `curl -X POST http://localhost:8000/sql -H "..."`

### SQLite
- `sqlite3 path/to/db.sqlite ".tables"`
- `sqlite3 path/to/db.sqlite "SELECT ..."`

## Safety Rules
- NEVER run DELETE/DROP without explicit user confirmation
- NEVER expose credentials in output
- Always LIMIT queries to 100 rows unless asked otherwise
- Use READ-ONLY mode when just exploring
```

### /search-code (replaces code search MCPs)

```yaml
# ~/.claude/skills/search-code/SKILL.md
---
name: search-code
description: Deep code search across project. Use when Grep/Glob aren't enough.
argument-hint: <what to search for>
allowed-tools: [Grep, Glob, Read, Agent]
model: haiku
---

Search the codebase for: $ARGUMENTS

## Strategy
1. Start with Grep for exact matches
2. Use Glob for file pattern matching
3. If not found, try related terms (aliases, abbreviations)
4. If complex, spawn a Haiku researcher agent for parallel search

## Common patterns
- Find all API routes: `Grep("app\.(get|post|put|delete|patch)")`
- Find all React components: `Glob("src/**/*.tsx")`
- Find all test files: `Glob("**/*.{test,spec}.{ts,tsx,js}")`
- Find all imports of X: `Grep("from.*['\"]X['\"]")`
- Find all env vars used: `Grep("process\.env\.|import\.meta\.env\.")`

Return: file paths + line numbers + relevant code snippets (not full files)
```

---

## SessionStart Hook: Context Without MCP

Instead of MCP servers loading 100K tokens, inject ~500 tokens of useful context at session start:

```bash
#!/bin/bash
# ~/.claude/hooks/smart-context.sh
# Runs at SessionStart — injects project-aware context

OUTPUT=""

# Git context (most useful for coding)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    RECENT=$(git log --oneline -3 2>/dev/null)
    CHANGED=$(git diff --name-only 2>/dev/null | head -10)
    OUTPUT+="Git: branch=$BRANCH
Recent commits:
$RECENT"
    [ -n "$CHANGED" ] && OUTPUT+="
Changed files:
$CHANGED"
fi

# Project type detection
[ -f "package.json" ] && OUTPUT+="
Node project: $(node -p 'Object.keys(require("./package.json").dependencies||{}).slice(0,10).join(", ")' 2>/dev/null)"
[ -f "pyproject.toml" ] && OUTPUT+="
Python project"
[ -f "Cargo.toml" ] && OUTPUT+="
Rust project"
[ -f "go.mod" ] && OUTPUT+="
Go project"

# Running services
PORTS=$(lsof -iTCP -sTCP:LISTEN -nP 2>/dev/null | awk '{print $9}' | sort -u | tail -5)
[ -n "$PORTS" ] && OUTPUT+="
Active ports: $PORTS"

echo "$OUTPUT"
```

**This gives Claude more useful context than most MCPs, at ~300 tokens instead of 100,000.**

---

## The Zero-MCP Architecture

```
                Session Start (~1,800 tokens total)
                ┌─────────────────────┐
                │ CLAUDE.md (~300 tok) │ Always loaded
                │ Memory (~500 tok)    │ Always loaded
                │ Skills metadata      │ ~100 tok × 10 skills = ~1,000 tok
                │ SessionStart hook    │ ~300 tok (git + project context)
                └─────────┬───────────┘
                          │
                    On-Demand Only
                ┌─────────┴───────────┐
                │                     │
          CLI Commands           Skills Invoked
          (0 overhead)         (load on /invoke)
                │                     │
         ┌──────┤──────┐       ┌──────┤──────┐
         │      │      │       │      │      │
        gh    psql   git    /docs  /github  /db
        │      │      │     ~500   ~500    ~500
        └──────┤──────┘     tokens tokens  tokens
               │
          Results only
        (no schema overhead)
```

### Comparison

| | 7 MCP Servers | Tool Search | Zero-MCP |
|---|---|---|---|
| **Initial load** | 100,000 tok | 8,500 tok | 1,800 tok |
| **Per message** | 100,000 tok (re-read) | 8,500 tok | 1,800 tok |
| **20-msg session** | 2,000,000 tok | 170,000 tok | 36,000 tok |
| **Session cost** | $6.00 | $0.51 | **$0.11** |
| **Monthly (50 sessions)** | $300 | $25.50 | **$5.40** |
| **Capability** | Full | Full | Full (via CLI) |

---

## Migration Checklist

| MCP Server | Disable | Replace With | Savings |
|-----------|---------|-------------|---------|
| filesystem | Yes | Built-in Read/Write/Edit/Glob/Grep | 5,000 tok |
| git | Yes | Built-in Bash(git ...) | 5,000 tok |
| github | Yes | `/github` skill + `gh` CLI | 55,000 tok |
| postgres | Yes | `/db` skill + `psql` | 3,000 tok |
| context7 | Yes | `/docs` skill + WebFetch | 5,000 tok |
| sentry | Yes | `/sentry` skill + `sentry-cli` | 10,000 tok |
| slack | Maybe | Keep if heavy Slack workflow | 15,000 tok |

**Rule of thumb:** If the MCP wraps a CLI tool, delete it. If it provides a unique real-time integration (Slack webhooks, live notifications), consider keeping it with Tool Search.

---

## When to Keep MCP

Keep MCP servers only if ALL of these are true:
1. No CLI alternative exists
2. Tool Search is enabled (auto since Jan 2026)
3. The MCP provides real-time capabilities (webhooks, subscriptions)
4. You use it in >50% of sessions

If even one is false, replace with CLI + skill.

---

## Sources

- [GitHub MCP: 55,000 tokens for 93 tools](https://dev.to/piotr_hajdas/mcp-token-limits-the-hidden-cost-of-tool-overload-2d5)
- [Tool Search: 46.9% reduction](https://medium.com/@joe.njenga/claude-code-just-cut-mcp-context-bloat-by-46-9)
- [Cloudflare Code Mode: 99.95% savings](https://blog.cloudflare.com/code-mode-mcp/)
- [Optimising MCP Context Usage](https://scottspence.com/posts/optimising-mcp-server-context-usage-in-claude-code)
- [Why CLIs Beat MCP](https://medium.com/@rentierdigital/why-clis-beat-mcp-for-ai-agents)
- [Claude Code Cost Management](https://code.claude.com/docs/en/costs)
- [MCP Token Bloat Issue](https://github.com/modelcontextprotocol/modelcontextprotocol/issues/1576)
