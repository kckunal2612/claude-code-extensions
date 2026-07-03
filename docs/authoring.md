# Authoring Guide

Use this guide when creating a new extension.

## Folder Shape

Create one folder per extension:

```text
skills/<category>/<extension-name>/
├── SKILL.md
└── optional-supporting-files.md
```

Use kebab-case for extension folder names.

## `SKILL.md`

Every `SKILL.md` should include:

- A short name and description in frontmatter.
- Clear trigger guidance.
- The workflow the agent should follow.
- References to supporting files only when they are needed.

## Supporting Files

Keep supporting material close to the skill that uses it. Examples:

- Checklists
- Templates
- Scripts
- Reference docs
- Example outputs

## Promotion Checklist

Before moving an extension out of `skills/in-progress/`:

- It has been tried on a real task.
- The trigger guidance is clear.
- The workflow is specific enough to follow.
- Supporting files are referenced from `SKILL.md`.
- The relevant category README lists it.
- `.claude-plugin/plugin.json` includes the extension path if it should be installable.
