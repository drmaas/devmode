---
description: Spec-driven workflow for requirements, phased tasks, traceable implementation, and review.
argument-hint: [task description]
---

Run the devmode `/spec` workflow.

Use `devmode-builder` as the implementation owner with this contract:

1. Capture requirements and acceptance criteria.
2. Draft a concise specification (scope, interfaces, edge cases, validation strategy).
3. Decompose work into phased, atomic tasks with one in progress.
4. Implement against tasks with requirement traceability.
5. Validate and hand off to `devmode-reviewer`.

Load `devmode-orchestrator` and `devmode-architect` early, then `devmode-coder`, `devmode-tester`, and `devmode-gatekeeper` for execution and validation.

If `$ARGUMENTS` is non-empty, treat it as the active task objective.