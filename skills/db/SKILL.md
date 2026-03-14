---
name: db
description: Database operations via CLI. Replaces Postgres/SurrealDB MCP (saves 3,000-8,000 tokens). Supports PostgreSQL, SurrealDB, SQLite.
argument-hint: <query or operation, e.g. "show all users" or "list tables" or "describe schema">
allowed-tools: [Bash, Read, Grep]
model: haiku
---

# Database CLI Operations

Execute database operations for: $ARGUMENTS

## Step 1: Detect Database
Check these files to find the database connection:
- `.env` / `.env.local` for `DATABASE_URL`
- `docker-compose.yml` for database services
- `drizzle.config.ts` / `prisma/schema.prisma` for ORM config

## Step 2: Execute Query

### PostgreSQL
```bash
# Connect
psql "$DATABASE_URL" -c "YOUR QUERY"

# Exploration
psql "$DATABASE_URL" -c "\dt"                    # List tables
psql "$DATABASE_URL" -c "\d tablename"           # Describe table
psql "$DATABASE_URL" -c "\di"                    # List indexes

# Queries (always LIMIT!)
psql "$DATABASE_URL" -c "SELECT * FROM users LIMIT 10"
psql "$DATABASE_URL" -c "SELECT count(*) FROM users"
```

### SurrealDB
```bash
# Via HTTP API (most reliable)
curl -s http://localhost:8000/sql \
  -H "Accept: application/json" \
  -H "NS: app" -H "DB: main" \
  -u "root:root" \
  --data "SELECT * FROM user LIMIT 10;"

# Via CLI
surreal sql --endpoint http://localhost:8000 \
  --namespace app --database main \
  --username root --password root \
  --query "INFO FOR DB;"
```

### SQLite
```bash
sqlite3 path/to/db.sqlite ".tables"
sqlite3 path/to/db.sqlite ".schema tablename"
sqlite3 path/to/db.sqlite "SELECT * FROM users LIMIT 10"
```

## Safety Rules
- NEVER run DELETE, DROP, TRUNCATE, or ALTER without explicit user confirmation
- Always add LIMIT to SELECT queries (default: 20)
- Never expose passwords or connection strings in output
- For writes, show the query first and ask before executing
- Use READ-ONLY connections when just exploring (add `?sslmode=require&options=-c default_transaction_read_only=on` for Postgres)
