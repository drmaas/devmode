---
description: Default implementation workflow with lightweight planning and full review handoff.
argument-hint: [--no-loop] [task description]
---

Run the devmode `/build` workflow.

Before proceeding, check `$ARGUMENTS` for flags:

- If `--no-loop` is present: run a single pass and hand off without iterating.
- Otherwise: use standard Ralph Loop iteration.
- Strip `--no-loop` from `$ARGUMENTS` and treat the remainder as the task objective.

Use `devmode-builder` as the implementation owner with this contract:

1. Create a lightweight plan (scope, touched files, validation approach).
2. Implement end-to-end.
3. Run type/lint checks and the strongest practical tests for changed surfaces.
4. Hand off to `devmode-reviewer` for a verdict.
5. If review requests changes, iterate until approved.

Use `devmode-orchestrator`, `devmode-librarian`, and `devmode-coder` skills as needed.
Load `devmode-tester` and `devmode-gatekeeper` before validation.

