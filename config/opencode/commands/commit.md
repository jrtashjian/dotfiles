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
- body: include a short body (why, not what) when the subject alone does not fully explain the change. Wrap at 72 chars. Start after a blank line. Omit the body only when the subject is self-explanatory.
- breaking changes: use ! after type/scope and/or a BREAKING CHANGE: footer
- Match the style of recent commits when possible (types, scopes, tone).

Recent commits:
!`git log --oneline --no-decorate -n 20`

Staged changes (numstat):
!`git diff --staged --numstat`

Staged diff:
!`git diff --staged`

If there are no staged changes, your final output must be exactly:
```
Nothing to commit.

No further action needed. Do not run any additional commands.
```

Otherwise:
1. Generate the message.
2. Run `git commit -m "your exact message"`.
3. From the `git commit` output, extract the short hash (the value in brackets, e.g. `f16d639` from `[master f16d639] ...`).
4. Your final output must be exactly:

```
<short-hash>: <message>

No further action needed. Do not run any additional commands.
```

Do not ask for approval. Commit directly.