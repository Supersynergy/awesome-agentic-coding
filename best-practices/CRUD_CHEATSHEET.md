# CRUD Cheatsheet — Every Pattern You Need

## Quick Decision

| Pattern | Best For | DX | Performance | Type Safety |
|---------|----------|-----|-------------|-------------|
| Server Actions (Next.js 15) | Fullstack Next.js apps | 10/10 | 8/10 | 9/10 |
| tRPC | TS monorepos | 9/10 | 8/10 | 10/10 |
| REST + Hono | Multi-client APIs | 7/10 | 9/10 | 7/10 |
| GraphQL | Complex data requirements | 6/10 | 7/10 | 8/10 |
| SurrealDB direct | Prototypes, AI agents | 8/10 | 7/10 | 6/10 |

---

## Pattern 1: Server Actions (Next.js 15 + Zod + Drizzle)

```typescript
// app/actions/users.ts
'use server'
import { z } from 'zod'
import { db } from '@/db'
import { users } from '@/db/schema'
import { eq } from 'drizzle-orm'
import { revalidatePath } from 'next/cache'

const CreateUserSchema = z.object({
  name: z.string().min(2).max(100),
  email: z.string().email(),
})

// CREATE
export async function createUser(formData: FormData) {
  const parsed = CreateUserSchema.safeParse({
    name: formData.get('name'),
    email: formData.get('email'),
  })
  if (!parsed.success) return { error: parsed.error.flatten() }

  const [user] = await db.insert(users).values(parsed.data).returning()
  revalidatePath('/users')
  return { data: user }
}

// READ (in a Server Component)
// app/users/page.tsx
export default async function UsersPage() {
  const allUsers = await db.select().from(users)
  return <UserList users={allUsers} />
}

// UPDATE
export async function updateUser(id: string, formData: FormData) {
  const parsed = CreateUserSchema.safeParse({
    name: formData.get('name'),
    email: formData.get('email'),
  })
  if (!parsed.success) return { error: parsed.error.flatten() }

  await db.update(users).set(parsed.data).where(eq(users.id, id))
  revalidatePath('/users')
  return { success: true }
}

// DELETE
export async function deleteUser(id: string) {
  await db.delete(users).where(eq(users.id, id))
  revalidatePath('/users')
  return { success: true }
}
```

### Client-Side with Optimistic Updates (React 19)

```typescript
'use client'
import { useOptimistic, useTransition } from 'react'
import { deleteUser } from '@/app/actions/users'

export function UserList({ users }: { users: User[] }) {
  const [optimisticUsers, removeOptimistic] = useOptimistic(
    users,
    (state, deletedId: string) => state.filter(u => u.id !== deletedId)
  )
  const [isPending, startTransition] = useTransition()

  const handleDelete = (id: string) => {
    startTransition(async () => {
      removeOptimistic(id)
      await deleteUser(id)
    })
  }

  return (
    <ul>
      {optimisticUsers.map(user => (
        <li key={user.id}>
          {user.name}
          <button onClick={() => handleDelete(user.id)} disabled={isPending}>
            Delete
          </button>
        </li>
      ))}
    </ul>
  )
}
```

---

## Pattern 2: tRPC (End-to-End Type Safety)

```typescript
// server/routers/users.ts
import { router, publicProcedure } from '../trpc'
import { z } from 'zod'

export const usersRouter = router({
  list: publicProcedure.query(async ({ ctx }) => {
    return ctx.db.select().from(users)
  }),

  byId: publicProcedure
    .input(z.string())
    .query(async ({ ctx, input }) => {
      return ctx.db.select().from(users).where(eq(users.id, input))
    }),

  create: publicProcedure
    .input(z.object({ name: z.string(), email: z.string().email() }))
    .mutation(async ({ ctx, input }) => {
      return ctx.db.insert(users).values(input).returning()
    }),

  update: publicProcedure
    .input(z.object({ id: z.string(), name: z.string(), email: z.string().email() }))
    .mutation(async ({ ctx, input }) => {
      const { id, ...data } = input
      return ctx.db.update(users).set(data).where(eq(users.id, id))
    }),

  delete: publicProcedure
    .input(z.string())
    .mutation(async ({ ctx, input }) => {
      return ctx.db.delete(users).where(eq(users.id, input))
    }),
})

// Client usage — fully typed, no codegen
const users = trpc.users.list.useQuery()
const createUser = trpc.users.create.useMutation()
await createUser.mutateAsync({ name: 'Max', email: 'max@example.com' })
```

---

## Pattern 3: SurrealDB (Multi-Model CRUD)

