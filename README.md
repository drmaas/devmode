# devmode

devmode is a plugin-first workflow toolkit for Claude Code.

This repository is the plugin. It does not require a global `devmode` CLI, mode files, or repo-install script.

## What devmode provides

- workflow entrypoint commands instead of a stateful mode switcher
- stable owner agents for implementation and review
- reusable skills for planning, architecture, coding, testing, validation, and UX

## Install

Install from a plugin source:

```bash
/plugin install devmode@claude-code-marketplace
```

For local development, load this repository as a plugin directory.

## Workflow Commands

Each workflow is an explicit command. No global active mode is required.

- `/build` - default implementation flow (plan -> implement -> validate -> review)
- `/tdd` - tests-first implementation flow
- `/spec` - requirements/spec/task-driven implementation flow
- `/spike` - exploratory implementation flow, not production-ready by default
- `/brainstorm` - non-coding exploration and option analysis

## Architecture

- commands choose the workflow contract for the current task
- `devmode-builder` owns implementation
- `devmode-reviewer` owns review decisions
- skills provide specialized execution guidance

## Repository Layout

- `.claude-plugin/plugin.json` - plugin manifest
- `commands/` - workflow entrypoints
- `agents/` - owner agents
- `skills/` - reusable execution skills
- `CLAUDE.md` - repository policy and contributor guidance

## Migration Notes (v2)

This version intentionally removes the legacy model:

- removed global `devmode` shell script
- removed repo installer and template-copy flow
- removed persistent mode state and hook-based injection
- removed `/devmode set|status|list|explain`

Use explicit workflow commands per task instead.
