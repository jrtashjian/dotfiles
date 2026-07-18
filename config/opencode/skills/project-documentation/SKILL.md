---
name: project-documentation
description: "Use ONLY when creating, maintaining, or updating structured Obsidian documentation for code projects. Organizes notes under ~/Documents/Obsidian/Personal Vault/code/ in GitHub-style {org}/{project} paths. Keywords: document this, explain how, I learned that, new understanding, update project notes, obsidian docs, capture learnings, project documentation."
---

# Project Documentation Skill (Obsidian + GitHub Hierarchy)

This skill turns OpenCode into a systematic documentation co-pilot. It creates and maintains high-quality personal knowledge management (PKM) artifacts for your code projects directly in your Obsidian vault.

**Core guarantees**:
- Documentation **always** lives at canonical path `~/Documents/Obsidian/Personal Vault/code/{org}/{project}/...` (even if you are working in `~/dev/`, `/tmp/`, a worktree, or any other location).
- **Zero external dependencies** — only `git`, bash, and coreutils available on any standard Linux distribution.
- **Obsidian-first** — YAML frontmatter, `[[wikilinks]]`, `#tags`, folder structure optimized for graph view, backlinks, search, Dataview/Tasks (optional but supported).
- **Best-practice structure** focused on understanding the project through a central hub and focused explanation files for important components and systems. Files stay focused and heavily cross-linked.
- **Safe & transparent** — detection is logged, confirmation asked on ambiguity, existing files are read before modification, templates provided, no blind overwrites.

## When This Skill Activates

Use it (or it activates automatically) when the request involves:
- Initializing or bootstrapping project documentation structure
- Writing or updating **explanations** and implementation details for how the system works
- **Capturing new learnings** or **updated understandings**
- Creating a central hub/MOC for a project
- Capturing references and important code pointers
- Maintaining or refactoring existing project documentation
- Any phrase like "document this", "explain how...", "I learned that...", "new understanding of...", "update the project notes for...", or "help me understand the authentication system"

Explicit trigger example: "Use the project-documentation skill to document how the Auth system works" or "Record this new understanding about the data flow"

## Project Detection (Strict Git + Question Tool Fallback)

**Always run detection first** before creating or modifying any files.

### Step 1: Run the detection script

Use the exact script provided (placed at the standard OpenCode skills location):

```bash
bash ~/.config/opencode/skills/project-documentation/scripts/detect-project.sh "$(pwd)"
```

(or without the path argument if the current working directory is already the project root).

**Expected success output**: A single line with `org/project` (e.g. `jrtashjian/omniform`).

If the script exits with code 0, capture that string as `ORG_PROJECT`.

### Step 2: Handle errors with the `question` tool

If the script fails (non-zero exit, e.g. "Not a git repository", "No origin remote found", parse error, etc.), **do not guess**. Instead, use the `question` tool to ask the user for the canonical identifier.

#### How to call the `question` tool

```markdown
### Using the `question` tool

Call the tool with `questions` as an array of question objects. Each object has these fields:

| Field     | Type    | Description |
|-----------|---------|-------------|
| `header`  | string  | Very short label (max 30 chars) |
| `question`| string  | Complete question |
| `options` | array   | Available choices; each has `label` (1-5 words) and `description` |
| `multiple`| boolean | (optional) Allow selecting multiple |
| `custom`  | boolean | (optional, default `true`) Allow typing a custom answer |

Answers come back as `Array<Array<string>>`.

**Example call for project identifier** (single question):

```
questions: [
  {
    header: "Project Identifier",
    question: "Enter the canonical org/project name for documentation under ~/Documents/Obsidian/Personal Vault/code/ (format: org/project, e.g. jrtashjian/omniform or mycompany/myapp). This will be used for the hub at ~/Documents/Obsidian/Personal Vault/code/org/project/index.md",
    options: [
      { label: "Use detected value", description: "If a partial value was suggested" },
      { label: "jrtashjian/omniform", description: "Example from your projects" }
    ],
    custom: true
  }
]
```

Only proceed once you have a clean `org/project` string from either the script success or the user's answer to the question tool.
```

After getting the identifier (from script or question answer), set:
- `ORG_PROJECT="org/project"`
- `CANONICAL_PATH="~/Documents/Obsidian/Personal Vault/code/${ORG_PROJECT}"`

### Step 3: Confirm and proceed

Always show the user the final `CANONICAL_PATH` and ask for confirmation before running `mkdir -p` or writing any files.

**Strong preference for the hub/MOC**: Every project **must** have (or update) a top-level `index.md` that acts as the Map of Content (MOC) / hub. It links to all sub-sections (references/, explanations/, plans/, logs/, etc.). This is the single most important file for navigation and context.

### Why this detection approach?

