---
name: pr-review-comments
description: "Use ONLY when fetching or reviewing unresolved GitHub PR review comments/threads. Fetch only unresolved (open) review threads from the current GitHub Pull Request and output them directly as clean markdown. Keywords: pr review, review comments, github pr, unresolved threads."
---

## What I Do

I retrieve **only unresolved review threads** from the current Pull Request using GitHub's GraphQL API. Resolved threads are filtered out automatically. The result is printed directly as clean markdown — perfect for immediate LLM consumption.

## Core Command

Run this command directly:

```bash
PR_NUMBER=$(gh pr view --json number -q .number)
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

gh api graphql -f query='
  query($owner: String!, $repo: String!, $pr: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $pr) {
        reviewThreads(first: 100) {
          nodes {
            isResolved
            comments(first: 50) {
              nodes {
                author { login }
                body
                path
                line
                startLine
              }
            }
          }
        }
      }
    }
  }
' -f owner="${REPO%%/*}" \
   -f repo="${REPO#*/}" \
   -F pr="$PR_NUMBER" \
  --jq '
    .data.repository.pullRequest.reviewThreads.nodes[]
    | select(.isResolved == false)
    | .comments.nodes[]
    | "- **\(.author.login)** on `\(.path):\(.line // .startLine)`:\n\(.body)\n"
  '
```

**Important**: This command prints the review comments directly to the terminal. No file is created.

## How to Use Me

The agent should:

1. Execute the **Core Command** above
2. Capture and use the output directly for reasoning, summarization, or response generation

**Example prompts to trigger me:**
- "Use pr-review-comments skill"
- "Fetch unresolved review comments"
- "Get open review threads and summarize them"
- "Load unresolved comments and suggest fixes"

## Sample Output

```markdown
- **alice** on `src/utils/api.ts:67`:
  Please add input validation for the userId parameter.

- **bob** on `components/Form.tsx:124`:
  This state update should be inside a useCallback.
```

## When to Use This Skill

- Before addressing PR feedback
- When preparing to merge
- To feed pending reviewer comments directly into LLM analysis
- To generate draft replies or a focused todo list

## Prerequisites

- GitHub CLI (`gh`) installed and authenticated (`gh auth login`)
- Run from a repository with an open PR for the current branch