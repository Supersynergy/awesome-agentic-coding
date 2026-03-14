# NATS + SurrealDB Quick Start

> Event-driven backend with multi-model database in under 50 lines.

## Setup

```bash
# Start both services
docker run -d --name nats -p 4222:4222 -p 8222:8222 nats:latest -js
docker run -d --name surrealdb -p 8000:8000 surrealdb/surrealdb:latest \
  start --user root --pass root

# Install deps
npm init -y
npm install nats surrealdb hono zod
```

## The Pattern: Event-Sourced CRUD

```typescript
// server.ts — Hono API + NATS events + SurrealDB storage
import { Hono } from 'hono'
import { connect, JSONCodec } from 'nats'
import Surreal from 'surrealdb'
import { z } from 'zod'

// --- Init ---
const app = new Hono()
const db = new Surreal()
await db.connect('ws://localhost:8000/rpc')
await db.use({ namespace: 'app', database: 'main' })
await db.signin({ username: 'root', password: 'root' })

const nc = await connect({ servers: 'nats://localhost:4222' })
const jc = JSONCodec()

// --- Schema ---
const UserSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
  role: z.enum(['admin', 'user']).default('user'),
})

// --- CRUD with Events ---
app.post('/users', async (c) => {
  const body = await c.req.json()
  const data = UserSchema.parse(body)

  // Store in SurrealDB
  const [user] = await db.create('user', data)

  // Publish event to NATS
  nc.publish('users.created', jc.encode(user))

  return c.json(user, 201)
})

app.get('/users', async (c) => {
  const users = await db.select('user')
  return c.json(users)
})

app.get('/users/:id', async (c) => {
  const user = await db.select(`user:${c.req.param('id')}`)
  return user ? c.json(user) : c.notFound()
})

app.put('/users/:id', async (c) => {
  const body = await c.req.json()
  const data = UserSchema.partial().parse(body)
  const user = await db.merge(`user:${c.req.param('id')}`, data)

  nc.publish('users.updated', jc.encode(user))
  return c.json(user)
})

app.delete('/users/:id', async (c) => {
  const id = c.req.param('id')
  await db.delete(`user:${id}`)

  nc.publish('users.deleted', jc.encode({ id }))
  return c.json({ success: true })
})

// --- Graph Queries (SurrealDB superpower) ---
app.post('/users/:id/follow/:targetId', async (c) => {
  const { id, targetId } = c.req.param()
  await db.query(`RELATE user:${id}->follows->user:${targetId} SET since = time::now()`)

  nc.publish('users.followed', jc.encode({ from: id, to: targetId }))
  return c.json({ success: true })
})

app.get('/users/:id/following', async (c) => {
  const result = await db.query(`
    SELECT ->follows->user.* AS following FROM user:${c.req.param('id')}
  `)
  return c.json(result)
})

// --- Event Consumer (separate process or same) ---
const sub = nc.subscribe('users.*')
;(async () => {
  for await (const msg of sub) {
    const event = msg.subject.split('.')[1]
    const data = jc.decode(msg.data)
    console.log(`[EVENT] users.${event}:`, data)

    // Store event in SurrealDB for audit trail
    await db.create('event', {
      type: `users.${event}`,
      data,
      timestamp: new Date().toISOString(),
    })
  }
})()

export default { port: 3000, fetch: app.fetch }
```

## Run

```bash
bun run server.ts
# or: npx tsx server.ts

# Test
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Max","email":"max@example.com"}'

curl http://localhost:3000/users
```

## What This Gives You

- **CRUD API** with Zod validation (Hono)
- **Event sourcing** — every mutation publishes to NATS
- **Audit trail** — events stored in SurrealDB
- **Graph queries** — follow/following relationships without JOINs
- **Real-time ready** — subscribe to NATS for live updates
- **12 lines of infrastructure** — just Docker
