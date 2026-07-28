# My OpenCode Setup

Personal global configuration at `~/.config/opencode/` (symlinked from dotfiles) focused on:

- Cost efficiency using free Zen models for routine work + xAI paid models for specialists
- Single-purpose subagents and skills to keep sessions short and token-efficient
- Stock `build`/`plan` primaries (no core changes)
- Minimal always-on context; heavy details loaded on-demand via skills

## Model Routing

| Slot          | Model                               | Purpose                          |
|---------------|-------------------------------------|----------------------------------|
| build         | `opencode/big-pickle`               | Daily coding (default)           |
| plan          | `xai/grok-4.5`                      | Design & planning                |
| `small_model` | `opencode/north-mini-code-free`     | Titles, summaries, light tasks   |
| explore       | `opencode/deepseek-v4-flash-free`   | Fast codebase exploration        |
| code-review   | `xai/grok-4.5`                      | Rigorous adversarial reviews     |
| commit        | `opencode/deepseek-v4-flash-free`   | Direct commit with minimal output|

## Custom Subagents

Invoke via `@name` or let primaries call them.

- **@code-review**  
  Adversarial review focused on real high-impact bugs.  
  - Model: grok-4.5 (cold, precise)  
  - Edit: fully denied  
  - Bash: git/rg/grep only  
  - Steps capped at 25

## Custom Commands

- **/commit-changes**  
  Analyzes staged changes + recent commits using git commands inside an isolated subtask, then commits directly.  
  - Runs as subtask (`subtask: true`) with `opencode/deepseek-v4-flash-free` 
  - Runs `git log`, `git diff`, `git add` (if needed), `git commit`, and `git rev-parse` inside the subtask  
  - Final output is exactly one line: `<short-hash>: <message>` (no confirmation step, no extra text)

## Key Efficiency Settings

- **AGENTS.md** (global): Very short. Core principles + "load `clean-code` skill for substantial edits". Full rules live in skills.
- **compaction.prune: true**: Drops stale tool output from long sessions.
- **steps** limits on subagents: Hard cap on agentic iterations.
- **task permissions** on `build`/`plan`: Only our focused subagents (`code-review`, `explore`, `general`) are auto-allowed. Unknowns denied (still usable via `@`).
- Skill descriptions gated with "Use ONLY when..." + keywords to prevent unnecessary loads.

External clean-code / clean-architecture / refactoring skills are left untouched (pulled from external source).

## Common Workflows

### Start a new feature or change
1. Tab to `plan` mode.
2. Describe the idea; iterate until the design/approach is solid.
3. Optionally capture the design via `obsidian-agent-memory`.
4. Tab back to `build` and implement from the plan.
5. Use `obsidian-agent-memory` (or mention "obsidian memory", "obsidian vault") to capture learnings or write session notes.

### Code review before PR or after big changes
- `@code-review` (or mention the diff/PR).
- It will git diff, apply strict bug filter, and output only high-value findings.

### Commit work
After edits:
```
/commit-changes
```
- Runs as isolated subtask (`subtask: true`) with deepseek-v4-flash-free.
- Stages if needed, follows project commit style from `git log`.
- Commits directly inside the subtask.
- Main thread receives only the one-line result: `<short-hash>: <message>`.

### Persistent Obsidian Agent Memory
- The `obsidian-agent-memory` skill provides graph-structured persistent memory across sessions using `~/Documents/Obsidian/Personal Vault/Agent Memory/`.
- Auto-orients at session start by detecting project and reading relevant notes if present.
- Auto-scaffolds project structure on first run.
- Use when: "use obsidian memory", "check the vault", "write this discovery to obsidian", etc.
- On "I'm done", offers to write session summary.
- Writes components, ADRs, sessions using frontmatter + wikilinks.
- Design specs from plan mode and implementation notes go to the Agent Memory vault (projects/, sessions/).
- Use for agent orientation, component notes, ADRs, session summaries, and cross-session memory.

### Quick codebase exploration (cheap)
- `@explore find all places that call the payment service`
- Uses deepseek-v4-flash-free.

### Fix tests
- Make changes.
- `@general` or directly use the `fix-jest-test-failures` skill (the description is gated so it only activates for this).

## Notes

- All model choices are only Zen free + xAI (no other providers).
- Subagents run in child sessions so their context doesn't pollute the main thread.
- Skills are procedures, not model routers — model selection happens at the agent/command level.
- Restart OpenCode after config changes for them to take effect.

This setup keeps the happy path cheap and fast while routing expensive intelligence only where it adds the most value.
