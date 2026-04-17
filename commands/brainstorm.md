---
description: Non-coding workflow for options, tradeoffs, architecture thinking, and decision support.
argument-hint: [topic]
---

Run the devmode `/brainstorm` workflow.

Behavior contract:

1. Do not edit files or run implementation steps.
2. Explore options, constraints, tradeoffs, and risks.
3. Propose a concrete implementation path and validation plan.
4. Recommend when to switch to `/build`, `/tdd`, `/spec`, or `/spike`.

Use `devmode-architect` and `devmode-orchestrator` as needed.

If `$ARGUMENTS` is non-empty, treat it as the active topic.