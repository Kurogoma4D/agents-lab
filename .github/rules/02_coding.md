# Coding Practices

## General

- Do not add inline comments
- Comments should be minimal
  - Only write the WHY in the comments for difficult implementations

## Principles (Backend)

- Use Clean Architecture
- Make components domain-driven (like DDD)

## Principles (Frontend)

- Use Clean Architecture
- Clarification of Responsibilities and Use Cases

## Test-Driven Development (TDD)

- Red-Green-Refactor cycle
- Treat tests as specifications
- Iterate in small units
- Continuous refactoring

## Implementation Procedure

1. Define types first as interface
2. Implement from Pure Functions
   - Write tests first
3. Separate Side Effects
4. Adapter Implementation

## Practices

- Start small and expand gradually
- Avoid excessive abstraction
- Emphasize types over code
- Adjust approach according to complexity

## Code Style

- Functions first (classes only when necessary)
- Utilize immutable update patterns
- Flatten conditional branches with early returns
- Define enumeration types for errors and use cases

## Test Strategy

- Prioritize unit tests for pure functions
- Repository tests with in-memory implementation
- Incorporate testability into design
- Assert first: work backward from expected results
