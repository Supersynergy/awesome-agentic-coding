# UI Component Solutions & CRUD Flow Patterns for 2026

**Last Updated**: March 2026 | **Status**: Production Reference

## Table of Contents
1. [Component Library Ecosystem](#component-library-ecosystem)
2. [CRUD Flow Architectures](#crud-flow-architectures)
3. [Advanced UI Patterns](#advanced-ui-patterns)
4. [Claude Code Integration](#claude-code-integration)
5. [Decision Matrix](#decision-matrix)

---

## Component Library Ecosystem

### Styled Component Libraries

#### **shadcn/ui** (v2 - Unified Radix UI)
- **Status**: Most mature, 2026 March release with CLI v4
- **Latest**: Unified Radix UI package in February 2026
- **Primitives**: Radix UI (180+ components)
- **Styling**: Tailwind CSS first
- **Philosophy**: Copy-paste → full ownership, no dependencies
- **2026 Updates**:
  - **CLI v4**: Inspection flags `--dry-run`, `--diff`, `--view`
  - **Design System Presets**: Visual builder → `npx shadcn@latest init --preset [CODE]`
  - **AI-Ready Docs**: `shadcn docs [component]` fetches official snippets
  - **Framework Support**: Next.js, Vite, TanStack Start, React Router, Astro, Laravel
- **New York style**: Now uses unified radix-ui package
- **Base UI Support**: Alternative to Radix primitives for all blocks
- **Best For**: Full-stack TypeScript apps, teams that want component control
- **Bundle Size**: ~2-5KB per component
- **Accessibility**: WCAG 2.1 AA via Radix primitives

```typescript
// Install with preset
npx shadcn@latest init --preset abc123

// Usage - copy exact component into your codebase
import { Button } from "@/components/ui/button"

export default () => <Button variant="outline">Click me</Button>
```

**Pros**: Maximum control, zero lock-in, huge ecosystem, active community
**Cons**: Copy-paste overhead, must maintain own components, requires Tailwind

---

#### **Origin UI** (Extended shadcn Blocks)
- **Status**: Pre-acquisition collection, limited support
- **Count**: 100+ copy-paste components
- **Base**: Radix UI + shadcn conventions
- **Features**: Accessibility built-in, dark mode out-of-box, regular updates
- **Best For**: Quick scaffolding of application UIs
- **Note**: Maintenance limited after acquisition; use if you can fork/maintain

---

#### **HeroUI** (Formerly NextUI)
- **Status**: Rebranded 2026, no breaking changes
- **Styling**: Tailwind CSS + React Aria
- **Accessibility**: React Aria ensures WCAG compliance
- **Features**:
  - Out-of-box dark theme
  - Full Next.js 15 app directory support
  - Tailwind Variants for slot-based customization
  - No class conflicts
- **Framework**: React-focused
- **Best For**: Modern React apps needing pre-styled components
- **Bundle**: Smaller than Material-UI, larger than shadcn

```typescript
import { Button, Card } from "@heroui/react"

export default () => (
  <Card>
    <Button isLoading color="primary">Loading...</Button>
  </Card>
)
```

**Pros**: Beautiful out-of-box, great defaults, strong accessibility
**Cons**: Less customizable than shadcn, less control, larger bundle

---

#### **Radix Themes**
- **Status**: Actively maintained, February 2026 updates
- **Approach**: Pre-styled, theme-aware components
- **Styling**: Vanilla CSS with CSS variables (no sx prop, no styled-components)
- **Components**: Layout, typography, buttons, cards, forms
- **Customization**: Theme component with color scales
- **Best For**: Teams wanting ready-to-use but customizable components
- **Ecosystem**: Radix Primitives + Radix Colors + Radix Icons

```typescript
import * as Dialog from '@radix-ui/react-dialog'
import { Theme, Button } from '@radix-ui/themes'

export default () => (
  <Theme appearance="dark">
    <Button>Themed Button</Button>
  </Theme>
)
```

**Pros**: Built on proven primitives, good theming, accessible
**Cons**: Opinionated styling, less customization than shadcn

---

#### **DaisyUI** (Tailwind Component Library)
- **Status**: Most popular free Tailwind library, v5.5.19 (March 2026)
- **Count**: 63 components (59 unique)
- **Type**: Pure CSS plugin for Tailwind
- **Framework**: Framework-agnostic (works with React, Vue, Svelte, plain HTML)
- **JavaScript**: Zero JS (unless you add interactions)
- **Themes**: 30+ built-in themes, multiple on same page
- **Downloads**: 611K/week npm, 41K+ GitHub stars
- **Best For**: Simple CRUD apps, content sites, rapid prototyping

```bash
npm install daisyui
```

```javascript
// tailwind.config.js
module.exports = {
  plugins: [require('daisyui')],
  daisyui: { themes: ['light', 'dark'] }
}
```

```html
<button class="btn">Click me</button>
<button class="btn btn-primary">Primary</button>
<div class="card bg-base-100 shadow">
  <div class="card-body">Content</div>
</div>
```

**Pros**: Easiest to learn, zero JS, pure CSS, many themes
**Cons**: Less composable, less control, monolithic classes

---

### Animation & Design Effect Libraries

#### **MagicUI** (Animated Components)
- **Status**: 150+ free animated components, 19K+ GitHub stars
- **Stack**: React, TypeScript, Tailwind CSS, Framer Motion
- **Philosophy**: Copy-paste like shadcn, give ownership
- **Components**: 50+ ready-to-use (animated backgrounds, text effects, cards, transitions)
- **License**: MIT open-source
- **Best For**: Landing pages, marketing sites, eye-catching UIs
- **Pairs Well With**: shadcn/ui (uses same conventions)

```typescript
// Example: Animated List
import { AnimatedList } from "@/components/magicui/animated-list"

export default () => (
  <AnimatedList>
    {items.map(item => <div key={item.id}>{item.name}</div>)}
  </AnimatedList>
)
```

**Pros**: Beautiful animations, shadcn-compatible, no external deps
**Cons**: Animation-heavy, not ideal for data-heavy apps

---

#### **AceternityUI** (Premium Effects)
- **Status**: Free components + Pro membership
- **Stack**: Tailwind CSS, Framer Motion
- **Premium Components**: 3D effects, parallax, aurora backgrounds, hero sections
- **Examples**: 3D Card, Globe, Lamp Effect, Wavy Background, Timeline
- **Pro Features**: Component blocks (hero, pricing, testimonial, blog sections)
- **Best For**: Premium designs, marketing sites, portfolio showcases
- **Pricing**: One-time or subscription for all-access

**Pros**: Stunning visual effects, production-ready blocks
**Cons**: Premium features require subscription, design-first (less CRUD-friendly)

---

### Multi-Framework & Headless Libraries

#### **Park UI** (Multi-Framework: React, Vue, Solid)
- **Status**: Actively maintained 2026
- **Base**: Built on Ark UI + Panda CSS
- **Frameworks**: React, Solid, Vue with consistent APIs
- **Philosophy**: Same component with multiple framework outputs
- **Styling**: Customizable via Panda CSS
- **Best For**: Monorepo projects with multiple frameworks
- **Alternative To**: Chakra UI for Tailwind-first teams

```typescript
// React
import { Button } from '@park-ui/react'

// Same component works in Solid, Vue
// import { Button } from '@park-ui/solid'
// import { Button } from '@park-ui/vue'

export default () => <Button>Click me</Button>
```

**Pros**: Consistent API across frameworks, accessibility built-in
**Cons**: Smaller ecosystem than React-only libraries, Panda CSS learning curve

---

#### **Ark UI** (Framework-Agnostic Primitives)
- **Status**: Chakra UI team, 45+ components, 4+ frameworks
- **Frameworks**: React, Solid, Vue, Svelte
- **Philosophy**: Headless, unstyled, logic-focused
- **Base**: Zag.js state machines (predictable, testable behavior)
- **Styling**: Zero opinions - use Tailwind, Panda CSS, CSS Modules, anything
- **Accessibility**: WCAG compliant, tested with real assistive tech
- **Best For**: Design systems, multi-framework monorepos, custom styling
- **Component Primitives**: Accordion, alert, calendar, checkbox, dialog, etc.

```typescript
import * as Dialog from '@ark-ui/react'

export default () => (
  <Dialog.Root>
    <Dialog.Trigger>Open</Dialog.Trigger>
    <Dialog.Content>
      <Dialog.Title>Dialog Title</Dialog.Title>
      <Dialog.CloseButton />
    </Dialog.Content>
  </Dialog.Root>
)
```

**Pros**: Framework agnostic, fully composable, zero dependencies, type-safe
**Cons**: Requires own styling, steeper learning curve, smaller ecosystem

---

## CRUD Flow Architectures

### Server Actions (Next.js 15) vs REST vs tRPC vs GraphQL

#### **Comparison Table**

| Aspect | Server Actions | REST | tRPC | GraphQL |
|--------|-----------------|------|------|---------|
| **Setup Complexity** | Lowest | Medium | Medium-High | High |
| **Type Safety** | Full (TypeScript) | Partial (manual) | Full (auto) | Full (schema) |
| **Caching** | Built-in (revalidate) | Excellent (HTTP) | Good (custom) | Poor |
| **Client Bundle** | ~0B | ~50-100KB | ~15KB | ~30KB |
| **Learning Curve** | Gentle | Familiar | Steep | Steep |
| **Payload Size** | Small | Small | Small | Medium (overselect) |
| **Real-Time** | SSE/WebSocket | Custom | Custom | Subscriptions |
| **Public APIs** | Not ideal | Ideal | No | Ideal |
| **CRUD Overhead** | Minimal | Significant | Minimal | Medium |
| **Response Time (CRUD)** | 1-2ms | Same | <1ms | 1-3ms |
| **Team Size** | Small (1-5) | Any | Small-Medium (1-10) | Large (10+) |
| **Market 2026** | 45% adoption | 70% | 15% (rising) | 25% (falling) |

**Decision Framework**:
- **Use Server Actions** if: Full-stack TypeScript, Next.js, small team, internal tools
- **Use REST** if: Public API, need broad compatibility, traditional architecture
- **Use tRPC** if: Full-stack TypeScript, internal APIs, maximum type safety
- **Use GraphQL** if: Multiple client types with different data needs, large team

---

#### **Server Actions (Next.js 15)** - Recommended for New Projects

**Architecture**:
```typescript
// app/actions/users.ts
'use server'

import { z } from 'zod'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

const userSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  role: z.enum(['user', 'admin'])
})

export async function createUser(formData: FormData) {
  const data = Object.fromEntries(formData)

  // Server-side validation
  const result = userSchema.safeParse(data)
  if (!result.success) {
    return { error: result.error.flatten() }
  }

  // Database write
  const user = await db.user.create({ data: result.data })

  // Revalidate cache
  revalidatePath('/users')
  redirect(`/users/${user.id}`)
}
```

**Client Usage**:
```typescript
'use client'

import { useActionState } from 'react'
import { createUser } from '@/app/actions/users'

export function CreateUserForm() {
  const [state, formAction, pending] = useActionState(createUser, null)

  return (
    <form action={formAction}>
      <input name="name" required />
      <input name="email" type="email" required />
      <select name="role">
        <option>user</option>
        <option>admin</option>
      </select>
      <button disabled={pending}>
        {pending ? 'Creating...' : 'Create'}
      </button>
      {state?.error && <p>{state.error.message}</p>}
    </form>
  )
}
```

**Key Patterns**:
1. **Validation**: Zod for runtime validation on server
2. **Authorization**: Check `user` session inside action
3. **Revalidation**: `revalidatePath()` before redirect
4. **Errors**: Use SafeParse + custom error shape
5. **Optimistic UI**: React 19's `useOptimistic` handles it
6. **Form Reset**: Automatic on success due to redirect

**Pros**:
- Minimal client-server friction
- Type-safe by default
- Zero API routes needed
- Built-in form handling
- Great for internal tools

**Cons**:
- Not suitable for public APIs
- Can't be called from mobile apps
- Coupling of backend and frontend concerns

---

#### **tRPC** - Full-Stack TypeScript

**Architecture**:
```typescript
// server/routers/user.ts
import { router, publicProcedure } from '../trpc'
import { z } from 'zod'
import { TRPCError } from '@trpc/server'

export const userRouter = router({
  create: publicProcedure
    .input(z.object({
      name: z.string(),
      email: z.string().email(),
    }))
    .mutation(async ({ input, ctx }) => {
      // Optional: auth check
      if (!ctx.user) throw new TRPCError({ code: 'UNAUTHORIZED' })

      return await db.user.create({
        data: input
      })
    }),

  list: publicProcedure
    .query(async ({ ctx }) => {
      return await db.user.findMany()
    }),

  getById: publicProcedure
    .input(z.string())
    .query(async ({ input }) => {
      return await db.user.findUniqueOrThrow({ where: { id: input } })
    }),

  update: publicProcedure
    .input(z.object({
      id: z.string(),
      data: z.object({ name: z.string().optional() })
    }))
    .mutation(async ({ input }) => {
      return await db.user.update({
        where: { id: input.id },
        data: input.data
      })
    }),

  delete: publicProcedure
    .input(z.string())
    .mutation(async ({ input }) => {
      await db.user.delete({ where: { id: input } })
      return { success: true }
    })
})

// server/root.ts
export const appRouter = router({
  user: userRouter
})

export type AppRouter = typeof appRouter
```

**Client Usage**:
```typescript
import { trpc } from '@/utils/trpc'

export function UserList() {
  const { data: users, isLoading } = trpc.user.list.useQuery()
  const createMutation = trpc.user.create.useMutation()

  if (isLoading) return <div>Loading...</div>

  return (
    <div>
      <ul>
        {users?.map(user => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
      <button onClick={() => createMutation.mutate({
        name: 'John',
        email: 'john@example.com'
      })}>
        Create User
      </button>
    </div>
  )
}
```

**Key Patterns**:
1. **Type-Safety**: Automatic inference from server to client
2. **Validation**: Zod for input/output
3. **Caching**: TanStack Query integration (React Query)
4. **Optimistic Updates**: Invalidate/update manually
5. **Error Handling**: TRPCError for typed errors
6. **Real-Time**: Add WebSocket links for subscriptions

**Pros**:
- End-to-end type safety
- Zero manual type definitions
- Perfect for monorepos
- Fast execution (gRPC-like but over HTTP)
- Excellent dev experience

**Cons**:
- TypeScript-only (frontend + backend)
- Not suitable for public APIs
- Smaller ecosystem than GraphQL

---

#### **GraphQL** - When Type Safety Meets Flexibility

**Architecture** (Apollo Server):
```typescript
import { ApolloServer, gql } from 'apollo-server-next'

const typeDefs = gql`
  type User {
    id: ID!
    name: String!
    email: String!
    posts: [Post!]!
  }

  type Post {
    id: ID!
    title: String!
    content: String!
    author: User!
  }

  type Query {
    users: [User!]!
    user(id: ID!): User
    posts: [Post!]!
  }

  type Mutation {
    createUser(name: String!, email: String!): User!
    updateUser(id: ID!, name: String): User
    deleteUser(id: ID!): Boolean!

    createPost(title: String!, content: String!, authorId: ID!): Post!
  }
`

const resolvers = {
  Query: {
    users: async () => await db.user.findMany(),
    user: async (_, { id }) => await db.user.findUnique({ where: { id } }),
    posts: async () => await db.post.findMany({ include: { author: true } })
  },

  Mutation: {
    createUser: async (_, { name, email }) => {
      return await db.user.create({ data: { name, email } })
    },
    updateUser: async (_, { id, name }) => {
      return await db.user.update({ where: { id }, data: { name } })
    },
    deleteUser: async (_, { id }) => {
      await db.user.delete({ where: { id } })
      return true
    }
  },

  User: {
    posts: async (user) => {
      return await db.post.findMany({ where: { authorId: user.id } })
    }
  }
}

export const server = new ApolloServer({ typeDefs, resolvers })
```

**Client Usage** (Apollo Client):
```typescript
import { gql, useMutation, useQuery } from '@apollo/client'

const GET_USERS = gql`
  query GetUsers {
    users {
      id
      name
      email
      posts {
        id
        title
      }
    }
  }
`

const CREATE_USER = gql`
  mutation CreateUser($name: String!, $email: String!) {
    createUser(name: $name, email: $email) {
      id
      name
      email
    }
  }
`

export function UserList() {
  const { data, loading } = useQuery(GET_USERS)
  const [createUser] = useMutation(CREATE_USER)

  if (loading) return <div>Loading...</div>

  return (
    <div>
      <ul>
        {data?.users.map(user => (
          <li key={user.id}>
            {user.name} ({user.posts.length} posts)
          </li>
        ))}
      </ul>
      <button onClick={() => createUser({
        variables: { name: 'John', email: 'john@example.com' }
      })}>
        Create User
      </button>
    </div>
  )
}
```

**Key Patterns**:
1. **Strongly Typed Schema**: SDL (Schema Definition Language)
2. **Resolver Functions**: Handle field resolution, N+1 queries
3. **Validation**: Custom logic or tools like graphql-scalars
4. **Caching**: Apollo Cache with normalization
5. **Batching**: DataLoader for efficient queries
6. **Subscriptions**: Real-time via WebSockets

**Pros**:
- Excellent for multiple client types
- Powerful query language
- Built-in introspection
- Great tooling (DevTools, Codegen)

**Cons**:
- Steep learning curve
- N+1 query problem
- Over-fetching prevention requires discipline
- Larger payload in many cases

---

#### **REST** - Traditional, Proven, Still Relevant

```typescript
// pages/api/users.ts (Next.js)
import type { NextApiRequest, NextApiResponse } from 'next'

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method === 'GET') {
    const users = await db.user.findMany()
    return res.status(200).json({ data: users })
  }

  if (req.method === 'POST') {
    const { name, email } = req.body
    const user = await db.user.create({ data: { name, email } })
    return res.status(201).json({ data: user })
  }

  res.status(405).end()
}

// pages/api/users/[id].ts
export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { id } = req.query

  if (req.method === 'GET') {
    const user = await db.user.findUnique({ where: { id: String(id) } })
    return res.status(200).json({ data: user })
  }

  if (req.method === 'PATCH') {
    const user = await db.user.update({
      where: { id: String(id) },
      data: req.body
    })
    return res.status(200).json({ data: user })
  }

  if (req.method === 'DELETE') {
    await db.user.delete({ where: { id: String(id) } })
    return res.status(204).end()
  }

  res.status(405).end()
}
```

**Client Usage**:
```typescript
async function createUser(name: string, email: string) {
  const res = await fetch('/api/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, email })
  })
  return res.json()
}

async function updateUser(id: string, data: Partial<User>) {
  const res = await fetch(`/api/users/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  })
  return res.json()
}

async function deleteUser(id: string) {
  await fetch(`/api/users/${id}`, { method: 'DELETE' })
}
```

**Pros**:
- Proven, standard, easy to understand
- Excellent caching (HTTP caching)
- Works with any framework/language
- Great for public APIs
- Familiar to most developers

**Cons**:
- Type safety requires manual work
- Multiple endpoints per resource
- Verbose request/response handling
- Over/under-fetching

---

### Form Handling & Validation

#### **React Hook Form + Zod** - Recommended for 2026

```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const userSchema = z.object({
  name: z.string().min(1, 'Name required'),
  email: z.string().email('Invalid email'),
  role: z.enum(['user', 'admin']),
  age: z.number().int().positive().optional()
})

type UserFormData = z.infer<typeof userSchema>

export function UserForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    control
  } = useForm<UserFormData>({
    resolver: zodResolver(userSchema),
    mode: 'onBlur' // Validate on blur for UX
  })

  async function onSubmit(data: UserFormData) {
    // This runs after Zod validation
    const result = await fetch('/api/users', {
      method: 'POST',
      body: JSON.stringify(data)
    })
    // Handle response...
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('name')} />
      {errors.name && <span>{errors.name.message}</span>}

      <input {...register('email')} type="email" />
      {errors.email && <span>{errors.email.message}</span>}

      <select {...register('role')}>
        <option>user</option>
        <option>admin</option>
      </select>

      <button disabled={isSubmitting}>
        {isSubmitting ? 'Submitting...' : 'Submit'}
      </button>
    </form>
  )
}
```

**Patterns**:
- **Client-Side Validation**: Fast UX feedback
- **Server-Side Validation**: Security, always use
- **Mode Options**: `onBlur`, `onChange`, `onSubmit`
- **Watch**: Watch specific fields for dynamic behavior
- **Arrays**: Use `useFieldArray` for dynamic form fields

**Pros**:
- Minimal re-renders
- TypeScript inference from schema
- Zero dependencies overhead
- Great error messages
- Works with any HTTP method

---

#### **Conform** - Progressive Enhancement (Remix/Next.js)

```typescript
// app/actions/user.ts
'use server'

