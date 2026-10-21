---
description: Generate a Conventional Commits message from staged changes and commit
subtask: true
model: opencode-go/deepseek-v4.1-flash
---

Generate a Conventional Commits message from the staged changes below, then commit.

Format (strict):
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]

Rules:
- type: feat, fix, docs, style, refactor, perf, test, build, ci, chore, or revert
- scope: optional noun in parentheses, e.g. feat(parser):
- description: imperative mood, ≤72 chars (ideally <60), no trailing period
- body: only if needed for the "why". Wrap at 72 chars. Start after a blank line.
- breaking changes: use ! after type/scope and/or a BREAKING CHANGE: footer
- Match the style of recent commits when possible (types, scopes, tone).

Recent commits:
!`git log --oneline --no-decorate -n 20`

Staged changes (numstat):
!`git diff --staged --numstat`

Staged diff:
!`git diff --staged`

If there are no staged changes, output exactly:
Nothing to commit.

Otherwise:
1. Generate the message.
2. Run: `git commit -m "your exact message"`
3. Capture the short hash with `git rev-parse --short HEAD`.
4. Your final output must be exactly one line and nothing else:

`<short-hash>: <message>`

Examples:
- `a1b2c3d: feat: add user authentication`
- `Nothing to commit.`

Do not ask for approval. Commit directly.