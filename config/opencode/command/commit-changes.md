---
description: Generate a high-quality, well-structured git commit message from staged changes following project conventions and best practices. Confirm with user before committing.
---

Generate a professional git commit message from the staged changes.

### Pre-Commit Checks
1. **Detect Project Convention First** (always do this):
   - Run `git log --oneline -20` to analyze recent commit patterns.
   - If the project follows a clear convention (e.g., Conventional Commits with `type(scope): subject`, Jira tickets, etc.), **strictly follow that convention**.
   - Project convention always takes precedence over defaults below.

2. **Check Staged Changes**:
   - If nothing is staged, automatically run `git add -A` first, then proceed.

3. **Atomic Commit Validation**:
   - Analyze the staged changes (`git diff --staged`).
   - If the changes clearly represent multiple unrelated logical changes (e.g., contains "and" logic in potential subject, mixes refactoring + features, unrelated files), **warn the user** and suggest splitting into multiple commits.

### Commit Message Rules (Default when no strong project convention)

**Subject Line** (first line):
- Completes the sentence: "If applied, this commit will _[subject]_"
- Imperative mood (Add, Fix, Refactor, Remove, Update, etc.)
- First word capitalized
- Maximum 72 characters (ideally under 50-60 for readability)
- No trailing period
- No scope prefix unless project uses Conventional Commits
- Meaningful and standalone

**Body** (after blank line):
- Explain **why** the change was made, not just what was changed.
- Describe effects, context, and any limitations.
- Wrap lines at 72 characters.
- Use blank line after subject (critical for tools).
- Add issue references (Fixes #123, etc.) only if project commonly uses them — place at the end of the body on their own lines.

**Summary of Staged Changes**:
`git diff --staged --name-only` + `git diff --staged`

### Workflow:
1. Analyze recent commits + staged diff.
2. Generate a high-quality commit message following the rules above.
3. Present the **full proposed commit message** (subject + body) to the user using the `question` tool with **exactly these three options**.

Only proceed with the commit if the user selects "Yes, use this commit message".

---

### How the `question` tool should be called:

```
text: |
  {{ proposed_full_commit_message }}

  ---
  Does this commit message accurately represent the changes and follow best practices?
options:
  - Yes, use this commit message
  - Edit message
  - Cancel
```

**Note**: When user selects "Edit message", you should ask for their desired changes and regenerate accordingly.