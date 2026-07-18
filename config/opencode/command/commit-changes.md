---
description: Generate a concise git commit message from staged changes following project conventions and commit immediately inside the subtask.
subtask: true
model: opencode/north-mini-code-free
---

# Generate and apply concise git commit message

Recent commits (match this style exactly):
!`git log --oneline -20`

Staged diff:
!`git diff --cached`

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
3. If there are changes:
   - Run the commit with bash:
     ```
     git commit -m "your exact message"
     ```
   - Then capture the hash: run `git rev-parse --short HEAD`
   - Use that short hash.
4. After the commit (or if nothing to commit), your **final output must be exactly one line** in this format and nothing else:

`<short-hash>: <message>`

Examples:
- `a1b2c3d: Update commit-changes.md syntax formatting`
- `Nothing to commit.`

**Strict rules for final output:**
- Output **only** that single line.
- No other text, no explanations, no "Plan complete", no tool calls after the hash capture.
- Do not run any bash commands after capturing the hash.
- This is the complete message that will be shown in the main thread.

**Never** use the `question` tool.  
**Never** ask for approval or surface anything to the main thread.  
**Commit directly** so the main conversation stays clean.
