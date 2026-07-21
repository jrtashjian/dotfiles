---
name: obsidian-agent-memory
description: Persistent Obsidian-based memory for coding agents. Use at session start to orient from a knowledge vault, during work to look up architecture/component/pattern notes, and when discoveries are made to write them back. Activate when the user mentions obsidian memory, obsidian vault, obsidian notes.
---

# Obsidian Agent Memory

You have access to a persistent Obsidian knowledge vault — a graph-structured memory that persists across sessions. Use it to orient yourself, look up architecture and component knowledge, and write back discoveries.

## Vault Location
`~/Documents/Obsidian/Personal Vault/Agent Memory/`

Verify the vault exists by checking for `~/Documents/Obsidian/Personal Vault/Agent Memory/index.md`. If it doesn't exist, do nothing and report that the vault is missing.

## Session Start - Orientation

Auto-detect the project from the current working directory:
```bash
basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null || basename $(pwd)
```

Then check if a matching project exists by listing files in `~/Documents/Obsidian/Personal Vault/Agent Memory/projects/`. If a matching project is found, read its `index.md` and any relevant subfiles to orient yourself.

This project overview contains wikilinks to all components, patterns, architecture decisions, and domains. **Do not read those linked notes yet.** Follow them on demand when the current task requires that context.

## Automatic Behaviors

These behaviors apply to any agent using this skill. They do not require explicit user instructions.

### On session start

Auto-orient without being asked, following the Session Start procedure above. If the vault doesn't exist at the resolved path, report that the vault is missing.

### On session end signals

When the user says "I'm done", "end session", or similar, offer to write a session summary. Don't auto-run; Ask first: "Want me to write a session summary to the Obsidian vault?"

### On component discovery

When you deeply analyze a component that has no vault note, and the project has an active vault, offer to create a component note and infer relationships from imports and dependencies. Example: "I noticed there's no vault note for the AuthMiddleware component. Want me to create one and maps it's dependencies?"

### On first run

Auto-scaffold the current projectin the vault if it doesn't exist.

### During work - Graph Navigation

- Need to understand a component? The project overview links to it. Read that one note.
- Need an architecture decision? The component note or project overview links to it. Follow the link.
- Need session history? Only read if you're stuck or the user references prior work.

### Frontmatter-first scanning

When you need to scan multiple notes to find the right one, read just the first ~10 lines of each file. The `tags`, `project`, and `type` fields in the frontmatter tell you if the note is relevant before reading the full body.

### Directory listing before reading.

List directory contents before reading files. Know what exists without consuming tokens:
- `~/Documents/Obsidian/Personal Vault/Agent Memory/projects/{project}/**/*.md` - all notes for a project.
- `~/Documents/Obsidian/Personal Vault/Agent Memory/domains/{tech}/*.md` - domain knowledge files.

## Writing to the Vault

Write concisely. Notes are for your future context, not human documentation. Prefer:

- Bullet points over prose.
- Wikilinks over repeated explanations (link to it, don't re-stae it).
- Frontmatter tags for discoverability over verbose descriptions.

### When to write
- **New component discovered**: Create a component note when you deeply understand a part of the codebase.
- **Architecture decision made**: Record ADRs when significant design choices are made.
- **Pattern identified**: Document recurring patterns that future sessions should follow.
- **Domain knowledge learned**: Write to domain notes when you discover cross-project knowledge.

### Scoping rules

| Knowledge Type | Location | Example |
|---|---|---|
| One project only | `projects/{project}/` | How this API handles auth |
| Shared across projects | `domains/{tech}/` | How Go interfaces work |
| Session summaries | `sessions/` | What was done and discovered |

### Frontmatter conventions

Always include in new notes:
```yaml
tags: [category, project/short-name]
type: <component|adr|session|project>
project: "[[projects/{project}/{project}]]"
created: YYYY-MM-DD
```

### Wikilink conventions

- Link to related notes: `[[projects/{name}/components/Component Name|Component Name]]`
- Link to domains: `[[domains/{tech}/{Tech Name}|Tech Name]]`
- Link back to project: `[[projects/{name}/{name}|project-name]]`

### Note templates

**Component Note:**
```yaml
---
tags: [components, project/{short-name}]
type: component
project: "[[projects/{name}/{name}]]"
created: {date}
status: active
layer: ""
depends-on: []
depended-on-by: []
key-files: []
---
```
Sections: Purpose, Gotchas

**Architecture Decision:**
```yaml
---
tags: [architecture, decision, project/{short-name}]
type: adr
project: "[[projects/{name}/{name}]]"
status: proposed | accepted | superseded
created: {date}
---
```
Sections: Context, Decision, Alternatives Considered, Consequences

**Session Note:**
```yaml
---
tags: [sessions]
type: session
projects:
  - "[[projects/{name}/{name}]]"
created: {date}
branch: {branch-name}
---
```
Sections: Context, Work Done, Discoveries, Decisions, Next Steps
