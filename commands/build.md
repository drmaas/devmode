---
description: Default implementation workflow with lightweight planning and full review handoff.
argument-hint: [task description]
---

Run the devmode `/build` workflow.

Use `devmode-builder` as the implementation owner with this contract:

1. Create a lightweight plan (scope, touched files, validation approach).
2. Implement end-to-end.
3. Run type/lint checks and the strongest practical tests for changed surfaces.
4. Hand off to `devmode-reviewer` for a verdict.
5. If review requests changes, iterate until approved.

Use `devmode-orchestrator`, `devmode-librarian`, and `devmode-coder` skills as needed.
Load `devmode-tester` and `devmode-gatekeeper` before validation.

If `$ARGUMENTS` is non-empty, treat it as the active task objective.