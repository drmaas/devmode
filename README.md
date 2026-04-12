# coding-agent-template

A generic, skill-first template for setting up coding agents with clear separation of concerns and low token overhead. Works as a Claude Code plugin out of the box.

## Purpose

This template gives you a minimal team model:

- `/builder` owns implementation.
- `/reviewer` owns review.

Specialized work is handled through skills/commands loaded by the active owner, not by adding many permanent owner roles.

## Repository Layout

| File / Directory | Purpose |
| --- | --- |
| `CLAUDE.md` | Root context file. Claude reads this automatically every session. |
| `AGENTS.md` | Team policy and routing rules (generic, reusable across repos). |
| `SOUL.md` | Shared behavioral defaults for all agents. |
| `.claude/commands/builder.md` | Implementation owner (`/builder` slash command). |
| `.claude/commands/reviewer.md` | Review owner (`/reviewer` slash command). |
| `.claude/skills/` | Auto-discoverable project skills. |
| `docs/modes.md` | Canonical source for active development mode. |

## Built-in Skills

| Skill | Purpose |
| --- | --- |
| `orchestrator` | Task decomposition, dependency ordering, handoff protocol. |
| `librarian` | Codebase navigation, dependency tracing, knowledge retrieval. |
| `coder` | Implementation patterns, refactoring discipline, type safety. |
| `tester` | Test strategy, test generation, coverage analysis. |
| `gatekeeper` | Quality gate enforcement, pre-handoff verification. |
| `architect` | System design, boundary enforcement, tradeoff analysis. |
| `ux-designer` | UI/UX patterns, accessibility, component design. |
| `code-review` | Review methodology, severity classification, feedback format. |
| `playwright-cli` | Browser automation, E2E testing, screenshots. |

`/builder` loads only the skills needed for the current step to conserve tokens.

## Installation

Clone or copy this template into your repository root. Claude Code will auto-discover:

- `CLAUDE.md` — loaded every session as persistent context.
- `.claude/commands/*.md` — available as `/builder` and `/reviewer` slash commands.
- `.claude/skills/*/SKILL.md` — available as auto-invocable skills.

No additional configuration needed.

## Operating Model

### Ownership

- Keep one active owner at a time.
- `/builder` executes end-to-end implementation.
- `/reviewer` reviews and returns a verdict.
- Delivery happens only after review passes.

### Workflow (default)

1. `/builder` analyzes scope and selects the minimal required skill set.
2. `/builder` implements and runs required verification checks.
3. `/reviewer` reviews for correctness, conventions, and risk.
4. `/builder` addresses feedback and finalizes delivery.

### Development modes

The template supports five optional modes:

- `traditional`
- `tdd`
- `vibe`
- `poc`
- `sdd` (spec-driven development)

At session start, the active owner should first discover the current mode from `docs/modes.md` (or another documented source). If none is discoverable, ask the user to choose before implementing.

For `sdd`, use this order:

1. Requirements
2. Specification
3. Plan
4. Atomic tasks (one in progress at a time)
5. Implementation
6. Verification + review

### Why this model

- Preserves separation of concerns.
- Reduces coordination overhead.
- Conserves tokens by avoiding unnecessary role switching.
- Still supports deep specialization through skills.

### Ralph Loop execution

Agents should run in a Ralph Loop: iterate until goal completion, verification pass, review pass, and final delivery. Avoid stopping at analysis-only states.

## Customizing for your repository

1. Fill in `AGENTS.md` Project Context.
2. Define your repository's concrete quality gate commands.
3. Document where development mode is stored/discovered.
4. Add only skills your team actually needs to `.claude/skills/`.
5. Keep owner roles limited to `builder` and `reviewer` unless there is a strong, sustained reason otherwise.

## Cross-platform compatibility

While the `.claude/` layout is native to Claude Code, the content files (`AGENTS.md`, `SOUL.md`, `docs/modes.md`) use open formats readable by any AI coding agent. Other platforms that read `AGENTS.md` (Codex, Copilot, Cursor, etc.) will pick up the team policy automatically.
