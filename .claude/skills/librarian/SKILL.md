---
name: librarian
description: Codebase navigation, documentation lookup, dependency tracing, and knowledge retrieval. Load when working with unfamiliar modules, onboarding to new areas, or tracing data flows.
---

# Librarian

Expert guide for codebase navigation, architectural mapping, and technical knowledge retrieval.

## When to Load This Skill

Load this skill when you encounter unfamiliar modules, need to trace data flows through multiple layers, require existing documentation, seek to understand the dependency graph, or are onboarding to a new functional area.

## Core Principles

*   Read the implementation before assuming behavior.
*   Trace logic from known entry points to internal handlers.
*   Follow data transformations rather than just control flow.
*   Verify findings using multiple sources like tests and history.
*   Build mental models incrementally, starting with core paths.
*   Document discoveries to prevent redundant exploration.

## Codebase Navigation

Orientation requires identifying the skeletal structure of a module. Start at defined entry points like main files, index exports, or route definitions. These files reveal the public API and the intended usage patterns. Follow imports to see where logic is delegated. Identify layer boundaries by looking for where data validation, persistence, or external communication occurs. Find canonical patterns by searching for repeated structures in sibling modules. If one module uses a specific strategy for error handling or configuration, others likely follow it. Use directory structures as a primary map but verify them against actual import graphs.

## Dependency Tracing

Understanding how components connect is critical for impact analysis. Perform upstream analysis to find all callers of a function or consumers of a type. This reveals the blast radius of changes. Perform downstream analysis to identify every utility, service, or library a module relies on. Trace dependency injection by looking for where instances are created and passed, rather than just where they are imported. Check configuration files to see how environment variables or static settings influence component behavior. Use type definitions to see how data structures link different parts of the system.

## Documentation Lookup

Source code is the primary source of truth, but context exists elsewhere. Read inline comments for the "why" behind complex logic. Check README files in local directories for module-specific overviews. Look for dedicated documentation directories for high-level architecture. Treat type definitions as machine-verified documentation of interfaces. Use test files as executable usage examples that demonstrate the intended behavior of a unit. Review commit history for context on why a specific design choice was made or what problem a bug fix addressed.

## Knowledge Retrieval Patterns

Systematic searching beats aimless browsing. Grep for unique symbols or error codes to find where they originate. Search by convention by looking for files named according to the project's established patterns. Trace through type definitions to understand the contract between modules. Use test suites to observe how a module handles edge cases and failures. If a module is complex, search for its tests first to see simplified usage scenarios. Find every implementation of an interface to understand the diversity of behaviors supported by a specific abstraction.

## Building Mental Models

Construct your understanding in stages. Start with the happy path to see how the system works when everything goes right. Move to error paths to see how failures are intercepted and reported. Finally, investigate edge cases like boundary conditions or rare state combinations. Map module boundaries by identifying where data enters and leaves a component. Identify the invariants—the conditions that must always be true for the code to function correctly. This structural understanding allows you to predict how changes will affect the broader system.

## Anti-Patterns

*   Assuming how code works based on naming alone.
*   Trusting outdated comments over the actual implementation.
*   Ignoring test files when trying to understand a module.
*   Performing shallow greps without reading the surrounding context.
*   Speculating about unread code instead of verifying it.
*   Overlooking configuration files that change runtime behavior.
*   Treating a single instance of a pattern as the global standard.

## Search Strategies

To master a codebase, use targeted searches. Find all implementations of an interface to see how an abstraction is used. Find all error handlers to understand the system's resilience strategy. Search for configuration sources to see how the application is initialized. Locate entry points to see how the outside world interacts with the system. Search for specific decorators or metadata to find cross-cutting concerns like logging or authorization. If a symbol is used everywhere, filter the search by directory to find its definition or primary usage site.
