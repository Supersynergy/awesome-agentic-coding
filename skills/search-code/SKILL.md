---
name: search-code
description: Deep codebase search. Use when simple Grep/Glob aren't enough. Spawns parallel search agents.
argument-hint: <what to find, e.g. "all auth middleware" or "where is user deletion handled">
allowed-tools: [Grep, Glob, Read, Agent]
model: haiku
---

# Deep Code Search

Search the codebase for: $ARGUMENTS

## Strategy (escalating depth)

### Level 1: Direct Search (try first)
```
Grep for exact pattern → if found, return results
Glob for file patterns → if found, read relevant files
```

### Level 2: Semantic Search (if Level 1 fails)
Try related terms:
- Synonyms: "auth" → "login", "session", "token", "jwt"
- Abbreviations: "config" → "cfg", "conf", "settings"
- Naming conventions: camelCase, snake_case, kebab-case variants

### Level 3: Structural Search (if Level 2 fails)
Spawn a Haiku researcher agent to:
1. Find all entry points (main files, route handlers, exports)
2. Trace the call chain to the target functionality
3. Map the dependency graph

## Common Search Patterns
| Looking for | Search with |
|-------------|------------|
| API routes | `Grep("app\.(get\|post\|put\|delete)")` or `Grep("router\.")` |
| React components | `Glob("src/**/*.tsx")` + `Grep("export.*function\|export default")` |
| Database queries | `Grep("\.query\|\.select\|\.insert\|\.update\|\.delete")` |
| Auth checks | `Grep("auth\|middleware\|session\|token\|jwt")` |
| Error handling | `Grep("catch\|throw\|Error\|error")` |
| Environment vars | `Grep("process\.env\|import\.meta\.env\|Deno\.env")` |
| Test files | `Glob("**/*.{test,spec}.{ts,tsx,js,jsx}")` |
| Config files | `Glob("**/*.{config,rc}.{ts,js,json,yml,yaml}")` |

## Output Format
Return:
1. File path + line number
2. Relevant code snippet (5-10 lines, not full file)
3. Brief explanation of what it does
4. Related files (if part of a larger pattern)
