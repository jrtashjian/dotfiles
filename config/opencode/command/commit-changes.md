---
description: Generate a concise git commit message from staged changes following project conventions.
subtask: true
model: opencode/north-mini-code-free
---

# Generate concise git commit message from staged changes

### Pre-Commit Checks

1. **Detect convention**: Run `git log --oneline -20`. Strictly follow project patterns (Conventional Commits, Jira, etc.).
2. **Stage if needed**: If nothing staged, run `git add -A`.
3. **Atomic check**: Warn if unrelated logical changes; suggest split.

### Message Rules

**Subject** (≤72 chars, ideally <60): Imperative, capitalized, no period. No scope unless convention requires. Completes: "If applied, this commit will _[subject]_".
**Body**: Short *why* only (diff shows *what*). 72-char wrap. Omit if subject sufficient.

### Workflow (minimize steps)

1. **First action only**: Call `bash` tools **in parallel**:
   - `git log --oneline -20`
   - `git diff --cached`
2. Analyze convention + atomicity + intent.
3. Generate concise message (specific, e.g. class/method names matching recent commits).
4. Present **once** via `question` tool (below).
5. Commit **only** on "Yes, use this commit message".

### question tool (single confirmation)

```json
questions: [{
  "header": "Confirm Commit",
  "question": "{proposed message}\n\n---\nDoes this commit message accurately represent the changes?",
  "options": [
    {"label": "Yes, use this commit message", "description": "Proceed with committing"},
    {"label": "Edit message", "description": "Modify the commit message"},
    {"label": "Cancel", "description": "Abort the commit"}
  ]
}]
