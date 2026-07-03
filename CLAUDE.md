# Claude Code Extensions Guidance

This repository contains reusable Claude Code extensions.

When adding or editing an extension:

- Keep the extension small and composable.
- Put each extension in `skills/<category>/<extension-name>/`.
- Use `SKILL.md` as the entry point.
- Keep supporting files next to the skill that uses them.
- Update the relevant category README and the root README when adding a stable extension.
- Add paths to `.claude-plugin/plugin.json` only for extensions that are ready to install.

Prefer practical workflows that have been used on real tasks over abstract prompt collections.
