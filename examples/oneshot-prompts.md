# 10 Proven One-Shot Prompt Templates

These prompts are designed to produce production-quality results in 1-2 turns.
Use with `/oneshot` skill or directly.

---

## 1. Bug Fix (Known Location)
```
Fix the bug in [file:line]. The issue is [symptom].
Expected: [expected behavior]. Actual: [actual behavior].
Run tests after fixing.
```

## 2. Bug Fix (Unknown Location)
```
There's a bug: [describe symptom]. I don't know where it is.
Search the codebase, find the root cause, fix it, and run tests.
Don't fix symptoms — find the actual cause.
```

## 3. New Feature (Simple)
```
Add [feature] to [file/component]. Follow the existing pattern
in [similar feature file] exactly. Run tests after.
```

## 4. New Feature (Complex)
```
I need [feature]. Before coding:
1. Read the relevant files
2. Show me a plan (which files change, what's the approach)
3. Wait for my approval
Then implement and run tests.
```

## 5. Refactor
```
Refactor [target] to [goal]. Run tests before AND after.
Don't change behavior — only structure. Keep the diff minimal.
```

## 6. Add Tests
```
Add tests for [file/function]. Cover:
- Happy path (normal usage)
- Edge cases (empty, null, boundary values)
- Error cases (invalid input, failures)
Follow existing test patterns in [test file].
```

## 7. API Endpoint
```
Add [METHOD] /api/[path] endpoint. It should:
- Accept: [input schema]
- Validate: [validation rules]
- Return: [output schema]
- Errors: [error cases]
Follow the pattern in [existing endpoint file]. Add tests.
```

## 8. Database Migration
```
Add [column/table/index] to the database. Create migration,
update the model, update any queries that need it.
Test with existing data — don't break current records.
```

## 9. Performance Fix
```
[operation] is slow ([current time]). Investigate why:
1. Profile/measure the bottleneck
2. Show me what's slow and why
3. Fix it
4. Measure again to confirm improvement
```

## 10. Code Review Response
```
Address these code review comments on [PR/branch]:
[paste comments]
For each comment: fix it if valid, explain why not if invalid.
Run tests after all changes.
```

---

## Meta-Prompt: Make Any Task One-Shot

Wrap any task with this template for better results:

```
Context: [what the project does, what part you're working on]
Task: [exactly what to do]
Constraints: [what NOT to do, what to preserve]
Verification: [how to know it worked — tests, curl, visual check]
Pattern: [reference an existing file that does something similar]
```

The more specific your constraints and verification, the fewer iterations needed.
