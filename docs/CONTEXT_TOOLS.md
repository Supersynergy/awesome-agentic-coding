# Context Management Tools & Techniques for AI-Assisted Coding (March 2026)

## Overview

Context is the bottleneck of AI-assisted coding. Even with Claude's 1M context window now generally available, strategic context management separates efficient workflows from token-wasteful ones. This guide covers eight proven approaches: three external tools (Context7, Greptile, Repomix/tree-sitter ecosystem) and five Claude Code native solutions for maximum efficiency.

---

## Part 1: External Context Tools

### 1. Context7 MCP: Live Library Documentation

**Problem Solved:** LLMs have stale training data. When working with Next.js 15, React 19, or libraries that evolve post-training, you get hallucinated APIs and deprecated patterns.

**What It Is:** An MCP server that injects up-to-date, version-specific documentation directly into your LLM's context window on demand.

**How It Works:**
- Queries a curated database of 9,000+ libraries and frameworks
- Resolves library names to versioned documentation IDs (e.g., `next.js` → `/vercel/next.js/v15.0.0`)
- Retrieves relevant documentation chunks and code examples
- Configurable token limits (default 5,000, scalable to your window size)

**Setup:**

```bash
# Install via npm
npm install @context7/mcp-server

# Or use with Claude Code via MCP configuration
# Add to settings.json or ~/.claude/mcp.json:
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["@context7/mcp-server"],
      "disabled": false
    }
  }
}
```

**Integration with Claude Code:**
- Use Context7 as an MCP tool alongside Cursor, VS Code, or Claude Code
- Available via HTTP (remote) or stdio (local)
- Best for: Cursor, VS Code with Copilot, Windsurf, or Claude Code with MCP support

**When to Use:**
- Working with rapidly-evolving frameworks (Next.js, React, Vue, Astro, TypeScript)
- Need current API signatures and examples
- Avoiding hallucinated deprecated patterns
- Cost: Free for most projects, context-efficient (only fetches what you ask for)

**Example Usage in Claude Prompt:**
```
I need to implement Next.js 15 server actions.
Can you fetch the current documentation and help me implement this correctly?
[Context7 fetches and injects latest Next.js 15 docs]
```

**Supported Libraries:**
Next.js, React, Vue, Astro, TypeScript, Tailwind CSS, and 9,000+ others in their index.

