# Architecture Patterns for AI-Native Development

## The Definitive Ranking (March 2026)

Based on production usage at Anthropic, Cognition (Devin), Manus, and 100+ real-world projects.

---

## 1. Orchestrator-Worker Pattern (Score: 59/70)

**The undisputed winner for AI coding agents.**

```
Orchestrator (Planner)
  |--- Worker A (Researcher, Haiku, Read-only)
  |--- Worker B (Coder, Sonnet, Edit+Bash)
  |--- Worker C (Reviewer, Haiku, Read-only)
```

### Why It Wins
- Anthropic's own multi-agent research system: **90.2% improvement** over single-agent
- Clear separation: Orchestrator plans, Workers execute
- Workers can't spawn sub-workers (prevents infinite nesting)
- Parallel execution where tasks are independent
- Context isolation: Worker failures don't crash orchestrator

### Real-World Usage
| System | How They Use It |
|--------|----------------|
| Claude Code | Lead agent (Opus) + Specialist subagents (Sonnet/Haiku) |
| Devin | Sequential loop: code -> compile -> test -> observe |
| Manus | Planner -> Executor -> Reviewer pipeline |
| Replit Agent | Backend + Frontend workers in parallel |

### When NOT to Use
- Simple, single-file edits (overhead not justified)
- Tasks under 5 minutes (coordination cost > execution cost)
- Sequential-only workflows (no parallelism benefit)

---

## 2. Plan-and-Execute Pattern (Score: 52/70)

**Standard for Claude Code workflows.**

```
[Planner] --> Plan.md --> [Review] --> [Executor] --> [Verifier]
```

### Why It Works
- 45% reduction in multi-file architecture errors
- Human review point before expensive execution
- Plan survives context compaction
- Natural checkpoint for rollback

### Implementation in Claude Code
```
User: "Plan this feature. Don't code yet."
Claude: Creates plan with file list, approach, risks
User: Reviews, annotates, approves
Claude: Implements in 1-2 turns (all decisions pre-made)
```

---

## 3. Blackboard Pattern (Score: 41/70)

**Hidden gem for complex analysis pipelines.**

```
┌─────────────────────────────┐
│         BLACKBOARD          │  <- Shared Knowledge Store
└──────────┬──────────────────┘
           |
    [Specialist 1] [Specialist 2] [Specialist 3]
     (each reads/writes independently)
```

### In Claude Code
- **Memory system** = your Blackboard
- **Task lists** = shared state between teammates
- **CLAUDE.md** = persistent knowledge base

### When to Use
- Multi-step research (each agent adds findings to shared doc)
- Complex debugging (multiple hypotheses tested against shared evidence)
- Knowledge synthesis (combine outputs from parallel researchers)

---

## 4. Event-Driven (Score: 39/70)

**Good for triggers and automation, not for direct coding.**

```
Event (webhook, schedule, file change)
  --> Handler (skill, hook, agent)
  --> Result (commit, notification, report)
```

### In Claude Code
- **Hooks** = event handlers (PreToolUse, PostToolUse, Stop, SessionStart)
- **/loop** = scheduled event polling
- **Desktop Tasks** = persistent scheduled automation

### When to Use
- CI/CD integration (trigger on PR, commit, deploy)
- Monitoring (poll for status, alert on failure)
- Automated workflows (daily reports, dependency updates)

---

## 5. Actor Model (Score: 38/70)

**Powerful but complex. Only for large-scale distributed systems.**

### In Claude Code
- **Agent Teams** approximate the Actor model
- Each teammate = independent actor with mailbox
- Communication via shared task list

### When to Use
- Large teams (5+ concurrent agents)
- Competing hypotheses (debug scenarios)
- Long-running, independent workstreams

### When NOT to Use
- Most projects. The coordination overhead rarely pays off for teams under 3.

---

## Framework Comparison (March 2026)

| | LangGraph | CrewAI | Claude SDK | OpenAI SDK |
|---|---|---|---|---|
| **Pattern** | Graph-based orchestrator | Role-based teams | MCP-native agents | Handoff-based |
| **Strength** | Checkpointing, persistence | Fast prototyping, community | Hooks, lifecycle control | Simplicity |
| **Weakness** | Steep learning curve | Less production control | Claude-only | OpenAI-only |
| **Latency** | Best | Good | Good | Nearly best |
| **GitHub Stars** | 18K | 44K | 5K | 12K |
| **Best For** | Complex stateful workflows | Multi-agent teams | All-in Claude projects | Quick MVPs |

**For Claude Code users: You already have the best agent framework built in.** Adding LangGraph or CrewAI only makes sense if you need cross-model orchestration or external agent coordination.

---

## The Failsafe Stack

```
Layer 1: CLAUDE.md           <- Rules (persistent, may be "forgotten" under pressure)
Layer 2: Skills              <- Workflows (on-demand, structured)
Layer 3: Hooks               <- Guards (deterministic, CANNOT be bypassed)
Layer 4: Subagents           <- Isolation (failures contained)
Layer 5: Memory              <- Learning (cross-session patterns)
Layer 6: Checkpoints         <- Recovery (/resume, session persistence)
```

**Critical insight:** Only Layer 3 (Hooks) is truly deterministic. Everything else relies on the LLM following instructions, which degrades under context pressure. Use hooks for anything that MUST happen (tests, security checks, format validation).

---

## Sources

- [Anthropic: Multi-Agent Research System](https://www.anthropic.com/engineering/multi-agent-research-system) — 90.2% improvement
- [Azure: AI Agent Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns)
- [Hatchworks: Orchestrating AI Agents](https://hatchworks.com/blog/ai-agents/orchestrating-ai-agents/)
- [Particula: Framework Comparison 2026](https://particula.tech/blog/langgraph-vs-crewai-vs-openai-agents-sdk-2026)
- [Cognition: Devin Architecture](https://cognition.ai/blog/introducing-devin)
- [Manus: Context Engineering](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
