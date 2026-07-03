#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
impact_log_ready || exit 0

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')
cwd=$(echo "$input" | jq -r '.cwd // empty')
[ -n "$cwd" ] || cwd="$PWD"
tool=$(echo "$input" | jq -r '.tool_name // empty')

# Only record file-change tools and recognized shell verbs. Never capture file
# contents, diffs, or full command text — just enough to know where/when
# work happened. The rich "what" is re-derived from git/gh at report time.
detail=""
case "$tool" in
  Edit|Write|MultiEdit|NotebookEdit)
    detail=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
    ;;
  Bash)
    cmd=$(echo "$input" | jq -r '.tool_input.command // empty')
    verb=$(awk '{print $1}' <<< "$cmd")
    case "$verb" in
      git|npm|pnpm|yarn|pytest|cargo|go|make|docker|terraform)
        detail="$verb $(awk '{print $2}' <<< "$cmd")"
        ;;
      *)
        exit 0
        ;;
    esac
    ;;
  *)
    exit 0
    ;;
esac

repo=$(git_repo_slug "$cwd")
branch=$(git_branch "$cwd")
confidence="high"
[ -n "$repo" ] || confidence="low"

event=$(jq -nc \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg session_id "$session_id" \
  --arg cwd "$cwd" \
  --arg repo "$repo" \
  --arg branch "$branch" \
  --arg tool "$tool" \
  --arg detail "$detail" \
  --arg confidence "$confidence" \
  '{ts:$ts, event:"tool_use", session_id:$session_id, cwd:$cwd,
    repo:(if $repo=="" then null else $repo end),
    branch:(if $branch=="" then null else $branch end),
    tool:$tool, detail:$detail, confidence:$confidence}')

impact_log_append "$event"
exit 0
