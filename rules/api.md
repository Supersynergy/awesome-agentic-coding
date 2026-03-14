---
description: API design standards
paths:
  - "src/api/**"
  - "api/**"
  - "routes/**"
  - "endpoints/**"
---

# API Rules

- All endpoints must validate input (use Zod, Pydantic, or equivalent)
- Return consistent error format: `{ error: { code, message, details? } }`
- Include proper HTTP status codes (don't use 200 for errors)
- Paginate list endpoints (default limit, max limit)
- Log request metadata (method, path, duration, status) but not request bodies
- Rate limit public endpoints
- Version APIs in the URL path (`/api/v1/...`)
