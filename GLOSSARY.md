# clean-apex Glossary

Comprehensive glossary of terms used in the clean-apex skill for Apex clean-code development.

## Architecture Terms

### 3-tier architecture
A layered architectural pattern separating concerns into three distinct layers: entry-point, service, and OO (object-oriented). This separation improves testability, maintainability, and code clarity.

### Entry-point layer
The outermost layer that receives external requests (REST calls, batch executions, trigger events). Entry-points handle error boundaries and delegate all business logic to the service layer. Examples: REST resources, batch classes, triggers.

### Service layer
The middle layer containing business logic orchestration and DML operations. Service classes coordinate work between entry-points and OO classes. Typically implemented as static classes for simplicity. All database operations (insert, update, delete) belong here.

### OO layer (Object-Oriented layer)
The innermost layer containing domain objects, builders, and transformation logic. OO classes encapsulate data and behavior without performing DML or SOQL. This purity enables unit testing without database access.

### Selector layer
A specialized layer for SOQL query isolation. Selectors contain all database queries and are injected into OO classes for dependency injection and testability.

### Layer separation
The principle of keeping architectural layers distinct with clear responsibilities. Entry-points don't contain business logic, OO classes don't perform DML, selectors own all SOQL.

### Dependency flow
The direction of dependencies between layers: entry-point → service → OO → selector. Dependencies always flow inward, never outward.

## Code Quality Terms

### Clean code
Code that is readable, maintainable, and expresses intent clearly through naming and structure rather than comments. Emphasizes simplicity and clarity over cleverness.

### Readability
The ease with which code can be read and understood by other developers. Achieved through clear naming, proper structure, and minimal comments.

### Maintainability
The ease with which code can be modified, extended, and debugged over time. Improved by separation of concerns, testability, and clear architecture.

### Technical debt
Accumulated shortcuts, poor design decisions, or outdated code that makes future changes harder. Clean-apex principles reduce technical debt.

### Code smell
A surface indication of a deeper problem in code. Examples: long methods, unclear names, swallowed exceptions, DML in OO classes.

### Dependency Injection (DI)
A design pattern where dependencies (like selectors) are passed to classes rather than created internally. Enables mocking for unit tests. In clean-apex, typically done via constructor or setter methods.

### DML (Data Manipulation Language)
Salesforce operations that modify database records: insert, update, delete, upsert, undelete. In clean-apex, DML is restricted to the service layer only.

### SOQL (Salesforce Object Query Language)
Salesforce's query language for retrieving data. In clean-apex, SOQL is isolated in selector classes and injected into OO classes via dependency injection.

## Naming Terms

### Role suffix
A suffix added to class names indicating their architectural role. Examples: Service, Builder, Selector, Action, Normalizer, Manager, Handler.

### Semantic naming
Naming variables and methods based on their business meaning rather than technical type. Example: `accountsByIds` instead of `accountMap`.

### Semantic map naming
Naming Map variables to express the relationship between keys and values. Patterns: `XToY` (idToAccount), `XByY` (accountsById), `XMap` (AccountMap), or ending with "Lookup" or "Index".

### Verb-noun pattern
Method naming pattern where verbs indicate actions (createOrder, validateInput) and nouns indicate queries (getAccount, findOpportunities).

### Variable prefix anti-pattern
Avoid prefixes that encode type information (objAccount, strName, idRecordId). Use semantic names instead (account, customerName, recordId).

### List/Set suffix anti-pattern
Avoid redundant "List" or "Set" suffixes on collection variables. Use plural names instead: `accounts` not `accountList`, `ids` not `idSet`.

### Generic map stem
Avoid generic, non-semantic map names like `map`, `data`, `result`, `value`, `item`, `record`, `object`. Use semantic names that express the mapping relationship.

## Testing Terms

### Unit test
A test that verifies business logic in isolation without database access. Uses mocked dependencies. Runs fast. Example: testing a builder or normalizer without DML.

