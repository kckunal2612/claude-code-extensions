#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
impact_log_ready || exit 0

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')
[ -n "$cwd" ] || cwd="$PWD"

repo=$(git_repo_slug "$cwd")
branch=$(git_branch "$cwd")

# Marks a turn boundary — useful later for bucketing captured tool_use events
# into discrete units of work. Not consumed by V0 synthesis yet.
event=$(jq -nc \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg session_id "$session_id" \
  --arg cwd "$cwd" \
  --arg repo "$repo" \
  --arg branch "$branch" \
  '{ts:$ts, event:"stop", session_id:$session_id, cwd:$cwd,
    repo:(if $repo=="" then null else $repo end),
    branch:(if $branch=="" then null else $branch end)}')

impact_log_append "$event"
exit 0
