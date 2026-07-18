---
name: writing-plans
description: "Use ONLY when you have an approved spec or requirements for a multi-step task. Create a detailed, actionable implementation plan before touching any code. Keywords: implementation plan, write plan, detailed plan, before coding, multi-step task."
---

Current git remote:
!`git config --get remote.origin.url`

Current directory:
!`pwd`

# Writing Plans

## Overview

Create comprehensive implementation plans for engineers who have zero context about the codebase. Document everything needed: exact files, code, tests, and commands.

Assume the reader is a skilled developer but knows nothing about our toolset or domain. Provide clear guidance on good test design.

**Always start with:**
"I'm using the writing-plans skill to create the implementation plan."

**Save plans to Obsidian:** Parse the injected git remote and pwd above to determine {org}/{project}. If unclear, choose sensible default like `local/$(basename of pwd)`. Save to:
`~/Documents/Obsidian/Personal Vault/code/{org}/{project}/plans/YYYY-MM-DD-<feature-name>.md`
Always document plans in the Obsidian vault. Never use the question tool.

## Scope Check

If the spec covers multiple independent subsystems, it should have been decomposed during brainstorming. If it wasn't, flag this immediately and recommend breaking it into separate plans (one per subsystem). Each plan must produce working, testable software on its own.

## File Structure (Before Tasks)

First, map out all files that will be created or modified and their single responsibility. Lock in clean decomposition here.

- Favor small, single-purpose files with clear boundaries and well-defined interfaces.
- Follow existing codebase patterns.
- If an existing file has grown unwieldy and affects the current work, include a targeted split in the plan.

## Task Granularity

Every task must be bite-sized (one small action that takes 2–5 minutes). Follow TDD.

**Example pattern for each task:**
- Write failing test
- Run test (verify it fails)
- Write minimal implementation
- Run test (verify it passes)

## Plan Document Header

Every plan MUST begin with this exact header:

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about the chosen approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

Use this exact format for every task. Adapt code examples to the project's language (PHP, JS, TS, Python, etc.).

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.ext`
- Modify: `exact/path/to/existing.ext:123-145`
- Test: `tests/exact/path/to/test.ext`

- [ ] **Step 1: Write the failing test**

```language
// Example test (adapt to your language)
function testSpecificBehavior() {
    const result = functionUnderTest(input);
    assertEquals(result, expected);
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `command-to-run-specific-test`
Expected: FAIL with clear error message

- [ ] **Step 3: Write minimal implementation**

```language
// Example implementation (adapt to your language)
function functionUnderTest(input) {
    return expected;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `command-to-run-specific-test`
Expected: PASS
````

## Hard Rules – No Placeholders

Never include any of these (these are plan failures):
- "TBD", "TODO", "implement later", "fill in details"
- Vague instructions like "add appropriate error handling", "add validation", or "handle edge cases"
- "Write tests for the above" without actual test code
- "Similar to Task N" – repeat the code instead
- Any step that describes *what* to do without showing *how* (code blocks required for code changes)

Every step must contain the exact code, exact commands, and expected output the engineer needs.

## Self-Review (Run After Writing the Full Plan)

1. **Spec coverage**: Verify every requirement in the spec has at least one corresponding task. Add missing tasks if needed.
2. **Placeholder scan**: Search for any forbidden vague language and fix it.
3. **Consistency check**: Ensure types, function names, method signatures, and property names are identical across all tasks.

Fix all issues inline. No need to re-review — just correct and proceed.

## Completion

After saving the plan, say:

> "Plan complete and saved to the Obsidian vault under `.../plans/<filename>.md`."

---

**Key Principles**
- DRY, YAGNI, TDD
- Exact file paths and complete code in every relevant step
- Clear, self-contained tasks that can be executed independently