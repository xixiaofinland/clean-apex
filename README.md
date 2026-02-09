# Clean Apex Agent Skill

An opinionated agent skill for Apex clean code guidance on readability and maintainable structure

## Standalone Package

This repository is ready to publish as a standalone skill package with:

- `SKILL.md`
- `agents/openai.yaml`
- `hooks/scripts/clean-apex-validate.py`
- `references/`
- `templates/`
- `examples-sanitized/`

## Scope

- Naming clarity
- 3-tier architecture: entry-point, static service, OO layer
- DML boundary: DML in static service layer only; no DML in OO layer
- SOQL + DI boundary: OO classes use selector/query dependencies injected as class properties so OO unit tests can mock selectors and avoid database SOQL
- Error propagation to entry-point handlers
- Unit vs integration test separation

## Safe Sharing

- `examples-sanitized/` contains masked examples safe to review and share.
- `templates/` contains generation-ready sanitized templates.

## Generation Flow

1. Select the right starting files from `templates/TEMPLATE_INDEX.md`.
2. Start from `CleanOrder*` templates, including async and trigger packs.
3. Run a sanitize review before publishing and remove org-specific class names, API names, IDs, endpoint domains, and business terms unless they are explicitly user-approved.

## CLI Behavior

- Hook support depends on the runtime.
- Core skill guidance works with or without hooks.
- Validation output is advisory by default and does not block file writes.

## Install and Use

### Claude Code

- Install the skill folder in your Claude skills/plugin location.
- `PostToolUse` hook runs `hooks/scripts/clean-apex-validate.py` automatically on `Write|Edit`.

### Codex CLI

- Install the skill under `.codex/skills/clean-apex/` or `~/.codex/skills/clean-apex/`.
- If runtime hook execution is not available, run validator manually:
  - `echo '{"tool_input":{"file_path":"force-app/main/default/classes/MyClass.cls"}}' | python3 hooks/scripts/clean-apex-validate.py`

### GitHub Copilot (Agent Skills)

- Install as an Agent Skill in your Copilot-supported workspace.
- If hook wiring is not configured for your environment, run validator manually:
  - `echo '{"tool_input":{"file_path":"force-app/main/default/classes/MyClass.cls"}}' | python3 hooks/scripts/clean-apex-validate.py`

## Pattern Packs

- REST: `CleanOrderApi` + `CleanOrderService` + `CleanOrderBuilder`
- Batch/Queueable: `CleanOrderAsyncBatch` + `CleanOrderAsyncQueueable` + `CleanOrderAsyncService`
- Trigger/Action: `CleanOrderTrigger` + `CleanOrderTriggerAction` + `CleanOrderTriggerService` + `CleanOrderNameNormalizer`

## Glossary

New to clean-apex or Apex architecture patterns? See **[GLOSSARY.md](./GLOSSARY.md)** for comprehensive definitions of all terms used in this skill.

