# My OpenCode Setup

Personal global configuration at `~/.config/opencode/` (symlinked from dotfiles) focused on:

- Cost efficiency using free Zen models for routine work + xAI paid models for specialists
- Single-purpose subagents and skills to keep sessions short and token-efficient
- Stock `build`/`plan` primaries (no core changes)
- Minimal always-on context; heavy details loaded on-demand via skills

## Model Routing

| Slot          | Model                          | Purpose                          |
|---------------|--------------------------------|----------------------------------|
| `model`       | `xai/grok-build-0.1`           | Daily coding (build/plan)        |
| `small_model` | `opencode/north-mini-code-free`| Titles, summaries, light tasks   |
| explore       | `opencode/deepseek-v4-flash-free` | Fast codebase exploration     |
| brainstorm    | `xai/grok-4.3`                 | Design & planning                |
| code-review   | `xai/grok-4.5`                 | Rigorous adversarial reviews     |
| commit        | free mini/flash (subtask)      | Commit message generation        |

## Custom Subagents

Invoke via `@name` or let primaries call them.

- **@brainstorm**  
  Turns vague ideas into approved designs before any code.  
  - Model: grok-4.3  
  - Edit limited to `docs/**` only  
  - Chains to `writing-plans` skill after approval  
  - Steps capped at 25

- **@code-review**  
  Adversarial review focused on real high-impact bugs.  
  - Model: grok-4.5 (cold, precise)  
  - Edit: fully denied  
  - Bash: git/rg/grep only  
  - Steps capped at 25

- **@docs**  
  Self-contained specialist for all Obsidian vault project documentation (create, update, review, explain, capture learnings).  
  - Model: grok-4.3  
  - Unrestricted write access to `~/Documents/Obsidian/Personal Vault/code/**` (no confirmation on writes)  
  - Single agent — no competing skill  
  - Keeps heavy PKM context isolated in its own session

## Custom Commands

- **/commit-changes**  
  Analyzes staged diff + recent commits, proposes conventional message.  
  - Runs as isolated subtask (`subtask: true`)  
  - Uses free model  
  - Uses `question` tool for single confirmation before commit

## Key Efficiency Settings

- **AGENTS.md** (global): Very short. Core principles + "load `clean-code` skill for substantial edits". Full rules live in skills.
- **compaction.prune: true**: Drops stale tool output from long sessions.
- **steps** limits on subagents: Hard cap on agentic iterations.
- **task permissions** on `build`/`plan`: Only our focused subagents (`brainstorm`, `code-review`, `docs`, `explore`, `general`) are auto-allowed. Unknowns denied (still usable via `@`).
- Skill descriptions gated with "Use ONLY when..." + keywords to prevent unnecessary loads.

External clean-code / clean-architecture / refactoring skills are left untouched (pulled from external source).

## Common Workflows

### Start a new feature or change
1. (Optional) Tab to `plan` or stay in `build`.
2. Describe the idea.
3. `@brainstorm` (or let it decide).
4. Iterate until design approved and spec written.
5. `writing-plans` skill is invoked automatically at end.
6. Switch back to build and implement from the plan.
7. Use `@docs` if you want to capture learnings in Obsidian.

### Code review before PR or after big changes
- `@code-review` (or mention the diff/PR).
- It will git diff, apply strict bug filter, and output only high-value findings.

### Commit work
After edits:
```
/commit-changes
```
- It stages if needed, follows project commit style from `git log`, proposes message.
- Confirm with "Yes, use this commit message".

### Document, update, or review a system in Obsidian
- `@docs document how authentication works`
- `@docs review the documentation for the payment flow`
- Or: "Record this new understanding about the data flow" or "help me understand the project from the docs"
- The agent detects the project from git, maintains the canonical structure under `~/Documents/Obsidian/Personal Vault/code/...`, and can review/improve existing docs directly (no confirmation needed for writes).
- Use @docs for documentation-related review and understanding instead of @explore.
- Implementation plans (from writing-plans skill) and design specs are now saved directly into the Obsidian vault under `/plans/` and `/designs/` respectively (using sensible project detection).

### Quick codebase exploration (cheap)
- `@explore find all places that call the payment service`
- Uses the free flash model.

### Fix tests
- Make changes.
- `@general` or directly use the `fix-jest-test-failures` skill (the description is gated so it only activates for this).

## Notes

- All model choices are only Zen free + xAI (no other providers).
- Subagents run in child sessions so their context doesn't pollute the main thread.
- Skills are procedures, not model routers — model selection happens at the agent/command level.
- Restart OpenCode after config changes for them to take effect.

This setup keeps the happy path cheap and fast while routing expensive intelligence only where it adds the most value.
