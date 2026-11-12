# Awesome Agentic Coding: Best Practices & 1-Click Setup

![Awesome Agentic Coding](assets/cover.png)

**🧭 Explore:** [Setup](#1-click-setup) · [Architecture](#the-architecture) · [What’s inside](#whats-inside) · [Quick reference](#quick-reference) · [Sources](#sources--evidence)

> **Turn Claude Code into a failsafe, token-efficient, one-shot coding machine.**
> Production-tested patterns from Anthropic, Manus, Devin, and 100+ real-world projects.
> Curated March 2026. Links and repository status re-checked on 31 July 2026.

[![Claude Code](https://img.shields.io/badge/Claude_Code-2.1+-blueviolet)](https://claude.ai/code)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## Why This Exists

What most setups leave on the table:

- Scaffold > Model, SWE-bench proves: changing the scaffold changes scores 22%. Changing the model changes them 1.3%. ([Source](https://www.morphllm.com/best-ai-model-for-coding))
- Context > Prompts, For every 1 output token, 166 input tokens are read. 10% context reduction saves more than eliminating all output. ([Source](https://dev.to/myougatheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c))
- Hooks > Instructions, CLAUDE.md rules can be "forgotten." Shell hooks execute deterministically, always.
- TDD + Agents = Gold, Anthropic officially endorsed Red/Green TDD as the agentic coding pattern. ([Source](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/))
- 65% is the real limit, Context quality degrades suddenly (not gradually) past 65% capacity. Plan for 650K in a 1M window. ([Source](https://research.trychroma.com/context-rot))

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

<details>
<summary><strong>📋 Show 14 entries</strong></summary>

- **Scaffold > Model**<br>
  #: 1<br>
  Impact: Models within 1.3pts on SWE-bench. Scaffold = 22pt difference<br>
  Source: [Morph LLM](https://www.morphllm.com/best-ai-model-for-coding)

- **65% context limit**<br>
  #: 2<br>
  Impact: Quality collapses suddenly past 65%, not gradually at 95%<br>
  Source: [Chroma Research](https://research.trychroma.com/context-rot)

- **Prompt caching GA**<br>
  #: 3<br>
  Impact: 90% savings on cached reads, automatic since Feb 2026<br>
  Source: [Anthropic](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)

- **Tool Search**<br>
  #: 4<br>
  Impact: 46.9% MCP token reduction via deferred tool loading<br>
  Source: [Medium](https://medium.com/@joe.njenga/claude-code-just-cut-mcp-context-bloat-by-46-9)

- **TDD + Agents**<br>
  #: 5<br>
  Impact: Red/Green TDD officially endorsed by Anthropic<br>
  Source: [Simon Willison](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/)

- **1:166 ratio**<br>
  #: 6<br>
  Impact: Every 1 output token costs 166 input tokens of context reads<br>
  Source: [Dev.to](https://dev.to/myougatheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c)

- **Memory tiering**<br>
  #: 7<br>
  Impact: Letta/Mem0 = 26% accuracy gain, 90% token reduction<br>
  Source: [Mem0](https://www.mem0.ai/)

- **Batch API**<br>
  #: 8<br>
  Impact: 50% discount on all tokens for async processing<br>
  Source: [Anthropic](https://platform.claude.com/docs/en/build-with-claude/batch-processing)

- **Self-healing CI**<br>
  #: 9<br>
  Impact: Standardized pattern: failures trigger repair agents<br>
  Source: [Medium](https://medium.com/@jagannathsarkar/i-built-a-self-healing-ai-coding-agent)

- **Inference cost 1000x drop**<br>
  #: 10<br>
  Impact: $20/MTok (2022) to $0.40/MTok (2026)<br>
  Source: [Introl](https://introl.com/blog/inference-unit-economics-true-cost-per-million-tokens-guide)

- **`/btw` command**<br>
  #: 11<br>
  Impact: Side questions at ~0 marginal cost (reuses parent cache)<br>
  Source: [Claude Code Docs](https://code.claude.com/docs/en/changelog)

- **`opusplan` alias**<br>
  #: 12<br>
  Impact: Opus planning + Sonnet execution = 40% cheaper<br>
  Source: [Claude Code Docs](https://code.claude.com/docs/en/changelog)

- **PreToolUse input modification**<br>
  #: 13<br>
  Impact: Hooks can now modify tool inputs, not just block<br>
  Source: [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide)

- **Memory timestamps**<br>
  #: 14<br>
  Impact: Stale memories (>7 days) now flagged by `/context`<br>
  Source: [Claude Code Changelog](https://code.claude.com/docs/en/changelog)

</details>


---

## What's Inside

### `/hooks/`: Deterministic Quality Gates
<details>
<summary><strong>📋 Show 5 entries</strong></summary>

- **`quality-gate.sh`**<br>
  Event: Stop<br>
  What It Does: Auto-detects project type, runs tests before Claude "finishes"

- **`secret-guard.sh`**<br>
  Event: PreToolUse<br>
  What It Does: Blocks writes to `.env`, `.pem`, credentials, warns on API keys in content

- **`context-inject.sh`**<br>
  Event: SessionStart<br>
  What It Does: Injects git branch, recent commits, project type detection

- **`protect-prod.sh`**<br>
  Event: PreToolUse<br>
  What It Does: Blocks edits to production configs

- **`syntax-check.sh`**<br>
  Event: PostToolUse<br>
  What It Does: Validates Python/JSON/YAML syntax after every edit

</details>


### `/skills/`: On-Demand Workflows (0 tokens when unused)
<details>
<summary><strong>📋 Show 11 entries</strong></summary>

- **`/oneshot <task>`**<br>
  Description: Context-primed 1-shot coding (4-phase protocol)

- **`/review [target]`**<br>
  Description: Multi-agent code review (3 parallel Haiku reviewers)

- **`/debug <bug>`**<br>
  Description: Scientific debugging with hypothesis testing

- **`/refactor <target>`**<br>
  Description: Safe refactoring with test verification at each step

- **`/plan <feature>`**<br>
  Description: Create implementation plan before coding (research → plan → review)

- **`/test <target>`**<br>
  Description: Auto-detect framework, write tests following TDD principles

- **`/commit`**<br>
  Description: Smart commit with auto-generated message from staged changes

- **`/github <cmd>`**<br>
  Description: GitHub via `gh` CLI, **replaces GitHub MCP** (saves 55K tokens)

- **`/docs <library>`**<br>
  Description: Fetch live docs via WebFetch, **replaces Context7 MCP** (saves 5-8K tokens)

- **`/db <query>`**<br>
  Description: Database via CLI, **replaces Postgres/SurrealDB MCP** (saves 3-8K tokens)

- **`/search-code <what>`**<br>
  Description: Deep codebase search with parallel agents

</details>


### `/agents/`: Specialized Subagents
<details>
<summary><strong>📋 Show 3 entries</strong></summary>

- **`researcher`**<br>
  Model: Haiku<br>
  Tools: Read, Grep, Glob<br>
  Cost/Task: $0.02

- **`reviewer`**<br>
  Model: Haiku<br>
  Tools: Read, Grep, Glob, Bash<br>
  Cost/Task: $0.03

- **`architect`**<br>
  Model: Sonnet<br>
  Tools: Read, Grep, Glob<br>
  Cost/Task: $0.10

</details>


### `/rules/`: Path-Specific (load only when relevant)
<details>
<summary><strong>📋 Show 3 entries</strong></summary>

- **`security.md`**<br>
  Paths: `**/*`<br>
  Focus: OWASP Top 10, input validation, no hardcoded secrets

- **`api.md`**<br>
  Paths: `src/api/**`, `routes/**`<br>
  Focus: Validation, error format, pagination, rate limiting

- **`tests.md`**<br>
  Paths: `**/*test*`, `**/*spec*`<br>
  Focus: Behavior testing, independence, happy + error paths

</details>


### `/docs/`: Deep Dives (9 Guides)
<details>
<summary><strong>📋 Show 10 entries</strong></summary>

- **`CONTEXT_ENGINEERING.md`**<br>
  What You'll Learn: The 6 principles + annotation cycle (90% quality improvement)

- **`CONTEXT_TOOLS.md`**<br>
  What You'll Learn: Context7 MCP, Greptile, Repomix, 1M window strategies

- **`TOKEN_ECONOMICS.md`**<br>
  What You'll Learn: Cost per task, 7 optimization levers, batch API, prompt caching

- **`PATTERNS.md`**<br>
  What You'll Learn: Architecture patterns ranked (Orchestrator: 59/70, Blackboard: 41/70)

- **`TOP_50_TOOLS.md`**<br>
  What You'll Learn: Top 50 dev tools for 2026, ranked by impact

- **`NATS_GUIDE.md`**<br>
  What You'll Learn: NATS.io for AI agents: pub/sub, JetStream, KV, code examples

- **`DATABASES.md`**<br>
  What You'll Learn: SurrealDB, Turso, EdgeDB, Dragonfly comparisons

- **`UI_AND_CRUD.md`**<br>
  What You'll Learn: shadcn alternatives, Server Actions, tRPC, optimistic updates

- **`ZERO_MCP.md`**<br>
  What You'll Learn: **Zero-MCP workflow: 97% token savings**, replace every MCP with CLI + skills

- **`WHY.md`**<br>
  What You'll Learn: Evidence and sources behind every decision

</details>


### `/best-practices/`: Quick-Reference Cheatsheets
<details>
<summary><strong>📋 Show 3 entries</strong></summary>

- **`CRUD_CHEATSHEET.md`**<br>
  What's Inside: Every CRUD pattern: Server Actions, tRPC, SurrealDB, Hono REST, NATS events

- **`AGENT_PATTERNS.md`**<br>
  What's Inside: 5 agent architectures, model routing, Claude Code agent best practices

- **`MODERN_STACK.md`**<br>
  What's Inside: 6 stack recipes: SaaS, AI agents, real-time, e-commerce, API-first, admin

</details>


### `ONESHOT_SETUP_PROMPT.md`: The Ultimate Setup Prompt
Copy-paste into Claude Code. 3 variants: full (clone + install), quick (no clone), project-specific.

### `validate.sh`: Installation Validator
Run `bash validate.sh` to check all hooks, skills, agents, settings are properly installed.

### `/examples/`
<details>
<summary><strong>📋 Show 6 entries</strong></summary>

- **`CLAUDE.md.template`**<br>
  Purpose: Optimized starter (copy, customize, ship)

- **`settings.json.optimal`**<br>
  Purpose: Full settings with 30+ pre-approved commands

- **`oneshot-prompts.md`**<br>
  Purpose: 10 proven one-shot prompt templates + meta-prompt

- **`mcp-config.json`**<br>
  Purpose: MCP server configs: Context7, GitHub, Postgres, SurrealDB

- **`agent-team.md`**<br>
  Purpose: Agent Teams examples: full-stack, debugging, multi-service

- **`nats-surrealdb-starter.md`**<br>
  Purpose: Event-sourced CRUD with NATS + SurrealDB + Hono in 50 lines

</details>


---

## The One-Shot Formula

> "Getting to 80% is fast. Getting to 95%+ takes discipline.", Addy Osmani

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

<details>
<summary><strong>📋 Show 5 entries</strong></summary>

- **Context read ratio**<br>
  Value: 1:166<br>
  Implication: 10% context reduction > eliminating all output

- **Degradation threshold**<br>
  Value: 65%<br>
  Implication: Quality collapses suddenly past this point

- **CLAUDE.md adherence**<br>
  Value: 95% under 200 lines, 40% over 500<br>
  Implication: Keep it lean

- **Cache savings**<br>
  Value: 90%<br>
  Implication: Cached reads cost $0.30/MTok vs $3.00/MTok

- **Lost-in-middle**<br>
  Value: Still unsolved<br>
  Implication: Critical info at start or end, never middle

</details>


### The 8 Principles

1. **Scaffold > Model**, Invest in your agent architecture, not model shopping
2. **Cache-friendly prompts**, Stable prefixes, no timestamps in system prompts
3. **Append-only context**, Never mutate; let model learn from failures in-context
4. **Preserve errors**, Wrong turns teach self-correction better than instructions
5. **External memory**, Large docs on filesystem, referenced by path (not embedded)
6. **Progressive disclosure**, Teach Claude *how to find* info, not dump everything
7. **Pointers over copies**, `file:line` references, not pasted code that goes stale
8. **Compact at 65%**, Don't wait for 95% auto-compact. Quality is already degraded.

---

## Token Economics (March 2026)

### Per-Task Costs

Rough estimates from our own runs, not vendor figures. Your token counts decide the real number.

<details>
<summary><strong>📋 Show 6 entries</strong></summary>

- **Simple edit**<br>
  Model: Sonnet<br>
  Cost: $0.05

- **Standard feature**<br>
  Model: Sonnet<br>
  Cost: $0.15

- **Complex architecture**<br>
  Model: Opus<br>
  Cost: $0.50

- **Codebase exploration**<br>
  Model: Haiku subagent<br>
  Cost: $0.02

- **Code review**<br>
  Model: Haiku subagent<br>
  Cost: $0.03

- **Batch refactoring (50% off)**<br>
  Model: Batch API<br>
  Cost: $0.08/file

</details>


### 8 Optimization Levers
<details>
<summary><strong>📋 Show 8 entries</strong></summary>

- **Model routing**<br>
  Savings: **3x** on exploration<br>
  How: Haiku ($1/$5 per MTok) for read-only, Sonnet ($3/$15) for code

- **Permission allowlists**<br>
  Savings: **500-1000 tok/session**<br>
  How: Pre-approve safe commands

- **CLAUDE.md < 200 lines**<br>
  Savings: **~1000 tok/session**<br>
  How: Details → skills + topic files

- **Skills (on-demand)**<br>
  Savings: **body loads only when used**<br>
  How: The description stays in context; the body is read on invocation

- **Prompt caching**<br>
  Savings: **90% on repeats**<br>
  How: Automatic since Feb 2026

- **Tool Search**<br>
  Savings: **46.9% MCP reduction**<br>
  How: Deferred tool loading

- **`/compact` at 65%**<br>
  Savings: **Prevents quality collapse**<br>
  How: Not 80%, not 95%, 65%

- **Batch API**<br>
  Savings: **50% off**<br>
  How: Async processing for bulk ops

</details>


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

**Why:** Without TDD, agents can "cheat", writing tests that confirm broken behavior. TDD defines correctness *before* implementation. The test is the spec.

---

## Sources & Evidence

<details>
<summary><strong>📋 Show 15 entries</strong></summary>

- **[Anthropic: Multi-Agent Research](https://www.anthropic.com/engineering/multi-agent-research-system)**<br>
  Key Insight: Orchestrator + Specialists = 90.2% improvement

- **[Morph LLM: SWE-bench Analysis](https://www.morphllm.com/best-ai-model-for-coding)**<br>
  Key Insight: Scaffold matters 22x more than model choice

- **[Chroma: Context Rot Research](https://research.trychroma.com/context-rot)**<br>
  Key Insight: Quality degrades suddenly at 65%, not gradually

- **[Manus: Context Engineering](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)**<br>
  Key Insight: KV-cache hit rate is the #1 cost metric

- **[Anthropic: Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)**<br>
  Key Insight: Context > Prompt crafting

- **[Anthropic: Agentic Coding Trends](https://resources.anthropic.com/hubfs/2026%20Agentic%20Coding%20Trends%20Report.pdf)**<br>
  Key Insight: TDD officially endorsed for agents

- **[Simon Willison: Red/Green TDD](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/)**<br>
  Key Insight: TDD + agents = the golden pattern

- **[Addy Osmani: The 80% Problem](https://addyo.substack.com/p/the-80-problem-in-agentic-coding)**<br>
  Key Insight: 80% is fast; 95%+ needs discipline

- **[Dev.to: 70% Token Cost Reduction](https://dev.to/myougattheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c)**<br>
  Key Insight: 1:166 input/output ratio

- **[MCP Tool Search](https://medium.com/@joe.njenga/claude-code-just-cut-mcp-context-bloat-by-46-9)**<br>
  Key Insight: 46.9% token reduction via deferred loading

- **[Claude Code Docs: Best Practices](https://code.claude.com/docs/en/best-practices)**<br>
  Key Insight: CLAUDE.md < 200 lines = 95% adherence

- **[Claude Code Docs: Hooks](https://code.claude.com/docs/en/hooks-guide.md)**<br>
  Key Insight: Deterministic enforcement > LLM instructions

- **[Anthropic: Prompt Caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)**<br>
  Key Insight: 90% savings on cached reads

- **[Anthropic: Batch API](https://platform.claude.com/docs/en/build-with-claude/batch-processing)**<br>
  Key Insight: 50% off for async processing

- **[Azure: AI Agent Patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns)**<br>
  Key Insight: Orchestrator pattern dominates production

</details>


---

## Related Awesome Lists

- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code), Skills, hooks, agents, applications
- [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents), 100+ subagents
- [awesome-claude-md](https://github.com/josix/awesome-claude-md), Exemplary CLAUDE.md files
- [awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules), 500+ Cursor rules
- [claude-code-ultimate-guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide), Comprehensive guide
- [agentic-coding-handbook](https://tweag.github.io/agentic-coding-handbook/), Tweag's handbook
- [agent-flywheel](https://agent-flywheel.com), The agentic coding flywheel concept

---

## Contributing

PRs welcome! Include evidence (benchmark, source, or production experience) with every claim.

## License

MIT, Use it, fork it, make it yours.

---

**Built by [@Supersynergy](https://github.com/Supersynergy)** | Powered by Claude Code | Research by 10 parallel Haiku agents
