# devmode rule

This repository uses **devmode** for Claude Code workflow control.

- Set or inspect the current mode with `/devmode:dm`.
- Implementation work routes to `devmode-builder`.
- Review work routes to `devmode-reviewer`.
- Mode state is stored outside the repository and read through the global `devmode` CLI.

Installed internal skills:

- `devmode-orchestrator`
- `devmode-librarian`
- `devmode-coder`
- `devmode-tester`
- `devmode-gatekeeper`
- `devmode-architect`
- `devmode-code-review`
