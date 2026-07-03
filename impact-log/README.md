# Impact Log

✨ **Impact Log turns your everyday Claude Code work into review-ready evidence.**

It ambiently captures lightweight breadcrumbs from your Claude Code sessions — repo, branch, tool activity, and timestamps — then uses fresh `git` and GitHub history to synthesize weekly and quarterly Markdown reports. Install it once, keep working normally, and stop trying to reconstruct three months of invisible work from memory.

## Why Use It

Impact Log is for the moments when your work mattered but the trail is scattered:

- 🧾 **Performance reviews:** turn commits, merged PRs, and Claude Code activity into concrete self-review material.
- 📣 **Visibility updates:** produce a weekly summary without hand-writing a status report from scratch.
- 🎤 **Demos and sprint reviews:** find shipped work and meaningful progress across repos.
- 🧠 **Personal reflection:** notice themes, gaps, and repeated kinds of impact over time.

The core idea is simple: **capture where and when work happened, then read the real evidence later.** Impact Log does not store file contents, diffs, full commands, or PR bodies in its event log.

## How It Works

Impact Log installs Claude Code hooks that run quietly in the background:

1. 🪝 **Hooks capture breadcrumbs** when you edit files or run recognized development commands.
2. 📍 **Breadcrumbs point to repos and branches** instead of duplicating sensitive work details.
3. 🔎 **Reports pull fresh evidence** from `git log` and, when available, `gh pr list`.
4. 📝 **Claude Code synthesizes Markdown reports** using the bundled weekly and quarterly templates.

Everything is local-first. The evidence store lives at `~/.claude/impact-log/` by default, or `$IMPACT_LOG_HOME` if you set it.

See [DESIGN.md](./DESIGN.md) for the architecture, privacy decisions, and deferred ideas.

## Requirements

- `jq` for safe JSON handling. Hooks no-op if it is missing, so capture never blocks Claude Code.
- `git` for repository evidence.
- `gh` optional, for merged pull request evidence.
- `claude` on `PATH`, used non-interactively for report synthesis.

## Install

Add this repo as a plugin marketplace once, then install Impact Log:

```text
/plugin marketplace add kckunal2612/claude-code-extensions
/plugin install impact-log@claude-code-extensions
```

This repo ships a [`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json) entry for `impact-log`, so the commands above resolve through Claude Code's plugin marketplace flow.

The install adds the hooks in [hooks/hooks.json](./hooks/hooks.json). Capture starts automatically from your next Claude Code session. On first session start, Impact Log also wires in its statusline when you do not already have a different statusline configured.

## First Check

Ask Claude Code:

```text
use impact-log to check capture status
```

Or run the CLI directly from the plugin directory:

```bash
./bin/impact-log status
```

You should see the event store location, total captured events, today's count, and the last captured timestamp.

## Everyday Usage

The easiest path is to ask Claude Code to use the bundled skill:

```text
use impact-log to generate my weekly report
use impact-log to generate my quarterly report
use impact-log to list items that need context
use impact-log to enable the statusline
```

The underlying CLI commands are shown below. If you run them directly from the plugin directory, prefix them with `./bin/`; if you have added the plugin `bin/` directory to `PATH`, use them as written.

```bash
impact-log status
impact-log weekly
impact-log weekly --since 2026-06-01
impact-log quarterly
impact-log needs-context
impact-log statusline enable
impact-log statusline disable
```

Generated reports land in:

```text
~/.claude/impact-log/reports/weekly/
~/.claude/impact-log/reports/quarterly/
```

## Statusline

Impact Log can show capture activity in the Claude Code statusline.

Run this if you want to explicitly enable it:

```bash
impact-log statusline enable
```

Claude Code only supports one active statusline at a time. Impact Log will not overwrite a different statusline unless you intentionally pass `--force`:

```bash
impact-log statusline enable --force
```

Disable it with:

```bash
impact-log statusline disable
```

The statusline command points at a stable copy under `$IMPACT_LOG_HOME`, not the plugin install path. That matters because plugin install paths under `~/.claude/plugins/` can change after updates.

## When To Run Reports

- 🗓️ **Weekly:** run `impact-log weekly` at the end of the week, before details fade.
- 🧭 **Before 1:1s:** run `impact-log weekly --since YYYY-MM-DD` to prepare a recent update.
- 🏁 **End of quarter:** run `impact-log quarterly` after you have a few weekly reports.
- 🔦 **Before sharing:** run `impact-log needs-context` to find ambiguous events worth a human note.

Reports are meant to be a strong first draft, not a final performance review. Review them, add missing business context, and delete anything that does not belong.

## Relationship To demo-prep

`impact-log` is the live evidence and memory layer. It runs continuously in the background and produces Markdown summaries.

`demo-prep` is a downstream presentation generator. Point `demo-prep` at an Impact Log weekly or quarterly report instead of raw git history when you want a richer starting point for a demo deck.

## Privacy Model

Impact Log is intentionally conservative:

- It stores lightweight JSONL breadcrumbs, not file contents or diffs.
- Bash capture records only recognized command verbs and subcommands, not full command lines.
- Low-confidence events are flagged for review instead of being silently discarded or over-explained.
- The store lives outside project repos so it is not accidentally committed.
- Sync is not implemented in V0; no private GitHub backup is created.

For the full rationale, see [DESIGN.md](./DESIGN.md).

## Troubleshooting

### `impact-log status` says jq is missing

Install `jq`, then start a new Claude Code session. Hooks skip capture when `jq` is unavailable.

### No events are captured yet

Ask Claude Code to run `impact-log init`, or run `./bin/impact-log init` from the plugin directory. Then use Claude Code in a git repo with a normal `origin` remote. Capture begins from future sessions after the plugin hooks are active.

### The statusline did not install automatically

You probably already had a different statusline configured. Ask Claude Code to run `impact-log statusline enable`, or run `./bin/impact-log statusline enable` from the plugin directory, to see what is currently set. Use `--force` only if you intentionally want Impact Log to replace it.

### Direct shell usage stopped working after a plugin update

The installed plugin path can change across updates. Asking Claude Code to use the Impact Log skill avoids this. If you prefer shell usage, re-add the current plugin `bin/` directory to your `PATH`.
