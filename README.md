# Claude Code Extensions

Claude Code Extensions is a collection of small, practical extensions for making AI-assisted work more useful, repeatable, and shareable.

The repo is organized like a skills catalog: each extension lives in its own folder, includes a `SKILL.md`, and can carry nearby reference docs, scripts, templates, or examples when the extension needs them.

## Structure

```text
.
├── .claude-plugin/
│   └── plugin.json
├── docs/
│   └── authoring.md
├── scripts/
│   └── list-skills.sh
└── skills/
    ├── engineering/
    ├── productivity/
    ├── personal/
    └── in-progress/
```

## Skill Categories

- [Engineering](./skills/engineering/README.md): coding, review, debugging, architecture, delivery, and repo workflows.
- [Productivity](./skills/productivity/README.md): planning, writing, handoffs, learning, and personal operating systems.
- [Personal](./skills/personal/README.md): extensions tuned to personal workflows that may still be useful to others.
- [In Progress](./skills/in-progress/README.md): experiments that are not polished enough to recommend yet.

## Conventions

Each extension should use this shape:

```text
skills/<category>/<extension-name>/
├── SKILL.md
└── optional-supporting-files.md
```

`SKILL.md` is the entry point. Supporting files should sit next to the skill and be referenced from the skill only when they are useful for progressive disclosure.

## Status

This project is just getting started. The current focus is building the repository structure and authoring standards before adding the first real extensions.
