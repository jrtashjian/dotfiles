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
| commit        | free mini/flash (subtask)      | Direct commit with minimal output        |

## Custom Subagents

Invoke via `@name` or let primaries call them.

- **@brainstorm**  
  Turns vague ideas into approved designs before any code.  
  - Model: grok-4.3  
  - Edit limited to `docs/**` only  
  - Chains to `obsidian-agent-memory` skill after approval  
  - Steps capped at 25

- **@code-review**  
  Adversarial review focused on real high-impact bugs.  
  - Model: grok-4.5 (cold, precise)  
  - Edit: fully denied  
  - Bash: git/rg/grep only  
  - Steps capped at 25

## Custom Commands

- **/commit-changes**  
  Analyzes staged changes + recent commits using git commands inside an isolated subtask, then commits directly.  
  - Runs as subtask (`subtask: true`) with free model  
  - Runs `git log`, `git diff`, `git add` (if needed), `git commit`, and `git rev-parse` inside the subtask  
  - Final output is exactly one line: `<short-hash>: <message>` (no confirmation step, no extra text)

## Key Efficiency Settings

- **AGENTS.md** (global): Very short. Core principles + "load `clean-code` skill for substantial edits". Full rules live in skills.
- **compaction.prune: true**: Drops stale tool output from long sessions.
- **steps** limits on subagents: Hard cap on agentic iterations.
- **task permissions** on `build`/`plan`: Only our focused subagents (`brainstorm`, `code-review`, `explore`, `general`) are auto-allowed. Unknowns denied (still usable via `@`).
- Skill descriptions gated with "Use ONLY when..." + keywords to prevent unnecessary loads.

External clean-code / clean-architecture / refactoring skills are left untouched (pulled from external source).

## Common Workflows

### Start a new feature or change
1. (Optional) Tab to `plan` or stay in `build`.
2. Describe the idea.
3. `@brainstorm` (or let it decide).
4. Iterate until design approved and spec written.
  5. `obsidian-agent-memory` skill is invoked automatically at end.
  6. Switch back to build and implement from the plan.
  7. Use `obsidian-agent-memory` skill (or mention "obsidian memory", "obsidian vault") to capture learnings, orient, or write to persistent agent memory in Obsidian.

### Code review before PR or after big changes
- `@code-review` (or mention the diff/PR).
- It will git diff, apply strict bug filter, and output only high-value findings.

### Commit work
After edits:
```
/commit-changes
```
- Runs as isolated subtask (`subtask: true`) with free model.
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
- Design specs from brainstorm and implementation plans are written via this skill to the Agent Memory vault (projects/, sessions/).
- Use for agent orientation, component notes, ADRs, session summaries, and cross-session memory.

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
