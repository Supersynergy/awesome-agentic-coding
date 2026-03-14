---
description: Test writing standards
paths:
  - "**/*test*"
  - "**/*spec*"
  - "tests/**"
  - "__tests__/**"
---

# Test Rules

- Test behavior, not implementation details
- Each test should test exactly one thing
- Use descriptive test names that explain the scenario: `test_returns_404_when_user_not_found`
- Don't mock what you don't own (mock your own interfaces, not third-party libraries)
- Prefer integration tests for database operations over mocking the database
- Tests must be independent — no shared mutable state between tests
- Include both happy path and error path tests
- Don't test private methods directly — test through the public interface
