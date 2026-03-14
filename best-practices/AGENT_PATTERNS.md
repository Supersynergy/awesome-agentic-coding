# Agent Patterns Cheatsheet

## The 5 Patterns (Ranked by Production Success)

### 1. Orchestrator-Worker (Score: 59/70)

```
Orchestrator (Opus/Sonnet) — plans, delegates, never codes
     │
     ├── Researcher (Haiku) — read-only, finds info
     ├── Coder (Sonnet) — edit+bash, writes code
     ├── Reviewer (Haiku) — read-only, finds bugs
     └── Tester (Haiku) — bash-only, runs tests
```

**Claude Code Implementation:**

```yaml
# ~/.claude/agents/researcher/AGENT.md
---
name: researcher
model: haiku
tools: Read, Glob, Grep
---
You are a codebase researcher. Find information, return concise summaries.
Never suggest code changes. Just report facts.
```

```typescript
// In your prompt or skill:
// "Use 3 parallel Haiku researcher agents to find:
//  1. All API endpoints that handle user auth
//  2. All database migrations related to users
//  3. All test files for user functionality
// Then synthesize their findings and plan the implementation."
```

### 2. Pipeline (Sequential Specialists)

```
Input → [Validator] → [Transformer] → [Enricher] → [Writer] → Output
```

**Best for:** Data processing, ETL, content generation

```bash
# Claude Code skill that chains agents:
# Step 1: Researcher finds all relevant code
# Step 2: Architect creates plan
# Step 3: Coder implements
# Step 4: Reviewer checks
# Each step is a separate subagent with isolated context
```

### 3. Fan-Out / Fan-In

```
Task → [Agent 1] ─┐
     → [Agent 2] ──┼── Merge Results → Final Output
     → [Agent 3] ─┘
```

**Best for:** Parallel research, multi-perspective review, competing hypotheses

```
# Claude Code: spawn 3 agents in parallel
"Launch 3 Haiku agents simultaneously:
 Agent 1: Search for security vulnerabilities in the auth module
 Agent 2: Search for performance bottlenecks in the API layer
 Agent 3: Search for missing test coverage
 Return findings for each."
```

### 4. Event-Driven (NATS-based)

```
Agent A ──publish──→ NATS ──subscribe──→ Agent B
                       │
                       └──subscribe──→ Agent C
```

**Best for:** Microservices, real-time processing, decoupled systems

```typescript
// Agent publishes task completion
nc.publish('tasks.completed', JSON.stringify({
  agent: 'researcher',
  findings: [...],
  nextStep: 'implement'
}))

// Another agent picks it up
const sub = nc.subscribe('tasks.completed')
for await (const msg of sub) {
  const task = JSON.parse(msg.data)
  if (task.nextStep === 'implement') {
    // Start implementation
  }
}
```

### 5. Blackboard (Shared State)

```
                ┌─────────────┐
Agent A ──────→ │  Blackboard  │ ←────── Agent C
Agent B ──────→ │ (shared DB)  │ ←────── Agent D
                └─────────────┘
```

**Best for:** Complex problem-solving where agents build on each other's work

```
# Claude Code: Memory + Task list = your blackboard
# Agents write findings to memory, others read them
# Task list tracks what's been done and what's next
```

---

## Claude Code Agent Best Practices

### Model Routing

| Task | Model | Cost | Why |
|------|-------|------|-----|
| File search, grep, glob | Haiku | $1/MTok in | 5x cheaper, same quality for search |
| Code review | Haiku | $1/MTok in | Pattern matching, not generation |
| Architecture decisions | Sonnet | $3/MTok in | Needs reasoning depth |
| Complex planning | Opus | $5/MTok in | Only for multi-system design |
| Code generation | Sonnet | $3/MTok in | Best quality/cost ratio |
| Test writing | Haiku | $1/MTok in | Mostly templated code |

### Agent Isolation Rules

1. **Read-only agents can't break anything** — Give researchers only Read, Glob, Grep
2. **One writer at a time** — Never have 2 agents editing the same file
3. **Subagent output = summary** — Don't let 100 file reads pollute main context
4. **Fail fast** — If a subagent can't find what it needs in 5 tool calls, it should stop
5. **Named agents** — Use `name:` parameter so agents can communicate via SendMessage

### The 3-Agent Sweet Spot

Most tasks need exactly 3 parallel agents:
- **Agent 1**: Research the problem (read existing code)
- **Agent 2**: Research the solution (search for patterns)
- **Agent 3**: Research the tests (find test patterns)

Then the orchestrator (main session) synthesizes and implements.

**Why 3?**
- 2 agents = not enough parallelism
- 4+ agents = diminishing returns, context merge overhead
- 3 agents = 3x research speed, clean merge, manageable cost

---

## NATS for Multi-Agent Communication

```typescript
// agent-bus.ts — Shared agent communication layer
import { connect, JSONCodec } from 'nats'

const nc = await connect()
const jc = JSONCodec()

// Agent registration
export async function registerAgent(name: string, capabilities: string[]) {
  nc.publish('agents.register', jc.encode({ name, capabilities, ts: Date.now() }))
}

// Task dispatch
export async function dispatchTask(task: string, payload: any) {
  const response = await nc.request(`tasks.${task}`, jc.encode(payload), { timeout: 30000 })
  return jc.decode(response.data)
}

// Agent heartbeat
setInterval(() => {
  nc.publish('agents.heartbeat', jc.encode({ name: agentName, status: 'alive' }))
}, 5000)
```

---

## Anti-Patterns (What NOT to Do)

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Single mega-agent | Context pollution, forgetting instructions | Split into orchestrator + workers |
| Opus for everything | 5x cost, no quality improvement for simple tasks | Route by complexity |
| No quality gates | LLM can "forget" to test | Add Stop hooks |
| Shared mutable state | Race conditions, conflicts | One writer per resource |
| No checkpointing | Can't recover from failures | Use /resume, save state |
| Over-communicating | Agents chatting instead of working | Strict input/output contracts |
