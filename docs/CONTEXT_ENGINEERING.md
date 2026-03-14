# Context Engineering: The 10x Multiplier

> "The developers getting best results don't write better prompts — they engineer their context."
> — Anthropic Engineering

## What Is Context Engineering?

Context engineering is deciding **what information the AI sees, when it sees it, and how it's structured**. It replaced "prompt engineering" as the primary lever for AI coding quality in 2025-2026.

**Key insight from Manus (rebuilt their agent framework 4 times):**
> "We've learned that the model's reasoning is only as good as the context we feed it. Clever prompts can't compensate for missing or poorly structured context."

---

## The 6 Proven Strategies

### 1. Keep Prompts Cache-Friendly
**What:** Stable prompt prefixes enable KV-cache reuse. Cached tokens cost 0.30 USD/MTok vs 3 USD/MTok uncached — a **10x difference**.

**How:**
- Never include timestamps in system prompts
- Keep CLAUDE.md stable (don't change it every session)
- Structure context so the prefix stays identical across turns

**Source:** [Manus Blog](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)

### 2. Append-Only Context
**What:** Never modify previous messages in the conversation. Make context append-only.

**How:**
- Don't ask the model to "forget" or "ignore" previous instructions
- Don't rewrite conversation history
- Add corrections as new messages, not edits to old ones
- Ensure deterministic serialization (same input = same token sequence)

**Why:** Modifying context breaks cache and confuses the model's understanding of conversation flow.

### 3. Preserve Errors for Learning
**What:** Leave wrong turns in the conversation. When the model sees a failed action + its result, it implicitly updates its beliefs.

**How:**
- Don't delete failed attempts from conversation
- Let Claude see its mistakes and the error messages
- The model learns to avoid the same mistake without being told

**Why:** Error context teaches better than instructions. "Don't do X" is weaker than showing what happened when X was tried.

### 4. External Memory (Filesystem as Context)
**What:** Large documents live on disk, referenced by path — not embedded in the prompt.

**How:**
- Download web pages/PDFs to local files
- Reference them: "Read the API docs at ./docs/api-reference.md"
- Let Claude use the Read tool when it needs the info
- This trades prompt tokens for tool-call tokens (much cheaper)

**Why:** A 10,000-line API doc in the prompt = 15,000 tokens wasted every turn. As a file, it costs tokens only when read.

### 5. Progressive Disclosure
**What:** Don't tell Claude everything upfront. Teach it **how to find** information.

**How:**
```markdown
# CLAUDE.md (good — progressive disclosure)
- API docs: see docs/api.md
- Database schema: see prisma/schema.prisma
- Component patterns: see src/components/Button.tsx as reference

# CLAUDE.md (bad — info dump)
[500 lines of API documentation pasted inline]
```

**Why:** Claude reads relevant docs on-demand. Upfront dumps waste context and reduce adherence (>200 lines = only 40% followed).

### 6. Pointers Over Copies
**What:** Reference code by file:line instead of pasting snippets that may become outdated.

**How:**
```markdown
# Good
- Result pattern: see src/utils/result.py:15-25

# Bad
- Result pattern:
  ```python
  class Result:  # This may be outdated!
      ...
  ```
```

**Why:** Code snippets in CLAUDE.md become stale. File references are always current.

---

## The CLAUDE.md Flywheel

```
1. /init                    → Generate starter CLAUDE.md
2. Review + prune           → Keep under 200 lines
3. Test understanding       → "What does this project do?"
4. Ask Claude to improve    → "Improve this CLAUDE.md based on what you see"
5. Quarterly review         → Remove stale entries, add new patterns
```

### What Goes In CLAUDE.md (Essential)
- Build/test/deploy commands (exact, copy-pasteable)
- Code style rules (specific + verifiable)
- Architecture map (directories + purpose)
- Gotchas that aren't obvious from code
- Import ordering and naming conventions

### What Stays OUT of CLAUDE.md
- Language conventions Claude already knows
- Standard API documentation (link to it instead)
- Frequently changing information (put in memory)
- Detailed implementation guides (make them skills)

---

## Context Priming Techniques

### Pre-Session Priming
Before starting a complex task, prime Claude's context:
```
Before we start: read these files to understand the codebase:
1. src/api/routes.ts (all API endpoints)
2. src/models/user.ts (data model)
3. prisma/schema.prisma (database schema)
Then tell me what you understand about how the system works.
```

This ensures Claude has the right mental model before coding.

### The Annotation Cycle (90% Quality Improvement)
```
1. "Create a plan for X. Don't code."
2. Open the plan → add inline notes: "@claude: use Zod here"
3. "Address all notes without implementing."
4. Claude refines → repeat until 0 ambiguity
5. "Implement." → Done in 1-2 turns
```

**Why it works:** Every decision is pre-made. Claude doesn't guess.

### Reference File Technique
```
I want to add a new API endpoint similar to src/api/users.ts.
Read that file first, then create src/api/products.ts following
the exact same pattern.
```

Giving Claude a concrete reference file is 3x more effective than describing patterns in words.

---

## Anti-Patterns (What Doesn't Work)

| Anti-Pattern | Why It Fails | Better Approach |
|-------------|-------------|-----------------|
| "Be careful" / "Be thorough" | Vague instructions are ignored | Specific rules with examples |
| 500+ line CLAUDE.md | Only 40% adherence | Keep under 200 lines |
| Pasting code in prompts | Becomes stale | Use file:line references |
| "Forget previous instructions" | Breaks context flow | Append corrections |
| Timestamps in system prompt | Kills KV-cache (10x cost) | Use SessionStart hook instead |
| Detailed docs inline | Wastes context | Put in files, reference by path |

---

## Measuring Context Quality

The #1 metric is **KV-cache hit rate** (for API usage) and **rule adherence** (for Claude Code):

- **Cache hit rate > 90%**: Excellent context structure
- **Rule adherence > 90%**: CLAUDE.md is well-sized and clear
- **Token usage stable**: No context explosions mid-session

Use `/context` in Claude Code to see your token breakdown and identify waste.

---

## Sources

- [Anthropic: Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Manus: Context Engineering Lessons](https://manus.im/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [HumanLayer: Writing Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Builder.io: CLAUDE.md Guide](https://www.builder.io/blog/claude-md-guide)
- [Simon Willison: Using LLMs for Code](https://simonwillison.net/2025/Mar/11/using-llms-for-code/)
