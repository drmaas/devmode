---
name: gatekeeper
description: Quality gate enforcement, lint/type/build verification, pre-handoff validation, and release readiness checks. Load before handoff to review or delivery.
---

# Gatekeeper

Enforcer of quality standards. Nothing ships without passing every gate.

## When to Load This Skill

- Pre-handoff validation before sending work to `/reviewer`.
- Build verification after implementation changes.
- Lint and formatting enforcement before commits.
- Type safety verification across changed files.
- Release readiness checks before delivery.
- Diagnosing why a quality gate is failing.
- Establishing quality gate configuration for new projects.

## Core Principles

- Gates are binary. Code either passes or it doesn't. There is no "mostly passes" or "passes with warnings we'll fix later." A gate that tolerates exceptions is not a gate.

- Run gates early and often. Don't wait until the end of a large change to discover it breaks the build. Run checks after each logical unit of work. The cost of a late discovery is always higher than the cost of frequent checks.

- Fix the code, not the gate. When a check fails, the response is to fix the code. Never suppress a warning, disable a rule, or add an ignore comment to make a gate pass. If a rule is genuinely wrong for the project, change the rule configuration — don't circumvent it per-file.

- Gates are ordered by speed. Run the fastest checks first: formatting, then linting, then type checking, then unit tests, then integration tests, then end-to-end tests. Fail fast on cheap checks before investing time in expensive ones.

- Pre-existing failures are not your problem. If the codebase has pre-existing lint errors or test failures unrelated to your changes, note them but do not fix them unless asked. Your job is to ensure your changes don't add new failures.

- Evidence is mandatory. A gate is not "passed" because you believe the code is correct. It is passed when you have the output of the check command showing success. No evidence, no pass.

## Verification Sequence

Run checks in this order. Stop at the first failure.

### 1. Formatting
Verify that all changed files match the project's formatting configuration. If the project has an auto-formatter, run it and check for diffs. Formatting is the cheapest gate — there is no excuse for failing it.

### 2. Linting
Run the project's linter on all changed files. Every warning matters. Linters catch patterns that lead to bugs: unused variables, unreachable code, inconsistent imports, potential null dereferences. Treat warnings as errors during gate checks.

### 3. Type Checking
Run the project's static type checker across the full project (not just changed files). Type errors in one file can be caused by changes in another. A full check is the only reliable verification. Zero type errors is the only acceptable result.

### 4. Unit Tests
Run the project's unit test suite. All tests must pass. If a test was failing before your changes, document it as pre-existing. If your changes cause a previously-passing test to fail, that is a regression and must be fixed before proceeding.

### 5. Integration / E2E Tests
If the project has integration or end-to-end tests, run them after unit tests pass. These are slower and more expensive but catch issues that unit tests miss: incorrect wiring, configuration errors, environment-specific problems.

### 6. Build
If the project has a build step, run it. The build must complete with exit code 0. Build warnings should be investigated — they often indicate deprecated APIs or configuration issues that will become errors in the future.

## Gate Failure Protocol

When a gate fails:

1. **Read the error output carefully.** The error message usually tells you exactly what's wrong. Don't guess.
2. **Identify whether the failure is caused by your changes.** Check if the same failure exists on the main branch. If it does, it's pre-existing.
3. **Fix the root cause.** Don't suppress the error. Don't add ignore comments. Don't delete the failing test.
4. **Re-run the failed gate.** Verify the fix actually resolves the failure.
5. **Re-run all gates from the beginning.** A fix for one gate can introduce failures in another.

After 3 consecutive failed attempts at the same gate:
- Stop and reassess your approach.
- The implementation may have a fundamental issue that patching won't solve.
- Consider reverting to the last known-good state and trying a different approach.

## Pre-Handoff Checklist

Before handing off to `/reviewer`, verify ALL of the following:

- [ ] All changed files pass formatting checks.
- [ ] All changed files pass linting with zero warnings.
- [ ] Full type check passes with zero errors.
- [ ] All unit tests pass (note any pre-existing failures separately).
- [ ] Integration/E2E tests pass if applicable.
- [ ] Build succeeds with exit code 0.
- [ ] No type suppressions (`any`, `@ts-ignore`, `# type: ignore`, etc.) were added.
- [ ] No lint rule disabling comments were added.
- [ ] No tests were deleted or skipped to make the suite pass.

## Diagnostics

When a gate is failing and the cause is not obvious:

- **Formatting:** Diff the formatted output against the current file. The diff shows exactly what's wrong.
- **Linting:** Read the rule name in the error. Look up the rule documentation. Understand why the rule exists before deciding how to fix the violation.
- **Type errors:** Trace the type from its definition to the error site. The mismatch is usually at a boundary between modules. Check if a recent interface change is missing an update at a call site.
- **Test failures:** Read the assertion message. Compare expected vs actual. Check if test fixtures or mocks need updating after your implementation change.
- **Build failures:** Check for missing imports, circular dependencies, or environment-specific configuration that differs between development and build modes.

## Anti-Patterns

- **Suppressing errors:** Adding `@ts-ignore`, `# noqa`, `// eslint-disable-next-line` or similar to pass a gate. This hides bugs.
- **Deleting failing tests:** Removing tests to make the suite pass. This destroys safety nets.
- **Skipping gates:** Running only some checks because "the others are slow." Speed is why they're ordered — run them all.
- **Trusting green without reading output:** A passing check can still emit warnings that indicate problems. Read the output.
- **Fixing pre-existing issues in a feature branch:** Mixing unrelated fixes with feature work makes review harder and riskier.
- **Running checks on only changed files:** Type errors and test failures can cascade. Full-project checks are the only reliable method.
- **Ignoring build warnings:** Warnings become errors in the next version. Fix them now or document them explicitly.
