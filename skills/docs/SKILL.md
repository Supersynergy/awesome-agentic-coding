---
name: docs
description: Fetch live library documentation via WebFetch. Replaces Context7 MCP (saves 5,000-8,000 tokens). Use when you need current API docs.
argument-hint: <library name, e.g. "react useEffect" or "drizzle select">
allowed-tools: [WebFetch, Bash]
model: haiku
---

# Documentation Fetcher

Fetch current documentation for: $ARGUMENTS

## Strategy
1. Identify the library and specific topic
2. Construct the documentation URL
3. Use WebFetch to retrieve the page
4. Extract ONLY: API signatures, parameters, return types, 1 code example
5. Return max 500 tokens of useful content

## Documentation URLs

### Frontend
| Library | Docs URL |
|---------|----------|
| React | https://react.dev/reference/react/{hook-or-api} |
| Next.js | https://nextjs.org/docs/app/{topic} |
| Tailwind | https://tailwindcss.com/docs/{utility} |
| shadcn/ui | https://ui.shadcn.com/docs/components/{component} |
| Zustand | https://docs.pmnd.rs/zustand/getting-started |
| TanStack Query | https://tanstack.com/query/latest/docs |
| TanStack Table | https://tanstack.com/table/latest/docs |

### Backend
| Library | Docs URL |
|---------|----------|
| Hono | https://hono.dev/docs/{topic} |
| Drizzle | https://orm.drizzle.team/docs/{topic} |
| tRPC | https://trpc.io/docs/{topic} |
| Zod | https://zod.dev/?id={topic} |
| Better-Auth | https://www.better-auth.com/docs/{topic} |

### Databases
| Library | Docs URL |
|---------|----------|
| SurrealDB | https://surrealdb.com/docs/surrealql/{topic} |
| NATS | https://docs.nats.io/{topic} |
| PostgreSQL | https://www.postgresql.org/docs/current/{topic}.html |

### Tools
| Library | Docs URL |
|---------|----------|
| Vitest | https://vitest.dev/api/{topic} |
| Playwright | https://playwright.dev/docs/{topic} |

## Rules
- Fetch the SPECIFIC page for the topic, never the homepage
- If unsure of URL, search with WebFetch on the docs site
- Return code examples > prose descriptions
- Note the library version if relevant
- If docs are behind JS rendering, try the raw GitHub source instead
