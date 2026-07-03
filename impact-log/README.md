# Impact Log

Ambiently captures work evidence — repo, branch, tool activity, git/gh history — so you have concrete material for quarterly reflections, visibility updates, demos, and performance reviews. Install once. No slash commands required.

See [DESIGN.md](./DESIGN.md) for the architecture and the reasoning behind it.

## Requirements

- `jq` (hooks no-op silently if missing — capture never blocks the agent)
- `git`
- `gh` (optional — enables merged-PR evidence in reports)
- The `claude` CLI available on `PATH` (used non-interactively for report synthesis)

## Install

1. Add this repo as a plugin marketplace (once) and install the plugin:

   ```
   /plugin marketplace add kckunal2612/claude-code-extensions
   /plugin install impact-log@claude-code-extensions
   ```

   This repo ships a [`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json) listing `impact-log`, so the commands above resolve through Claude Code's plugin marketplace flow.

   This installs the hooks in [hooks/hooks.json](./hooks/hooks.json) — capture starts automatically from your next session. On first session start, Impact Log also wires its statusline into Claude Code if you do not already have a different statusline configured. The plugin also ships an `impact-log` skill that tells Claude Code how to run the bundled CLI from the plugin directory.

2. (Optional) Run setup yourself if you want to refresh the stable statusline copy or initialize the store before the next Claude Code session:

   ```
   impact-log init
   ```

   This creates `~/.claude/impact-log/` (or `$IMPACT_LOG_HOME` if set) as the local, append-only evidence store, and copies the statusline script to a stable path outside the plugin install directory. Nothing is written inside this repo or any project repo. It's optional because the hooks create the store and refresh the statusline copy themselves on first capture.

3. If you already had a different statusline and want Impact Log to replace it:

   ```
   impact-log statusline enable
   ```

   This patches `statusLine` in `settings.json` (`$CLAUDE_CONFIG_DIR/settings.json`, default `~/.claude/settings.json`) to point at the stable copy in `$IMPACT_LOG_HOME` — not at the plugin's own install path, since plugin install paths are ephemeral and change on every update. Claude Code only supports one active statusline at a time: automatic setup and `enable` both refuse to overwrite an existing different one unless you pass `--force`, and `impact-log statusline disable` only removes it if it's the one impact-log set.

## Usage

The simplest way to use this is to ask Claude Code, in chat, to use Impact Log:

```
use impact-log to check capture status
use impact-log to generate my weekly report
use impact-log to enable the statusline
```

The underlying CLI commands are:

```
impact-log status          # is capture active, how much has it seen
impact-log weekly          # synthesize this week's report from captured evidence
impact-log weekly --since 2026-06-01
impact-log quarterly       # roll up this quarter's weekly reports
impact-log needs-context   # list low-confidence events worth a manual look
```

To run these directly from your own shell (outside Claude Code) instead, add the plugin's `bin/` directory to your shell's `PATH` — but note that path lives under `~/.claude/plugins/` and is not stable across plugin updates, so it needs re-adding after updates. Asking Claude Code to use the Impact Log skill avoids that entirely.

Reports land in `~/.claude/impact-log/reports/weekly/` and `.../quarterly/` as Markdown.

## Relationship to demo-prep

`impact-log` is the live evidence/memory layer — it runs continuously in the background. `demo-prep` is a downstream generator that turns a *selected slice* of history into a presentation. Point `demo-prep` at an `impact-log` weekly or quarterly report instead of raw git history for a richer starting point.

## Notes

- **Direct-shell usage of `bin/impact-log`** outside Claude Code requires locating the installed plugin directory yourself. That path lives under `~/.claude/plugins/` and can change across plugin updates. The statusline path is handled explicitly through a stable copy outside the plugin directory.
