# Agent Teams: Real-World Examples

> Claude Code Agent Teams = independent sessions with shared task list + mailbox.

## When to Use Teams vs Subagents

| Use Case | Teams | Subagents |
|----------|-------|-----------|
| Parallel research across different areas | Yes | Yes |
| Frontend + Backend + Tests simultaneously | **Yes** | No (file conflicts) |
| Competing hypotheses (try 2 approaches) | **Yes** | No |
| Quick file search | No | **Yes** |
| Sequential pipeline | No | **Yes** |
| Same-file editing | **No** | **No** |

## Example 1: Full-Stack Feature (3 Teammates)

```bash
# Enable teams (one-time)
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# In your prompt:
"Build the user profile feature with 3 teammates:
 - Teammate 1 (backend): Create API routes in src/api/profile.ts with Hono + Drizzle
 - Teammate 2 (frontend): Create ProfilePage in src/app/profile/page.tsx with shadcn
 - Teammate 3 (tests): Write tests in src/__tests__/profile.test.ts with Vitest

 Backend publishes the API schema first. Frontend and Tests wait for it."
```

## Example 2: Competing Debugging Hypotheses

```bash
"Debug the login timeout with 2 teammates:
 - Teammate 1: Investigate the auth middleware (hypothesis: token expiry)
 - Teammate 2: Investigate the database connection pool (hypothesis: pool exhaustion)

 Each teammate writes findings to .debug/hypothesis-{1,2}.md
 I'll review both and decide which to pursue."
```

## Example 3: Multi-Service Research

```bash
"Research our payment flow across 3 services with 3 teammates:
 - Teammate 1: Map the checkout API in services/checkout/
 - Teammate 2: Map the payment processor in services/payments/
 - Teammate 3: Map the notification system in services/notifications/

 Each writes a service-map.md to .research/"
```

## Team Rules

1. **Max 3 teammates** — 3 = optimal, 4+ = diminishing returns, high cost
2. **Never edit same files** — Use worktrees if needed: `isolation: worktree`
3. **Communication via tasks** — Use TaskCreate for handoffs, SendMessage for coordination
4. **Cost awareness** — 3 teammates = 3x token consumption
5. **Clear boundaries** — Each teammate gets a specific directory/scope
