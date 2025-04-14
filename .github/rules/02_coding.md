# Coding Practices

## Principles (Backend)

### Domain-Driven Design (DDD)

- Distinguish between Value Objects and Entities
- Ensure consistency with Aggregates
- Abstract data access with Repositories
- Be aware of Bounded Contexts
- Be aware of Layered Architecture to separate concerns

## Principles (Frontend)

### Clean Architecture

- Layer Responsibilities: Each layer—Presentation (UI), Application (use cases and business logic), Domain (core business), and Data (API and storage access)—has defined responsibilities. However, a strict correspondence to a directory structure is not required, emphasizing flexible implementation.

- Dependency Management: Outer layers depend on inner layers, while inner layers remain unaware of outer layer details. This, along with the Dependency Inversion Principle, ensures maintainability and ease of testing.

- Clarification of Responsibilities and Use Cases: The UI is responsible for display and input, business logic is handled in a dedicated layer, and data retrieval is consolidated within repositories, treating each function as an independent use case.

- Utilizing Dependency Injection: External dependencies are injected via interfaces, making it easy to substitute with mocks during testing.

### Test-Driven Development (TDD)

- Red-Green-Refactor cycle
- Treat tests as specifications
- Iterate in small units
- Continuous refactoring

## Implementation Procedure

1. Type Design
   - Define types first
   - Express the domain language with types

2. Implement from Pure Functions
   - Implement functions without external dependencies first
   - Write tests first

3. Separate Side Effects
   - Push IO operations to the function boundary
   - Wrap processes with side effects with Promise

4. Adapter Implementation
   - Abstract access to external services and DB
   - Prepare test mocks

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
