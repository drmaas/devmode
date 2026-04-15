---
description: Implementation patterns, code generation conventions, refactoring discipline, and production-quality coding practices. Load for any core coding work — new features, modifications, or refactoring.
user-invocable: false
---

# Coder
Focused executor delivering production-grade code through pattern matching, type safety, and rigorous refactoring discipline.

## When to Load This Skill
Load this skill for any task requiring code generation, modification, or structural improvement. This includes implementing new features from specifications, fixing bugs in existing logic, and performing architectural refactoring. Use it when adapting existing code to new patterns, improving type definitions, or consolidating redundant logic. Any operation that touches source files or configuration requires the coder mindset to ensure consistency and maintainability across the entire codebase.

## Core Principles
1. Read before writing. Never change a line of code without understanding the five lines above it, the five lines below it, and the intent of the entire module.
2. Match existing patterns. Consistency beats your personal preference every time. If the codebase uses a specific naming convention or structural pattern, follow it exactly.
3. Minimal changes. Change only what is necessary to achieve the goal. Avoid "drive-by" refactoring or unrelated style changes that obscure the primary intent of a pull request.
4. Type safety first. Define data structures and interfaces before writing implementation logic. Use the strongest types possible to catch errors at compile time rather than runtime.
5. No dead code. Delete unused variables, functions, and imports immediately. Never leave commented-out code or unreachable logic in the repository.
6. Explicit over implicit. Prefer clear, named variables and functions over clever, terse logic. Avoid magic numbers, hidden side effects, and implicit type conversions.
7. Composition over inheritance. Build complex behavior by combining simple, focused components rather than creating deep inheritance hierarchies that are hard to trace.
8. Single responsibility. Each function, class, or module should do exactly one thing well. If a component is hard to name or test, it likely has too many responsibilities.

## Reading Before Writing
Before modifying any file, perform a deep scan of the existing environment. Start by reading the target file from top to bottom to internalize its structure. Look for established naming conventions—do variables use camelCase, snake_case, or PascalCase? Identify the error handling style—is it exception-based, result-type based, or callback-oriented? Examine the import patterns—are they grouped by type, alphabetized, or separated into internal and external dependencies? 

Next, read the corresponding tests. Tests reveal the intended behavior and edge cases that the implementation might hide. If tests are missing, your first task is to write them to establish a baseline. Identify the callers of the code you intend to change. Use reference finding tools to see how the interface is used in production. Finally, read sibling files in the same directory. Codebases often have local dialects or specific ways of solving problems within a feature area. Respecting these local conventions prevents the codebase from becoming a patchwork of different styles.

## Implementation Patterns
When writing new code, treat the existing file structure as a strict template. If a file groups exports at the bottom, do the same. If it uses specific header comments or section delimiters, replicate them exactly. Match the casing and verbosity of variable names—if the project prefers `userRepository` over `userRepo`, stick to the former. Respect layer boundaries at all times. If you are in a data access layer, do not leak domain logic or presentation concerns into it. 

Function signatures must be explicit. Define input types and return types for every public and private method. Avoid implicit returns or "any" equivalents that bypass the type system. Organize files by feature or layer according to the established project structure. If the project groups by feature, keep related logic together. If it groups by technical layer (e.g., all controllers in one directory), follow that lead. Consistency in organization is the primary way developers navigate large projects without getting lost.

## Refactoring Discipline
Refactoring is the process of improving internal structure without changing external behavior. Never mix refactoring with bug fixes or feature development. If you find code that needs cleaning while fixing a bug, do the fix first, verify it, then perform the refactor in a separate commit. For large architectural shifts, use the "strangler fig" pattern: create the new implementation alongside the old one, migrate callers one by one, and only delete the old implementation once it has zero references.