import { parseWithZod } from '@conform-to/zod'
import { userSchema } from '@/schemas'

export async function createUser(formData: FormData) {
  const submission = parseWithZod(formData, {
    schema: userSchema
  })

  if (submission.status !== 'success') {
    return submission.reply()
  }

  // Create user...
  return { success: true }
}
```

```typescript
// components/UserForm.tsx
'use client'

import { useFormAction, useFormStatus } from 'react-dom'
import { useForm } from '@conform-to/react'
import { createUser } from '@/app/actions/user'

export function UserForm() {
  const [form, fields] = useForm({
    onValidate({ formData }) {
      // Optional client-side validation
    }
  })
  const { pending } = useFormStatus()

  return (
    <form {...form.props} action={createUser}>
      <input {...conform.input(fields.name)} />
      <div>{fields.name.errors}</div>

      <input {...conform.input(fields.email)} type="email" />
      <div>{fields.email.errors}</div>

      <button disabled={pending}>Submit</button>
    </form>
  )
}
```

**Key Feature**: Server-side validation with client-side error display, no hydration mismatch

---

#### **Superforms** - SvelteKit Standard

```svelte
<script lang="ts">
  import { superForm } from 'sveltekit-superforms'
  import { zodClient } from 'sveltekit-superforms/adapters'
  import { userSchema } from '$lib/schemas'

  let data = $props() // From load function
  const form = superForm(data.form, {
    validators: zodClient(userSchema)
  })

  const { form: formData, enhance, errors } = form
