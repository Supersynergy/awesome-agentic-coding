# Token Economics: The Complete Cost Guide

## Model Pricing (March 2026)

| Model | Input $/MTok | Output $/MTok | Best For |
|-------|-------------|--------------|----------|
| Haiku 4.5 | $1.00 | $5.00 | Exploration, search, simple edits |
| Sonnet 4.6 | $3.00 | $15.00 | Production code, day-to-day tasks |
| Opus 4.6 | $5.00 | $25.00 | Architecture, complex planning |

**Cached input tokens:** $0.30/MTok (10x cheaper than uncached)

---

## Cost Per Task (Real Measurements)

| Task | Model | Avg Tokens | Avg Cost |
|------|-------|-----------|----------|
| Simple edit | Sonnet | ~5K | $0.05 |
| Standard feature | Sonnet | ~15K | $0.15 |
| Complex architecture | Opus | ~30K | $0.50 |
| Codebase exploration | Haiku subagent | ~8K | $0.02 |
| Code review | Haiku subagent | ~10K | $0.03 |
| Plan review | Sonnet | ~8K | $0.10 |
| Full session (unoptimized) | Mixed | ~200K | $2.50 |
| Full session (optimized) | Mixed | ~80K | $0.40 |

---

## The 7 Optimization Levers

### 1. Model Routing (5x savings on exploration)
```
Exploration/Search  -> Haiku ($1/$5)    = 5x cheaper than Sonnet
Code Writing        -> Sonnet ($3/$15)  = balanced
Architecture        -> Opus ($5/$25)    = only when needed
```

**Impact:** If 60% of your session is exploration (typical), routing to Haiku saves **60% of exploration cost**.

### 2. Permission Allowlists (500-1000 tokens/session)
Every permission prompt = Claude re-reads context to ask. Pre-approve safe commands:
```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep", "Bash(git status*)", "Bash(npm test*)"]
  }
}
```

### 3. CLAUDE.md Size (1000+ tokens/session)
| Lines | Adherence | Token Cost |
|-------|-----------|-----------|
| < 100 | 98% | ~300 tokens |
| 100-200 | 95% | ~600 tokens |
| 200-500 | 60% | ~1500 tokens |
| 500+ | 40% | ~3000 tokens |

Keep under 200 lines. Move details to skills (loaded on-demand = 0 tokens when unused).

### 4. Skills (0 tokens when unused)
A 500-line deployment guide loaded as:
- CLAUDE.md section: **~1500 tokens every session**
- Skill file: **0 tokens** (loaded only when `/deploy` is invoked)

### 5. Effort Levels (60-80% thinking savings)
```
/effort low   -> Simple edits, lookups     (minimal thinking tokens)
/effort medium -> Standard tasks (default)  (balanced thinking)
/effort high  -> Complex reasoning          (deep thinking)
```

Extended thinking tokens are **output tokens** (expensive). For a simple rename, `/effort low` avoids spending $0.10 on unnecessary reasoning.

### 6. Context Management
```
/clear              -> Reset between tasks (prevents cross-contamination)
/compact focus on X -> Save 40% context at 70% usage
/btw question       -> Side question (0 history pollution)
/resume name        -> Continue named session (no context rebuild)
```

### 7. Subagent Context Isolation
A subagent exploring 100 files returns a 2-paragraph summary instead of flooding the main context with file contents.

**Without subagents:** 100 files * ~200 lines = ~50,000 tokens in main context
**With subagents:** 2-paragraph summary = ~200 tokens in main context

---

## Real-World Session Comparison

### Before Optimization
```
Session: Add user authentication
Model: Opus (entire session)
Steps: Permission prompts (15x), file reads, planning, coding, debugging
Tokens: 180,000 (input) + 40,000 (output)
Cost: $0.90 + $1.00 = $1.90
Duration: 25 minutes
```

### After Optimization
```
Session: Add user authentication
Models: Haiku (exploration) + Sonnet (coding) + Haiku (review)
Steps: Pre-approved reads (0 prompts), plan, implement, verify
Tokens: 60,000 (input, 40% cached) + 15,000 (output)
Cost: $0.12 + $0.23 = $0.35
Duration: 15 minutes (fewer permission interruptions)
```

**Savings: 82% cost reduction, 40% time reduction**

---

