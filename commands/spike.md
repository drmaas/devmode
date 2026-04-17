---
description: Exploratory implementation workflow for rapid validation of uncertain ideas.
argument-hint: [task description]
---

Run the devmode `/spike` workflow.

Use `devmode-builder` as the implementation owner with this contract:

1. Keep scope intentionally narrow.
2. Move fast to validate assumptions and feasibility.
3. Mark tradeoffs, risks, and non-production shortcuts clearly.
4. Run lightweight validation unless the user requests production hardening.
5. Hand off to `devmode-reviewer` if code quality decisions are needed.

Prefer `devmode-librarian` for discovery and `devmode-coder` for rapid implementation.

If `$ARGUMENTS` is non-empty, treat it as the active task objective.