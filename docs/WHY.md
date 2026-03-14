# Why Every Decision Was Made

Every file in this repo has evidence behind it. Here's the reasoning.

---

## Why Orchestrator-Worker?
**Evidence:** Anthropic's multi-agent research system showed **90.2% improvement** using Orchestrator (Opus) + Specialists (Sonnet) vs single Opus agent.
**Source:** [Anthropic Engineering Blog](https://www.anthropic.com/engineering/multi-agent-research-system)

## Why CLAUDE.md Under 200 Lines?
**Evidence:** Testing shows frontier LLMs consistently follow ~150-200 instructions. Beyond that, adherence drops to 40-50%.
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)

## Why Hooks Over Instructions?
**Evidence:** LLM instructions can be "forgotten" under context pressure. Hooks are shell scripts that execute deterministically regardless of LLM state.
**Source:** [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide.md)

## Why Haiku for Exploration?
**Evidence:** Haiku costs $1/$5 per MTok vs Sonnet's $3/$15. For read-only tasks (search, exploration), output quality is comparable. 5x cost savings with no quality loss.
**Source:** [Anthropic Pricing](https://www.anthropic.com/pricing)

## Why Permission Allowlists?
**Evidence:** Each permission prompt forces Claude to re-read context (~100 tokens) and generate a response (~50 tokens). 15 prompts/session = ~2,250 tokens wasted.
**Source:** [Claude Code Settings Docs](https://code.claude.com/docs/en/settings.md)

## Why Skills Over CLAUDE.md Sections?
**Evidence:** CLAUDE.md is loaded every session. Skills load only when invoked. A 500-line deployment guide costs ~1,500 tokens/session in CLAUDE.md vs 0 tokens as a skill.
**Source:** [Claude Code Skills Docs](https://code.claude.com/docs/en/skills.md)

## Why Plan-Then-Execute?
**Evidence:** Plan mode reduces multi-file architecture errors by 45%. Pre-made decisions eliminate guessing during implementation.
**Source:** [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices), [Manus Context Engineering](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)

## Why Context Engineering Over Prompt Engineering?
**Evidence:** Manus rebuilt their agent framework 4 times. Their conclusion: "Performance gains come from intelligent context flow, not prompt perfection." KV-cache hit rate (context stability) matters 10x more than prompt wording.
**Source:** [Manus Blog](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus), [Anthropic Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

## Why Append-Only Context?
**Evidence:** Modifying conversation history breaks KV-cache (10x cost increase) and confuses model's understanding. Leaving errors in context teaches the model to self-correct.
**Source:** [Manus Blog](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)

## Why Test-on-Stop Hook?
**Evidence:** Claude can "forget" to run tests under context pressure. A Stop hook deterministically runs tests before finishing. Catches regressions that instructions-based approaches miss.
**Source:** [Claude Code Hooks Guide](https://code.claude.com/docs/en/hooks-guide.md)

## Why Secret Guard Hook?
**Evidence:** LLMs occasionally write secrets to files they shouldn't. A PreToolUse hook blocks this deterministically, regardless of what the LLM "intends."
**Source:** Security best practices, OWASP guidelines

## Why Subagent Context Isolation?
**Evidence:** A subagent exploring 100 files returns ~200 tokens (summary) vs ~50,000 tokens (raw file contents) in the main context. Prevents context pollution and enables parallel work.
**Source:** [Claude Code Sub-agents Docs](https://code.claude.com/docs/en/sub-agents.md)

## Why 3-5 Agent Team Size?
**Evidence:** Teams larger than 5 create coordination chaos. Communication overhead grows quadratically (n*(n-1)/2 channels). 3-5 is the sweet spot for parallel work with manageable coordination.
**Source:** [Multi-Agent Systems Architecture Guide 2026](https://ztabs.co/blog/multi-agent-systems-guide), [O'Reilly: Designing Effective Multi-Agent Architectures](https://www.oreilly.com/radar/designing-effective-multi-agent-architectures/)

## Why Checkpointing for Long Workflows?
**Evidence:** Multi-step agent workflows fail ~30% of the time. Without checkpoints, the entire workflow restarts. With checkpoints, recovery from last good state saves 60% of wasted processing.
**Source:** [Fast.io: AI Agent State Checkpointing](https://fast.io/resources/ai-agent-state-checkpointing/)