## The Compaction Decision Tree

```
Context usage < 50%  -> Keep working
Context usage 50-65% -> Consider /compact if switching subtasks
Context usage > 65%  -> /compact with focus instructions NOW
Context usage > 80%  -> /clear and start fresh (quality already collapsed)
```

**BREAKTHROUGH (March 2026):** Research from Chroma shows quality degrades **suddenly at 65%**, not gradually at 95%. The old advice of "compact at 80%" is outdated. Compact proactively at 65%.

**Source:** [Chroma: Context Rot Research](https://research.trychroma.com/context-rot)

---

## Checkpointing Economics

| Workflow Length | Without Checkpoints | With Checkpoints | Savings |
|---------------|-------------------|-----------------|---------|
| < 5 steps | $0.10 | $0.12 (overhead) | -20% (not worth it) |
| 5-15 steps | $0.50 | $0.35 | 30% |
| 15+ steps | $2.00 | $0.80 | **60%** |

Long-running workflows fail ~30% of the time. Checkpointing = restart from last good state instead of from scratch.

---

---

## NEW: The 1:166 Ratio (March 2026 Breakthrough)

For every **1 token of output**, approximately **166 tokens of input context** are read. This fundamentally changes optimization priorities:

```
Impact ranking:
1. Reduce context waste     → 10% context reduction = MORE savings than
2. Eliminate all output      → removing every generated token
3. Switch models             → Haiku vs Sonnet is 3-5x, but context is 166x
```

**Practical implication:** .claudeignore, CLAUDE.md pruning, and tool search have MORE impact than model routing.

---

## NEW: Prompt Caching Economics (GA Feb 2026)

| Scenario | Uncached | Cached | Savings |
|----------|----------|--------|---------|
| System prompt (5K tokens) | $0.015/call | $0.0015/call | 90% |
| Codebase context (50K) | $0.15/call | $0.015/call | 90% |
| Multi-turn (10 turns) | $1.50 | $0.15 | 90% |
| Agent loop (20 steps) | $3.00 | $0.30 | 90% |

**Cache TTL:** 5 min (default, free), 1 hour (2x write cost on Bedrock).
**Requirement:** Stable prompt prefixes. No timestamps in system prompts!

---

## NEW: Batch API (50% Off Everything)

For async/bulk operations:
```bash
# Refactor 100 files at once
/batch "Add TypeScript types to all .js files in src/"

# Generate tests for entire codebase
/batch "Write unit tests for all files without coverage"
```

**Pricing:** 50% off both input and output tokens.
**Latency:** Up to 24 hours (usually much faster).
**Limit:** 100K requests or 256MB per batch.

---

## NEW: Claude Code Router (Open Source)

Multi-model routing that reduces costs by up to 10x:
- Simple queries → Haiku or even free models (Gemma)
- Code generation → Sonnet
- Architecture → Opus
- Automatic routing based on task complexity

**Source:** [Claude Code Router](https://www.datacamp.com/tutorial/claude-code-router)

---

## Developer Cost Benchmarks (March 2026)

| Usage Level | Monthly Cost | Daily Average |
|-------------|-------------|---------------|
| Light | $0-20 | $0-1 |
| Standard | $20-50 | $1-2 |
| Power user | $100-200 | $4-8 |
| Team (per dev) | $40-250 | $2-10 |

**90% of users stay below $12/day.** The optimizations in this repo target the $6/day average → $2/day.

---

## Sources

- [Claude Code Docs: Costs](https://code.claude.com/docs/en/costs.md)
- [Anthropic Pricing](https://www.anthropic.com/pricing)
- [Manus: KV-Cache Optimization](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- [Redis: LLM Token Optimization 2026](https://redis.io/blog/llm-token-optimization-speed-up-apps/)
- [Dev.to: Cut Token Costs by 70%](https://dev.to/myougatheaxo/cut-claude-code-token-costs-by-70-practical-optimization-guide-78c)
- [Anthropic: Prompt Caching](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)
- [Anthropic: Batch Processing](https://platform.claude.com/docs/en/build-with-claude/batch-processing)
- [The Real Cost of AI Coding Agents 2026](https://www.gauraw.com/real-cost-ai-coding-agents-2026/)
- [Chroma: Context Rot Research](https://research.trychroma.com/context-rot)
