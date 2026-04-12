---
name: code-review
description: Systematic code review methodology — evaluation criteria, severity classification, architecture compliance, security analysis, and actionable feedback. Load for any review task.
---

# Code Review

Systematic evaluation of code changes for correctness, safety, maintainability, and convention adherence.

## When to Load This Skill

- Reviewing a pull request or changeset from `/builder`.
- Evaluating architecture compliance of proposed changes.
- Security review of new endpoints, auth flows, or data handling.
- Assessing whether changes follow established patterns.
- Reviewing refactoring work for behavioral preservation.
- Evaluating test quality and coverage adequacy.

## Core Principles

- Review the change, not the person. Feedback is about code, never about the developer. Frame issues as observations about the code, not judgments about competence.

- Correctness first, style second. A working solution with imperfect style is better than a stylistically perfect solution that doesn't work. Prioritize bugs and logic errors over formatting preferences.

- Every comment must be actionable. "This doesn't look right" is useless. "This will throw a null reference when `user` is undefined — add a guard check" is useful. If you can't suggest a fix, you haven't understood the problem well enough.

- Read the full diff before commenting. Don't review line by line in isolation. A concern about line 20 may be resolved by line 80. Read the entire change first, then comment.

- Assume good intent, verify correctness. The author likely had a reason for their approach. Understand it before suggesting alternatives. But understanding intent doesn't mean accepting incorrect implementation.

- Scope your review. Review what changed. Don't flag pre-existing issues unless they are directly related to the change. Note them separately if they're significant.

## Review Sequence

Evaluate changes in this order. Earlier categories catch more critical issues.

### 1. Architecture Compliance

- Do changes respect the declared layer boundaries? Does data flow in the correct direction?
- Are new components placed in the correct location within the project structure?
- Are dependencies introduced in the right direction? No lower layer importing from a higher layer.
- Are new modules wired into the existing structure (dependency injection, registration, routing) correctly?
- Are external integrations placed in their designated location, not inlined in business logic?

Questions to ask:
- Could this change break other modules that depend on the same interface?
- Does this introduce a new dependency direction that didn't exist before?
- Is there an existing pattern for this type of change that wasn't followed?

### 2. Correctness

- Does the code do what the author intended? Trace the logic for the happy path.
- Does it handle edge cases? Null inputs, empty collections, boundary values, concurrent access.
- Are error conditions handled? What happens when external calls fail, data is invalid, or resources are unavailable?
- Are there off-by-one errors, integer overflow risks, or floating-point comparison issues?
- Does the code handle the "nothing" case? Empty arrays, null results, missing optional fields.

Questions to ask:
- What happens when this input is empty, null, or missing?
- What happens when this external call times out or returns an error?
- Is there a race condition if this runs concurrently?

### 3. Security

- Are authentication and authorization checks present where required? Every endpoint that accesses user data needs auth.
- Are inputs validated before use? Never trust data from external sources (user input, API responses, file contents).
- Are secrets hardcoded? Connection strings, API keys, tokens must come from environment configuration.
- Is sensitive data logged or exposed in error messages?
- Are SQL queries parameterized? Are template strings sanitized?
- Do file operations validate paths to prevent directory traversal?

Questions to ask:
- Can an unauthenticated user reach this code path?
- Can a user access another user's data through this endpoint?
- What happens if the input contains malicious content?

### 4. Type Safety & Data Integrity

- Are types explicit on public interfaces? No implicit return types on exported functions.
- Are type suppressions introduced (`any`, `@ts-ignore`, `# type: ignore`, `as unknown as`)? Reject them.
- Are runtime validations present for external data (API inputs, file parsing, database results)?
- Are null/undefined cases handled explicitly, not silently ignored?
- Do generics preserve type information through transformations?

### 5. Error Handling

- Are errors typed and descriptive? Generic "something went wrong" errors are unacceptable.
- Are errors propagated with context? Wrapping errors should add "what the system was doing" information.
- Are resources cleaned up in error paths? File handles, database connections, temporary state.
- Are there empty catch blocks? These silently swallow failures and make debugging impossible.
- Does error handling match the established pattern in the codebase?

### 6. Convention Adherence

- Does naming match existing conventions? File names, function names, variable names, class names.
- Does file organization follow existing structure? New files placed in the correct directory.
- Do imports follow project conventions? Path aliases, grouping, ordering.
- Does error handling follow the established pattern?
- Does the code use existing utilities instead of reimplementing them?

### 7. Test Quality

- Are new behaviors covered by tests?
- Do tests verify behavior, not implementation? Tests should survive refactoring.
- Are error paths tested? Not just the happy path.
- Are test names descriptive? A failing test name should tell you what broke without reading the test body.
- Are tests deterministic? No reliance on time, random values, or external state.
- Were any tests deleted or skipped? This requires strong justification.

### 8. Code Hygiene

- No dead code, commented-out blocks, or orphaned imports.
- No TODO comments without context (who, what, when, why).
- No unnecessary dependencies introduced.
- Changes are minimal — no unrelated modifications bundled in.

## Severity Classification

Classify each finding by severity:

- **Blocker** — Must fix before merge. Bugs, security issues, data loss risks, broken tests. The change cannot ship with this issue.
- **Major** — Should fix before merge. Architecture violations, missing error handling, type safety issues. Could ship in an emergency but creates significant technical debt.
- **Minor** — Fix recommended but not blocking. Style inconsistencies, naming improvements, documentation gaps. Note it, move on.
- **Suggestion** — Optional improvement. Alternative approaches, performance ideas, future considerations. Clearly label as non-blocking.

## Feedback Format

For each issue found:

```
**[Severity]** File: path/to/file.ext, line N

**Problem:** What is wrong, stated concisely.

**Impact:** What could go wrong if this ships as-is.

**Fix:** Specific, actionable change to resolve the issue.
```

## Verdict

Every review ends with exactly one verdict:

- **Approve** — No issues found, or only suggestions. Ship it.
- **Approve with suggestions** — Minor issues noted. Ship it, optionally address suggestions.
- **Request changes** — Blocker or major issues found. Must be fixed before merge. Return a precise fix list.

Never leave a review without a clear verdict.

## Anti-Patterns

- **Rubber stamping.** Approving without reading the diff. If you can't describe what the change does, you didn't review it.
- **Nitpick overload.** Flooding a review with style preferences while missing a logic bug. Prioritize.
- **Blocking on style.** Using "request changes" for formatting issues. Use "approve with suggestions" instead.
- **Vague feedback.** "This could be better" without saying how. Every comment needs a specific fix.
- **Scope creep.** Requesting improvements to code that wasn't changed. Flag pre-existing issues separately.
- **Review by fear.** Approving because you don't understand the code well enough to comment. If you can't evaluate it, say so.
- **Delayed reviews.** Sitting on a review for days. Review promptly or hand off to someone who can.
- **Rewriting in review.** Suggesting a complete rewrite of an approach that works. If the approach is fundamentally wrong, that conversation should have happened during planning, not review.

## Checklist

Before submitting your review:

- [ ] Read the full diff before writing any comments.
- [ ] Traced the happy path through the changed code.
- [ ] Checked error paths and edge cases.
- [ ] Verified auth/security for any new endpoints or data access.
- [ ] Confirmed no type suppressions or empty catch blocks were added.
- [ ] Verified tests cover new behavior (or noted their absence).
- [ ] Classified each finding by severity.
- [ ] Every comment includes a specific, actionable fix.
- [ ] Review ends with a clear verdict.
