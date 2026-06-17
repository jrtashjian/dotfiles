#!/bin/bash
set -euo pipefail

TARGET_DIR="${1:-$(pwd)}"

# Resolve directory
TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd) || { echo "Error: Invalid directory" >&2; exit 2; }

# Check if git repo and get origin URL
if ! git -C "$TARGET_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Not a git repository" >&2
  exit 1
fi

url=$(git -C "$TARGET_DIR" config --get remote.origin.url 2>/dev/null || true)
if [[ -z "$url" ]]; then
  echo "Error: No origin remote found" >&2
  exit 1
fi

# Normalize to org/project
normalized=$(echo "$url" | sed -E 's#^(git@|https?://|git://)##; s#:#/#g; s#\.git$##; s#/$##')
org=$(echo "$normalized" | awk -F/ '{print $(NF-1)}' | tr -cd '[:alnum:]._-' | head -c 80)
project=$(echo "$normalized" | awk -F/ '{print $NF}' | tr -cd '[:alnum:]._-' | head -c 80)

if [[ -z "$org" || -z "$project" ]]; then
  echo "Error: Could not parse org/project from remote URL" >&2
  exit 1
fi

echo "${org}/${project}"
exit 0
