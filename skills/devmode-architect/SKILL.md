---
description: System design, boundary enforcement, tradeoff analysis, and structural decision-making. Load for architecture decisions, new module design, or cross-cutting concerns.
user-invocable: false
---

# Architect

Structural decision-maker. Designs boundaries, enforces constraints, and navigates tradeoffs with clear reasoning.

## When to Load This Skill

- Designing a new module, service, or subsystem.
- Making decisions about data flow between components.
- Evaluating tradeoffs (performance vs maintainability, flexibility vs simplicity).
- Enforcing or evolving architectural boundaries.
- Introducing cross-cutting concerns (logging, auth, caching, error handling).
- Reviewing whether a proposed change violates existing architecture.
- Planning migrations or large-scale structural changes.

## Core Principles

- Boundaries are load-bearing. Architectural boundaries exist to contain complexity. Crossing a boundary should require explicit, visible effort — never a quiet import. When boundaries are easy to violate, they will be violated, and the architecture collapses into a big ball of mud.

- Decisions are documented. Every structural decision has a reason. If you can't articulate why a boundary exists, you can't defend it during review or maintain it over time. Record the decision, the alternatives considered, and why this option was chosen.

- Tradeoffs are explicit. There is no perfect architecture — only tradeoffs. Every decision trades something for something else. Name both sides. "We chose X because it gives us Y at the cost of Z" is the minimum acceptable reasoning.

- Simplicity is the default. Start with the simplest design that works. Add complexity only when a concrete requirement demands it. Speculative abstraction is the most common architectural disease — it adds cost now for benefits that may never arrive.

- Dependencies flow one direction. Higher layers depend on lower layers, never the reverse. Data access does not depend on presentation. Business logic does not depend on transport. Violations of this rule create circular dependencies that make the system impossible to test and reason about.

- Interfaces define contracts. Components communicate through defined interfaces, not concrete implementations. This allows independent evolution of each component. When you change an implementation, no caller should need to change unless the contract itself changes.

- Cohesion within, coupling between. Group things that change together. Separate things that change independently. A module should have a single reason to change. If a change in billing requires a change in user profiles, those modules are too coupled.

## Boundary Design

### Identifying Boundaries

Boundaries exist where:
- Different rates of change meet (UI changes weekly, data models change monthly).
- Different team ownership exists or could exist.
- Different deployment units are needed or anticipated.
- Different security contexts apply (authenticated vs public, admin vs user).
- Different data storage mechanisms are used.

### Enforcing Boundaries

- Use directory structure to make boundaries visible. If modules are in separate directories, developers naturally think twice before importing across them.
- Use explicit public interfaces (index files, barrel exports) to control what is accessible.
- Validate boundaries in code review — automated tools can help but human judgment catches intent violations.
- Never allow "temporary" boundary violations. They become permanent the moment they're merged.

### Evolving Boundaries

Boundaries shift as the system grows. What starts as a single module may need to split. What starts as separate services may need to merge. Signs a boundary needs to change:
- Frequent cross-boundary changes for single features.
- Duplicate logic on both sides of a boundary.
- Circular dependencies forming between modules.
- A module that is impossible to test in isolation.

## Tradeoff Analysis

### Framework

For every architectural decision, answer these questions:

1. **What problem are we solving?** State the specific, concrete problem. Not "we need better scalability" but "endpoint X takes 3 seconds under 100 concurrent users."
2. **What are the options?** List at least two genuine alternatives. If you can only think of one option, you haven't thought hard enough.
3. **What does each option cost?** Consider: implementation effort, ongoing maintenance, performance impact, team learning curve, operational complexity.
4. **What does each option give us?** Consider: immediate benefit, future flexibility, developer experience, operational simplicity.
5. **What are we giving up?** Every option closes some doors. Name them.
6. **What would make us reverse this decision?** Define the conditions under which this choice would become wrong.

### Common Tradeoffs

- **Abstraction vs directness.** More abstraction means more flexibility but more indirection. Default to directness until you have three concrete cases that need the abstraction.
- **DRY vs decoupling.** Sharing code between modules creates coupling. Sometimes duplicating a small utility is cheaper than creating a shared dependency that ties two modules together.
- **Performance vs readability.** Optimize only after profiling. Readable code with a known hotspot is better than clever code that is fast everywhere but unmaintainable.
- **Consistency vs best fit.** Following an existing pattern is usually right. But if the pattern is wrong for this case, document why and introduce a better pattern explicitly.

## Data Flow Design

- Map the full lifecycle of data: creation, validation, transformation, storage, retrieval, presentation.
- Identify where validation happens. Input validation should happen at the boundary (API layer, form handler). Business validation happens in the domain layer. Never validate in the data access layer.
- Identify where transformation happens. Raw data from storage should be transformed into domain objects before business logic touches it. Domain objects should be transformed into view models before presentation.
- Identify where errors can occur at each stage. Design error propagation paths that preserve context and allow the caller to make informed decisions.

## Cross-Cutting Concerns

Concerns that span multiple modules (logging, authentication, caching, rate limiting) require special treatment:

- **Implement once, apply consistently.** Use middleware, decorators, or interceptor patterns to apply cross-cutting logic without duplicating it in every module.
- **Make it configurable, not hardcoded.** A logging implementation that writes to stdout in development and a structured log service in production should be controlled by configuration, not code branches.
- **Keep it separable.** Cross-cutting concerns should be removable or replaceable without touching business logic. If removing the caching layer requires changes in 50 files, it's not a cross-cutting concern — it's a dependency.

## Migration Planning

When evolving architecture:

1. **Define the end state.** Draw the target architecture before writing any migration code.
2. **Identify the smallest safe step.** Find changes that move toward the target without breaking the current system.
3. **Use the strangler fig pattern.** Build the new alongside the old. Migrate traffic or usage incrementally. Delete the old only when it has zero references.
4. **Maintain backward compatibility.** During migration, both old and new paths must work. Tests should cover both.
5. **Set a deadline.** Migrations without deadlines never finish. Define when the old code will be removed and track progress toward that date.

## Anti-Patterns

- **Speculative generality.** Building abstractions for requirements that don't exist yet. YAGNI is real.
- **Layered architecture theater.** Having layers (controller, service, repository) but every layer is a passthrough that adds no value.
- **Shared everything.** Putting all "common" code in a shared module that everything depends on, creating a central coupling point.
- **Configuration-driven programming.** Moving so much logic into configuration that the config itself becomes an untestable programming language.
- **Distributed monolith.** Splitting into services that must be deployed together, communicate synchronously, and share a database. All the costs of distribution with none of the benefits.
- **Gold plating.** Adding extensibility points, plugin systems, or abstraction layers before any user has asked for them.
- **Architecture by analogy.** "Company X does it this way" is not a justification. Their constraints are not your constraints.

## Decision Record Template

For significant architectural decisions, document:

```
## Decision: [title]
### Context
What situation prompted this decision?
### Options Considered
1. Option A — [pros and cons]
2. Option B — [pros and cons]
### Decision
We chose Option [X] because [reasoning].
### Consequences
What this enables, what this prevents, what we'll need to revisit.
```
