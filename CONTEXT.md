# Project Context

## Purpose

Claude Code Extensions is a public catalog for reusable Claude Code skills and related agent workflows.

## Terms

- Extension: A reusable workflow, skill, script, or small package of instructions that improves Claude Code.
- Skill: A Claude-compatible extension with a `SKILL.md` entry point.
- Category: A top-level grouping under `skills/`, such as `engineering`, `productivity`, or `personal`.
- Stable extension: An extension that is documented, tested through real use, and listed in `.claude-plugin/plugin.json`.
- In-progress extension: An experiment kept under `skills/in-progress/` until it is ready to promote.

## Repository Shape

Stable skills live under `skills/<category>/<name>/SKILL.md`.

Reference docs live under `docs/`.

Utility scripts live under `scripts/`.
