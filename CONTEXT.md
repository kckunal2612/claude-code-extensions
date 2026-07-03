# Project Context

## Purpose

Claude Code Extensions is a public home for installable Claude Code extensions.

The first extension is `impact-log`: an ambient helper that captures work evidence over time for quarterly reflections, visibility updates, demos, and performance reviews.

## Terms

- Extension: A concrete, installable Claude Code plugin or helper.
- Impact Log: The first extension in this repo. It records lightweight breadcrumbs from Claude Code sessions and synthesizes reports later.
- Breadcrumb: A small evidence pointer such as timestamp, repo, branch, tool kind, or file path. Breadcrumbs avoid duplicating full command text, diffs, or file contents.
- Report: A generated Markdown weekly or quarterly summary built from breadcrumbs plus fresh git/GitHub evidence.

## Repository Shape

Each extension should live in a top-level folder, for example:

```text
impact-log/
├── .claude-plugin/plugin.json
├── bin/
├── hooks/
├── statusline/
├── templates/
├── DESIGN.md
└── README.md
```

Do not add broad category folders until there are enough real extensions to justify them.
