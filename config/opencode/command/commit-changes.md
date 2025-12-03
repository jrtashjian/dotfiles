---
description: Generate and confirm git commit message from changes, then commit.
---

Generate a very short, clear git commit message from staged changes.
Maximum 50 characters total. Use imperative mood (e.g., "Add login button").

If nothing is staged, automatically run `git add -A` first.

Summary: `git diff --staged`

Output exactly:

Proposed commit message: <your short message here>

Then ask naturally: Use this commit message?

Continue chatting and refining the message until the user explicitly says "y", "yes", "commit", or "confirm".
Only then run `git commit -m "<final message>"`.
If the user replies with anything else (including a new message), treat it as a suggestion, show the updated proposal, and ask again.

Never commit without clear confirmation.
