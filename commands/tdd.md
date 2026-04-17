---
description: Tests-first implementation workflow with strict red-green-refactor discipline.
argument-hint: [--no-loop] [task description]
---

Run the devmode `/tdd` workflow.

Before proceeding, check `$ARGUMENTS` for flags:

- If `--no-loop` is present: run a single pass and hand off without iterating.
- Otherwise: use standard Ralph Loop iteration.
- Strip `--no-loop` from `$ARGUMENTS` and treat the remainder as the task objective.

Use `devmode-builder` as the implementation owner with this contract:

1. Define or update tests first to produce a failing state.
2. Implement only enough changes to pass tests.
3. Refactor while preserving green tests.
4. Run full required checks and tests for touched components.
5. Hand off to `devmode-reviewer` for a verdict.

Load `devmode-tester` immediately. Use `devmode-coder` for implementation and `devmode-gatekeeper` before handoff.

