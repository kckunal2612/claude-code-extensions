# Claude Code Extensions

Claude Code Extensions is a collection of installable Claude Code extensions for making AI-assisted work more useful, repeatable, and shareable.

The first extension is [Impact Log](./impact-log/README.md), an install-once helper that ambiently captures work evidence for quarterly reflections, visibility updates, demos, and performance reviews.

## Structure

```text
.
└── impact-log/
    ├── .claude-plugin/
    │   └── plugin.json
    ├── bin/
    │   └── impact-log
    ├── hooks/
    │   └── hooks.json
    ├── statusline/
    ├── templates/
    ├── DESIGN.md
    └── README.md
```

## Extensions

- [Impact Log](./impact-log/README.md): ambient work-evidence capture for reviews and reflections. See [DESIGN.md](./impact-log/DESIGN.md) for the implementation decisions behind the V0.

## Direction

This repo is not a broad prompt or skills catalog. Each folder should be a concrete Claude Code extension with a clear install story, a practical workflow, and enough documentation for someone else to try it.

## Status

This project is just getting started. The current focus is proving the `impact-log` extension before adding more.
