---
description: Generate a concise git commit message from staged changes following project conventions and commit immediately inside the subtask.
subtask: true
model: opencode/north-mini-code-free
---

# Generate and apply concise git commit message

Recent commits (match this style exactly):
!git log --oneline -20

Staged diff:
!git diff --cached

## Pre-Commit Checks

- If the diff above is empty, run `git add -A` first.
- Detect exact commit convention from the log above (Conventional Commits, etc.).
- Keep changes atomic. If clearly unrelated, still commit the current logical group.

## Message Rules

**Subject** (≤72 chars, ideally <60): Imperative, capitalized, no period. No scope unless the history above consistently uses scopes. Completes: "If applied, this commit will _[subject]_".

**Body**: Short *why* only. 72-char wrap. Omit body if subject is sufficient.

## Workflow

1. Analyze the **injected** log and diff above.
2. Generate the best message following the rules and observed style.
3. **Immediately commit** inside this subtask by calling the bash tool:
   ```
   git commit -m "exact message here"
   ```
4. Output only a brief confirmation: the message + short commit hash.

**Never** use the `question` tool.  
**Never** ask for approval or surface anything to the main thread.  
**Commit directly** so the main conversation stays clean.

If there is nothing to commit, report "Nothing to commit." and stop.
