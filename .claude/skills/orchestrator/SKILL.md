---
name: orchestrator
description: Task decomposition, dependency ordering, parallel execution planning, and handoff protocol. Load when work involves multiple steps, cross-module changes, or coordinated delivery.
---

# Orchestrator
Master of decomposition, sequencing, and reliable execution of complex work streams.

## When to Load This Skill
- Multi-step implementation requiring 3 or more distinct operations.
- Cross-module changes where order of operations prevents regressions.
- Parallel execution planning to maximize throughput.
- Complex refactoring involving multiple files and dependent call sites.
- Handoffs between different execution phases or specialized owners.

## Core Principles
- Task Atomicity: Every task must be a single, logical unit of work. If it can fail partially, it's too big.
- Dependency-First Ordering: Identify and execute blockers before dependents. No circularity.
- Parallel-by-Default: Run independent tasks simultaneously. Do not wait unless a dependency exists.
- Single-Task-in-Progress: Focus on one active task. Close it before starting the next to prevent context sprawl.
- Progress Tracking: Real-time status updates are non-negotiable. Stale todos are useless.
- Fail-Fast: If a task fails, stop the sequence. Evaluate if the plan remains valid before continuing.

## Task Decomposition
Break work into the smallest possible units that provide value or enable subsequent work.
- Boundaries: Define tasks by file changes, logical components, or validation checkpoints.
- Granularity: A task is too big if it touches unrelated files. It's too small if it doesn't leave the system in a valid state.
- Identification: Scan the goal for "and" or "then" connectors. These are usually task boundaries.

## Dependency Ordering
Sequence work to minimize idle time and maximize correctness.
- Serial: Task B needs the output or existence of Task A.
- Parallel: Task A and Task B touch different files and don't share data.

Example Sequence:
1. [Serial] Update Interface Definition
2. [Parallel] Implement Logic A (uses Interface)
3. [Parallel] Implement Logic B (uses Interface)
4. [Serial] Integration Test A + B

## Handoff Protocol
Consistency in handoffs prevents information loss. Every phase transition requires:
- Status: Current state of the plan.
- Changes: Files modified and why.
- Decisions: Architecture or logic choices made during execution.
- Validation: Proof that the work functions (tests, diagnostics, builds).
- Blockers: Any remaining issues preventing final delivery.
- Next Action: The immediate first step for the next phase.

Status Format:
Status | Changes | Risks | Next Step

## Progress Tracking
Maintain a live state for every task in the plan:
- pending: Queued for work.
- in_progress: Active focus (Exactly one allowed).
- completed: Finished and verified.
- blocked: Cannot proceed due to external factors or failed dependencies.

Transition Rule: Move to 'completed' only after verification passes. Never batch completions.

## Anti-Patterns
- Premature Parallelization: Running tasks before their dependencies are stable.
- Task Sprawl: Creating dozens of tiny tasks for a simple change.
- Skipping Analysis: Starting work before identifying the dependency graph.
- Batching Completions: Marking multiple tasks done at once.
- Stopping at Analysis: Thinking about the problem without updating the execution plan.
- Implicit Handoffs: Assuming the next owner knows the context without a report.

## Examples

### Add New API Endpoint
1. Define request/response data structures.
2. Implement core logic handler.
3. Add route registration and middleware.
4. Verify with integration tests.

### Refactor Shared Utility
1. Create new utility implementation alongside the old one.
2. Update call sites in Module A.
3. Update call sites in Module B.
4. Remove legacy utility and verify all imports.