```typescript
import Surreal from 'surrealdb'

const db = new Surreal()
await db.connect('ws://localhost:8000/rpc')
await db.use({ namespace: 'app', database: 'main' })

// CREATE — returns the created record with auto-generated ID
const user = await db.create('user', {
  name: 'Max',
  email: 'max@example.com',
  settings: { theme: 'dark', lang: 'de' },
})

// READ — select all or by ID
const allUsers = await db.select('user')
const oneUser = await db.select('user:max123')

// UPDATE — merge (partial) or replace (full)
await db.merge('user:max123', { settings: { theme: 'light' } })

// DELETE
await db.delete('user:max123')

// RELATIONS (graph queries!)
await db.query(`
  RELATE user:max123->follows->user:jane456
  SET since = time::now();
`)

// Query with relations
const result = await db.query(`
  SELECT *, ->follows->user.name AS following
  FROM user:max123;
`)

// LIVE QUERIES (real-time!)
const queryUuid = await db.live('user', (action, result) => {
  console.log(action, result) // CREATE, UPDATE, DELETE events
})
```

---

## Pattern 4: Hono REST API

```typescript
import { Hono } from 'hono'
import { zValidator } from '@hono/zod-validator'
import { z } from 'zod'

const app = new Hono()

const UserSchema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
})

// CRUD routes
app.get('/users', async (c) => {
  const users = await db.select().from(usersTable)
  return c.json(users)
})

app.get('/users/:id', async (c) => {
  const user = await db.select().from(usersTable).where(eq(usersTable.id, c.req.param('id')))
  return user ? c.json(user) : c.notFound()
})

app.post('/users', zValidator('json', UserSchema), async (c) => {
  const data = c.req.valid('json')
  const [user] = await db.insert(usersTable).values(data).returning()
  return c.json(user, 201)
})

app.put('/users/:id', zValidator('json', UserSchema), async (c) => {
  const data = c.req.valid('json')
  await db.update(usersTable).set(data).where(eq(usersTable.id, c.req.param('id')))
  return c.json({ success: true })
})

app.delete('/users/:id', async (c) => {
  await db.delete(usersTable).where(eq(usersTable.id, c.req.param('id')))
  return c.json({ success: true })
})

export default app
```

---

## Pattern 5: Real-Time with NATS

```typescript
import { connect, StringCodec } from 'nats'

const nc = await connect({ servers: 'nats://localhost:4222' })
const sc = StringCodec()

// Publish CRUD events
async function createUser(data: User) {
  const user = await db.insert(users).values(data).returning()
  // Notify all subscribers
  nc.publish('users.created', sc.encode(JSON.stringify(user)))
  return user
}

// Subscribe to changes (e.g., in another service or SSE endpoint)
const sub = nc.subscribe('users.*')
for await (const msg of sub) {
  const event = msg.subject.split('.')[1] // created, updated, deleted
  const data = JSON.parse(sc.decode(msg.data))
  console.log(`User ${event}:`, data)
}

// Request/Reply pattern (synchronous-like)
nc.subscribe('users.get', {
  callback: async (err, msg) => {
    const id = sc.decode(msg.data)
    const user = await db.select().from(users).where(eq(users.id, id))
    msg.respond(sc.encode(JSON.stringify(user)))
  }
})

// Client requesting a user
const response = await nc.request('users.get', sc.encode('user123'), { timeout: 5000 })
const user = JSON.parse(sc.decode(response.data))
```

---

## Form Handling: The Stack

```
Form Library:  React Hook Form (most mature) or Conform (progressive enhancement)
Validation:    Zod (server + client shared schemas)
UI:            shadcn/ui Form component (wraps RHF + Zod)
Tables:        TanStack Table (sorting, filtering, pagination, virtual scroll)
```

### React Hook Form + Zod + shadcn

```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email'),
})

type FormData = z.infer<typeof schema>

export function UserForm({ onSubmit }: { onSubmit: (data: FormData) => void }) {
  const form = useForm<FormData>({ resolver: zodResolver(schema) })

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)}>
        <FormField control={form.control} name="name" render={({ field }) => (
          <FormItem>
            <FormLabel>Name</FormLabel>
            <FormControl><Input {...field} /></FormControl>
            <FormMessage />
          </FormItem>
        )} />
        <FormField control={form.control} name="email" render={({ field }) => (
          <FormItem>
            <FormLabel>Email</FormLabel>
            <FormControl><Input {...field} /></FormControl>
            <FormMessage />
          </FormItem>
        )} />
        <Button type="submit">Save</Button>
      </form>
    </Form>
  )
}
```
