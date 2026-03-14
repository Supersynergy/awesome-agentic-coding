# Modern Stack Recipes (March 2026)

## Recipe 1: SaaS Starter (Most Common)

```
Frontend:   Next.js 15 App Router
Components: shadcn/ui + Tailwind CSS
Forms:      React Hook Form + Zod
Tables:     TanStack Table
State:      Zustand (client) + React Query (server)
Auth:       Better-Auth or Clerk
Database:   Neon (serverless Postgres)
ORM:        Drizzle
Validation: Zod (shared client/server)
Payments:   Stripe (or Lemon Squeezy)
Email:      Resend
Deploy:     Vercel or Coolify
Testing:    Vitest + Playwright
API Client: Bruno
```

**Why this stack:** Maximum ecosystem support, best Claude Code compatibility (most training data), fastest time-to-production.

---

## Recipe 2: AI Agent Platform

```
Orchestrator: Claude Code + Agent SDK
Messaging:    NATS.io (JetStream for persistence)
Database:     SurrealDB (knowledge graph + agent memory)
Cache:        Dragonfly (Redis-compatible, 25x faster)
Jobs:         Inngest (durable background functions)
Search:       Meilisearch (agent knowledge retrieval)
API:          Hono (runs on Edge, Bun, Node)
Monitoring:   OpenTelemetry + Grafana
Deploy:       Docker + Coolify
```

**Why this stack:** NATS provides the inter-agent event bus. SurrealDB stores agent memory as a graph (who knows what, who talked to whom). Dragonfly for fast KV state. Inngest for reliable long-running workflows.

---

## Recipe 3: Real-Time App (Chat, Collaboration)

```
Frontend:   Next.js 15 + HeroUI
Real-time:  NATS WebSocket or Liveblocks
Database:   SurrealDB (live queries) or Supabase (Realtime)
Backend:    ElysiaJS on Bun
Auth:       Supabase Auth or Better-Auth
State:      Yjs (CRDT for collaboration)
Deploy:     Fly.io (low-latency global)
```

**Why this stack:** SurrealDB live queries push changes to clients automatically. NATS WebSocket bridges server events to the browser. Yjs handles conflict-free concurrent editing.

---

## Recipe 4: API-First / Multi-Client

```
API:        Hono (universal runtime)
Validation: Zod + @hono/zod-openapi
Docs:       Auto-generated OpenAPI 3.1
Database:   Neon + Drizzle
Auth:       JWT + Better-Auth
Rate Limit: Upstash Redis
Deploy:     Cloudflare Workers or Fly.io
Testing:    Hurl (plain text HTTP tests)
API Client: Bruno (for development)
```

**Why this stack:** Hono runs everywhere (CF Workers, Bun, Deno, Node). Zod-OpenAPI auto-generates docs. Hurl tests are just text files in git.

---

## Recipe 5: Internal Tool / Admin Dashboard

```
Frontend:   Next.js 15 + shadcn/ui
Tables:     TanStack Table (sorting, filtering, virtual scroll)
Forms:      React Hook Form + Zod + shadcn Form
Charts:     Recharts or Tremor
Auth:       Role-based with Better-Auth
Database:   PostgreSQL + Drizzle
Search:     pg_trgm (built-in Postgres) or Meilisearch
Deploy:     Docker + internal network
```

**Why this stack:** shadcn/ui has the best data-display components. TanStack Table handles any data volume. No need for fancy real-time — just good CRUD.

---

## Recipe 6: E-Commerce

```
Framework:  MedusaJS v2 (headless commerce)
Frontend:   Astro 5 + React islands
Components: shadcn/ui + MagicUI (animations)
Payments:   Stripe / PayPal / Mollie
Search:     Meilisearch (product search)
CDN:        Cloudflare R2 (images)
Email:      Resend (transactional)
Analytics:  Plausible (privacy-friendly)
Deploy:     Coolify or Railway
```

---

## Key Technology Deep Dives

### Drizzle ORM (Why Not Prisma?)

```typescript
// Drizzle: SQL-like, zero overhead, serverless-ready
const users = await db
  .select({ id: usersTable.id, name: usersTable.name })
  .from(usersTable)
  .where(eq(usersTable.status, 'active'))
  .orderBy(desc(usersTable.createdAt))
  .limit(10)

// Prisma equivalent:
// const users = await prisma.user.findMany({
//   where: { status: 'active' },
//   select: { id: true, name: true },
//   orderBy: { createdAt: 'desc' },
//   take: 10,
// })

// Winner: Drizzle
// - 0 dependencies (Prisma: 15MB engine binary)
// - Serverless-ready (no cold start penalty)
// - SQL-like syntax (transferable knowledge)
// - Relational queries without N+1
```

### Hono (Why Not Express?)

```typescript
// Hono: 14KB, runs everywhere, modern API
import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { jwt } from 'hono/jwt'
import { zValidator } from '@hono/zod-validator'

const app = new Hono()
  .use('*', cors())
  .use('/api/*', jwt({ secret: process.env.JWT_SECRET! }))
  .get('/users', async (c) => c.json(await getUsers()))
  .post('/users', zValidator('json', UserSchema), async (c) => {
    const user = await createUser(c.req.valid('json'))
    return c.json(user, 201)
  })

// Works on: Cloudflare Workers, Bun, Deno, Node, AWS Lambda, Vercel Edge
export default app

// Express equivalent needs: body-parser, cors, express-jwt, celebrate
// Express only works on: Node.js
```

### Better-Auth (Why Not Clerk?)

```typescript
// Better-Auth: self-hosted, framework-agnostic, free
import { betterAuth } from 'better-auth'
import { drizzleAdapter } from 'better-auth/adapters/drizzle'

export const auth = betterAuth({
  database: drizzleAdapter(db, { provider: 'pg' }),
  emailAndPassword: { enabled: true },
  socialProviders: {
    google: { clientId: env.GOOGLE_ID, clientSecret: env.GOOGLE_SECRET },
    github: { clientId: env.GITHUB_ID, clientSecret: env.GITHUB_SECRET },
  },
  plugins: [
    twoFactor(),     // 2FA built-in
    magicLink(),     // Passwordless
    organization(),  // Multi-tenancy
  ],
})

// Client:
import { createAuthClient } from 'better-auth/react'
const { signIn, signUp, useSession } = createAuthClient()

// Clerk: $25/mo for 1000 MAU, vendor-locked
// Better-Auth: Free forever, your data, your server
```

---

## Anti-Patterns to Avoid

| Don't | Do Instead | Why |
|-------|-----------|-----|
| Prisma in serverless | Drizzle ORM | No 15MB engine binary, no cold start |
| Express in 2026 | Hono or Fastify | Express is unmaintained, single-runtime |
| REST for fullstack TS | tRPC | Zero codegen, end-to-end types |
| Elasticsearch for search | Meilisearch | 100x simpler, fast enough |
| Redis for everything | Dragonfly (cache) + NATS (messaging) | Right tool for the job |
| Firebase | Supabase or self-hosted | Vendor lock-in, pricing surprises |
| Clerk for auth | Better-Auth | Free, self-hosted, same features |
| Jest | Vitest | 10x faster, Vite-native |
| Selenium | Playwright | Auto-wait, codegen, multi-browser |
| Postman | Bruno | Offline, git-friendly, open source |
