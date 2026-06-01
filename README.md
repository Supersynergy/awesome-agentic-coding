# Awesome Agentic Coding — Best Practices & 1-Click Setup

> **Turn Claude Code into a failsafe, token-efficient, one-shot coding machine.**
> Production-tested patterns from Anthropic, Manus, Devin, and 100+ real-world projects.
> Updated March 2026 with latest breakthroughs from 10-agent parallel research.

[![Claude Code](https://img.shields.io/badge/Claude_Code-2.1+-blueviolet)](https://claude.ai/code)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## Why This Exists

Most developers use Claude Code at **20% of its potential**. The top 1% know:

- **Scaffold > Model** — SWE-bench proves: changing the scaffold changes scores 22%. Changing the model changes them 1.3%. ([Source](https://www.morphllm.com/best-ai-model-for-coding))
- **Context > Prompts** — For every 1 output token, 166 input tokens are read. 10% context reduction saves more than eliminating all output. ([Source](https://dev.to/myougatheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c))
- **Hooks > Instructions** — CLAUDE.md rules can be "forgotten." Shell hooks execute deterministically, always.
- **TDD + Agents = Gold** — Anthropic officially endorsed Red/Green TDD as the agentic coding pattern. ([Source](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/))
- **65% is the real limit** — Context quality degrades suddenly (not gradually) past 65% capacity. Plan for 650K in a 1M window. ([Source](https://research.trychroma.com/context-rot))

This repo gives you everything in a single `bash setup.sh`.

---

## 1-Click Setup

### Option A: Just paste this into Claude Code (easiest)
```
https://github.com/Supersynergy/awesome-agentic-coding — clone this, run setup.sh, confirm what's installed.
```
That's it. Claude clones the repo, runs the installer, and shows you what was set up.

### Option B: Manual
```bash
git clone https://github.com/Supersynergy/awesome-agentic-coding.git ~/awesome-agentic-coding
cd ~/awesome-agentic-coding && bash setup.sh
```

### Option C: Full auto-setup + project optimization
```
Clone https://github.com/Supersynergy/awesome-agentic-coding and run bash setup.sh — then detect this project's stack, create an optimized CLAUDE.md, add path-specific rules, run tests, and show me what's available.
```

**What it installs:** 5 hooks, 10 skills, 3 agents, 3 rules, optimized settings.json, CLAUDE.md template.
**What it preserves:** Your existing config (backup + merge, never overwrite).

> See [`ONESHOT_SETUP_PROMPT.md`](ONESHOT_SETUP_PROMPT.md) for all 4 setup variants including a zero-clone option.

---

## The Architecture

```
                    YOU
                     |
              "Plan this. Don't code."
                     |
                     v
            ┌────────────────┐
            │  ORCHESTRATOR  │  Opus/Sonnet — plans only, never codes
            └───────┬────────┘
                    │ spawns parallel
        ┌───────────┼───────────────┐
        v           v               v
   [Researcher]  [Coder]      [Reviewer]
    Haiku         Sonnet        Haiku
    Read-only     Edit+Bash     Read-only
    $0.02/task    $0.15/task    $0.03/task
        |           |               |
        └───────────┼───────────────┘
                    v
          ┌──────────────────┐
          │   QUALITY GATES  │  <-- Hooks (deterministic, can't bypass)
          │ TDD | Lint | Secrets │
          └──────────────────┘
                    v
              Production Code
```

**Evidence:** Orchestrator + Specialists beats single-agent by **90.2%** ([Anthropic](https://www.anthropic.com/engineering/multi-agent-research-system)). Scaffold matters **22x more** than model choice ([SWE-bench](https://www.morphllm.com/best-ai-model-for-coding)).

---

## 10 Breakthroughs That Changed Everything (March 2026)

| # | Breakthrough | Impact | Source |
|---|-------------|--------|--------|
| 1 | **Scaffold > Model** | Models within 1.3pts on SWE-bench. Scaffold = 22pt difference | [Morph LLM](https://www.morphllm.com/best-ai-model-for-coding) |
| 2 | **65% context limit** | Quality collapses suddenly past 65%, not gradually at 95% | [Chroma Research](https://research.trychroma.com/context-rot) |
| 3 | **Prompt caching GA** | 90% savings on cached reads, automatic since Feb 2026 | [Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) |
| 4 | **Tool Search** | 46.9% MCP token reduction via deferred tool loading | [Medium](https://medium.com/@joe.njenga/claude-code-just-cut-mcp-context-bloat-by-46-9) |
| 5 | **TDD + Agents** | Red/Green TDD officially endorsed by Anthropic | [Simon Willison](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/) |
| 6 | **1:166 ratio** | Every 1 output token costs 166 input tokens of context reads | [Dev.to](https://dev.to/myougatheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c) |
| 7 | **Memory tiering** | Letta/Mem0 = 26% accuracy gain, 90% token reduction | [Mem0](https://www.mem0.ai/) |
| 8 | **Batch API** | 50% discount on all tokens for async processing | [Anthropic](https://platform.claude.com/docs/en/build-with-claude/batch-processing) |
| 9 | **Self-healing CI** | Standardized pattern: failures trigger repair agents | [Medium](https://medium.com/@jagannathsarkar/i-built-a-self-healing-ai-coding-agent) |
| 10 | **Inference cost 1000x drop** | $20/MTok (2022) to $0.40/MTok (2026) | [Introl](https://introl.com/blog/inference-unit-economics-true-cost-per-million-tokens-guide) |
| 11 | **`/btw` command** | Side questions at ~0 marginal cost (reuses parent cache) | [Claude Code Docs](https://code.claude.com/docs/en/changelog) |
| 12 | **`opusplan` alias** | Opus planning + Sonnet execution = 40% cheaper | [Claude Code Docs](https://code.claude.com/docs/en/changelog) |
| 13 | **PreToolUse input modification** | Hooks can now modify tool inputs, not just block | [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide) |
| 14 | **Memory timestamps** | Stale memories (>7 days) now flagged by `/context` | [Claude Code Changelog](https://code.claude.com/docs/en/changelog) |

---

## What's Inside

### `/hooks/` — Deterministic Quality Gates
| Hook | Event | What It Does |
|------|-------|-------------|
| `quality-gate.sh` | Stop | Auto-detects project type, runs tests before Claude "finishes" |
| `secret-guard.sh` | PreToolUse | Blocks writes to `.env`, `.pem`, credentials, warns on API keys in content |
| `context-inject.sh` | SessionStart | Injects git branch, recent commits, project type detection |
| `protect-prod.sh` | PreToolUse | Blocks edits to production configs |
| `syntax-check.sh` | PostToolUse | Validates Python/JSON/YAML syntax after every edit |

### `/skills/` — On-Demand Workflows (0 tokens when unused)
| Skill | Description |
|-------|-------------|
| `/oneshot <task>` | Context-primed 1-shot coding (4-phase protocol) |
| `/review [target]` | Multi-agent code review (3 parallel Haiku reviewers) |
| `/debug <bug>` | Scientific debugging with hypothesis testing |
| `/refactor <target>` | Safe refactoring with test verification at each step |
| `/plan <feature>` | Create implementation plan before coding (research → plan → review) |
| `/test <target>` | Auto-detect framework, write tests following TDD principles |
| `/commit` | Smart commit with auto-generated message from staged changes |
| `/github <cmd>` | GitHub via `gh` CLI — **replaces GitHub MCP** (saves 55K tokens) |
| `/docs <library>` | Fetch live docs via WebFetch — **replaces Context7 MCP** (saves 5-8K tokens) |
| `/db <query>` | Database via CLI — **replaces Postgres/SurrealDB MCP** (saves 3-8K tokens) |
| `/search-code <what>` | Deep codebase search with parallel agents |

### `/agents/` — Specialized Subagents
| Agent | Model | Tools | Cost/Task |
|-------|-------|-------|-----------|
| `researcher` | Haiku | Read, Grep, Glob | $0.02 |
| `reviewer` | Haiku | Read, Grep, Glob, Bash | $0.03 |
| `architect` | Sonnet | Read, Grep, Glob | $0.10 |

### `/rules/` — Path-Specific (load only when relevant)
| Rule | Paths | Focus |
|------|-------|-------|
| `security.md` | `**/*` | OWASP Top 10, input validation, no hardcoded secrets |
| `api.md` | `src/api/**`, `routes/**` | Validation, error format, pagination, rate limiting |
| `tests.md` | `**/*test*`, `**/*spec*` | Behavior testing, independence, happy + error paths |

### `/docs/` — Deep Dives (9 Guides)
| Guide | What You'll Learn |
|-------|------------------|
| `CONTEXT_ENGINEERING.md` | The 6 principles + annotation cycle (90% quality improvement) |
| `CONTEXT_TOOLS.md` | Context7 MCP, Greptile, Repomix, 1M window strategies |
| `TOKEN_ECONOMICS.md` | Cost per task, 7 optimization levers, batch API, prompt caching |
| `PATTERNS.md` | Architecture patterns ranked (Orchestrator: 59/70, Blackboard: 41/70) |
| `TOP_50_TOOLS.md` | Top 50 dev tools for 2026, ranked by impact |
| `NATS_GUIDE.md` | NATS.io for AI agents: pub/sub, JetStream, KV, code examples |
| `DATABASES.md` | SurrealDB, Turso, EdgeDB, Dragonfly comparisons |
| `UI_AND_CRUD.md` | shadcn alternatives, Server Actions, tRPC, optimistic updates |
| `ZERO_MCP.md` | **Zero-MCP workflow: 97% token savings** — replace every MCP with CLI + skills |
| `WHY.md` | Evidence and sources behind every decision |

### `/best-practices/` — Quick-Reference Cheatsheets
| Guide | What's Inside |
|-------|--------------|
| `CRUD_CHEATSHEET.md` | Every CRUD pattern: Server Actions, tRPC, SurrealDB, Hono REST, NATS events |
| `AGENT_PATTERNS.md` | 5 agent architectures, model routing, Claude Code agent best practices |
| `MODERN_STACK.md` | 6 stack recipes: SaaS, AI agents, real-time, e-commerce, API-first, admin |

### `ONESHOT_SETUP_PROMPT.md` — The Ultimate Setup Prompt
Copy-paste into Claude Code. 3 variants: full (clone + install), quick (no clone), project-specific.

### `validate.sh` — Installation Validator
Run `bash validate.sh` to check all hooks, skills, agents, settings are properly installed.

### `/examples/`
| File | Purpose |
|------|---------|
| `CLAUDE.md.template` | Optimized starter (copy, customize, ship) |
| `settings.json.optimal` | Full settings with 30+ pre-approved commands |
| `oneshot-prompts.md` | 10 proven one-shot prompt templates + meta-prompt |
| `mcp-config.json` | MCP server configs: Context7, GitHub, Postgres, SurrealDB |
| `agent-team.md` | Agent Teams examples: full-stack, debugging, multi-service |
| `nats-surrealdb-starter.md` | Event-sourced CRUD with NATS + SurrealDB + Hono in 50 lines |

---

## The One-Shot Formula

> "Getting to 80% is fast. Getting to 95%+ takes discipline." — Addy Osmani

### Why One-Shot Works (When It Works)
The secret isn't the prompt. It's the **context scaffold**:

```
1. CLAUDE.md loaded          → Claude knows your patterns
2. Rules auto-applied        → Security, API, test standards enforced
3. Context injection hook    → Git state, project type detected
4. /oneshot "add X"          → 4-phase protocol: gather → plan → implement → verify
5. Quality gate hook         → Tests run before "done"
```

### The Annotation Cycle (for complex tasks)
```
You:    "Plan this feature. Don't code."
Claude: Returns plan.md
You:    Add inline notes → "@claude: use Zod here", "@claude: skip auth for MVP"
You:    "Address all notes. Still don't code."
Claude: Refined plan with 0 ambiguity
You:    "Implement."
Claude: Done in 1-2 turns. Every decision pre-made.
```

**Why:** 90% of iterations come from ambiguity, not capability.

---

## Context Engineering: The 10x Multiplier

### The Numbers That Matter

| Metric | Value | Implication |
|--------|-------|------------|
| Context read ratio | 1:166 | 10% context reduction > eliminating all output |
| Degradation threshold | 65% | Quality collapses suddenly past this point |
| CLAUDE.md adherence | 95% under 200 lines, 40% over 500 | Keep it lean |
| Cache savings | 90% | Cached reads cost $0.30/MTok vs $3.00/MTok |
| Lost-in-middle | Still unsolved | Critical info at start or end, never middle |

### The 8 Principles

1. **Scaffold > Model** — Invest in your agent architecture, not model shopping
2. **Cache-friendly prompts** — Stable prefixes, no timestamps in system prompts
3. **Append-only context** — Never mutate; let model learn from failures in-context
4. **Preserve errors** — Wrong turns teach self-correction better than instructions
5. **External memory** — Large docs on filesystem, referenced by path (not embedded)
6. **Progressive disclosure** — Teach Claude *how to find* info, not dump everything
7. **Pointers over copies** — `file:line` references, not pasted code that goes stale
8. **Compact at 65%** — Don't wait for 95% auto-compact. Quality is already degraded.

---

## Token Economics (March 2026)

### Per-Task Costs
| Task | Model | Cost |
|------|-------|------|
| Simple edit | Sonnet | $0.05 |
| Standard feature | Sonnet | $0.15 |
| Complex architecture | Opus | $0.50 |
| Codebase exploration | Haiku subagent | $0.02 |
| Code review | Haiku subagent | $0.03 |
| Batch refactoring (50% off) | Batch API | $0.08/file |

### 8 Optimization Levers
| Lever | Savings | How |
|-------|---------|-----|
| Model routing | **5x** on exploration | Haiku for read-only, Sonnet for code |
| Permission allowlists | **500-1000 tok/session** | Pre-approve safe commands |
| CLAUDE.md < 200 lines | **~1000 tok/session** | Details → skills + topic files |
| Skills (on-demand) | **0 tokens when unused** | Load only on `/invoke` |
| Prompt caching | **90% on repeats** | Automatic since Feb 2026 |
| Tool Search | **46.9% MCP reduction** | Deferred tool loading |
| `/compact` at 65% | **Prevents quality collapse** | Not 80%, not 95% — 65% |
| Batch API | **50% off** | Async processing for bulk ops |

**Optimized: ~$0.40/session. Unoptimized: ~$2.50/session. Savings: 84%.**

---

## The Failsafe Stack (6 Layers)

```
Layer 1: CLAUDE.md + Rules    → Persistent rules (always loaded, <200 lines)
Layer 2: Skills               → On-demand workflows (0 tokens when unused)
Layer 3: Hooks                → Deterministic guards (CANNOT be bypassed)
Layer 4: Subagents            → Isolated specialists (failures don't crash main)
Layer 5: Memory + TDD         → Cross-session learning + test-driven verification
Layer 6: Checkpoints          → /resume, /rewind, session persistence
```

**Only Layer 3 is deterministic.** Everything else relies on LLM compliance. For anything that MUST happen (tests, security), use hooks.

---

## Quick Reference

```bash
# Context management (the #1 lever)
/clear              # Reset between unrelated tasks
/compact focus on X # Manual compact at 65% (not 95%)
/context            # Token breakdown — find waste
/btw question       # Side question (0 history pollution)

# Effort routing
/effort low         # Simple edits ($0.05)
/effort medium      # Standard tasks ($0.15) [default]
/effort high        # Complex reasoning ($0.50)

# Skills (this repo)
/oneshot task       # 1-shot with 4-phase protocol
/review             # Multi-agent code review
/debug issue        # Scientific debugging
/refactor target    # Safe refactoring with tests

# Session management
/resume name        # Continue named session
/rewind             # Roll back to earlier state
/loop 5m prompt     # Repeat prompt on interval
```

---

## TDD: The Non-Negotiable Pattern

Anthropic's official recommendation ([Agentic Coding Trends Report 2026](https://resources.anthropic.com/hubfs/2026%20Agentic%20Coding%20Trends%20Report.pdf)):

```
1. Write failing test first (Red)
2. Ask Claude to make it pass (Green)
3. Review + refactor
4. Repeat
```

**Why:** Without TDD, agents can "cheat" — writing tests that confirm broken behavior. TDD defines correctness *before* implementation. The test is the spec.

---

## Sources & Evidence

| Source | Key Insight |
|--------|------------|
| [Anthropic: Multi-Agent Research](https://www.anthropic.com/engineering/multi-agent-research-system) | Orchestrator + Specialists = 90.2% improvement |
| [Morph LLM: SWE-bench Analysis](https://www.morphllm.com/best-ai-model-for-coding) | Scaffold matters 22x more than model choice |
| [Chroma: Context Rot Research](https://research.trychroma.com/context-rot) | Quality degrades suddenly at 65%, not gradually |
| [Manus: Context Engineering](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus) | KV-cache hit rate is the #1 cost metric |
| [Anthropic: Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) | Context > Prompt crafting |
| [Anthropic: Agentic Coding Trends](https://resources.anthropic.com/hubfs/2026%20Agentic%20Coding%20Trends%20Report.pdf) | TDD officially endorsed for agents |
| [Simon Willison: Red/Green TDD](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/) | TDD + agents = the golden pattern |
| [Addy Osmani: The 80% Problem](https://addyo.substack.com/p/the-80-problem-in-agentic-coding) | 80% is fast; 95%+ needs discipline |
| [Dev.to: 70% Token Cost Reduction](https://dev.to/myougattheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c) | 1:166 input/output ratio |
| [MCP Tool Search](https://medium.com/@joe.njenga/claude-code-just-cut-mcp-context-bloat-by-46-9) | 46.9% token reduction via deferred loading |
| [Claude Code Docs: Best Practices](https://code.claude.com/docs/en/best-practices) | CLAUDE.md < 200 lines = 95% adherence |
| [Claude Code Docs: Hooks](https://code.claude.com/docs/en/hooks-guide.md) | Deterministic enforcement > LLM instructions |
| [Anthropic: Prompt Caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching) | 90% savings on cached reads |
| [Anthropic: Batch API](https://platform.claude.com/docs/en/build-with-claude/batch-processing) | 50% off for async processing |
| [Azure: AI Agent Patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns) | Orchestrator pattern dominates production |

---

## Related Awesome Lists

- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — Skills, hooks, agents, applications
- [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) — 100+ subagents
- [awesome-claude-md](https://github.com/josix/awesome-claude-md) — Exemplary CLAUDE.md files
- [awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules) — 500+ Cursor rules
- [claude-code-ultimate-guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide) — Comprehensive guide
- [agentic-coding-handbook](https://tweag.github.io/agentic-coding-handbook/) — Tweag's handbook
- [agent-flywheel](https://agent-flywheel.com) — The agentic coding flywheel concept

---

## Contributing

PRs welcome! Include evidence (benchmark, source, or production experience) with every claim.

## License

MIT — Use it, fork it, make it yours.

---

**Built by [@Supersynergy](https://github.com/Supersynergy)** | Powered by Claude Code | Research by 10 parallel Haiku agents