</script>

<form method="POST" use:enhance>
  <input name="name" bind:value={$formData.name} />
  {#if $errors.name}
    <span>{$errors.name}</span>
  {/if}

  <button>Submit</button>
</form>
```

**Note**: Superforms is SvelteKit-specific, not for React

---

### Data Tables (TanStack Table / React Table)

**Advanced Patterns**:

```typescript
import {
  useReactTable,
  getCoreRowModel,
  getPaginationRowModel,
  getSortedRowModel,
  getFilteredRowModel,
  ColumnDef
} from '@tanstack/react-table'

type User = {
  id: string
  name: string
  email: string
  role: 'user' | 'admin'
}

const columns: ColumnDef<User>[] = [
  {
    accessorKey: 'name',
    header: 'Name',
    cell: info => info.getValue()
  },
  {
    accessorKey: 'email',
    header: 'Email'
  },
  {
    accessorKey: 'role',
    header: 'Role',
    cell: info => <Badge>{info.getValue()}</Badge>
  },
  {
    id: 'actions',
    cell: ({ row }) => (
      <DropdownMenu>
        <button onClick={() => handleEdit(row.original.id)}>Edit</button>
        <button onClick={() => handleDelete(row.original.id)}>Delete</button>
      </DropdownMenu>
    )
  }
]

export function DataTable({ users }: { users: User[] }) {
  const [sorting, setSorting] = useState<SortingState>([])
  const [columnFilters, setColumnFilters] = useState<ColumnFiltersState>([])

  const table = useReactTable({
    data: users,
    columns,
    state: { sorting, columnFilters },
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    getPaginationRowModel: getPaginationRowModel()
  })

  return (
    <div>
      {/* Filters */}
      <input
        placeholder="Filter by name..."
        onChange={e => table.getColumn('name')?.setFilterValue(e.target.value)}
      />

      {/* Table */}
      <table>
        <thead>
          {table.getHeaderGroups().map(headerGroup => (
            <tr key={headerGroup.id}>
              {headerGroup.headers.map(header => (
                <th
                  key={header.id}
                  onClick={header.column.getToggleSortingHandler()}
                >
                  {header.isPlaceholder
                    ? null
                    : flexRender(header.column.columnDef.header, header.getContext())}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody>
          {table.getRowModel().rows.map(row => (
            <tr key={row.id}>
              {row.getVisibleCells().map(cell => (
                <td key={cell.id}>
                  {flexRender(cell.column.columnDef.cell, cell.getContext())}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>

      {/* Pagination */}
      <div>
        <button onClick={() => table.previousPage()}>Previous</button>
        <span>{table.getState().pagination.pageIndex + 1}</span>
        <button onClick={() => table.nextPage()}>Next</button>
      </div>
    </div>
  )
}
```

**Key Patterns**:
1. **Headless**: You own the markup completely
2. **Sorting**: Click column headers
3. **Filtering**: Server or client-side
4. **Pagination**: Built-in or manual
5. **Selection**: Row checkboxes with state
6. **Virtual Scrolling**: Combine with TanStack Virtual

---

### Real-Time Patterns

#### **Server-Sent Events (SSE) - 95% of Cases**

**When to use**: Dashboards, notifications, feeds, logs, any one-way server→client

```typescript
// app/api/notifications/route.ts (Next.js)
export async function GET(request: Request) {
  const encoder = new TextEncoder()
  let subscription: Subscription | null = null

  const customReadable = new ReadableStream({
    async start(controller) {
      // Subscribe to events
      subscription = await db.notifications.subscribe(user.id, (event) => {
        controller.enqueue(
          encoder.encode(`data: ${JSON.stringify(event)}\n\n`)
        )
      })
    },
    cancel() {
      subscription?.unsubscribe()
    }
  })

  return new Response(customReadable, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive'
    }
  })
}
```

```typescript
// Client
export function NotificationClient() {
  useEffect(() => {
    const eventSource = new EventSource('/api/notifications')

    eventSource.onmessage = (event) => {
      const notification = JSON.parse(event.data)
      toast.info(notification.message)
    }

    eventSource.onerror = () => {
      eventSource.close()
      // Reconnect logic
    }

    return () => eventSource.close()
  }, [])

  return null
}
```

**Pros**: Simple, unidirectional, HTTP standard, great for most cases
**Cons**: No client→server messaging

---

#### **WebSockets - Real Collaboration**

**When to use**: Trading systems, multiplayer editors, live chat, CRM live updates

```typescript
// app/api/websocket.ts (Upgrading HTTP to WS)
import { WebSocketServer } from 'ws'

const wss = new WebSocketServer({ noServer: true })

export default function handler(req: any, socket: any, head: any) {
  if (req.url === '/api/ws') {
    wss.handleUpgrade(req, socket, head, (ws) => {
      ws.on('message', (message) => {
        const data = JSON.parse(message)

        // Broadcast to all clients
        wss.clients.forEach(client => {
          if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify({
              type: 'update',
              payload: data
            }))
          }
        })
      })
    })
  }
}
```

```typescript
// Client (Socket.io or ws)
const socket = io('/api/ws')

socket.on('update', (data) => {
  console.log('Received:', data)
})

socket.emit('user:typing', { userId: me.id, status: 'typing' })
```

**Pros**: Bidirectional, low-latency, perfect for collaboration
**Cons**: Harder to scale, connection management, more resource-intensive

---

#### **NATS Streaming** - Microservices

```typescript
// Pub
const nc = await connect({ servers: 'nats://localhost:4222' })
const js = nc.jetstream()

await js.publish('orders.created', JSON.stringify({
  orderId: '123',
  userId: 'user-1',
  total: 99.99
}))

// Sub
const sub = await js.subscribe('orders.created')
for await (const msg of sub) {
  const order = JSON.parse(new TextDecoder().decode(msg.data))
  // Process order
  msg.ack()
}
```

**Use Case**: Event sourcing, order processing, microservices communication

---

### Optimistic Updates Pattern

```typescript
'use client'

import { useOptimistic, useTransition } from 'react'
import { updateUserAction } from '@/app/actions/users'

export function UserCard({ user }: { user: User }) {
  const [optimisticUser, addOptimisticUpdate] = useOptimistic(
    user,
    (state, newName: string) => ({
      ...state,
      name: newName
    })
  )
  const [pending, startTransition] = useTransition()

  async function handleNameChange(newName: string) {
    // Update UI immediately
    addOptimisticUpdate(newName)

    // Call server
    startTransition(async () => {
      const result = await updateUserAction(user.id, { name: newName })

      // If error, useOptimistic automatically rolls back
      if (!result.ok) {
        toast.error('Failed to update')
      }
    })
  }

  return (
    <div>
      <h2>{optimisticUser.name}</h2>
      <input
        defaultValue={optimisticUser.name}
        onChange={e => handleNameChange(e.target.value)}
        disabled={pending}
      />
    </div>
  )
}
```

**Benefits**:
- Users see updates instantly
- Automatic rollback on error
- Works with React 18+
- No manual error handling needed

---

## Advanced UI Patterns

### Command Palette (cmdk + AI)

```typescript
import { Command } from 'cmdk'
import { Search } from 'lucide-react'

export function CommandPalette() {
  const [open, setOpen] = useState(false)

  useEffect(() => {
    const down = (e: KeyboardEvent) => {
      if (e.key === 'k' && (e.metaKey || e.ctrlKey)) {
        e.preventDefault()
        setOpen(open => !open)
      }
    }

    document.addEventListener('keydown', down)
    return () => document.removeEventListener('keydown', down)
  }, [])

  return (
    <Command.Dialog open={open} onOpenChange={setOpen}>
      <Command.Input
        placeholder="Search or ask..."
        icon={<Search />}
      />
      <Command.List>
        <Command.Empty>No results found.</Command.Empty>

        <Command.Group heading="Navigation">
          <Command.Item onSelect={() => router.push('/users')}>
            Users
          </Command.Item>
          <Command.Item onSelect={() => router.push('/settings')}>
            Settings
          </Command.Item>
        </Command.Group>

        <Command.Group heading="Actions">
          <Command.Item onSelect={handleNewUser}>
            Create new user
          </Command.Item>
          <Command.Item onSelect={handleExport}>
            Export data
          </Command.Item>
        </Command.Group>
      </Command.List>
    </Command.Dialog>
  )
}
```

**AI Integration** (better-cmdk):
```typescript
import { BetterCmdk } from 'better-cmdk'

export function AICommandPalette() {
  return (
    <BetterCmdk
      actions={[
        { id: 'create-user', label: 'Create new user', perform: handleCreate },
        { id: 'delete-user', label: 'Delete user', perform: handleDelete }
      ]}
      onAsk={async (question) => {
        // Call your LLM endpoint
        const response = await fetch('/api/ask', {
          method: 'POST',
          body: JSON.stringify({ question })
        })
        return response.json()
      }}
    />
  )
}
```

---

### Drag & Drop (dnd-kit)

```typescript
import { DndContext, closestCenter, KeyboardSensor, PointerSensor, useSensor, useSensors } from '@dnd-kit/core'
import { arrayMove, SortableContext, sortableKeyboardCoordinates, verticalListSortingStrategy } from '@dnd-kit/sortable'
import { useSortable } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'

function SortableItem({ id, task }: { id: string; task: Task }) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging
  } = useSortable({ id })

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  }

  return (
    <div ref={setNodeRef} style={style} {...attributes} {...listeners}>
      <div className="grip">⋮⋮</div>
      <span>{task.title}</span>
    </div>
  )
}

export function TaskList({ tasks }: { tasks: Task[] }) {
  const [items, setItems] = useState(tasks)
  const sensors = useSensors(
    useSensor(PointerSensor),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  )

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event

    if (over && active.id !== over.id) {
      setItems(items => {
        const oldIndex = items.findIndex(item => item.id === active.id)
        const newIndex = items.findIndex(item => item.id === over.id)
        return arrayMove(items, oldIndex, newIndex)
      })
    }
  }

  return (
    <DndContext sensors={sensors} collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
      <SortableContext items={items} strategy={verticalListSortingStrategy}>
        {items.map(task => (
          <SortableItem key={task.id} id={task.id} task={task} />
        ))}
      </SortableContext>
    </DndContext>
  )
}
```

---

### Virtual Scrolling (TanStack Virtual)

```typescript
import { useVirtualizer } from '@tanstack/react-virtual'

export function VirtualList({ items }: { items: Item[] }) {
  const parentRef = useRef<HTMLDivElement>(null)

  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 35, // Row height
    overscan: 10 // Buffer rows
  })

  const virtualItems = virtualizer.getVirtualItems()

  return (
    <div
      ref={parentRef}
      style={{
        height: '500px',
        overflow: 'auto'
      }}
    >
      <div
        style={{
          height: `${virtualizer.getTotalSize()}px`,
          width: '100%',
          position: 'relative'
        }}
      >
        {virtualItems.map(virtualItem => (
          <div
            key={virtualItem.key}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualItem.size}px`,
              transform: `translateY(${virtualItem.start}px)`
            }}
          >
            <div>{items[virtualItem.index]?.name}</div>
          </div>
        ))}
      </div>
    </div>
  )
}
```

**Use Case**: Lists with 1000+ items without performance degradation

---

### State Machines (XState v5)

```typescript
import { setup, assign } from 'xstate'

const userMachine = setup({
  types: {
    context: {} as { userId: string; error: string | null },
    events: {} as
      | { type: 'FETCH' }
      | { type: 'RETRY' }
      | { type: 'CANCEL' }
  }
}).createMachine({
  id: 'user-fetcher',
  initial: 'idle',
  context: { userId: '1', error: null },
  states: {
    idle: {
      on: { FETCH: 'loading' }
    },
    loading: {
      invoke: {
        src: async ({ context }) => {
          const res = await fetch(`/api/users/${context.userId}`)
          if (!res.ok) throw new Error('Failed to fetch')
          return res.json()
        },
        onDone: {
          target: 'success',
          actions: assign({ error: null })
        },
        onError: {
          target: 'error',
          actions: assign({ error: (_, event) => event.error.message })
        }
      },
      on: { CANCEL: 'idle' }
    },
    success: {
      on: { FETCH: 'loading' }
    },
    error: {
      on: { RETRY: 'loading' }
    }
  }
})

export function UserFetcher() {
  const [state, send] = useActor(userMachine)

  return (
    <div>
      {state.matches('idle') && (
        <button onClick={() => send({ type: 'FETCH' })}>Load</button>
      )}
      {state.matches('loading') && <div>Loading...</div>}
      {state.matches('success') && <div>Success!</div>}
      {state.matches('error') && (
        <div>
          Error: {state.context.error}
          <button onClick={() => send({ type: 'RETRY' })}>Retry</button>
        </div>
      )}
    </div>
  )
}
```

**Benefits**:
- Predictable state transitions
- Visual debugging (XState Studio)
- TypeScript state safety
- Complex workflows made simple

---

## Claude Code Integration

### File Organization for Maximum Claude.AI Success

**Structure that Claude understands**:

```
your-project/
├── .claude/
│   ├── CLAUDE.md          # Project conventions & patterns
│   ├── rules/
│   │   ├── components.md  # Component library rules
│   │   └── forms.md       # Form patterns & conventions
│   └── skills/            # Custom slash commands
├── .claudeignore          # Exclude node_modules, .next, etc.
├── docs/
│   ├── ARCHITECTURE.md    # System design
│   ├── UI_AND_CRUD.md     # This file
│   └── DATABASE.md        # Schema & queries
├── src/
│   ├── app/               # Next.js app directory
│   ├── components/        # shadcn/ui + custom
│   │   ├── ui/            # shadcn components (don't edit)
│   │   ├── forms/         # Form wrappers
│   │   └── layouts/       # Page layouts
│   ├── lib/
│   │   ├── hooks.ts       # Custom hooks
│   │   ├── utils.ts       # Utilities
│   │   └── trpc.ts        # tRPC config
│   ├── actions/           # Server Actions
│   ├── schema/            # Zod schemas
│   └── types/             # TypeScript types
└── tests/
    ├── components/        # Component tests
    └── actions/           # Server Action tests
```

---

### CLAUDE.md Template for UI Projects

```markdown
# Project Convention Guide

## Component Library

- **UI Framework**: shadcn/ui v2 (Radix UI primitives)
- **Styling**: Tailwind CSS 3.4+
- **Animations**: Framer Motion (when needed)
- **Forms**: React Hook Form + Zod
- **Data Tables**: TanStack Table v8
- **Installation**: `npx shadcn-ui@latest add [component]`

## File Patterns

### Components
- Organize by feature, not layer
- One component per file
- Suffix: `.tsx` for client, leave off for server
- No index files (explicit imports)

```typescript
// ✅ Good
src/components/users/user-card.tsx
src/components/users/user-form.tsx
src/components/users/user-list.tsx

// ❌ Avoid
src/components/index.tsx
src/components/UserCard/index.tsx
```

### Server Actions
- Location: `src/app/actions/` or `src/server/actions/`
- One action per file
- Always `'use server'` directive
- Always validate with Zod

```typescript
// src/app/actions/users.ts
'use server'

import { userSchema } from '@/schema/users'

export async function createUser(formData: FormData) {
  const data = userSchema.parse(Object.fromEntries(formData))
  // ...
}
```

### Schemas
- Location: `src/schema/`
- One per resource
- Use Zod for runtime validation

```typescript
// src/schema/users.ts
import { z } from 'zod'

export const userSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  role: z.enum(['user', 'admin'])
})
```

## Form Patterns

All forms use React Hook Form + Zod:

```typescript
const {
  register,
  handleSubmit,
  formState: { errors, isSubmitting }
} = useForm({
  resolver: zodResolver(schema),
  mode: 'onBlur'
})
```

## CRUD Patterns

- CREATE: Server Action + redirect
- READ: React Query or Server Components
- UPDATE: Optimistic update + revalidatePath
- DELETE: Confirmation modal + action

## Testing Commands

\`\`\`bash
npm run dev           # Start dev server
npm run build         # Production build
npm run test          # Run tests
npm run test:ui       # UI tests
\`\`\`

## Key Files to Review

- `.env.local` — Database, API keys
- `src/schema/` — All validation schemas
- `src/app/layout.tsx` — App shell
- `src/components/ui/` — shadcn components (don't edit)
```

---

### Key Patterns Claude Should Understand

**When giving Claude context about your project**:

1. **Component Dependencies**: Clearly list which components use shadcn/ui
2. **Form Submission Flow**: Map client → action → database → revalidate
3. **Error Boundaries**: Show error handling patterns
4. **Type Safety**: Use Zod + TypeScript inference explicitly
5. **Async Boundaries**: Clearly mark server vs client components

**Example context injection for Claude**:

```markdown
## Current State

We're building a user management page with:
- Table: TanStack Table (sorting, pagination, filtering)
- Create Modal: React Hook Form + Zod validation
- Row Actions: Edit/delete dropdowns with optimistic updates
- Real-time: SSE for notification badges

## Schemas (in src/schema/users.ts)
\`\`\`typescript
export const userSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  role: z.enum(['user', 'admin'])
})
\`\`\`

## Server Actions (in src/app/actions/users.ts)
- createUser(formData): Creates + redirects
- updateUser(id, data): Updates + revalidates
- deleteUser(id): Deletes with confirmation

## Next Step
Claude should create the UpdateUserForm component that:
1. Pre-fills with existing user data
2. Validates with userSchema
3. Calls updateUser action
4. Shows optimistic updates
5. Redirects on success
```

---

### Claude Code Skills for UI Projects

Create custom slash commands for repetitive tasks:

**`.claude/skills/new-form.md`**:
```markdown
---
name: new-form
description: Generate a new form component with validation
argument-hint: "ComponentName"
allowed-tools: [Write, Read, Bash]
---

# Generate Form Component

Create a new form component `$ARGUMENTS[0]` that:
1. Uses React Hook Form + Zod
2. Includes proper error display
3. Has loading state
4. Includes TypeScript types

Read the existing form components in `src/components/forms/` to match the style.
```

**`.claude/skills/add-component.md`**:
```markdown
---
name: add-component
description: Add a new shadcn/ui component
argument-hint: "component-name"
---

Install and document a new shadcn/ui component.

1. Install: `npx shadcn-ui@latest add $ARGUMENTS[0]`
2. Document: Update `docs/COMPONENTS.md`
```

---

## Decision Matrix

### Choosing Your Stack (2026)

| Project Type | UI Library | Form Handling | Data Fetching | State |
|--------------|-----------|---------------|---------------|-------|
| **Internal Tool** | shadcn/ui | React Hook Form + Zod | Server Actions | TanStack Query |
| **SaaS App** | shadcn/ui | React Hook Form + Zod | tRPC | TanStack Query |
| **Marketing Site** | DaisyUI | Conform | REST | useState |
| **Real-time App** | HeroUI | React Hook Form | WebSocket | XState + TanStack Query |
| **Multi-framework** | Park UI | Conform | REST | Zustand (Vue) / Pinia (Svelte) |
| **Public API** | N/A | Postman | REST/GraphQL | N/A |
| **Design-focused** | MagicUI + Aceternity | N/A | N/A | N/A |

---

### Speed Ranking (2026)

**Fastest to Ship**:
1. **Server Actions + shadcn/ui** — Zero API boilerplate
2. **REST + React Hook Form** — Familiar, proven
3. **tRPC + Server Actions** — Maximum type safety

**Most Maintainable**:
1. **GraphQL** — Schema as documentation
2. **tRPC** — End-to-end type safety
3. **Server Actions** — Minimal abstraction

**Most Scalable**:
1. **GraphQL** — Multiple client types
2. **REST** — CDN-friendly, standard
3. **tRPC** — Limited to TypeScript monorepos

---

### Performance Comparison

| Aspect | shadcn/ui | HeroUI | DaisyUI | Park UI |
|--------|-----------|--------|---------|---------|
| **Bundle Size** | ~5KB/comp | ~15KB | ~2KB | ~8KB |
| **Bundle Impact** | Incremental | Monolithic | Minimal | Medium |
| **CSS-in-JS** | No | Yes | No | Via Panda |
| **Customization** | Maximum | Good | Limited | Good |
| **Accessibility** | WCAG 2.1 AA | WCAG 2.1 AA | Good | WCAG 2.1 AA |
| **Theming** | CSS classes | Built-in | Built-in | Panda tokens |
| **Dark Mode** | Native | Native | Native | Native |

---

## Summary: 2026 Best Practices

### For New Projects
- **Use**: Next.js 15 + Server Actions + shadcn/ui + React Hook Form
- **Why**: Minimal boilerplate, full type safety, zero-dep components
- **Stack**: `npx create-next-app@latest --typescript --tailwind`

### For Existing React Apps
- **Use**: tRPC + shadcn/ui + TanStack Query
- **Why**: Full type safety, familiar hooks, great DX
- **Migration**: Gradual, can coexist with REST

### For Teams with Multiple Frameworks
- **Use**: Ark UI + Park UI + REST
- **Why**: Consistent primitives across frameworks

### For Public APIs
- **Use**: GraphQL or REST
- **Why**: Standard, interoperable, predictable

### For Real-Time Collaboration
- **Use**: WebSockets + XState + shadcn/ui
- **Why**: Bidirectional, predictable state, beautiful UI

---

## Resources

- [shadcn/ui Docs](https://ui.shadcn.com/)
- [Next.js 15 Docs](https://nextjs.org/docs)
- [React Hook Form Docs](https://react-hook-form.com/)
- [TanStack Docs](https://tanstack.com/)
- [Zod Docs](https://zod.dev/)
- [Framer Motion Docs](https://www.framer.com/motion/)
- [XState Docs](https://stately.ai/docs/xstate)

---

**Last verified**: March 2026 | **Maintained by**: Claude Code
