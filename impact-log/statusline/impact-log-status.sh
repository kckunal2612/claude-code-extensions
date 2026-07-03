#!/usr/bin/env bash
# Claude Code statusline script. Reads and discards stdin (session context we
# don't need), then prints a single status line. Must stay fast — this runs
# on every statusline refresh.
cat >/dev/null 2>&1 || true

HOME_DIR="${IMPACT_LOG_HOME:-$HOME/.claude/impact-log}"
STATE="$HOME_DIR/state.json"
EVENTS="$HOME_DIR/events.jsonl"

if ! command -v jq >/dev/null 2>&1 || [ ! -f "$STATE" ]; then
  echo "impact-log: off"
  exit 0
fi

today=$(date -u +%Y-%m-%d)
today_count=0
if [ -f "$EVENTS" ]; then
  today_count=$(grep -c "\"ts\":\"$today" "$EVENTS" 2>/dev/null || true)
  today_count=${today_count:-0}
fi
echo "📝 impact-log: ${today_count} today"
