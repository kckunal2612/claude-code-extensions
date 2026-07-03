#!/usr/bin/env bash
# Shared helpers for impact-log hooks. Meant to be sourced, not executed.

IMPACT_LOG_HOME="${IMPACT_LOG_HOME:-$HOME/.claude/impact-log}"
IMPACT_LOG_EVENTS="$IMPACT_LOG_HOME/events.jsonl"
IMPACT_LOG_STATE="$IMPACT_LOG_HOME/state.json"

impact_log_ready() {
  command -v jq >/dev/null 2>&1
}

impact_log_init_home() {
  mkdir -p "$IMPACT_LOG_HOME/reports/weekly" "$IMPACT_LOG_HOME/reports/quarterly"
  [ -f "$IMPACT_LOG_EVENTS" ] || : > "$IMPACT_LOG_EVENTS"
  [ -f "$IMPACT_LOG_STATE" ] || echo '{"enabled":true,"event_count":0,"last_event_ts":null}' > "$IMPACT_LOG_STATE"
}

git_repo_slug() {
  local remote
  remote=$(git -C "$1" remote get-url origin 2>/dev/null) || { echo ""; return 0; }
  remote="${remote%.git}"
  awk -F'[/:]' '{print $(NF-1)"/"$NF}' <<< "$remote"
}

git_branch() {
  git -C "$1" branch --show-current 2>/dev/null
}

# Appends a single-line JSON event and bumps state.json. $1 = json object.
impact_log_append() {
  impact_log_init_home
  echo "$1" >> "$IMPACT_LOG_EVENTS"
  local now count
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  count=$(( $(jq -r '.event_count // 0' "$IMPACT_LOG_STATE" 2>/dev/null || echo 0) + 1 ))
  jq -nc --arg ts "$now" --argjson count "$count" \
    '{enabled:true, event_count:$count, last_event_ts:$ts}' > "$IMPACT_LOG_STATE.tmp" \
    && mv "$IMPACT_LOG_STATE.tmp" "$IMPACT_LOG_STATE"
}
