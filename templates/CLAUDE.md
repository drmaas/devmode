# CLAUDE.md - devmode

This repository uses **devmode** to control how the active coding harness executes work.

## Core command

Use `/devmode` to choose or inspect the active development mode.

## Execution model

- Implementation-oriented work routes to the `devmode-builder` subagent.
- Review work routes to the `devmode-reviewer` subagent.
- Mode state is stored outside the repository and read through the global `devmode` CLI.

## Installed skills

- `devmode-orchestrator`
- `devmode-librarian`
- `devmode-coder`
- `devmode-tester`
- `devmode-gatekeeper`
- `devmode-architect`
- `devmode-code-review`
- `devmode-ux-designer` (load when work touches frontend UX, accessibility, or other user-facing design)

## Expectations

1. Discover or set the active mode before implementation.
2. Follow the workflow required by that mode.
3. Keep implementation and review ownership separate.
4. Use repo-specific rules in this file alongside the installed devmode workflow.
