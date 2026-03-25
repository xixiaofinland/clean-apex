# clean-apex Reference Documentation

This directory contains focused reference documentation for the clean-apex skill. Each file addresses a specific aspect of clean-code Apex development.

## Reference Files

### 1. [architecture.md](./architecture.md)

**Core 3-tier architecture principles**

**When to read**:

- Before generating any new Apex code
- When reviewing code structure and layer separation
- When planning a new feature implementation

**What it covers**:

- Entry-point, service, and OO layer definitions
- Responsibilities of each layer
- DML boundary enforcement (DML only in service layer)
- Dependency flow patterns

### 2. [naming-conventions.md](./naming-conventions.md)

**Naming patterns and role suffix standards**

**When to read**:

- When naming new classes, methods, or variables
- During code review focused on clarity
- When refactoring for better readability

**What it covers**:

- Role suffixes (Service, Builder, Selector, Action, Normalizer)
- Semantic map naming conventions
- Method naming patterns (verbs for actions, nouns for queries)
- Variable naming best practices

### 3. [soql-di.md](./soql-di.md)

**SOQL query management and dependency injection**

**When to read**:

- When implementing domain objects that need data access
- When writing unit tests that need to mock database queries
- When refactoring OO classes that contain SOQL

**What it covers**:

- Selector pattern for SOQL isolation
- Dependency injection for testability
- Mocking selectors in unit tests
- When to use integration tests vs unit tests

### 4. [error-handling.md](./error-handling.md)

**Exception propagation and error boundaries**

**When to read**:

- When implementing REST APIs, batch jobs, or triggers
- When deciding where to catch vs throw exceptions
- During code review focused on error handling

**What it covers**:

- Entry-point error boundary pattern
- Exception propagation through layers
- Avoiding swallowed exceptions
- Proper try-catch placement

### 5. [validator-exceptions.md](./validator-exceptions.md)

**Naming exceptions and suppression directives**

**When to read**:

- When a rule needs to be intentionally violated (e.g. third-party contracts, legacy migration)
- When reviewing code with suppression comments

**What it covers**:

- Allowed naming exceptions
- Suppression directive syntax for communicating intentional rule breaks
- When suppression is and is not acceptable

## Reading Order by Task Type

### For Code Generation

Start with this order:

1. `architecture.md` - Understand layer structure
2. `naming-conventions.md` - Learn naming patterns
3. `soql-di.md` - Handle data access correctly
4. `error-handling.md` - Implement proper error boundaries
5. Browse `templates/TEMPLATE_INDEX.md` to find starting templates

### For Code Review

Start with this order:

1. `naming-conventions.md` - Check naming clarity
2. `architecture.md` - Verify layer separation
3. `error-handling.md` - Review exception handling
4. `soql-di.md` - Check SOQL isolation if applicable
5. `validator-exceptions.md` - When a violation is intentional

### For Migration from Existing Code

Start with this order:

1. `architecture.md` - Understand target structure
2. Plan layer extraction strategy
3. `soql-di.md` - Refactor data access first
4. `naming-conventions.md` - Rename for clarity
5. `error-handling.md` - Fix error boundaries last

## Quick Reference Summary

| File                    | Primary Focus    | Key Takeaway                                          |
| ----------------------- | ---------------- | ----------------------------------------------------- |
| architecture.md         | Layer separation | DML only in service layer, OO classes stay pure       |
| naming-conventions.md   | Code clarity     | Use role suffixes, semantic names, verb/noun patterns |
| soql-di.md              | Testability      | Inject selectors, mock in tests, avoid SOQL in OO     |
| error-handling.md       | Error boundaries | Let exceptions propagate, catch at entry-point only   |
| validator-exceptions.md | Rule compliance  | Use suppressions sparingly, understand rule intent    |

## Additional Resources

- **Templates**: See `templates/TEMPLATE_INDEX.md` for code generation starting points
- **Examples**: Review `examples-sanitized/` for full working examples
- **Main Documentation**: See root `README.md` for overview and scope

## Contribution

When adding or updating references:

1. Keep files focused on a single topic
2. Provide concrete examples for each principle
3. Explain the "why" behind each guideline
4. Update this README.md index with "when to read" guidance
