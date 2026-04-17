# CLAUDE.md — Generic Skill-First Team Template

> All agents must read `SOUL.md` before starting work.

This file is the single source of truth for team operating policy.
It intentionally avoids project-specific stack and directory assumptions.

---

## 1) Project Context (fill in per repository)

Use this section to describe your product and constraints at a high level.

- **What this project does:** [one paragraph]
- **Primary users:** [who this is for]
- **Core constraints:** [latency, security, compliance, cost, etc.]
- **Quality bar:** [definition of done for your team]

---

## 2) Team Model (separation of concerns)

This template uses a **two-owner model** provided by **devmode**:

- `devmode-builder` owns all implementation work.
- `devmode-reviewer` owns all review work.

No other persistent owner roles are required.

### Routing Rules

- Route implementation tasks to `devmode-builder`.
- Route correctness/design/security/architecture reviews to `devmode-reviewer`.
- `devmode-builder` should rely on **skills** for specialized execution instead of proliferating specialist owners.
- `devmode-reviewer` must publish a clear verdict before final delivery.

### Communications Protocol

- Use explicit handoffs with: owner, goal, files, decisions, validation, blockers, and next action.
- One owner at a time.
- Status format: `Status | Changes | Risks/Blockers | Next step`.
- Final delivery report includes: what changed, files touched, validation outcomes, trade-offs, and follow-ups.

---

## 3) Quality Gates (generic)

Adapt these to your repository's actual scripts/tools:

- **Type safety/static analysis:** run your project's type/static checks.
- **Lint/format:** run your project's lint/format checks.
- **Tests:** run required tests for the active work mode.

If your repo does not provide one of these gates, document the equivalent verification approach.

---

## 4) Development Modes (optional)

Use modes only if they are useful for your team:

- `og`: lightweight plan → implement → verify → review.
- `tdd`: tests-first (red/green/refactor), then review.
- `vibe`: fast iteration with reduced ceremony.
- `poc`: exploratory spike, not production-ready.
- `sdd` (spec-driven development): requirements → specification → plan → task execution → review.
- `brainstorm`: explore ideas, options, and tradeoffs without writing code.
- `oneoff`: directly implement the requested change with minimal ceremony.

If you use modes, document where mode is configured in your environment.

### OG Guidance

When mode is `og`, add a short planning pass before coding:

1. Confirm scope, constraints, and likely touched areas.
2. Sketch a lightweight plan: implementation order, impacted files, and validation approach.
3. Use skills selectively rather than by default. Reach for `orchestrator`, `architect`, or `librarian` when the task is multi-step, boundary-sensitive, or unfamiliar.

If the work needs a full spec, task decomposition, and traceability, prefer `sdd` instead of overloading `og`.

### Workflow Selection Rule (session start)

At the start of each coding session, select an explicit workflow command before implementation:

1. `/build` for default implementation,
2. `/tdd` for tests-first,
3. `/spec` for spec-driven work,
4. `/spike` for exploratory implementation,
5. `/brainstorm` for non-coding exploration.

Do not rely on global mode state.

### Execution Continuity Rule (Ralph Loop)

Agents should run in a Ralph Loop: continue iterating until the active goal is complete, verified, and either handed off (`devmode-reviewer`) or delivered.

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
   - Hand off to `devmode-reviewer` with spec-to-implementation traceability (what requirement each change satisfies).

---

## 5) Skills & Commands Policy

- Skills are the preferred mechanism for specialization (installed by **devmode** into the target repo).
- Keep active skill set minimal per step to conserve tokens.
- Favor composable skills over adding new permanent owner roles.
- Keep review responsibility centralized in `devmode-reviewer` even when review-related skills are used.

### Internal Skills (devmode)

| Skill | Purpose | Load when... |
| --- | --- | --- |
| `devmode-orchestrator` | Task decomposition, dependency ordering, handoff protocol | Multi-step or cross-module work |
| `devmode-librarian` | Codebase navigation, dependency tracing, knowledge retrieval | Unfamiliar modules, tracing data flows |
| `devmode-coder` | Implementation patterns, refactoring discipline, type safety | Any core coding work |
| `devmode-tester` | Test strategy, test generation, coverage analysis | Writing, updating, or analyzing tests |
| `devmode-gatekeeper` | Quality gate enforcement, verification sequencing | Pre-handoff validation |
| `devmode-architect` | System design, boundary enforcement, tradeoff analysis | Architecture decisions, new module design |
| `devmode-code-review` | Review methodology, severity classification, feedback format | Any code review task |
| `devmode-ux-designer` | UI/UX patterns, accessibility, component design | Frontend, accessibility, and other user-facing work |

### Optional Skills (separate plugins)

| Skill | Purpose | Install |
| --- | --- | --- |
| `playwright-cli` | Browser automation, E2E testing, screenshots | `.claude/skills/playwright-cli/` |

Internal skills live in `skills/devmode-<name>/SKILL.md` in this repository and are auto-discovered when the plugin is installed.

---

## 6) Owner Definitions

### `devmode-builder`

- **Source:** `agents/devmode-builder.md`
- **Goal:** Execute end-to-end implementation with skill-first workflow.

### `devmode-reviewer`

- **Source:** `agents/devmode-reviewer.md`
- **Goal:** Serve as sole review authority.
- **Scope:** Reviews only; no implementation ownership.

---

## 7) Customization Checklist

When applying this template to a new repository:

1. Fill in **Project Context**.
2. Define concrete **quality gate commands** for this repo.
3. Install this plugin through your plugin installation flow.
4. Use explicit workflow commands (`/build`, `/tdd`, `/spec`, `/spike`, `/brainstorm`) per task.
5. Add only the extra separate-plugin skills your team actually uses (optional: `playwright-cli`).
