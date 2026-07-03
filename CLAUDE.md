# Claude Code Extensions

This repository contains installable Claude Code extensions.

Current focus: `impact-log`, an ambient work-evidence capture plugin for Claude Code.

When editing this repo:

- Do not reintroduce the old generic `skills/` catalog structure.
- Keep each extension as a concrete, installable folder at the repo root.
- Keep extension-specific plugin metadata inside that extension folder.
- Prefer local-first behavior for tools that collect user work evidence.
- Avoid prompts that ask the developer to remember what they did; infer from existing artifacts where possible.
- Keep docs honest about what is implemented versus deferred.
