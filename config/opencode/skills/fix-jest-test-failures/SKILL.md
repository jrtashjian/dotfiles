---
name: fix-jest-test-failures
description: Runs Jest tests silently and returns only failing test details. Empty output means all tests are passing. Re-run only after meaningful fixes.
---

# Fix Jest Test Failures

## Purpose
This skill executes the full Jest test suite in a clean, silent mode. It returns structured details **only** for failing tests. No output means the test suite is fully passing.

## Test Command
```bash
npx jest --silent --forceExit --noStackTrace --json 2>/dev/null | jq '.testResults[] | select(.status == "failed") | {
  file: (.name),
  failed: [.assertionResults[] | select(.status == "failed") | {
    test: .title,
    error: (.failureMessages[0] | split("\n")[0])
  }]
}'
```

## Workflow

1. **Execute Tests**
   - Run the command above
   - Return the exact raw output

2. **Interpret Results**
   - **No output** → All tests are passing. Confirm success.
   - **Output present** → Failing tests exist. Provide the details clearly.

3. **Fix & Validate**
   - Analyze the failures and implement fixes.
   - Re-run this skill **only after making changes that are likely to resolve the failing tests**.
   - Avoid running the full test suite after every small edit, as it is time-consuming.

## Instructions for You

- Use this skill to validate the test suite after implementing meaningful fixes.
- Do not re-run this skill after every minor code change — it is expensive in time.
- Re-run the skill once you believe the current set of changes should resolve the reported failures.
- Focus on minimal, targeted fixes that address the root cause.

## Success Criteria
The skill returns **no output** (empty result). This confirms:
- `numFailedTests == 0`
- `numFailedTestSuites == 0`

At this point, confirm that the test suite is now passing.