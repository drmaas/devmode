# Development Modes

This file is the canonical place to declare the active development mode for the repository.

## Active Mode

Set one value:

- `traditional`
- `tdd`
- `vibe`
- `poc`
- `sdd`

Example:

```md
## Active Mode

`sdd`
```

## Session Start Rule

At the start of each coding session, the active owner must:

1. Discover the mode from this file (or another documented source), or
2. Ask the user to choose a mode if no source is configured.

Do not assume a mode silently.

## Mode Summaries

- `traditional`: implement → verify → review.
- `tdd`: tests first (red/green/refactor) → review.
- `vibe`: fast iteration with reduced ceremony.
- `poc`: exploratory spike; not production-ready.
- `sdd`: requirements → specification → plan → atomic tasks → implementation → verification/review.

## SDD Task Guidelines

When active mode is `sdd`:

1. Capture requirements, constraints, non-goals, and acceptance criteria.
2. Draft a concise spec (scope, contracts, edge cases, validation strategy).
3. Build an ordered implementation plan with dependencies.
4. Decompose into atomic tasks with explicit completion criteria.
5. Keep exactly one task in progress.
6. Maintain traceability from each change back to a requirement.