**Key concepts**:
- **[3-tier architecture](./GLOSSARY.md#3-tier-architecture)**: Separation into entry-point, service, and OO layers
- **[DML boundary](./GLOSSARY.md#dml-data-manipulation-language)**: DML operations restricted to service layer only
- **[Dependency Injection](./GLOSSARY.md#dependency-injection-di)**: Injecting selectors into OO classes for testability
- **[Advisory mode](./GLOSSARY.md#advisory-mode)**: Validator provides feedback without blocking operations
- **[Semantic naming](./GLOSSARY.md#semantic-naming)**: Names express business meaning rather than technical types

## Getting Started

### Prerequisites

- Python 3.7 or higher (for validator)
- One of the supported platforms: Claude Code, Codex CLI, or GitHub Copilot
- Basic understanding of Apex and Salesforce development

### Quick Start

1. **Install the skill** in your preferred platform:
   - Claude Code: Place in your Claude skills directory
   - Codex CLI: Install under `.codex/skills/clean-apex/` or `~/.codex/skills/clean-apex/`
   - GitHub Copilot: Install as an Agent Skill in your workspace

2. **Test the validator** to ensure it runs correctly:
   ```bash
   echo '{"tool_input":{"file_path":"templates/CleanOrderBuilder.cls"}}' | python3 hooks/scripts/clean-apex-validate.py
   ```
   You should see advisory feedback about the template file.

3. **Review the references** to understand the core principles:
   - Start with `references/architecture.md` for the 3-tier architecture
   - Read `references/naming-conventions.md` for naming patterns
   - Check `references/README.md` for guided reading order

4. **Try generating code** using the templates:
   - Browse `templates/TEMPLATE_INDEX.md` to find the right template
   - Copy and customize templates for your use case
   - The validator will run automatically (if hooks are configured)

## Troubleshooting

### Validator Not Running Automatically

**Problem**: The validator doesn't run after editing files.

**Solution**:
- Verify hooks are supported by your platform
- Check the hook configuration in SKILL.md matches your environment
- Run the validator manually as a fallback:
  ```bash
  echo '{"tool_input":{"file_path":"path/to/YourClass.cls"}}' | python3 hooks/scripts/clean-apex-validate.py
  ```

### Python Import Errors

**Problem**: `ModuleNotFoundError` or Python version issues.

**Solution**:
- Verify Python version: `python3 --version` (must be 3.7+)
- The validator uses only standard library modules (no external dependencies)
- Try using `python` instead of `python3` if your system uses that alias

### Hook Timeout Errors

**Problem**: Validator times out on large files.

**Solution**:
- Increase timeout in SKILL.md hooks configuration (default: 15000ms)
- Consider splitting very large files (over 2000 lines) into smaller modules
- Run validator manually for large files outside the hook system

### Platform-Specific Installation Issues

**Problem**: Skill doesn't load or agent can't find references.

**Solution**:
- Check that all directories are present: `references/`, `templates/`, `hooks/scripts/`, `agents/`
- Verify SKILL.md is at the root of the skill directory
- Consult platform-specific config in `agents/` directory
- Review `agents/README.md` for platform-specific installation steps

### Validator Reporting False Positives

**Problem**: Validator flags code that intentionally violates a rule.

**Solution**:
- Use suppression directives in comments: `// clean-apex: allow=RULE_CODE`
- See `references/validator-exceptions.md` for all rule codes and suppression syntax
- Common suppressions: `allow=DML_IN_OO` for unavoidable DML in domain objects

## FAQ

### What is 3-tier architecture in Apex?

The clean-apex skill enforces a 3-tier pattern:
- **Entry-point layer**: REST resources, batch jobs, trigger handlers - receives requests
- **Service layer**: Static classes with business logic orchestration - coordinates work
- **OO layer**: Domain objects, builders, collections - encapsulates data and behavior

This separation improves testability and maintainability by isolating concerns.

### Why no DML in OO classes?

DML operations (insert, update, delete) tightly couple domain objects to the database, making them hard to unit test. By keeping DML in the service layer and passing data to/from OO objects, you can:
- Test OO logic in pure unit tests (no database access)
- Mock dependencies easily
- Reuse domain logic across different contexts

### How do I handle SOQL in OO classes?

Don't write SOQL directly in OO classes. Instead:
1. Create a selector class (e.g., `OrderSelector`) with query methods
2. Inject the selector as a dependency in the OO class constructor
3. Call selector methods from the OO class
4. In tests, mock the selector to return test data

See `references/soql-di.md` for detailed examples.

### Can I disable specific validator rules?

Yes. Use suppression directives in code comments:
```apex
// clean-apex: allow=DML_IN_OO
insert records; // Intentional exception to the rule
```

All rule codes are documented in `references/validator-exceptions.md`.

### What's the difference between unit tests and integration tests?

- **Unit tests**: Test business logic in isolation using mocks, no database access (`@IsTest(SeeAllData=false)`)
- **Integration tests**: Test database operations and SOQL queries with real data

In clean-apex:
- Test OO/service business logic with unit tests
- Test selectors and trigger handlers with integration tests
- See `references/clean-testing.md` for patterns

### Which template should I use for my scenario?

Consult `templates/TEMPLATE_INDEX.md`:
- REST API endpoint → Start with `CleanOrderApi` + `CleanOrderService` + `CleanOrderBuilder`
- Batch job → Use `CleanOrderAsyncBatch` + `CleanOrderAsyncService`
- Trigger → Use `CleanOrderTrigger` + `CleanOrderTriggerAction` + `CleanOrderTriggerService`
- Domain object → Use `CleanOrder` (OO class) + `CleanOrderBuilder`
- Query layer → Use `CleanOrderSelector`

### What platforms support this skill?

The clean-apex skill works with:
- Claude Code (hooks fully supported)
- Codex CLI (manual validation if hooks unavailable)
- GitHub Copilot Agent Skills (manual validation if hooks unavailable)
- Any agent platform supporting SKILL.md format (see `agents/generic.yaml`)

Platform-specific configurations are in the `agents/` directory.

### How do I report issues or request features?

Submit issues at: https://github.com/anthropics/claude-code/issues

Include:
- Your platform (Claude Code, Codex, etc.)
- Validator output or error messages
- Minimal code example demonstrating the issue

### Can I use this skill for security or performance analysis?

No. The clean-apex skill focuses exclusively on:
- Code readability and naming
- Architectural layering
- Testing patterns
- Error handling

For security analysis (SOQL injection, XSS, authentication) or performance optimization (queries, CPU limits), use specialized security/performance tools.

### How often is this skill updated?

See `CHANGELOG.md` for version history and release notes. The skill follows semantic versioning:
- Major versions (2.0.0): Breaking changes to core principles
- Minor versions (1.1.0): New templates, references, or rules
- Patch versions (1.0.1): Bug fixes and documentation updates

## Contributing

### Scope

Contributions are welcome within the defined scope:
- **In scope**: Clean-code guidance, naming conventions, architecture patterns, testing approaches, error handling, template improvements
- **Out of scope**: Security analysis, performance optimization, Salesforce platform features unrelated to clean code

### Submission Workflow

1. **Discuss first**: Open an issue to discuss proposed changes before implementing
2. **Follow existing patterns**: Match the style of existing templates and references
3. **Document thoroughly**: Update relevant README sections and reference docs
4. **Test validator changes**: Add test cases to `hooks/scripts/test_clean_apex_validate.py`
5. **Update CHANGELOG**: Add entry under `[Unreleased]` section

### Documentation Requirements

All contributions must include:
- Updates to relevant reference documentation in `references/`
- Examples in comments or `examples-sanitized/` if adding templates
- CHANGELOG.md entry describing the change
- Test coverage if modifying the validator

### Review Process

1. Submit a pull request with clear description of changes
2. Ensure all verification checks pass (run `scripts/verify-implementation.sh`)
3. Address reviewer feedback
4. Maintainer will merge after approval
