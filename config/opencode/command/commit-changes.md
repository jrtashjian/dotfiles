---
description: Generate a concise git commit message from staged changes following project conventions. Confirm with user before committing.
---

Generate a concise git commit message from the staged changes.

### Pre-Commit Checks
1. **Detect Project Convention**: Run `git log --oneline -20` to analyze recent patterns. If the project follows a clear convention (e.g., Conventional Commits, Jira tickets), **strictly follow it** — it takes precedence over defaults below.

2. **Stage Changes**: If nothing is staged, automatically run `git add -A`, then proceed.

3. **Atomic Commit Validation**: If staged changes represent multiple unrelated logical changes, **warn the user** and suggest splitting into multiple commits.

### Commit Message Rules (Default)

**Subject Line** (first line):
- Imperative mood, capitalized, no trailing period
- Maximum 72 characters, ideally under 60
- No scope prefix unless project convention requires it
- Completes: "If applied, this commit will _[subject]_"

**Body** (after blank line):
- Keep it **short** — explain *why*, not *what* (the diff shows what)
- Wrap at 72 characters
- Skip the body entirely if the subject alone is sufficient

### Workflow
1. Analyze recent commits + staged diff.
2. Generate a commit message — keep it concise.
3. Present the proposed message to the user using the `question` tool.

### Using the `question` tool

Call the tool with `questions` as an array of question objects. Each object has these fields:

| Field | Type | Description |
|---|---|---|
| `header` | string | Very short label (max 30 chars) |
| `question` | string | Complete question |
| `options` | array | Available choices; each has `label` (1-5 words, concise) and `description` (explanation of choice) |
| `multiple` | boolean (optional) | Allow selecting multiple choices |
| `custom` | boolean (optional, default `true`) | Allow typing a custom answer |

Answers are returned as `Array<Array<string>>` — each question's answer is an array of selected option labels. Since `custom` defaults to `true`, users can always type a custom response. For multi-question flows, users can navigate between questions before submitting.

For the commit confirmation, use a single question:

```
questions: [
  {
    header: "Confirm Commit",
    question: "{proposed commit message}\n\n---\nDoes this commit message accurately represent the changes?",
    options: [
      { label: "Yes, use this commit message", description: "Proceed with committing" },
      { label: "Edit message", description: "Modify the commit message" },
      { label: "Cancel", description: "Abort the commit" }
    ]
  }
]
```

Only proceed with the commit if the user selects "Yes, use this commit message". When "Edit message" is selected, ask for the desired changes and regenerate.
