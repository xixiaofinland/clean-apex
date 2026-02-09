# Validator Exceptions

Use exceptions only when there is a concrete business or integration reason.

## Allowed Naming Exceptions

- Map names can use one of:
  - key-value style: `IdToAccount`
  - grouping style: `itemsByType`
- Generic map names are still discouraged: `map`, `dataMap`, `resultMap`.

## Suppression Directives

Prefer local suppressions over disabling globally.

- File-level disable:
  - `// clean-apex: disable=MAP_NAMING,LIST_NAMING,COMMENT_NOISE`
- Line-level allow:
  - `Map<String, Object> dataMap; // clean-apex: allow=MAP_NAMING`
  - `/** Integration contract note */ // clean-apex: allow=COMMENT_NOISE`
  - `/** Temporary migration docs */ // clean-apex: allow=AUTO_JAVADOC`

## When Suppression Is Acceptable

- Third-party payload contracts force a naming shape.
- Existing interface signatures must remain unchanged.
- Legacy migration code is intentionally temporary.
- A short compliance or legal notice is required in-file.
- Temporary generated docs are required during migration.

## When Suppression Is Not Acceptable

- Convenience-only naming shortcuts.
- Avoiding architecture rules (`OO_DML`, `OO_SOQL_DI`) without explicit user approval.
- Keeping boilerplate comments or auto-generated JavaDoc by default.
