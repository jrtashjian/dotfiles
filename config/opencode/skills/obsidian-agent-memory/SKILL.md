---
name: obsidian-agent-memory
description: >
  Persistent Obsidian agent memory. When loaded: orient from the vault, look up
  architecture/component/pattern notes during work, and write discoveries back.
  Also activate when the user mentions obsidian memory, obsidian vault, agent
  notes, or says "write session note".
---

# Obsidian Agent Memory

Persistent Obsidian knowledge vault — graph-structured memory across sessions.
When this skill is loaded: orient, look up on demand, write discoveries back.
Bias toward action: create and update notes without asking.

## Vault Location

`~/Documents/Obsidian/Personal Vault/Agent Memory/`

Verify the vault exists by checking for `index.md` at that path. If missing, stop and report that the vault is missing. Expand `~` to an absolute path before tool calls.

## Project Resolution

```bash
basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null || basename $(pwd)
```

Match the result (typically lowercased) to a folder under `projects/`.

## Orientation (on load)

1. Resolve the project name (above).
2. List `projects/` to see what exists.
3. If a matching project exists, read **only** `projects/{name}/{name}.md`.
4. If no matching project exists, scaffold it (see Scaffold), then read the overview.
5. **Do not** follow wikilinks or read component/pattern/ADR/session notes yet.
6. Follow links only when the current task needs that context.

## Navigation

- **Component** → project overview links to it; read that one note.
- **Architecture decision** → follow the link from the overview or a related component/pattern.
- **Pattern** → follow the link from the overview or a related component.
- **Session history** → only if stuck or the user references prior work.
- **Scan many notes** → read through the closing frontmatter `---` only (`tags`, `project`, `type`). Skip the body until a note matches.
- **Before reading a tree** → list the directory so you know what exists:
  - `projects/{project}/**/*.md`
  - `domains/{tech}/*.md`
  - `sessions/*.md`

## Writing

Notes are for future agent context, not human docs.

Prefer:

- Bullet points over prose
- Wikilinks over restating another note
- Frontmatter tags for discoverability
- Revising existing notes (edit, reorganize, split, merge, delete) over leaving them stale

### When to write (do it; don't ask)

| Event | Action |
|---|---|
| Deep understanding of a component with no note | Create component note; wire links |
| Existing note wrong, thin, or outdated | Update, reorganize, or delete |
| Significant design choice **you/the user made** | Create ADR |
| Recurring approach **recognized** in the codebase | Create pattern note |
| Cross-project technical knowledge | Write/update domain note |
| User says "write session note" (or equivalent) | Write session note + index row |
| New project with no vault folder | Scaffold project |

### ADR vs pattern

- **ADR** — a decision that was actually made (context, choice, alternatives, consequences).
- **Pattern** — a recurring structure or approach observed in the code, not necessarily a formal decision.

### Scoping

| Knowledge | Location |
|---|---|
| One project only | `projects/{project}/` |
| Shared across projects | `domains/{tech}/` |
| Session summaries | `sessions/` |

### Filenames

| Kind | Path |
|---|---|
| Project overview | `projects/{name}/{name}.md` |
| Component | `projects/{name}/components/{PascalCase}.md` |
| Pattern | `projects/{name}/patterns/{kebab-case}.md` |
| ADR | `projects/{name}/architecture/{kebab-case}.md` |
| Domain | `domains/{tech}/{kebab-case}.md` |
| Session | `sessions/YYYY-MM-DD_{kebab-slug}.md` |

### Frontmatter

Every new or revised note should include:

```yaml
tags: [category, project/short-name]
type: component | pattern | adr | session | project | domain
project: "[[{name}]]"
created: YYYY-MM-DD
```

Use `projects:` (list) on session notes that span multiple projects. Set `updated: YYYY-MM-DD` when revising an existing note.

### Wikilinks

Use **relative** wikilinks only. Do not link outside the Agent Memory vault.

From a component note:

```markdown
[[FormNotificationSettings]]
[[../patterns/immutable-domain-model|immutable domain model]]
[[../{name}|{name}]]
```

From the project overview:

```markdown
[[components/Form|Form]]
[[patterns/immutable-domain-model|immutable domain model]]
```

From a session note:

```markdown
[[../projects/{name}/{name}|{name}]]
```

Display aliases (`[[path|label]]`) are fine. Prefer shortest relative path that resolves.

### Dependency frontmatter

On component notes, record outbound deps only:

```yaml
depends-on:
  - "[[FormNotificationSettings]]"
```

Do **not** maintain `depended-on-by` (it drifts). Infer dependents from overview graphs, search, or other notes' `depends-on` when needed.

### Index maintenance

After creating, renaming, or deleting notes, keep indexes truthful:

| Change | Also update |
|---|---|
| New / removed project | `projects/index.md` |
| New component, pattern, or ADR | Project overview (`projects/{name}/{name}.md`) link tables / lists |
| New session note | `sessions/index.md` (date, link, one-line summary) |
| New domain note | `domains/index.md` when a new tech folder or top-level entry appears |
| Rename / delete note | Fix or remove broken wikilinks in overview and indexes you already touched |

### Do not

- Dump full source files into notes
- Write speculative or "might be true" notes
- Restate another note instead of linking
- Read the whole project tree during orientation
- Follow every wikilink "just in case"
- Maintain `depended-on-by`
- Link to files outside this vault
- Ask permission to create/update notes (except if the vault root itself is missing)

## Scaffold

When the current project has no `projects/{name}/` folder:

1. Create `projects/{name}/`, `components/`, `patterns/`, and `architecture/` as needed.
2. Create `projects/{name}/{name}.md` from the project template (short description from repo README or root layout).
3. Add a row/link in `projects/index.md`.
4. Stop — fill components/patterns as you actually learn them.

## Templates

### Project overview

```yaml
---
tags: [project, project/{short-name}]
type: project
project: "[[{name}]]"
created: {date}
---
```

Sections: one-line summary, Core Architecture, component table (wikilinks), Key Patterns (wikilinks), optional dependency diagram.

### Component

```yaml
---
tags: [components, project/{short-name}]
type: component
project: "[[{name}]]"
created: {date}
status: active
layer: ""
key-files: []
depends-on: []
---
```

Sections: one-line summary (file + namespace if known), Purpose, Public API, Gotchas.

### Pattern

```yaml
---
tags: [patterns, project/{short-name}]
type: pattern
project: "[[{name}]]"
created: {date}
---
```

Sections: Rationale, Implementation, Exceptions, Related (wikilinks).

### Architecture decision (ADR)

```yaml
---
tags: [architecture, decision, project/{short-name}]
type: adr
project: "[[{name}]]"
status: proposed | accepted | superseded
created: {date}
---
```

Sections: Context, Decision, Alternatives Considered, Consequences.

Only write ADRs for decisions actually made in the work, not for observed structure (use pattern notes for that).

### Session

```yaml
---
tags: [sessions]
type: session
projects:
  - "[[{name}]]"
created: {date}
branch: {branch-name}
---
```

Filename: `sessions/YYYY-MM-DD_{kebab-slug}.md`.

Sections: Context, Work Done, Discoveries, Decisions, Next Steps.

Omit `branch` when not in a git repo. Add a one-line row to `sessions/index.md`.

### Domain

```yaml
---
tags: [domain, domain/{tech}]
type: domain
created: {date}
---
```

Cross-project only. If it only applies to one codebase, it belongs under that project's `patterns/` or components.
