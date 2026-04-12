---
name: tester
description: Test strategy, test generation, coverage analysis, and verification discipline. Load when writing, updating, or analyzing tests.
---

# Tester
The Tester role ensures software reliability through systematic verification, test-driven design, and rigorous validation of behavioral contracts.

## When to Load This Skill
Load this skill when initiating new feature development to establish acceptance criteria through automated checks.
Invoke this when refactoring existing modules to ensure that internal structural changes do not break external functional behavior.
Use this when analyzing coverage reports to identify missing execution paths, unhandled exceptions, or untested boundary conditions.
Apply these principles when debugging regression failures to create reproduction cases that prevent future reoccurrences of the same defect.
Activate this skill during the initial project setup to define the testing pyramid and organizational patterns for the entire codebase.
Utilize these guidelines when reviewing pull requests to verify that new code includes sufficient unit, integration, and end-to-end coverage.
Load this during TDD workflows to maintain the discipline of writing failing tests before any production code implementation.
Consult this strategy when dealing with flaky tests to isolate non-deterministic factors and stabilize the CI/CD pipeline.

## Core Principles
Tests document behavior by serving as executable specifications that clearly describe what the system does under specific conditions.
A well-written test provides a living manual for developers, showing exactly how to interact with an interface and what outcomes to expect.
Test the contract not the implementation by focusing on public API outputs and side effects rather than internal private methods or variables.
This approach prevents brittle tests that break during refactoring even when the external behavior remains perfectly correct and consistent.
One assertion per logical concept ensures that when a test fails, the root cause is immediately obvious without debugging multiple failure points.
While a single test function might contain multiple physical assertions, they must all relate to the same atomic behavioral outcome or state change.
Arrange-Act-Assert structure provides a consistent visual and logical flow that makes tests easy to read, understand, and maintain over time.
Every test must clearly separate the setup of preconditions, the execution of the target action, and the verification of the resulting state.
Tests must be deterministic to ensure that the same input always produces the same output regardless of the environment or execution order.
Eliminating non-determinism like system time, random numbers, or global state is essential for maintaining trust in the automated suite.
Test names describe the scenario and expectation using clear, descriptive language that communicates the intent of the check without reading code.
A good name follows a pattern like "should return error when input is empty" rather than generic titles like "test function one."
Fast tests run first in the execution pipeline to provide immediate feedback to developers during the local development and commit cycle.
The suite should be organized so that lightweight unit tests execute before heavier integration tests and slow end-to-end browser simulations.
Tests are production code and must adhere to the same standards of clarity, modularity, and cleanliness as the features they verify.
Do not allow test code to become a dumping ground for "quick and dirty" hacks, as technical debt in tests is just as costly as in features.

## Test Strategy
The testing pyramid prioritizes a high volume of fast unit tests, a moderate number of integration tests, and a few critical end-to-end flows.
Unit tests isolate individual components to verify logic in a vacuum, providing the fastest feedback loop and the most granular error reporting.
Integration tests verify the communication between different modules or external systems, catching errors that unit tests cannot see in isolation.
End-to-end tests validate the entire system from the user's perspective, ensuring that the most critical business paths function correctly.
Risk-based testing allocates more resources and depth to complex, frequently changed, or high-impact areas of the codebase where bugs are likely.
Code that handles financial transactions, security, or sensitive data requires exhaustive edge case coverage compared to simple UI layout logic.
Boundary testing focuses on the minimum and maximum values of input ranges, where off-by-one errors and overflow issues commonly occur.
Error path testing ensures the system fails gracefully by verifying that exceptions are caught and meaningful error messages are returned to the caller.
Regression testing for bugs involves creating a specific test case for every reported defect to ensure that the fix is permanent and stays fixed.
Do not test trivial getters, setters, or pass-through methods that contain no logic, as these tests add maintenance overhead without adding value.
Avoid testing third-party library behavior or framework internals, as you should trust that these dependencies are already verified by their authors.
Focus on your own code's logic and how it integrates with those libraries rather than re-verifying that a standard list sorts correctly.

## Test Generation
Identify the public interface of the module or function to determine the entry points that require verification and behavioral documentation.
Enumerate happy paths first to establish the baseline functionality that the system must provide when given valid, standard inputs.
Enumerate error paths next by considering every possible way the inputs could be invalid or external dependencies could fail during execution.
Identify boundary conditions by looking at the limits of data types, collection sizes, and logical ranges defined in the requirements.
Write test names first as a list of requirements, which serves as a checklist of behaviors to implement and verify before writing any code.
Fill in the implementation for each test name following the Arrange-Act-Assert pattern to ensure consistency and readability across the suite.
A standard test file template includes a top-level grouping for the module, followed by nested groups for each specific method or scenario.
Each scenario group contains individual tests for specific inputs, ensuring that the output and side effects are thoroughly checked for that case.
Mock or stub external dependencies only when necessary to isolate the unit under test, keeping the setup as close to reality as possible.
Verify that the mock interactions are correct, ensuring that the unit calls the dependency with the expected arguments in the right order.
Check that the module handles both successful and failed responses from its dependencies to ensure comprehensive resilience against external errors.
Finalize the generation process by running the new tests and confirming they provide clear, actionable feedback when forced to fail.

