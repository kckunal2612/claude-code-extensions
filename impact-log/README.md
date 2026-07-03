# Impact Log

Ambiently captures work evidence — repo, branch, tool activity, git/gh history — so you have concrete material for quarterly reflections, visibility updates, demos, and performance reviews. Install once. No slash commands required.

See [DESIGN.md](./DESIGN.md) for the architecture and the reasoning behind it.

## Requirements

- `jq` (hooks no-op silently if missing — capture never blocks the agent)
- `git`
- `gh` (optional — enables merged-PR evidence in reports)
- The `claude` CLI available on `PATH` (used non-interactively for report synthesis)

## Install

1. Install this plugin in Claude Code (adds the hooks in [hooks/hooks.json](./hooks/hooks.json) automatically).
2. Run the one-time setup:

   ```
   impact-log init
   ```

   This creates `~/.claude/impact-log/` (or `$IMPACT_LOG_HOME` if set) as the local, append-only evidence store. Nothing is written inside this repo or any project repo.

3. (Optional) Show capture status in your statusline by adding to `settings.json`:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/absolute/path/to/impact-log/statusline/impact-log-status.sh"
     }
   }
   ```

   Claude Code only supports one active statusline at a time, so this step is manual — the plugin can't register it for you.

## Usage

```
impact-log status          # is capture active, how much has it seen
impact-log weekly          # synthesize this week's report from captured evidence
impact-log weekly --since 2026-06-01
impact-log quarterly       # roll up this quarter's weekly reports
impact-log needs-context   # list low-confidence events worth a manual look
```

Reports land in `~/.claude/impact-log/reports/weekly/` and `.../quarterly/` as Markdown.

## Relationship to demo-prep

`impact-log` is the live evidence/memory layer — it runs continuously in the background. `demo-prep` is a downstream generator that turns a *selected slice* of history into a presentation. Point `demo-prep` at an `impact-log` weekly or quarterly report instead of raw git history for a richer starting point.
