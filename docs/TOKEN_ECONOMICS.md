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
Context usage 50-70% -> Consider /compact if switching subtasks
Context usage 70-85% -> /compact with focus instructions
Context usage > 85%  -> /clear and start fresh (quality degrades rapidly)
```

**Auto-compact triggers at ~95%** — but quality already degraded by then. Compact proactively at 70%.

---

## Checkpointing Economics

| Workflow Length | Without Checkpoints | With Checkpoints | Savings |
|---------------|-------------------|-----------------|---------|
| < 5 steps | $0.10 | $0.12 (overhead) | -20% (not worth it) |
| 5-15 steps | $0.50 | $0.35 | 30% |
| 15+ steps | $2.00 | $0.80 | **60%** |

Long-running workflows fail ~30% of the time. Checkpointing = restart from last good state instead of from scratch.

---

## Sources

- [Claude Code Docs: Costs](https://code.claude.com/docs/en/costs.md)
- [Anthropic Pricing](https://www.anthropic.com/pricing)
- [Manus: KV-Cache Optimization](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- [Redis: LLM Token Optimization 2026](https://redis.io/blog/llm-token-optimization-speed-up-apps/)
