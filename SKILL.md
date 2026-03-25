---
name: clean-apex
version: "1.0.0"
author: "Xi Xiao"
description: "Clean-code focused Apex guidance for readability, naming conventions, 3-tier architecture (entry-point, static service, OO), error handling, and unit vs integration testing. Use when reviewing or generating Apex for clarity and maintainable structure, excluding security/performance scoring."
keywords:
  - apex
  - salesforce
  - clean-code
  - architecture
  - testing
  - code-quality
capabilities:
  - code_review
  - code_generation
  - architecture_guidance
platforms:
  - claude-code
  - codex
  - github-copilot
---

# clean-apex

Provide opinionated, minimal clean-code guidance for Apex. Focus on readability, naming, architecture layering, error handling, and test separation. Avoid security checks, performance scoring, and broad best-practice audits unless explicitly requested.

## Load References

Read these files before doing any work:

- `references/naming-conventions.md`
- `references/architecture.md`
- `references/error-handling.md`
- `references/soql-di.md`
- `references/validator-exceptions.md`

## Quick Workflow

1. Clarify the task: review, generate, or both.
2. Identify the layer(s): entry-point, service, OO, or test.
3. Apply naming conventions from `references/naming-conventions.md`.
4. Enforce 3-tier responsibilities from `references/architecture.md`.
5. Apply error handling from `references/error-handling.md`.
6. Apply SOQL + DI constraints and test rules from `references/soql-di.md`.

## Generation Mode

When generating Apex:

- Use the 3-tier structure. Keep entry-point minimal; orchestrate in service; compute in OO.
- Put all DML in the static service layer only.
- Keep OO classes DML-free and focused on in-memory logic.
- Put SOQL in selector/query classes and inject into OO classes as properties.
- Follow naming conventions strictly.
- Avoid code comments unless they convey non-obvious intent or constraints that the code cannot express.
- Do not add auto-generated JavaDoc-style comments for classes or methods.
- Provide unit tests for OO classes with no DML; use DI to replace SOQL.
- Provide integration tests for entry-point/service behavior where DML is expected.

## How To Use Clean-Apex

Use this exact generation flow:

1. Read `templates/TEMPLATE_INDEX.md` and select layer-appropriate files.
2. Start from `CleanOrder*` templates in `templates/`, including async and trigger packs.
3. Run a sanitize check before final output and remove org-specific class names, object/field API names, IDs, endpoint domains, and business terms unless the user explicitly provides approved real names.

### Templates

Check `templates/TEMPLATE_INDEX.md` first to see which templates map to each layer/test type.
If templates exist at `templates/`, prefer them. If missing or incomplete, ask the user for sample Apex templates before generating full files.
Use `examples-sanitized/` for safe style references.

## Sanitization Rules

- Do not copy user-provided org-specific source snippets directly into generated output.
- Treat any org-specific source material as private pattern input only.
- Use generic class/object/field names in output unless the user explicitly provides org-specific names.
- Prefer standard objects or obvious placeholders in generated templates/examples.
- Before producing shareable code, ensure names and terms are masked and user-reviewed.

## Review Mode

When reviewing Apex:

- Flag naming violations with concrete rename suggestions.
- Flag layer violations (entry-point logic, service doing OO work, OO doing DML).
- Flag missing DI where OO relies on SOQL.
- Flag error handling that swallows exceptions without business justification.
- Flag OO tests that use DML or fail to mock SOQL.
- Flag unnecessary comments or auto-generated JavaDoc-style comments on classes/methods.
- Keep feedback concise and focused on readability and structure only.

## Error Handling Rules

- Let exceptions bubble to entry-point and handle there.
- Do not swallow exceptions unless business requirements demand it; log before swallowing.

## Testing Rules

- OO class unit tests must not use DML.
- When SOQL is required, inject a selector/query dependency to substitute the SOQL in tests.
- Use integration tests for entry-point/service flows that perform DML.

## Out of Scope

Do not add security checks, performance tuning, or scoring unless the user explicitly requests them.