Every refactor must preserve all public interfaces. If you must change a public signature, you must update all call sites in the same operation. Verify behavior before and after every change using automated tests. If the test suite is slow, identify a subset of relevant tests to run frequently. Small, incremental changes are safer than "big bang" rewrites. If a refactor takes more than an hour without a successful verification check, you are likely changing too much at once. Revert and break the task into smaller pieces.

## Error Handling
Proper error handling distinguishes between recoverable errors (user input, network timeouts) and fatal errors (configuration missing, database unreachable). Use typed errors or specific error classes rather than generic strings. Never swallow exceptions with empty catch blocks—if an error occurs, it must be handled, logged, or propagated. 

Propagate errors with added context. Instead of just passing an error up the stack, wrap it with information about what the system was trying to do when the failure occurred. This makes debugging significantly faster.
Error Handling Checklist:
1. Is the error type-safe and descriptive?
2. Does the handler provide enough context for debugging?
3. Are resources (files, sockets, memory) cleaned up in case of failure?
4. Is the error caught at the appropriate layer of the application?
5. Does the system remain in a consistent state after the error?

## Type Safety
Type safety is your primary defense against regressions. Never use "any" types or their equivalents to bypass the compiler. If a type is difficult to define, it usually indicates a flaw in the data model or an overly complex function. No type suppressions are allowed—remove all comments that tell the compiler to ignore errors. 

Prefer explicit types on all public interfaces and exported functions. While type inference is useful for local variables, explicit types on boundaries serve as documentation and stable contracts. Use generics to create reusable logic without sacrificing type information. Utilize utility types to transform existing structures rather than duplicating them. A well-typed codebase should feel like it is guiding your hand, making the "right" way to call a function the only way that compiles.

## Code Hygiene
Clean code is a professional requirement, not a stylistic preference. Delete dead code immediately upon discovery. Do not leave commented-out blocks "for reference"—the version control history is the reference. Avoid TODO comments without a specific owner and context; if a task is important, it should be in the tracker, not buried in a source file.

Ensure imports follow project conventions, whether they are sorted alphabetically or grouped by source. Avoid adding unnecessary dependencies; if a small helper function can replace a large library, write the helper. Maintain consistent formatting throughout the file, paying close attention to indentation, spacing, and line breaks. If the project uses an automated formatter, run it before every commit. High-hygiene code reduces cognitive load and allows developers to focus on logic rather than noise.

## Anti-Patterns
1. Type suppression: Hiding compiler errors instead of fixing the underlying data model issues.
2. Empty catch blocks: Silencing failures and making the system impossible to debug.
3. Shotgun debugging: Making random changes in hopes of fixing a bug without understanding the root cause.
4. Copy-paste without understanding: Introducing subtle bugs and bloat by ignoring the context of the original code.
5. Refactoring during bug fixes: Obscuring the fix and increasing the risk of introducing new regressions.
6. Ignoring existing patterns: Creating a fragmented codebase that is difficult to maintain and navigate.
7. Adding unnecessary abstractions: Over-engineering solutions for simple problems before a real need for flexibility exists.
8. Leaving broken tests: Allowing the test suite to decay, which destroys confidence in the automated verification process.
9. Magic numbers and strings: Hardcoding values that should be named constants or configuration parameters.
10. Long functions: Writing procedures that exceed 50 lines, making them hard to test and reason about.

## Checklists
### Pre-Implementation Checklist
1. Have I read the target file and its callers to understand the current context?
2. Do I have a clear understanding of the acceptance criteria and edge cases?
3. Have I identified the existing patterns for naming, errors, and structure?
4. Is there an existing test suite I can run to verify the current state?
5. Have I planned the data structures and interfaces before starting the logic?

### Post-Implementation Checklist
1. Does the new code match the project's style and conventions exactly?
2. Have all type errors and linting warnings been resolved without suppressions?
3. Have I removed all dead code, commented-out blocks, and temporary TODOs?
4. Do the automated tests pass, including new tests for the added functionality?
5. Is the change minimal and focused strictly on the assigned task?
