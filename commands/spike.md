---
description: Exploratory implementation workflow for rapid validation of uncertain ideas.
argument-hint: [--no-loop] [task description]
---

Run the devmode `/spike` workflow.

Before proceeding, check `$ARGUMENTS` for flags:

- If `--no-loop` is present: run a single pass and hand off without iterating.
- Otherwise: use standard Ralph Loop iteration.
- Strip `--no-loop` from `$ARGUMENTS` and treat the remainder as the task objective.

Use `devmode-builder` as the implementation owner with this contract:

1. Keep scope intentionally narrow.
2. Move fast to validate assumptions and feasibility.
3. Mark tradeoffs, risks, and non-production shortcuts clearly.
4. Run lightweight validation unless the user requests production hardening.
5. Hand off to `devmode-reviewer` if code quality decisions are needed.

Prefer `devmode-librarian` for discovery and `devmode-coder` for rapid implementation.

