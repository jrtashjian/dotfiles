# My OpenCode Setup

Personal global configuration at `~/.config/opencode/` (symlinked from this dotfiles repo).

Stock `build` and `plan` agents, one default model, and skills loaded only when a task needs them.

## Model

| Slot | Model | Purpose |
|------|-------|---------|
| default | `opencode-go/deepseek-v4.1-flash` | Daily coding. Used by any session that has not picked another model. |
| `title` | `opencode/nemotron-3.5-lightning-free` | Hidden agent that names sessions. Kept on a free model so titles stay cheap. |

`build`, `plan`, `explore`, and `general` are not pinned. Changing the default here changes them together. Selecting an agent does not change the session model.

`formatter` is on. Built-in formatters run after `write`, `edit`, and `patch`.

## Always-on instructions

`AGENTS.md` is the standing working agreement. OpenCode loads it into every session, then any project `AGENTS.md` closer to the code.

It stays short so it does not crowd out project instructions or skills. It covers how to change code: preserve behavior, stay inside the request, keep names and the happy path clear, and do not write secrets. It does not name a skill. Which skill applies is left to the skill descriptions.

Build, test, and layout rules belong in that project's own `AGENTS.md`.

## Skills

OpenCode advertises each skill's description. The agent loads the body when the task matches, or you can force one with `@id`. Skills are not in the always-on prompt.

| Skill | Load when | Source |
|-------|-----------|--------|
| `@clean-code` | Readability, naming, function design, responsibilities, or everyday testable code | [Clean Code](https://github.com/ciembor/agent-rules-books/blob/main/clean-code/clean-code.md) |
| `@clean-architecture` | Separating business policy from frameworks, databases, UI, or infrastructure | [Clean Architecture](https://github.com/ciembor/agent-rules-books/blob/main/clean-architecture/clean-architecture.md) |
| `@refactoring` | Improving structure while preserving observable behavior | [Refactoring](https://github.com/ciembor/agent-rules-books/blob/main/refactoring/refactoring.md) |
| `@domain-driven-design` | Complex domain modeling, bounded contexts, ubiquitous language, or aggregates | [Domain-Driven Design](https://github.com/ciembor/agent-rules-books/blob/main/domain-driven-design/domain-driven-design.md) |
| `@designing-data-intensive-applications` | Reliability, scalability, consistency, replication, transactions, streams, or schema evolution | [Designing Data-Intensive Applications](https://github.com/ciembor/agent-rules-books/blob/main/designing-data-intensive-applications/designing-data-intensive-applications.md) |

Those five are the complete rule files from [Agent Rules Books](https://ciembor.github.io/agent-rules-books), inlined as `SKILL.md`. The upstream skill package loads the shorter `mini` file first and keeps the complete file as a reference. These copies load the complete file. The rules are inspired by the books, not official author or publisher material. Repository: [ciembor/agent-rules-books](https://github.com/ciembor/agent-rules-books).

## MCP

`chrome-devtools` is a local server started with `npx -y chrome-devtools-mcp@latest`. It connects automatically.

[`chrome-devtools-mcp`](https://github.com/ChromeDevTools/chrome-devtools-mcp) drives and inspects Chrome through Puppeteer and Chrome DevTools. Use it to open pages, click, and fill forms, and to inspect console messages, network requests, CSS, screenshots, performance traces, Lighthouse, and heap snapshots. Automation and debugging share the same Chrome session.
