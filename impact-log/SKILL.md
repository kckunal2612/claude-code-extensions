---
name: impact-log
description: Use when the user asks about impact-log, work evidence capture, weekly or quarterly impact reports, captured Claude Code activity, statusline setup for Impact Log, or commands such as impact-log status/init/weekly/quarterly/needs-context/statusline.
---

# Impact Log

Impact Log is a Claude Code plugin that captures local work evidence through hooks and provides a bundled CLI at `bin/impact-log`. It is designed to turn everyday Claude Code activity into weekly and quarterly Markdown reports for visibility updates, demos, personal reflection, and performance reviews.

## When To Use

Use this skill when the user asks to:

- Check whether Impact Log capture is active.
- Initialize or repair Impact Log's local store.
- Generate a weekly or quarterly impact report.
- Find low-confidence entries that need manual context.
- Enable, disable, or troubleshoot the Impact Log statusline.
- Understand or troubleshoot the Impact Log plugin.

## How To Run It

Run the bundled CLI through Bash from the plugin root:

```bash
./bin/impact-log status
./bin/impact-log init
./bin/impact-log weekly
./bin/impact-log weekly --since 2026-06-01
./bin/impact-log quarterly
./bin/impact-log needs-context
./bin/impact-log statusline enable
./bin/impact-log statusline disable
```

If Claude Code runs this skill from another working directory, first locate the plugin root from the skill file path or the installed plugin directory, then invoke `bin/impact-log` from there. Do not assume the user's current repository contains an `impact-log` command.

## How To Interpret Results

- `status` should tell the user whether capture is initialized, how many events exist, and where the local store lives.
- `weekly` and `quarterly` write Markdown reports under `~/.claude/impact-log/reports/` unless `IMPACT_LOG_HOME` is set. Report the output path back to the user.
- `needs-context` lists low-confidence events. Present these as optional review items, not as failures.
- If a command reports missing `jq`, explain that hooks skip capture until `jq` is installed so Claude Code work is not blocked.

## Notes

- The plugin's hooks capture evidence automatically after install and reload.
- The SessionStart hook automatically installs the Impact Log statusline when no different statusline is already configured.
- `impact-log init` is safe to run more than once.
- `impact-log statusline enable` edits the user's Claude Code `settings.json`; mention this before running it when the user has not explicitly requested statusline setup.
- Reports are written under `~/.claude/impact-log/reports/` unless `IMPACT_LOG_HOME` is set.
- Impact Log captures breadcrumbs, not file contents, diffs, full shell commands, or PR bodies.
