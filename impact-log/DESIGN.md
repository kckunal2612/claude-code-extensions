# Design

This expands the original idea note into concrete decisions for V0. Where the note left something open, the decision and reasoning are recorded here so later changes are deliberate, not accidental.

## Breadcrumbs now, evidence at read time

The hooks do **not** store commit messages, diffs, PR bodies, or command text. They store lightweight breadcrumbs: timestamp, session id, repo slug, branch, which tool ran, and (for file tools) the file path touched.

The actual rich evidence — commit subjects, merged PR titles — is pulled fresh from `git log` and `gh pr list` at `weekly`/`quarterly` synthesis time, scoped to the repos and time windows the breadcrumbs point at. This means:

- The JSONL store stays small and cheap to append to on every tool call.
- Nothing sensitive (secrets in commands, file contents, commit message bodies) is duplicated into a second store.
- Reports are always as accurate as the underlying git/gh history, even if that history was rewritten after the fact (rebases, squash-merges) — the breadcrumbs just say *where and when to look*, not *what happened*.

This is the core mechanism for the note's "do not ask the developer what they did" principle: the system doesn't need to remember *what*, only *where/when*, because git already remembers *what*.

## What counts as evidence-worthy

`PostToolUse` fires on every tool call. Recording all of them would make the log noisy and would risk capturing sensitive command text. V0 only records:

- `Edit`, `Write`, `MultiEdit`, `NotebookEdit` — the file path only, never contents.
- `Bash` — only if the command's first word is a recognized verb (`git`, `npm`, `pnpm`, `yarn`, `pytest`, `cargo`, `go`, `make`, `docker`, `terraform`), and only the verb + subcommand (e.g. `git commit`, `npm test`), never the full command line. This avoids capturing flags, file arguments, or embedded secrets.

Everything else (`Read`, `Grep`, `Glob`, `TodoWrite`, unrecognized `Bash` commands, etc.) is ignored. This can be widened later, but starting narrow is safer for a tool that runs unattended and writes to disk on every call.

## Confidence and "needs context"

An event is `confidence: "low"` when the working directory isn't a git repo with a resolvable `origin` remote — i.e. the tool ran somewhere impact-log can't attribute to a project. These events are still recorded (so nothing is silently dropped) but are surfaced separately via `impact-log needs-context` and called out in a dedicated section of the weekly report, rather than being asserted as attributed work. The system never blocks or prompts to ask "what was this?" — per the core principle, low-confidence items are just flagged for an optional human pass, never interrupted for.

## Storage location: outside the repo, outside any project

Data lives in `~/.claude/impact-log/` (overridable via `$IMPACT_LOG_HOME`), not inside this plugin's repo and not inside any project repo. Two reasons:

1. Work spans many repos; quarterly reflection needs a store that isn't scoped to one project.
2. This plugin's own source lives in a public repo. Work evidence — even lightweight breadcrumbs — should never risk being committed to git history by accident.

Local-first per the note; the sync step described below is deliberately deferred.

## Synthesis via `claude -p`, not custom NLG

`impact-log weekly` and `impact-log quarterly` are bash that gathers raw evidence (breadcrumb-scoped `git log`/`gh pr list` output) and pipes it through `claude -p` with the relevant template ([templates/weekly.md](./templates/weekly.md), [templates/quarterly.md](./templates/quarterly.md)) as the instruction. This reuses Claude Code itself as the synthesis engine instead of writing a bespoke summarizer, and keeps the prompt explicit about not inventing unevidenced work.

## Statusline is opt-in and manual

Claude Code statuslines are configured once, globally, via the user's `settings.json` — a plugin cannot auto-register one, and only one can be active at a time. `impact-log` ships [statusline/impact-log-status.sh](./statusline/impact-log-status.sh) and documents the `settings.json` snippet in the README, but wiring it in is a manual, optional step for users who don't already have a statusline they'd rather keep.

## Deferred to a later version

- **Sync to a private GitHub repo.** V0 is local-only. When added, it should push the JSONL/reports to a private repo the user controls — never a shared one — and remain opt-in.
- **`Stop`-based task bucketing.** `hooks/stop.sh` already records turn boundaries, but V0's synthesis doesn't use them yet. A later version could group `tool_use` events between consecutive `stop` events into a single "unit of work" for tighter weekly summaries.
- **Widening captured tools/commands** once the noise/signal tradeoff has been observed in real use.
