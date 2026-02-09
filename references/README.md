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
**Validator rule codes and suppression directives**

**When to read**:
- When validator reports a violation you want to suppress
- When understanding validator feedback
- When you need to intentionally violate a rule

**What it covers**:
- All validator rule codes and descriptions
- Suppression directive syntax
- Common scenarios for rule exceptions
- Best practices for using suppressions

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
4. `validator-exceptions.md` - Understand reported violations
5. `soql-di.md` - Check SOQL isolation if applicable

### For Troubleshooting Validator Output
Start with this order:
1. `validator-exceptions.md` - Lookup the rule code
2. Relevant topic reference (architecture/naming/soql/error) based on rule type
3. `templates/` - Find example of correct pattern
4. Use suppression directive if intentional exception

### For Migration from Existing Code
Start with this order:
1. `architecture.md` - Understand target structure
2. Plan layer extraction strategy
3. `soql-di.md` - Refactor data access first
4. `naming-conventions.md` - Rename for clarity
5. `error-handling.md` - Fix error boundaries last

## Quick Reference Summary

| File | Primary Focus | Key Takeaway |
|------|--------------|--------------|
| architecture.md | Layer separation | DML only in service layer, OO classes stay pure |
| naming-conventions.md | Code clarity | Use role suffixes, semantic names, verb/noun patterns |
| soql-di.md | Testability | Inject selectors, mock in tests, avoid SOQL in OO |
| error-handling.md | Error boundaries | Let exceptions propagate, catch at entry-point only |
| validator-exceptions.md | Rule compliance | Use suppressions sparingly, understand rule intent |

## Additional Resources

- **Templates**: See `templates/TEMPLATE_INDEX.md` for code generation starting points
- **Examples**: Review `examples-sanitized/` for full working examples
- **Validator**: Run `hooks/scripts/clean-apex-validate.py` to check code compliance
- **Main Documentation**: See root `README.md` for installation and getting started

## Contribution

When adding or updating references:
1. Keep files focused on a single topic
2. Provide concrete examples for each principle
3. Explain the "why" behind each guideline
4. Update this README.md index with "when to read" guidance
5. Add entry to CHANGELOG.md under [Unreleased]