- The provided script is strict and reliable when a proper git remote exists (your preferred case).
- The `question` tool provides a clean, structured way to ask for input when the script cannot auto-detect (non-git projects, client work without remotes, fresh clones, etc.).
- Keeps everything deterministic and user-controlled.

You can view/improve the script at `~/.config/opencode/skills/project-documentation/scripts/detect-project.sh`.

## Best-Practice Documentation Structure

Create this simplified layout under every `$canonical_path` (i.e. inside `~/Documents/Obsidian/Personal Vault/code/`):

```
~/Documents/Obsidian/Personal Vault/code/{org}/{project}/
├── index.md                     # Central Hub / MOC (Map of Content). Always keep this updated.
├── explanations/                # Implementation details & how the system works (primary content area)
│   ├── index.md
│   ├── architecture-overview.md # High-level view of the system and major components
│   ├── authentication.md        # Example: detailed breakdown of a key system (Auth, data flow, code locations, integration points)
│   ├── data-model.md
│   └── key-components/          # Or individual focused files for important entities/systems
└── references/                  # External documentation, important links, and code pointers
    └── index.md
```

**Optional lightweight addition**: You can add a `notes/` folder for manual notes or quick learnings if desired. Meeting notes can live here or be referenced from the hub.

### Why This Structure (Rationale & Implications)

This simplified structure is designed specifically for **your use case**: a personal + LLM-agent-friendly knowledge base focused on **understanding how the project works**.

**Focused files** — Each explanation file targets one important system or component (e.g. Authentication, Data Model, API Layer). This makes it easy for both you and future LLM agents to quickly find "how Auth works and where the code lives."

**The Hub (`index.md`)** remains the single source of truth — it gives an at-a-glance view of the most important entities/components and links to detailed explanations.

**Cross-linking** in Obsidian makes navigation powerful:
- From the hub you can jump directly to `[[explanations/authentication|How Authentication works]]`
- Explanation files link back to the hub and to relevant references.
- Result: Fast context for you *and* excellent context for future LLM coding agents.

**Core focus areas**:
- **Explanations**: Deep understanding of architecture, key components, data flow, and integration points.
- **References**: Pointers to important external docs and code locations.
- New learnings and updated understandings are captured as focused files in `explanations/` and linked from the hub.

**Additional recommended kinds** (evolve as needed):
- You can later add `notes/`, `snippets/`, or other folders. The skill will help integrate them into the hub.

**Obsidian optimizations**:
- Every `.md` starts with YAML frontmatter (title, aliases, tags, dates, repo link, status).
- Use `#project/org/project` `#type/plan` `#status/in-progress` tags for global Dataview queries like "LIST FROM #type/plan AND #status/in-progress".
- Folder notes / index.md pattern works great for navigation.
- Keep individual files under ~400-500 lines; split when they grow.

**The Hub / MOC (`index.md`)**: This is the single most important file for every project. It serves as the Map of Content (MOC) — a central dashboard with quick links to all sub-areas, current status, recent learnings/insights, and key metadata. Always keep it updated and well-linked. When recording **new learnings or updated understandings**, create focused files (e.g. under `explanations/learnings/` or a specific topic file) and **immediately link them from the hub `index.md`** so they are discoverable in the graph and search.

This structure scales from tiny scripts to large multi-year codebases and mirrors how successful open-source maintainers and senior engineers organize their personal notes.

## Templates

### 1. Root `index.md` Template

```bash
cat > "$canonical_path/index.md" << 'ENDOFFILE'
---
title: {{project}}
aliases: ["{{project}}", "{{org}}/{{project}}"]
tags:
  - project
  - code
  - "{{org}}/{{project}}"
  - status/active
repo: https://github.com/{{org}}/{{project}}
docs_path: {{canonical_path}}
created: {{date}}
updated: {{date}}
---

# {{project}}

> One-sentence elevator pitch. (Keep this brutally concise and update it when direction changes.)

## Overview

{{Short paragraph or two describing purpose, users, and current high-level state. Pull from repo README if helpful.}}

## Quick Navigation

- [[references/index|References & External Resources]]
- [[explanations/index|Explanations & How Systems Work]]
- GitHub: [{{org}}/{{project}}](https://github.com/{{org}}/{{project}})

## Key Components & Systems

- [[explanations/architecture-overview|Architecture Overview]]
- [[explanations/authentication|Authentication System]] (example)

## Recent Learnings & Key Insights

- [[explanations/learnings/|Latest insights and updated understandings]] (link new ones here)

## Related Projects & Context

- [[other-org/related-project|Why related]]

## Metadata

- **Canonical Docs**: `{{canonical_path}}`
- **Last Updated**: {{date}}
ENDOFFILE
```

### 2. Category Index Template (references/index.md, explanations/index.md)

Simple hub that lists children and provides context.

