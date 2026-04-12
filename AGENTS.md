# AGENTS.md — Generic Skill-First Team Template

> All agents must read `SOUL.md` before starting work.

This template intentionally avoids project-specific stack and directory assumptions.

---

## 1) Project Context (fill in per repository)

Use this section to describe your product and constraints at a high level.

- **What this project does:** [one paragraph]
- **Primary users:** [who this is for]
- **Core constraints:** [latency, security, compliance, cost, etc.]
- **Quality bar:** [definition of done for your team]

---

## 2) Team Model (separation of concerns)

This template uses a **two-owner model**:

- `/builder` owns all implementation work.
- `/reviewer` owns all review work.

No other persistent owner roles are required.

### Routing Rules

- Route implementation tasks to `/builder`.
- Route correctness/design/security/architecture reviews to `/reviewer`.
- `/builder` should rely on **skills/commands** for specialized execution instead of proliferating specialist owners.
- `/reviewer` must publish a clear verdict before final delivery.

### Communications Protocol

- Use explicit handoffs with: owner, goal, files, decisions, validation, blockers, and next action.
- One owner at a time.
- Status format: `Status | Changes | Risks/Blockers | Next step`.
- Final delivery report includes: what changed, files touched, validation outcomes, trade-offs, and follow-ups.

---

## 3) Quality Gates (generic)

Adapt these to your repository’s actual scripts/tools:

- **Type safety/static analysis:** run your project’s type/static checks.
- **Lint/format:** run your project’s lint/format checks.
- **Tests:** run required tests for the active work mode.

If your repo does not provide one of these gates, document the equivalent verification approach.

---

## 4) Development Modes (optional)

Use modes only if they are useful for your team:

- `traditional`: implement, then verify, then review.
- `tdd`: tests-first (red/green/refactor), then review.
- `vibe`: fast iteration with reduced ceremony.
- `poc`: exploratory spike, not production-ready.
- `sdd` (spec-driven development): requirements → specification → plan → task execution → review.

If you use modes, document where mode is configured in your environment.

### Mode Discovery Rule (session start)

At the start of each coding session, the active owner must do one of the following before implementation:

1. **Discover** the current development mode from repository docs/config, or
2. **Ask** the user to pick a mode if no mode is discoverable.

Never assume a mode silently.

Preferred source: `docs/modes.md`.

### Execution Continuity Rule (Ralph Loop)

Agents should run in a Ralph Loop: continue iterating until the active goal is complete, verified, and either handed off (`/reviewer`) or delivered.

- Do not stop at intermediate analysis-only states.
- On failures, adjust approach and continue the loop.
- End only when completion criteria are satisfied for the current mode.

### Spec-Driven Development (SDD) Guidance

When mode is `sdd`, follow this sequence:

1. **Requirements capture**
   - Extract explicit goals, constraints, and non-goals.
   - Record acceptance criteria in testable language.

2. **Specification drafting**
   - Produce a concise spec with: scope, interfaces/contracts, data model impacts, edge cases, and validation strategy.
   - Resolve ambiguities before coding.

3. **Plan formation**
   - Convert the spec into ordered implementation phases.
   - Identify dependencies and verification checkpoints per phase.

4. **Task decomposition**
   - Break phases into atomic tasks with clear completion criteria.
   - Track task state (pending/in progress/completed) and keep exactly one task in progress.

5. **Implementation against tasks**
   - Implement strictly against current task scope.
   - Update the spec/plan/tasks when scope changes; do not proceed with stale requirements.

6. **Verification and review**
   - Run required quality gates for the repository.
   - Hand off to `/reviewer` with spec-to-implementation traceability (what requirement each change satisfies).

---

## 5) Skills & Commands Policy

- Skills/commands are the preferred mechanism for specialization.
- Keep active skill set minimal per step to conserve tokens.
- Favor composable skills over adding new permanent owner roles.
- Keep review responsibility centralized in `/reviewer` even when review-related skills are used.

### Built-in Skills

| Skill | Purpose | Load when... |
| --- | --- | --- |
| `orchestrator` | Task decomposition, dependency ordering, handoff protocol | Multi-step or cross-module work |
| `librarian` | Codebase navigation, dependency tracing, knowledge retrieval | Unfamiliar modules, tracing data flows |
| `coder` | Implementation patterns, refactoring discipline, type safety | Any core coding work |
| `tester` | Test strategy, test generation, coverage analysis | Writing, updating, or analyzing tests |
| `gatekeeper` | Quality gate enforcement, verification sequencing | Pre-handoff validation |
| `architect` | System design, boundary enforcement, tradeoff analysis | Architecture decisions, new module design |
| `ux-designer` | UI/UX patterns, accessibility, component design | Frontend or user-facing work |
| `code-review` | Review methodology, severity classification, feedback format | Any code review task |
| `playwright-cli` | Browser automation, E2E testing, screenshots | Browser-based verification |

Skills live in `.claude/skills/<name>/SKILL.md` and are auto-discoverable.

---

## 6) Owner Definitions

### `/builder`

- **Source:** `.claude/commands/builder.md`
- **Goal:** Execute end-to-end implementation with skill-first workflow.

### `/reviewer`

- **Source:** `.claude/commands/reviewer.md`
- **Goal:** Serve as sole review authority.
- **Scope:** Reviews only; no implementation ownership.

---

## 7) Customization Checklist

When applying this template to a new repository:

1. Fill in **Project Context**.
2. Define concrete **quality gate commands** for this repo.
3. Define whether **development modes** are used and where configured.
4. Keep `.claude/commands/` focused on `builder` and `reviewer`.
5. Add only the skills your team actually uses.
