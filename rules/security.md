---
description: Security baseline rules for all code
paths:
  - "**/*"
---

# Security Rules

- Never hardcode API keys, passwords, tokens, or secrets
- Always validate user input at system boundaries
- Use parameterized queries for all database operations (no string concatenation)
- Sanitize output to prevent XSS (escape HTML in user-generated content)
- Check authentication and authorization on every API endpoint
- Use HTTPS for all external API calls
- Never log sensitive data (passwords, tokens, PII)
- Set appropriate CORS headers (never use `*` in production)
- Use secure cookie flags (HttpOnly, Secure, SameSite)