### Integration test
A test that verifies behavior with real database operations (DML and SOQL). Slower than unit tests but validates full flow. Example: testing a service class with actual insert/query.

### Mock
A test double that simulates a dependency's behavior. In clean-apex, typically implemented as stub classes overriding selector methods. Enables unit testing without database.

### Test data factory
A utility class for creating test data. Not emphasized in clean-apex templates; tests create their own minimal data inline.

### SeeAllData
An Apex test annotation controlling database access. `@IsTest(SeeAllData=false)` is the default and recommended for unit tests. Integration tests use real data setup.

### Test.startTest() / Test.stopTest()
Apex testing methods that reset governor limits. Place between test setup and execution to get fresh limits for the code under test.

### Assertion
A test statement verifying expected behavior. Examples: `System.assertEquals()`, `System.assertNotEquals()`, `System.assert()`.

## Validator Terms

### Advisory mode
The default validator behavior where violations are reported as feedback but don't block file operations. Developers can choose to address or suppress issues.

### Suppression directive
A code comment that tells the validator to ignore specific rules. Syntax: `// clean-apex: allow=RULE_CODE` or `// clean-apex: disable=RULE_CODE`.

### Rule code
An identifier for a specific validator rule. Examples: `OO_DML`, `MAP_NAMING`, `COMMENT_NOISE`, `AUTO_JAVADOC`, `CATCH_RETHROW`.

### File-level suppression
Disabling a rule for an entire file using `// clean-apex: disable=RULE_CODE` anywhere in the file. Use sparingly; prefer line-level suppressions.

### Line-level suppression
Allowing a rule exception for a specific line using `// clean-apex: allow=RULE_CODE` on or near the line. More precise than file-level.

### Validator exception
An intentional violation of a clean-apex rule, documented with a suppression directive. Should be rare and well-justified.

## Apex-Specific Terms

### @RestResource
An Apex annotation marking a class as a REST API endpoint. Requires global access and urlMapping parameter. Entry-point layer in clean-apex.

### @IsTest
An Apex annotation marking a class or method as a test. Classes with this annotation are excluded from deployment and code coverage.

### Database.Batchable
An Apex interface for batch processing. Requires start(), execute(), and finish() methods. Entry-point layer in clean-apex.

### Queueable
An Apex interface for asynchronous jobs with chaining support. Requires execute(QueueableContext) method. Entry-point layer in clean-apex.

### Trigger
An Apex construct that fires automatically on DML events (before/after insert/update/delete/undelete). Entry-point layer in clean-apex; should delegate to action handlers.

### with sharing / without sharing
Apex keywords controlling record-level security. `with sharing` enforces sharing rules; `without sharing` runs in system mode. Clean-apex defaults to `with sharing` for security.

### global vs public
Apex access modifiers. `global` allows access from any namespace (required for REST/managed packages). `public` allows access within the namespace. Use `public` unless `global` is required.

### SOQL injection
A security vulnerability where user input is concatenated into SOQL queries. Prevent with bind variables. Not in clean-apex scope but important for security.

## Pattern Terms

### Builder pattern
A creational design pattern for constructing complex objects step-by-step. In clean-apex, used for building sObjects with validation and defaults. Example: CleanOrderBuilder.

### Selector pattern
A data access pattern isolating SOQL queries in dedicated classes. Enables dependency injection and mocking for unit tests. Example: CleanOrderPricingSelector.

### REST API pattern
A pattern for exposing Apex functionality via HTTP REST endpoints. Combines @RestResource entry-point, service layer business logic, and OO builders.

### Trigger pattern
A pattern for handling Salesforce trigger events. Combines trigger definition (entry-point), action handler (routing), and service layer (business logic).

### Batch pattern
A pattern for processing large data volumes asynchronously. Combines Database.Batchable entry-point and service layer processing logic.

### Queueable pattern
A pattern for asynchronous processing with chaining support. Combines Queueable entry-point and service layer processing logic.