**Strengths:**
- Zero stale data issues
- Minimal token overhead (fetches only what's needed)
- Version-specific documentation
- Works with any LLM (Claude, ChatGPT, DeepSeek, etc.)

**Limitations:**
- Requires internet connection
- Library must be in Context7's index
- Initial setup with MCP configuration

---

### 2. Greptile: Semantic Code Search for AI

**Problem Solved:** Finding relevant code in large, messy legacy codebases is hard. Traditional grep/regex fails on semantic queries like "find all classes that inherit from this base class."

**What It Is:** A semantic code search engine specifically designed for AI agents, combining code search, code graphs, and AI embeddings.

**How It Works:**
- Analyzes code semantically (not just string matching)
- Builds code graphs tracking relationships and dependencies
- Uses AI vector database for intelligent ranking
- Translates code to natural language before generating embeddings
- Chunks at function level (not file level) for precision

**Setup:**

```bash
# Install Greptile CLI
npm install -g greptile

# Initialize in your repo
greptile init

# Or use via API
curl -X POST https://api.greptile.com/v2/search \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{"query": "find all database connection pooling implementations"}'
```

**Integration with Claude Code:**
- Via MCP server (if available)
- Via API calls in prompts: request Greptile search for specific patterns
- Works with multiple repos and branches simultaneously

**When to Use:**
- Onboarding to large codebases (200K+ lines)
- Code review context: semantic search finds related implementations
- Refactoring: find all callers of a function across the codebase
- Understanding patterns: "show me all examples of how we handle errors"

**Example Workflow:**
```
User: "How do we handle database transactions in this codebase?"
→ Greptile semantic search finds all transaction-related patterns
→ Returns relevant code snippets with context
→ Claude provides implementation guidance based on actual patterns
```

**Real-World Impact:**
- Teams using Greptile merge PRs 4x faster on average
- 3x more bugs caught in code review
- Used by 250+ companies including Stripe, Amazon, PostHog, Raycast

**Strengths:**
- Semantic understanding (not just regex)
- Scales to massive codebases
- Cross-branch and cross-repo search
- ML-powered ranking ensures relevance
- AI code review agent available

**Limitations:**
- Requires initial indexing (one-time cost)
- Paid plans required for large teams
- API-based (requires cloud service)

---

### 3. tree-sitter: AST Parsing for Intelligent Context

**Problem Solved:** LLMs need structured understanding of code, not just text. String-based context misses relationships, scope, and semantic meaning.

**What It Is:** A generic parser generator and incremental parsing library that builds concrete syntax trees (CSTs) for 40+ languages.

**How It Works:**
- Creates Abstract Syntax Trees (ASTs) that capture semantics
- Preserves exact syntax (unlike pure ASTs)
- Error-tolerant parsing (works on incomplete/broken code)
- Real-time incremental updates as code changes
- Powers semantic indexing for RAG pipelines

**Setup:**

```bash
# Install tree-sitter CLI
npm install -g tree-sitter

# Initialize language support
tree-sitter init-config

# Generate parsers
tree-sitter generate

# Parse a file to JSON AST
tree-sitter parse --quiet myfile.js | jq '.tree'
```

**Python Integration (for RAG pipelines):**

```bash
pip install tree-sitter tree-sitter-python

# Use in indexing pipeline
from tree_sitter import Language, Parser

PYTHON_LANGUAGE = Language('build/my-languages.so', 'python')
parser = Parser()
parser.set_language(PYTHON_LANGUAGE)

tree = parser.parse(code_bytes)
# Now query tree.root_node for semantic information
```

**Integration with Claude Code:**
- Use tree-sitter as a preprocessing step before sending code to Claude
- Query for specific patterns: "Get all function definitions and their arguments"
- Build semantic context: track which functions call which

**When to Use:**
- Building RAG pipelines: chunk by semantic units (functions, classes) not lines
- Context extraction: get only the relevant function + its dependencies
- Large codebase analysis: understand structure before feeding to LLM
- Code refactoring: find all dependents of a function

**Language Support:**
C, Java, JavaScript, TypeScript, Python, Rust, Go, C++, C#, PHP, Ruby, and 30+ more.

**Example: Extract Function Context for Claude**

```python
# Get function definition + all functions it calls
import tree_sitter

def extract_function_context(code: str, function_name: str) -> str:
    """Return function + all dependencies for LLM context."""
    tree = parser.parse(code.encode())

    # Find target function
    def_node = find_function(tree, function_name)

    # Get all called functions
    called = extract_calls(def_node)

    # Return minimal context needed for Claude
    return build_context_string(def_node, called)
```

**Strengths:**
- Precise structural understanding
- Scales to any codebase size
- Language-agnostic (supports 40+ languages)
- Incremental updates (efficient for long sessions)
- Powers many professional tools (GitHub, VSCode)

**Limitations:**
- Requires preprocessing step
- Learning curve for AST queries
- Best suited for automated pipelines, not manual use

---

### 4. ast-grep: Structural Code Search & Transformation

**Problem Solved:** Finding code by structure (not text): "Find all try-catch blocks with empty catch" or "Find functions > 50 lines."

**What It Is:** A fast, polyglot CLI tool for structural search, lint, and code rewriting using AST patterns.

**How It Works:**
- Patterns look like ordinary code you write daily (isomorphic to code)
- Uses tree-sitter for AST generation
- Supports 23+ languages including TypeScript, Python, Rust, Go, Java, C++
- Enables large-scale code transformation and refactoring

**Setup:**

```bash
# Install
cargo install ast-grep
# or
npm install -g @ast-grep/cli

# Verify installation
sg --version

# Create config file (.ast-greprc.yaml or ast-grep.yaml)
cat > ast-grep.yaml << 'EOF'
rules:
  - id: find-large-functions
    pattern: function $name($$$args) { $$$ }
    constraints:
      function_body_lines: ">50"
    message: Function $name is too large
EOF
```

**Basic Usage Examples:**

```bash
# Find all try-catch blocks
sg --pattern 'try { $$$ } catch { $$$ }' src/

# Find empty catch blocks (bug pattern)
sg --pattern 'catch ($$error) { }' --rewrite 'catch ($$error) { console.error($$error); }' src/

# Find console.log statements to remove
sg --pattern 'console.log($$_)' --rewrite '' src/

# Find deprecated function calls
sg --pattern 'deprecatedFunc($$args)' --rewrite 'newFunc($$args)' src/
```

**Pattern Syntax:**

| Symbol | Meaning |
|--------|---------|
| `$$$` | Match any number of statements/expressions |
| `$$var` | Named capture (preserves original) |
| `$$$args` | Multi-argument capture |
| `$$_` | Anonymous wildcard |

**Integration with Claude Code:**

1. Define patterns in `.ast-greprc.yaml`
2. Run searches to identify refactoring opportunities
3. Share results with Claude for context-aware suggestions
4. Use `--rewrite` for large-scale automated changes

**Example: Refactoring Workflow**

```yaml
# Find all old API calls in your codebase
rules:
  - id: old-api-calls
    pattern: fetch('/api/v1/$endpoint', $$opts)
    message: Update to v2 API
```

```bash
# Find all occurrences
sg --config ast-grep.yaml src/

# Show matches with context
sg --config ast-grep.yaml --json src/ > findings.json

# Let Claude review and suggest rewrites
# Claude can then generate --rewrite patterns
```

**Strengths:**
- Pattern language looks like real code (intuitive)
- Scales to massive codebases (millions of LOC)
- Supports 23+ languages
- Language-independent pattern engine
- Excellent for enforcing code standards
- Integrates with CI/CD and pre-commit hooks

**Limitations:**
- Patterns can be complex for advanced cases
- Not a full refactoring IDE (focuses on search + replace)
- Requires learning pattern syntax

**Real-World Use Cases:**
- Library authors: Help users adopt breaking changes
- Tech leads: Enforce coding standards at scale
- Migrations: Update deprecated APIs across massive codebases

---

### 5. Sourcegraph Cody: Code Intelligence Platform

**Problem Solved:** Claude needs context about how code fits together: dependencies, usage patterns, function signatures, inheritance chains.

**What It Is:** An AI coding assistant that uses code intelligence (search, code graphs, embeddings, and symbolic analysis) to provide precise, repository-aware context.

**How It Works:**
- **Code Search:** Text + semantic search across repos
- **Code Graph (SCIP):** Analyzes code structure and dependencies
- **Vector DB:** AI embeddings for semantic matching
- **Symbolic Analysis:** Tracks all definitions, usages, relationships

**Setup:**

```bash
# Install Cody CLI
npm install -g @sourcegraph/cody

# Configure for your repo
cody init

# Or integrate with Sourcegraph Cloud
# 1. Upload repo to sourcegraph.com
# 2. Access Cody via web UI
# 3. Use @-mentions for context retrieval
```

**Context Retrieval with @-mentions:**

```
@files:src/api/handlers.ts
Show me how this file is used across the codebase

@symbols:validateEmail
Find all usages of validateEmail function

@repositories:backend,frontend
Search across multiple repos

@pull-requests:123
Provide context from this PR
```

**Integration with Claude Code:**
- Use Cody's semantic search to gather context
- Export context from Cody and paste into Claude
- Or use MCP bridge if available

**When to Use:**
- Onboarding to new repos: `@` your way to understanding
- Code review: Find all related code with one symbol mention
- Debugging: Trace where a variable comes from across files
- Refactoring: Find all dependents before making changes

**Real Impact:**
- More accurate and specific responses than vanilla LLMs
- Cody understands repo-specific patterns, conventions, frameworks
- Reduces hallucination of non-existent APIs/functions
- Contextual awareness makes suggestions 100x more relevant

**Strengths:**
- Deep code understanding (not just text search)
- Works with massive monorepos and polyglot codebases
- Code graph enables "find all references" queries
- Cloud or self-hosted options
- Integrates with GitHub, GitLab, Bitbucket

**Limitations:**
- Setup requires Sourcegraph instance or Cloud account
- Proprietary platform (not open-source)
- Complex queries have learning curve

---

### 6. Repomix/Repopack: Repo-to-Prompt Flattening

**Problem Solved:** You want to give Claude your entire repo context at once, but thousands of files don't fit. Repomix intelligently packs it.

**What It Is:** A tool that flattens entire repositories into single AI-friendly files (XML, Markdown, JSON) with token counting and intelligent compression.

**How It Works:**
- Scans entire repository
- Intelligently compresses code (70% token reduction with tree-sitter)
- Generates single output file with full codebase context
- Includes token counts for each file
- Supports multiple output formats and filters

**Setup:**

```bash
# Install
npm install -g repomix
# or
pip install repomix

# Initialize
repomix --init

# Generate packed output
repomix

# Output: repomix-output.xml (default)
```

**Configuration (.repomixrc or repomix.json):**

```json
{
  "output": {
    "file": "codebase.xml",
    "format": "xml",
    "tokenCount": true,
    "language": "typescript"
  },
  "include": ["src/**/*.ts", "src/**/*.tsx"],
  "exclude": ["node_modules/**", "**/*.test.ts"],
  "compression": {
    "enabled": true,
    "targetTokens": 50000
  },
  "topFilesLength": 5,
  "git": {
    "includeBranchInfo": true
  }
}
```

**Example Output Structure:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<repository>
  <metadata>
    <name>my-app</name>
    <totalTokens>48,234</totalTokens>
    <filesCount>127</filesCount>
    <compressionRatio>3.2</compressionRatio>
  </metadata>
  <directory name="src">
    <file name="api.ts" language="typescript" tokens="2,143">
      <source>... compressed source code ...</source>
    </file>
    <file name="utils.ts" language="typescript" tokens="891">
      <source>... compressed source code ...</source>
    </file>
  </directory>
</repository>
```

**Usage with Claude:**

```
Here's my entire codebase context:
[paste repomix-output.xml]

I need to:
1. Understand the architecture
2. Add a new API endpoint for /auth/refresh
3. Maintain consistency with existing patterns

Please analyze the structure and suggest implementation.
```

**Advanced Features:**

**MCP Integration:**
```json
{
  "mcpServers": {
    "repomix": {
      "command": "repomix",
      "args": ["--watch"],
      "disabled": false
    }
  }
}
```

**GitHub Actions Integration:**
```yaml
- name: Generate codebase context
  uses: yamadashy/repomix-action@v1
  with:
    output: codebase.xml
    exclude: 'node_modules,dist,build'
```

**Tree-sitter Compression:**
```bash
# Enable intelligent compression
repomix --compress --target-tokens 40000
```

**Token Reduction Strategies:**

| Strategy | Reduction | Use Case |
|----------|-----------|----------|
| tree-sitter compression | 70% | Large codebases |
| Smart filtering | 40-60% | Focus on relevant files |
| Removing comments | 10-15% | Space optimization |
| Combined approach | 80%+ | Maximum efficiency |

**When to Use:**
- Onboarding new developers (full codebase reference)
- Code review: provide full context to Claude
- Large refactoring: Claude needs to understand all implications
- Architecture analysis: understand system holistically
- AI code generation: needs full codebase patterns

**Strengths:**
- Handles massive codebases intelligently
- Token counting built-in (plan your context budget)
- Multiple output formats (XML, Markdown, JSON)
- Intelligent compression (70% reduction possible)
- Works offline (no API required)
- Supports filtering and inclusion patterns
- GitHub Actions integration for CI/CD

**Limitations:**
- Output can still be large even with compression
- Requires careful file filtering for massive monorepos
- Not suitable for real-time collaboration (static snapshot)

**Real-World Examples:**

```bash
# Frontend-only codebase
repomix --include "src/**/*.tsx" --exclude "node_modules"

# Backend API + database
repomix --include "app/**/*.py,migrations/**" --exclude "__pycache__"

# Monorepo: specific package
repomix --include "packages/my-package/**" --exclude "packages/*/node_modules"
```

---

## Part 2: Claude Code Native Solutions

### 7. Claude Code 1M Context Window Strategies

**Available Since:** March 13, 2026 (generally available)

**What Changed:**
- 1M context now standard (not premium) for Opus 4.6 and Sonnet 4.6
- Maintained accuracy across full window
- No per-token premium for long context
- Enables whole-document processing without chunking

**Strategy 1: Selective Loading (Still Important)**

Even with 1M tokens available, loading irrelevant files dilutes signal and wastes tokens. Load strategically:

```
Total Context: 1M tokens (1,000,000)

System Prompt + Rules:      5,000 (0.5%)
CLAUDE.md + MEMORY:        15,000 (1.5%)
Project Context:           50,000 (5%)
  ├─ Architecture diagram
  ├─ Core file list
  ├─ Conventions
  └─ Recent decisions

Current Task Context:      200,000 (20%)
  ├─ Current files
  ├─ Related implementations
  ├─ Test cases
  └─ Examples

Conversation History:      300,000 (30%)
Remaining Buffer:          430,000 (43%)
```

**Strategy 2: Full Codebase + Long Sessions**

With 1M, you can load:
- Entire small-to-medium codebases (100K-200K LOC)
- Complete conversation history (avoid compaction)
- Full test suites for understanding
- All documentation in context

```bash
# Old approach (200K context): chunk + summarize
# New approach (1M context): load everything relevant

repomix --output codebase.xml  # Full codebase
# Then: Here's my full codebase [paste xml]
# Conversation continues without compaction needed
```

**Strategy 3: Long-Running Projects**

For multi-hour sessions without manual compaction:

```markdown
# In CLAUDE.md:
## Context Management
- Use 1M window to avoid auto-compaction
- Keep full conversation history
- Load all related code upfront
- Batch multiple tasks in one session
```

**When 1M Doesn't Help (Still Limit):**

- Token limit is still a limit (can't do "infinite context")
- 500K+ tokens/message = slower response times
- Better to use smaller focused windows for speed
- Long historical context still dilutes current reasoning

**Best Practices:**

1. **Load Once:** Fetch full codebase at session start, not incrementally
2. **Organize by Layer:** System → Project → Task → Conversation (top-down loading)
3. **Use Checkpoints:** Mark major decision points with `/compact` to save progress
4. **Monitor Usage:** Check `context_window.used_percentage` in status bar

---

### 8. CLAUDE.md Optimization (Under 200 Lines)

**Token Impact:**
- Unoptimized CLAUDE.md (300 lines): 4,500 tokens
- Optimized CLAUDE.md (150 lines): 1,800 tokens
- **Savings: 60% reduction**

**Structure: 5 Blocks**

```markdown
# CLAUDE.md Optimal Structure

## Block 1: Role & Principles (20 lines)
What are you? What do you believe?

## Block 2: Stack & Commands (30 lines)
Tools, tech stack, key commands as tables

## Block 3: Conventions (40 lines)
Code style, naming, patterns (tables > prose)

## Block 4: Prohibitions (20 lines)
What NOT to do (hard rules)

## Block 5: @imports (Optional, <10 lines)
Links to modular rules files
```

**Example Optimized CLAUDE.md:**

```markdown
# Claude Code Config

**Mode**: Architect + coder | **Lang**: TypeScript | **Framework**: Next.js 15

## Stack

| Layer | Tech | Version |
|-------|------|---------|
| Frontend | Next.js + React | 15 + 19 |
| Backend | Node.js | 22.0 |
| Database | PostgreSQL | 16 |
| Testing | Vitest + Playwright | Latest |
| Linter | Biome | 1.9 |

## Commands

| Command | Action |
|---------|--------|
| `npm run dev` | Start dev server localhost:3000 |
| `npm run build` | Production build |
| `npm test` | Run all tests |
| `npm run format` | Biome fix |

## Conventions

**Naming:**
- Components: PascalCase (`UserCard.tsx`)
- Hooks: camelCase + use prefix (`useAuth`)
- Utils: camelCase (`formatDate()`)
- Consts: UPPER_SNAKE_CASE

**File Structure:**
- `/src/components` – UI components
- `/src/app` – Next.js routes
- `/src/lib` – Utilities & helpers
- `/src/types` – Shared types

**Code Style:**
- Max line length: 100
- Arrow functions: Always
- Imports: Grouped (React, packages, local)

## DO NOT

- ❌ Modify database schema manually (use migrations)
- ❌ Add external npm packages without discussing
- ❌ Commit to main (create branches)
- ❌ Use var/function declarations

## Rules

@import .claude/rules/typescript.md
@import .claude/rules/next.md
```

**Token Breakdown Comparison:**

| Section | Unoptimized | Optimized | Savings |
|---------|------------|-----------|---------|
| Prose descriptions | 2,100 | 0 | 100% |
| Tables (concise) | 600 | 900 | -50% |
| Code examples | 800 | 400 | 50% |
| Comments | 400 | 200 | 50% |
| **Total** | **4,500** | **1,800** | **60%** |

**Guidelines for Optimized CLAUDE.md:**

1. **Use Tables, Not Prose**
   - Prose: "We use TypeScript for type safety, Node.js for the backend, and PostgreSQL for the database."
   - Table: See Stack section above (same info, 70% fewer tokens)

2. **Use Commands, Not Descriptions**
   - Bad: "To start the development server, open your terminal and run npm run dev. The server will start on localhost:3000."
   - Good: `npm run dev` → Start dev server localhost:3000

3. **Cut Redundancy**
   - Don't repeat info available in README.md
   - Don't explain what tools do (assume knowledge)
   - Focus on project-specific conventions

4. **Keep Under 150 Lines**
   - Use @import for modular rules (see Part 8)
   - One section per 30 lines max
   - Every line should earn its tokens

**Quarterly Review:**
- Review CLAUDE.md every 3 months
- Remove outdated commands/conventions
- Update tech stack versions
- Consolidate similar patterns

---

### 9. Skills for On-Demand Context (Load Only When Needed)

**Token Cost of Skills When Unused: 0 tokens**

**What Are Skills:**
Skills are folders with instructions, scripts, and resources that Claude discovers and loads only when relevant. Unlike CLAUDE.md (always loaded), Skills exist as a library—Claude accesses exactly what it needs, when it needs it.

**Structure:**

```
.claude/skills/
├── my-skill/
│   ├── SKILL.md           # Instructions (loaded when invoked)
│   ├── templates/         # Code templates (loaded when needed)
│   ├── examples/          # Examples (only if referenced)
│   └── hooks.json         # Optional: auto-invoke triggers
├── testing-skill/
│   ├── SKILL.md
│   └── test-templates/
└── api-design/
    ├── SKILL.md
    └── patterns.md
```

**Skill Frontmatter (in SKILL.md):**

```yaml
---
name: typescript-best-practices
description: >
  Enforce TypeScript strict mode, avoid any, use discriminated unions
  Load automatically when editing .ts/.tsx files
argument-hint: "[topic]"
allowed-tools: [Read, Edit, Bash]
model: haiku
context: fork
once: true
user-invocable: true
---

# TypeScript Best Practices

[Skill content follows]
```

**Example: Database Migration Skill**

```yaml
---
name: db-migration
description: Generate database migrations, validate schema changes
allowed-tools: [Read, Write, Bash]
once: false
---

# Database Migration Skill

Use this when modifying database schema.

## Commands

- `npm run migrate:create` – Create new migration
- `npm run migrate:up` – Apply migrations
- `npm run migrate:down` – Rollback

## Best Practices

- Always create migrations (never modify schema directly)
- Name: YYYY-MM-DD-HH-MM-description.sql
- Include UP and DOWN statements
- Use transactions for safety

## Template

See templates/ for migration templates.
```

**Auto-Invoke Triggers (hooks.json):**

```json
{
  "skills": [
    {
      "name": "db-migration",
      "triggers": {
        "paths": ["db/migrations/**", "schema.sql"],
        "keywords": ["migration", "alter table", "schema change"]
      }
    },
    {
      "name": "testing-skill",
      "triggers": {
        "paths": ["**/*.test.ts", "**/*.spec.ts"],
        "keywords": ["test", "testing", "assert"]
      }
    }
  ]
}
```

**Token Efficiency:**

| Approach | Tokens/Session | Cost |
|----------|----------------|------|
| Monolithic CLAUDE.md | 4,500 | Always loaded |
| Optimized CLAUDE.md + 5 Skills | 1,800 base + 1,000 active | Only active skills loaded |
| 10 Skills (all active) | 1,800 + 8,000 | Rarely needed together |

**When to Use Skills:**

| Scenario | Skill | Benefit |
|----------|-------|---------|
| Editing tests | testing-skill | 1,200 tokens saved when not testing |
| Database work | db-migration | 900 tokens saved unless doing migrations |
| API design | api-design | 1,500 tokens saved for UI work |
| Deployment | devops-skill | 2,000 tokens saved for non-devops |

**Best Practices:**

1. **One Skill per Major Tool/Task**
   - testing
   - deployment
   - api-design
   - database
   - documentation

2. **Keep Skills Independent**
   - Don't reference other skills
   - Self-contained instructions
   - No dependencies on specific projects

3. **Auto-Invoke Sparingly**
   - Use path-based triggers (most reliable)
   - Use keyword triggers (load on demand)
   - Avoid always-loading skills (defeats purpose)

4. **Document Invocation**
   - Make `/skill-name [args]` discoverable
   - Document in main CLAUDE.md what skills exist
   - Use `argument-hint` for CLI-style skills

---

### 10. Rules with Path Matching (Load Only for Relevant Files)

**Concept:** Instead of one giant CLAUDE.md, split rules by file type/path. Load only when Claude is working on those files.

**Structure:**

```
.claude/rules/
├── typescript.md           # For *.ts, *.tsx files
├── next.md                # For app/, pages/ directories
├── testing.md             # For *.test.ts, *.spec.ts
├── database.md            # For db/, migrations/
├── api.md                 # For api/ routes
├── frontend.md            # For components/, styles/
└── security.md            # For auth/, security-related
```

**Rule File Format (with path frontmatter):**

```yaml
---
paths:
  - "src/**/*.ts"
  - "src/**/*.tsx"
  - "!src/**/*.test.tsx"
description: TypeScript best practices for this project
---

# TypeScript Standards

## Strict Mode

Always enable `strict: true` in tsconfig.json.

## Type Definitions

- No `any` type (use `unknown` with type narrowing)
- All function parameters typed
- All return types explicit

## Example

```typescript
// ✅ Good
function processUser(user: User): Promise<ProcessResult> {
  // implementation
}

// ❌ Bad
function processUser(user: any) {
  // implementation
}
```
```

**Another Example: Next.js Specific Rules**

```yaml
---
paths:
  - "src/app/**"
  - "src/app/**/*.ts"
description: Next.js 15 + App Router conventions
---

# Next.js App Router Rules

## File Conventions

- `page.tsx` – Route component
- `layout.tsx` – Shared layout
- `loading.tsx` – Loading UI (suspense boundary)
- `error.tsx` – Error boundary
- `route.ts` – API routes

## Server Components by Default

All components are Server Components. Use `'use client'` only when needed.

## Data Fetching

- Use `fetch()` with `revalidate` options
- Cache: { revalidate: 3600 }
- Don't use getStaticProps/getServerSideProps (App Router only)

## Dynamic Routes

```typescript
// app/users/[id]/page.tsx
export default function UserPage({ params }: { params: { id: string } }) {
  return <div>User {params.id}</div>
}
```
```

**Path Matching Patterns:**

| Pattern | Matches |
|---------|---------|
| `src/**/*.ts` | All TypeScript files in src |
| `src/api/**` | Files in api directory |
| `!src/**/*.test.ts` | Exclude test files (negation) |
| `src/app/admin/**` | Admin routes only |
| `migrations/**` | Database migrations |

**Token Savings:**

```
Scenario: Working on TypeScript component

Total Context Budget: 200,000 tokens

Option 1: Monolithic CLAUDE.md with ALL rules
├─ TS rules: 800 tokens
├─ Next.js rules: 700 tokens
├─ Testing rules: 600 tokens
├─ API rules: 500 tokens
├─ Database rules: 400 tokens
└─ Total loaded: 3,000 tokens

Option 2: Path-matched rules (typescript.md + next.md only)
├─ TS rules: 800 tokens
├─ Next.js rules: 700 tokens
└─ Total loaded: 1,500 tokens

Savings: 1,500 tokens (50%)
```

**Best Practices:**

1. **Map to Codebase Structure**
   - One rule file per major directory
   - Match real file organization
   - Use clear naming

2. **Keep Rules DRY**
   - Avoid duplication across files
   - Use @import if rules overlap
   - Link to CLAUDE.md for shared conventions

3. **Test Path Matching**
   - Verify patterns match intended files
   - Use negation (!) for exclusions
   - Check rules load during edits

4. **Granularity Sweet Spot**
   - ~700 tokens per rule file
   - 3-5 rule files typical
   - More than 10 is too many

---

### 11. Memory System for Cross-Session Context (Auto-Memory)

**What Is It:** Claude automatically writes notes to MEMORY.md about patterns, decisions, and learnings. These notes persist across sessions.

**How It Works:**
1. Claude recognizes patterns while working (build commands, architectural decisions, naming conventions)
2. Saves notes to `.claude/memory/MEMORY.md` automatically
3. Next session loads first 200 lines of MEMORY.md (0 token cost if you don't exceed 200 lines)
4. You can manually add notes with `/memory` command

**Auto-Memory Captures:**

- Build commands and scripts
- Debugging insights and known issues
- Architecture notes and decisions
- Code style preferences
- Workflow habits and patterns
- Libraries and dependencies
- Testing conventions
- Performance optimizations

**Example MEMORY.md:**

```markdown
# Claude Code Memory Index

## Project Setup
- **Start command**: `npm run dev` (localhost:3000)
- **Build**: `npm run build` then `npm start`
- **Test**: `npm test` (Vitest, watch mode default)
- **Deploy**: `git push origin main` (CI/CD handles rest)

## Known Issues & Fixes
- **WSL2 slow file watch**: Use `WATCHPACK_POLLING=true npm run dev`
- **Database connection timeout**: Requires local PostgreSQL running on 5432
- **Next.js ISR cache**: Clear `.next` folder if stale data shows

## Architecture Decisions
- **API routes** in `app/api/` (not `pages/api/`)
- **Database migrations** via `migrations/` folder (TypeORM)
- **State management**: No external library (React Context + hooks)
- **Styling**: Tailwind CSS + CSS Modules (per-component)

## Code Patterns
- **Error handling**: Always return `{ error: string }` from API routes
- **Validation**: Use Zod for runtime validation (not TypeScript types)
- **Async operations**: Always add timeout (default 30s)
- **Database**: Connection pooling via Prisma (max 5 connections)

## Team Patterns
- Commit message format: `[feature|fix|docs] brief description`
- PR requirements: Tests + docs + one approval before merge
- Code review checklist in PULL_REQUEST_TEMPLATE.md

## Performance Notes
- Images must be optimized (use `next/image`)
- Consider ISR for static pages (cache 1 hour)
- Database queries: Always use indexes (check EXPLAIN ANALYZE)
```

**Manual Memory Management:**

```bash
# Edit memory directly
/memory

# Add a note about today's work
> User: /memory add
> Claude: Creates new section, you add content

# View all memory
/memory show
```

**Token Efficiency:**

| Approach | Token Cost | Persistence |
|----------|-----------|------------|
| No memory | 0 | Lost each session |
| Manual notes | 1,000-2,000 | Only if you write |
| Auto-memory | 1,000-2,000 | Automatic capture |
| Full historical context | 10,000+ | Bloated, slow |

**Best Practices:**

1. **Keep MEMORY.md Under 200 Lines**
   - First 200 lines loaded free (auto at session start)
   - Quarterly cleanup required
   - Remove obsolete notes

2. **Structure for Fast Lookup**
   - Table of contents at top
   - Clear section headers
   - Related items grouped

3. **Update Quarterly**
   - Review what's still relevant
   - Archive old issues/decisions
   - Consolidate redundant entries

4. **Sync with CLAUDE.md**
   - CLAUDE.md = static team rules
   - MEMORY.md = dynamic learnings
   - No duplication between them

---

### 12. Agent Isolation (Subagents Don't Pollute Main Context)

**Problem:** When you spawn a research agent to explore 100 files, all that content pollutes your main context window.

**Solution:** Use subagents. They run with their own context, and only the final summary returns to you.

**How Subagents Work:**

```
Main Agent (your session)
└─ spawn("research-agent")
   ├─ Own context window: 200K
   ├─ Reads 50 files: all stays isolated
   ├─ Tool calls: intermediate results hidden
   ├─ Generates summary
   └─ Returns to main agent: "Found X patterns, Y issues, Z opportunities"

Main Agent (your session) gets only the summary
└─ Can continue with 195K of context still available
```

**Example: Codebase Audit**

```bash
# Instead of reading 100 files in main session
# Spawn a subagent with specific task

# In Claude prompt:
spawn("audit-agent")
task: "Audit src/api/ for security issues. Report findings as markdown."
tools: [Read, Grep]
context_budget: 150000
```

**Subagent Definition (agent-config.yaml):**

```yaml
subagents:
  - name: audit-agent
    description: Security audit specialist
    system_prompt: |
      You are a security auditor. Analyze code for vulnerabilities.
      Report findings in Markdown format.
    allowed_tools:
      - Read
      - Grep
    context_budget: 150000

  - name: test-coverage-agent
    description: Test analysis specialist
    system_prompt: |
      You are a test coverage expert. Analyze test files.
      Report coverage gaps and recommendations.
    allowed_tools:
      - Read
      - Bash  # for running test coverage
    context_budget: 100000

  - name: docs-generator
    description: Documentation specialist
    system_prompt: |
      You are a documentation expert. Generate API docs from code.
    allowed_tools:
      - Read
      - Write
    context_budget: 80000
```

**Usage Patterns:**

**Pattern 1: Parallel Research**
```bash
# Main agent spawns 3 research agents in parallel
audit-agent: Analyze security
performance-agent: Profile code for bottlenecks
style-agent: Check code style consistency

# Agents run in parallel
# Main context stays clean
# All return findings

# Main agent integrates findings
```

**Pattern 2: Isolated Exploration**
```bash
# Explore large unfamiliar codebase without polluting main context
spawn("explorer-agent")
task: "Map architecture of src/services/ folder"
return: structured summary (JSON)

# Main agent receives clean summary
# Can ask follow-up questions with full context available
```

**Token Budgeting with Subagents:**

```
Total Available: 1,000,000 tokens (1M window)

Main Session: 200,000 tokens
├─ Current work
├─ Conversation history
└─ Available for results

Subagent 1 (audit): 200,000 tokens
├─ Isolated from main
├─ Reads files freely
└─ Only summary returned

Subagent 2 (testing): 150,000 tokens
├─ Independent context
├─ Testing analysis
└─ Report returned

Remaining for growth: 450,000 tokens
```

**When to Use Subagents:**

| Scenario | Subagent | Benefit |
|----------|----------|---------|
| Audit 100+ files | audit-agent | Main context clean |
| Generate tests | test-agent | Isolated from code |
| Documentation | docs-agent | Independent generation |
| Performance analysis | perf-agent | Deep profiling |
| Large refactoring | refactor-agent | Handles complexity |

**API-Level Subagent Usage (SDK):**

```typescript
const result = await client.beta.messages.create({
  model: "claude-opus-4-6",
  max_tokens: 16000,
  messages: [{
    role: "user",
    content: "Analyze codebase security"
  }],

  // Spawn subagent for audit
  betas: ["interacting-with-claude-beta"],

  tools: [{
    type: "create_subagent",
    name: "audit-agent",
    description: "Security analysis",
    instructions: "Perform comprehensive security audit"
  }]
});
```

**Best Practices:**

1. **One Subagent Per Task**
   - Don't spawn too many (limits parallelism)
   - 2-3 parallel subagents = optimal
   - Each with clear, focused mission

2. **Budget Subagent Context**
   - Allocate based on expected file reads
   - Leave room for processing
   - Monitor actual usage

3. **Structured Returns**
   - Request JSON or Markdown output
   - Include sections for findings/recommendations
   - Make integration easy for main agent

4. **Error Handling**
   - Subagents can fail independently
   - Main session unaffected
   - Can retry specific subagent

---

## Part 3: The Context Engineering Formula

### Token Budget Allocation

**Research Finding:** Optimal context utilization is 60-80% of available tokens.

**Formula:**

```
Context Utilization = (Used Tokens / Available Tokens) × 100

Optimal Range: 60-80%
Below 60% = Over-provisioning (wastes budget, dilutes signal)
Above 80% = Risk of hitting limits (triggers auto-compaction)

Example (200K window):
- 120K-160K tokens = optimal range
- <120K = unused budget
- >160K = approaching auto-compaction threshold
```

**Token Budget Allocation Table:**

| Category | Allocation | Example (200K) | Purpose |
|----------|-----------|----------------|---------|
| **System** | 10-15% | 20-30K | Safety, behavior, guardrails |
| **Tool Context** | 15-20% | 30-40K | Tool descriptions + examples |
| **Knowledge** | 30-40% | 60-80K | Code, docs, context (dynamic) |
| **Conversation** | 30-45% | 60-90K | Messages + history |
| **Buffer** | 5-10% | 10-20K | Reserve for new responses |

**Real-World Allocation (200K Window):**

```
System Prompt + Safety:        15,000 (7.5%)
├─ Core instructions
├─ Guidelines
└─ Constraints

CLAUDE.md + MEMORY:            20,000 (10%)
├─ Project conventions
└─ Learnings

Tool Descriptions:             15,000 (7.5%)
├─ Available tools
├─ Parameters
└─ Examples

Active Task Context:           80,000 (40%)
├─ Current files
├─ Related code
├─ Test cases
└─ Examples

Conversation History:          50,000 (25%)
├─ Messages
├─ Reasoning
└─ Earlier context

Reserve Buffer:                20,000 (10%)
└─ For Claude's response generation
```

**Token Budget by Task Type:**

| Task | Context Needs | Allocation | Tools |
|------|---------------|-----------|----|
| Code Review | Full repo context + specific PR | 30-40K | Greptile + Repomix |
| Bug Fix | File + related code + logs | 20-30K | tree-sitter for AST context |
| Feature Design | Architecture + patterns + examples | 40-50K | Cody for code graph |
| Documentation | Code + comments + examples | 30-40K | Repomix for full context |
| Large Refactor | Entire related module | 60-80K | ast-grep for find-all |

### Pre-Flight Context Checklist

**Before asking Claude for help, verify:**

- [ ] **Is the context focused?**
  - Only include files Claude will modify/reference
  - Exclude unrelated code, tests, dependencies
  - Remove commented-out code

- [ ] **Is it structured?**
  - Use tables for conventions (not prose)
  - Group related items
  - Clear sections with headers

- [ ] **Is it up-to-date?**
  - Latest file versions (no stale copies)
  - Current API signatures
  - Recent decisions (not 6-month-old notes)

- [ ] **Is it minimal?**
  - CLAUDE.md <150 lines
  - MEMORY.md <200 lines
  - Only "need to know" information

- [ ] **Are dependencies clear?**
  - "This endpoint calls X, which requires Y"
  - "This component uses the Z context"
  - Show the causal chain

- [ ] **Are patterns documented?**
  - "We always validate with Zod"
  - "Errors follow this structure"
  - "Tests go in __tests__ folder"

- [ ] **Token budget respected?**
  - Files total <80% of window
  - CLAUDE.md + MEMORY <2K
  - Leave 30K for conversation/response

### What Information Claude Actually Needs

**Essential (Always Include):**
1. **What Claude will modify** – Give complete files
2. **How it fits together** – Dependency chains
3. **Enforcement rules** – "Must use Zod for validation"
4. **Failure modes** – "Breaking change if..."
5. **Success criteria** – Clear acceptance criteria

**Important (Usually Include):**
6. **Related examples** – Existing implementations
7. **Anti-patterns** – "Don't do this"
8. **Naming conventions** – Consistent naming
9. **Testing expectations** – "Must have test coverage"
10. **Architecture decisions** – Why things are structured this way

**Nice to Have (Optional):**
11. **Historical context** – Why decisions were made
12. **Future plans** – Upcoming refactors
13. **Performance notes** – Known bottlenecks
14. **Team preferences** – Style quirks
15. **Tools and workflows** – Build systems, CI/CD

**Do Not Include (Wastes Tokens):**
- Unrelated modules
- Full test output (summaries only)
- Package contents (just versions)
- Repeated documentation
- Large binary files or images (unless essential)

### Context Problem Taxonomy

**Problem 1: Hallucinated Code**
- Symptom: Claude suggests APIs that don't exist
- Root cause: Stale training data or missing examples
- Solution: Use Context7 MCP + actual code examples

**Problem 2: Wrong Patterns**
- Symptom: Claude doesn't follow team conventions
- Root cause: Conventions not documented
- Solution: Add to CLAUDE.md with examples

**Problem 3: Large Codebase Blindness**
- Symptom: Claude misses related code elsewhere
- Root cause: Only given current file
- Solution: Use Greptile to find related code

**Problem 4: Context Bloat**
- Symptom: Slow responses, wrong focus
- Root cause: Too much irrelevant context loaded
- Solution: Use Skills + Rules for selective loading

**Problem 5: Forgotten Context**
- Symptom: Different answers in new session
- Root cause: Context not persisted
- Solution: Update MEMORY.md automatically

**Problem 6: Decision Amnesia**
- Symptom: Claude overwrites earlier decisions
- Root cause: Earlier context not available
- Solution: Use `/compact` with focus to preserve decisions

---

## Recommended Tool Combinations

### For Small Projects (< 50K LOC)
```
Primary: CLAUDE.md (optimized) + MEMORY.md
Optional: 2-3 Skills for major workflows
Cost: 2K-3K tokens
```

### For Medium Projects (50K-500K LOC)
```
Primary: Repomix (weekly snapshots) + CLAUDE.md
Secondary: Greptile for semantic search
Tertiary: Skills + Rules for isolation
Cost: 5K-10K tokens base + dynamic queries
```

### For Large Projects (500K+ LOC)
```
Primary: Repomix (intelligent compression) + Greptile
Secondary: Sourcegraph Cody for code intelligence
Tertiary: ast-grep for structural queries
Advanced: Subagents for parallel research
Cost: 10K-20K tokens base + indexed queries
```

### For Library Development
```
Primary: Context7 MCP (keep docs fresh)
Secondary: ast-grep (enforce breaking changes)
Tertiary: CLAUDE.md + Rules
Cost: Minimal (context7 on-demand)
```

---

## Practical Example: Complete Context Setup

**Project:** Next.js SaaS app, 200K LOC, 15 developers

**Setup:**

```bash
# 1. Create optimized CLAUDE.md (150 lines)
# 2. Create modular rules (.claude/rules/)
# 3. Set up skills (.claude/skills/)
# 4. Initialize Repomix
repomix --init

# 5. Create MEMORY.md structure
mkdir -p .claude/memory
touch .claude/memory/MEMORY.md

# 6. Optional: Set up Greptile
greptile init
```

**CLAUDE.md (optimized):**

```markdown
# Next.js SaaS

**Stack:** Next.js 15 + React 19 + PostgreSQL + Prisma

## Commands
| Cmd | Action |
|-----|--------|
| npm run dev | Start localhost:3000 |
| npm run build | Build for prod |
| npm test | Vitest (watch) |

## Patterns
| What | How |
|------|-----|
| API routes | app/api/[route]/route.ts |
| Validation | Zod schemas |
| Errors | { error: string, code?: string } |
| Tests | __tests__/ folder, .test.ts suffix |

## DO NOT
- ❌ Modify schema manually (use migrations)
- ❌ Import from app/ in lib/
- ❌ Use getStaticProps/getServerSideProps
- ❌ No next/router (use next/navigation)

@import .claude/rules/typescript.md
@import .claude/rules/next.md
@import .claude/rules/testing.md
```

**.claude/rules/next.md:**

```yaml
---
paths:
  - "src/app/**"
description: Next.js App Router patterns
---

# Next.js 15 App Router

## Server Components by Default

All components are Server Components unless marked with `'use client'`.

## Dynamic Routes

```typescript
export default function Page({ params }: { params: { id: string } }) {
  return <div>{params.id}</div>
}
```
```

**.claude/skills/testing-skill/SKILL.md:**

```yaml
---
name: testing
description: Unit and integration testing
allowed-tools: [Read, Write, Bash]
---

# Testing Skill

## Commands

- `npm test` – Run all tests
- `npm test -- --ui` – Interactive UI
- `npm test -- src/api` – Single module

## File Structure

Tests go in `__tests__/` or alongside code (*.test.ts).

## Pattern: API Test

```typescript
describe('POST /api/users', () => {
  it('creates user with valid data', async () => {
    const res = await POST(request)
    expect(res.status).toBe(201)
  })
})
```
```

**MEMORY.md:**

```markdown
# Project Memory

## Setup
- **Dev**: npm run dev (3000)
- **DB**: PostgreSQL on 5432
- **Migrations**: npm run migrate

## Known Issues
- Image optimization: Always use next/image
- ISR: Cache 1 hour for static pages
- Database: Connection pool max 5

## Architecture
- API routes in app/api/
- Components in app/components/
- Utils in lib/
- No external state management (React Context only)

## Team Patterns
- Commit format: [feature|fix] description
- PR: Tests + docs + 1 approval
```

**Session Start (0 tokens wasted):**

1. CLAUDE.md loads (1.5K tokens)
2. Rules auto-load if editing .ts/.tsx files (1K tokens)
3. Skills available but not loaded (0 tokens)
4. MEMORY.md first 200 lines loaded (1K tokens)
5. **Total base: 3.5K tokens** (reserve 196.5K for task)

**When user asks "Build user registration":**

1. Greptile searches: "Show existing auth patterns" (semantic)
2. Gets relevant code (5K tokens of actual patterns)
3. User provides specific requirements (2K tokens)
4. Claude has 188.5K tokens remaining for implementation
5. No wasted context, perfect precision

---

## Summary: Tool Selection Decision Tree

```
START: "I need context for AI coding"

Q1: Is the codebase constantly evolving libraries (Next.js 15, React 19)?
├─ YES → Use Context7 MCP (live docs)
└─ NO → Continue

Q2: Do you need semantic code search (find implementations, not grep)?
├─ YES → Use Greptile
└─ NO → Continue

Q3: Is your repo large (200K+ LOC) and you need full context?
├─ YES → Use Repomix (intelligent compression)
└─ NO → Continue

Q4: Do you need structural transformations (refactor patterns)?
├─ YES → Use ast-grep
└─ NO → Continue

Q5: Working with monorepo or need deep code intelligence?
├─ YES → Use Sourcegraph Cody
└─ NO → Continue

Q6: Are you optimizing token budget in Claude Code?
├─ YES → Use CLAUDE.md (optimized) + Skills + Rules + MEMORY
├─ YES & large codebase → Add subagents for isolation
└─ Done

RESULT: Optimized context stack matched to your project
```

---

## References & Resources

- [Context7 MCP](https://context7mcp.com/)
- [Greptile](https://www.greptile.com/)
- [tree-sitter](https://tree-sitter.github.io/)
- [ast-grep](https://ast-grep.github.io/)
- [Sourcegraph Cody](https://sourcegraph.com/docs/cody)
- [Repomix](https://repomix.com/)
- [Claude API Documentation](https://platform.claude.com/docs)
- [Claude Code Documentation](https://code.claude.com/docs)

---

**Last Updated:** March 14, 2026
**Status:** Production-Ready
**Maintained By:** Claude Code Community