## TDD Workflow
The Red-Green-Refactor cycle begins by writing a small, focused test that fails because the desired functionality does not yet exist.
This initial failure proves that the test is actually checking the requirement and that the subsequent code implementation is what makes it pass.
Implement the minimum amount of production code necessary to make the failing test turn green, ignoring perfection in favor of immediate progress.
Avoid the temptation to add extra features or handle future cases during the green phase, as this violates the principle of simplicity.
Refactor the code only after the test is green, improving the design, naming, and structure while using the passing test as a safety net.
During refactoring, keep the tests green at all times to ensure that structural improvements do not accidentally alter the established behavior.
Never write production code without a failing test, ensuring that every line of logic in the system has a documented reason for existing.
Never refactor with failing tests, as you cannot distinguish between existing bugs and new errors introduced by your structural changes.
Keep test-to-implementation cycles short, ideally only a few minutes, to maintain momentum and minimize the scope of any potential errors.
This iterative process leads to more modular, decoupled, and testable designs because the code is built specifically to satisfy its verification suite.
The result of a disciplined TDD workflow is a comprehensive regression suite that grows naturally alongside the feature set without extra effort.
Continuous feedback from the TDD cycle reduces the cost of change and increases confidence when modifying complex or legacy parts of the system.

## Coverage Analysis
Analyze coverage gaps by reviewing the paths through the code that were not executed during the last run of the automated test suite.
Look specifically for untested error paths, such as catch blocks and conditional branches that handle invalid data or system failures.
Untested boundary conditions are a common source of defects, so verify that the suite checks the edges of all logical and numeric ranges.
Examine integration points where your code interacts with external systems, ensuring that both successful and failed handshakes are verified.
Coverage metrics are a floor not a ceiling, providing a useful indicator of what is definitely missing but not what is definitely correct.
High coverage with weak or missing assertions is worse than moderate coverage with strong, meaningful assertions that truly verify behavior.
A line of code that is executed but not asserted upon is still functionally untested, regardless of what the coverage tool reports.
Use coverage reports as a guide to prioritize where to add more tests, focusing on high-risk areas that currently have low execution visibility.
Avoid chasing 100% coverage for its own sake, as the final few percentage points often involve testing trivial code with diminishing returns.
Instead, focus on meaningful coverage that protects the system against regressions in its most complex and critical business logic sections.
Regularly review the coverage trends over time to ensure that the quality of the codebase is improving or staying stable as it grows.
Integrating coverage checks into the CI/CD pipeline prevents the merging of code that significantly drops the established testing standards.

## Test Maintenance
Keep tests healthy by updating them immediately when a deliberate change in the system's requirements alters the expected behavior.
Delete tests for removed features to keep the suite lean and prevent it from becoming a source of confusion or false positives.
Refactor test helpers and utility functions just like production code to reduce duplication and improve the readability of the setup logic.
Avoid test interdependence by ensuring that every test is completely isolated and does not rely on the side effects of a previous execution.
Keep test data minimal and focused on the specific scenario being checked, avoiding "god objects" that contain unrelated or unnecessary properties.
Large, complex data structures in tests make it difficult to see which specific value is actually being used to drive the behavior.
Regularly audit the test suite for slow-running checks and optimize them or move them to a less frequent execution tier to maintain speed.
Treat the test suite as a primary asset of the project, allocating time for maintenance and cleanup in every development cycle or sprint.
When a test becomes flaky, prioritize fixing or removing it immediately to prevent the team from becoming desensitized to failing builds.
Documentation in tests should be minimal because the code itself, when written clearly, should be the best explanation of the requirement.
Ensure that the test environment is easy to set up for new developers, minimizing the friction required to run and contribute to the suite.
The goal of maintenance is to ensure the test suite remains a helpful tool for developers rather than a burdensome chore that slows them down.

## Anti-Patterns
Testing implementation details is the most common anti-pattern, leading to tests that break during refactoring even when behavior is correct.
Flaky tests that fail intermittently due to time, network latency, or execution order destroy trust in the entire automated suite.
Testing framework internals or third-party libraries wastes time and adds maintenance without increasing the quality of your own logic.
Overly broad assertions like checking a whole object when only one property changed make it hard to identify the reason for failure.
Shared mutable test state causes side effects where one test's outcome depends on another, leading to confusing and hard-to-debug failures.
Ignoring test failures in the CI/CD pipeline or "commenting them out" to bypass builds allows regressions to accumulate and rot the codebase.
Deleting failing tests instead of fixing the underlying bug or updating the requirement is a betrayal of the verification discipline.
Mocking everything leads to "mirror tests" that only verify that the code calls certain functions, without checking if the integration actually works.
No error path tests leave the system vulnerable to crashes and data corruption when unexpected conditions occur in the production environment.
Giant test files with no organization or descriptive naming make it impossible for new developers to understand the module's requirements.
Hard-coding environment-specific values like file paths or URLs prevents the test suite from running reliably across different developer machines.
Redundant tests that verify the same logic in multiple places add execution time and maintenance overhead without providing additional safety.
Testing the wrong thing, such as UI colors in a functional logic test, leads to a suite that is both brittle and conceptually confused.
Relying on manual testing for critical paths instead of automating them ensures that regressions will eventually reach the end user.
Failing to run the tests locally before pushing code results in a broken main branch and interrupts the workflow of the entire team.

## Checklists
Pre-test checklist:
- The requirements for the new feature or bug fix are clearly understood.
- The public interface for the module has been defined and documented.
- A list of happy paths, error paths, and boundary cases has been created.
- The test environment is clean and free of leftover state from previous runs.
- The correct test runner and configuration for the module are selected.

Post-test checklist:
- All new tests follow the Arrange-Act-Assert structure and naming conventions.
- The tests pass locally and provide clear error messages when forced to fail.
- Coverage analysis confirms that all new logic paths and edge cases are checked.
- No implementation details are leaked into the test assertions or setup logic.
- The test suite is fast, deterministic, and contains no unnecessary dependencies.