### Async pattern
General term for asynchronous processing patterns (batch, queueable, future methods). In clean-apex, batch and queueable are preferred over future methods.

## Anti-Patterns

### Entry-point logic
Business logic implemented directly in entry-point classes (REST resources, triggers). Anti-pattern; delegate to service layer instead.

### OO DML
Performing DML operations (insert, update, delete) inside OO layer classes. Anti-pattern; moves DML to service layer to preserve OO purity and testability.

### Swallowed exception
Catching exceptions without re-throwing or logging. Anti-pattern; prevents error handling at entry-point boundaries.

### Generic variable names
Using vague names like `data`, `result`, `obj`, `str`. Anti-pattern; use semantic names that express business meaning.

### Comment overuse
Excessive comments explaining what code does rather than letting code express itself. Anti-pattern; prefer clear naming and structure.

### Auto-generated JavaDoc
Boilerplate JavaDoc comments on classes/methods that add no value. Anti-pattern; use JavaDoc only when adding meaningful documentation beyond what code expresses.

### Hungarian notation
Encoding type information in variable names (`strName`, `idAccount`). Anti-pattern; modern IDEs show types, so names should express meaning not type.

### God class
A class that does too many things. Anti-pattern; split into focused classes following single responsibility principle.

### Tight coupling
Classes that directly depend on concrete implementations rather than abstractions. Anti-pattern; use dependency injection with selectors for loose coupling.

## Platform and Skill Terms

### clean-apex skill
An agent skill for Claude Code, Codex, and GitHub Copilot providing opinionated Apex clean-code guidance focused on architecture, naming, and testing.

### SKILL.md
The skill definition file containing agent instructions, hook configuration, and metadata. Root file for agent skills.

### Hook
An automated script that runs in response to agent tool use (e.g., running validator after Write or Edit). Platform-dependent; not all platforms support hooks.

### Agent platform
The AI coding tool hosting the skill: Claude Code, Codex CLI, GitHub Copilot, or custom platforms.

### Template
A pre-built code file following clean-apex principles. Templates use "CleanOrder" prefix and include metadata headers. Copy and customize for your use case.

### Pattern pack
A group of related templates for common scenarios. Examples: REST API pack (API + Service + Builder), Trigger pack (Trigger + Action + Service).

### Skill version
The semantic version of the clean-apex skill (e.g., 1.0.0). Follows semver: major.minor.patch.

### Reference documentation
Focused markdown files in `references/` directory covering architecture, naming, testing, and error handling. Load before generating or reviewing code.

### Advisory validation
Validation mode where violations are reported as informational feedback without blocking operations. Default mode for clean-apex validator.

### Suppression
See "Suppression directive" above. Mechanism for intentionally violating clean-apex rules with documentation.

## Acronyms and Abbreviations

- **API**: Application Programming Interface
- **CLI**: Command Line Interface
- **DI**: Dependency Injection
- **DML**: Data Manipulation Language
- **FAQ**: Frequently Asked Questions
- **HTTP**: Hypertext Transfer Protocol
- **JSON**: JavaScript Object Notation
- **OO**: Object-Oriented
- **REST**: Representational State Transfer
- **SOQL**: Salesforce Object Query Language
- **URL**: Uniform Resource Locator
- **YAML**: YAML Ain't Markup Language

## Related Resources

- **README.md**: Getting started, installation, and usage instructions
- **SKILL.md**: Core skill definition and agent instructions
- **references/**: Detailed reference documentation on architecture, naming, testing
- **templates/TEMPLATE_INDEX.md**: Complete template catalog and usage guide
- **CHANGELOG.md**: Version history and release notes
- **agents/**: Platform-specific configuration files

## Contributing to the Glossary

To add or update glossary terms:

1. Place terms in the appropriate section
2. Use **bold** for the term, followed by its definition
3. Provide examples where helpful
4. Link to related terms or resources
5. Keep definitions concise (2-3 sentences max)
6. Update CHANGELOG.md under [Unreleased]
