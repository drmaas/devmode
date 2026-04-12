# CLAUDE.md

Read `SOUL.md` first — it defines who you are.

Then read `AGENTS.md` — it defines how this team operates.

## Team Model

Two owners. No exceptions.

- `/builder` — implementation. Analysis through delivery.
- `/reviewer` — review. Correctness, architecture, conventions.

One owner active at a time. Skills handle specialization.

## Session Start

1. Discover the active development mode from `docs/modes.md`.
2. If none is set, ask the user to pick one before implementing.
3. Never assume a mode silently.

## Available Skills

Skills live in `.claude/skills/`. They are auto-discoverable.

## Quality Gates

Run the repository's configured checks before handoff:

- Type safety / static analysis
- Lint / format
- Tests (unless mode is `vibe` or `poc`)

## Execution

Work in a Ralph Loop: iterate until complete, verified, and delivered. Do not stop at analysis-only states.