```bash
cat > "$canonical_path/references/index.md" << 'ENDOFFILE'
---
title: References for {{project}}
tags: [references, "{{org}}/{{project}}"]
updated: {{date}}
---

# References • {{project}}

[[../index|← Back to Project Hub]]

This page curates all important external and internal references with brief context on why they matter.

## Key External Resources

- [Official Docs](url) — Core reference for X.
- [API Spec](url) — ...

## Related Projects & Code

- [[other-org/other-project|Similar pattern used for Y]] — See how they solved Z.

## Internal Notes

- [[../explanations/architecture|Architecture]] uses concepts from ...
ENDOFFILE
```

### 3. Focused Explanation Template (for important systems/components)

Use this pattern when documenting how a major part of the system works (e.g. Authentication, Payments, Data Pipeline).

```bash
cat > "$canonical_path/explanations/authentication.md" << 'ENDOFFILE'
---
title: Authentication System
tags: [explanation, "{{org}}/{{project}}"]
updated: {{date}}
---

# Authentication System

**Purpose**: Brief one-sentence description of what this system does.

## Key Components & Responsibilities
- Component A (file/path)
- Component B

## How It Works (High Level Flow)
1. ...
2. ...

## Code Locations
- Main logic: `src/auth/...`
- Integration points: `src/api/middleware/auth.ts`, `src/services/user-service.ts`

## Important Details / Gotchas
- ...

## Related Explanations
- [[data-model|Data Model]]
- [[api-layer|API Layer]]

## References
- External docs: [link]
ENDOFFILE
```

Create one focused file per major system or component you want to understand deeply. This is the most valuable content for both you and future LLM agents.

## Common Workflows

### Bootstrap a Brand New Project

1. Run detection (script + question tool fallback) and confirm the `CANONICAL_PATH`.
2. Create the minimal structure:
   ```bash
   mkdir -p "$canonical_path"/{explanations,references}
   ```
3. Write the hub `index.md` using the template.
4. Write `explanations/index.md` and `references/index.md`.
5. Tell the user: "Project hub created at `{{canonical_path}}/index.md`. Start by documenting the most important components/systems in `explanations/`."

### Document a Major System or Component (e.g. Authentication)

1. Detect/confirm the project.
2. Create a focused file in `explanations/` (e.g. `explanations/authentication.md`).
3. Use the Focused Explanation Template (include purpose, key components, how it works, code locations, integration points).
4. Add a clear link from the hub `index.md` under "Key Components & Systems".
5. Link back to the hub from the explanation file.

### Capture New Learnings or Updated Understandings

When you gain a new insight or revised understanding:
1. Create or update a focused file in `explanations/` (or `notes/learnings/` if you prefer separation).
2. Clearly describe the new/updated understanding and its implications.
3. Add a prominent link from the project hub `index.md`.
4. This makes the knowledge immediately available to both you and future LLM agents working on the project.

### After Major Work or Discoveries

- Update the relevant explanation file(s) if your understanding changed.
- Add or update links in the hub `index.md`.
- Bump the `updated:` date in the hub and affected files.
- Optionally capture the insight as a new focused learning file.

### Refactoring / Growing the Structure

When a file gets too long or a new category emerges (e.g. you want `snippets/`):
- The skill can propose the new folder + `index.md`.
- Update all parent indexes with new `[[new-category/index|New Category]]` links.
- Move or split content as needed (read first, then write new files, leave redirects or update links).

## Safety & CLI Best Practices

- **Confirmation gate**: Never write files to an ambiguous canonical path without user OK.
- **Read before write**: For existing files, `cat "$file"` first (or head/tail), understand current state, then propose targeted changes.
- **Generation pattern** (recommended for new/complex files):
  ```bash
  tmp=$(mktemp)
  cat > "$tmp" << 'ENDOFFILE'
  ...full content with variables expanded...
  ENDOFFILE
  # Optional: diff -u "$existing" "$tmp"   (if exists)
  mv "$tmp" "$target"
  ```
- Use `date +%F` or `date +%Y-%m-%d` consistently.
- Quote all variable expansions: `"$canonical_path"`
- `mkdir -p` is idempotent and safe.
- After major changes, you may run `ls -R "$canonical_path"` or `tree "$canonical_path"` (if installed) to show user the result.
- If the `~/Documents/Obsidian/Personal Vault/code/` directory itself is a git repo (optional but nice for versioning your PKM), you can `git add` / commit the new docs.

## Extending Beyond Code Projects

The simplified structure works well for any project where you want deep understanding of components and implementation details (homelab, personal tools, client work, research, etc.).

Just provide the `org/project` name when the detection script cannot auto-detect it.

## Philosophy Summary

This skill implements a lightweight, focused knowledge base for understanding code projects. It centers on a strong hub/MOC and focused explanation files so both you and future LLM agents can quickly grasp how important components and systems work.

By using only ubiquitous CLI tools it remains portable across machines, containers, and minimal Linux environments. The structure grows with the project instead of fighting it.

Future you (and anyone you share the vault with) will thank you.
