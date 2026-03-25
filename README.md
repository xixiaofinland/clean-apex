# Clean Apex Agent Skill

An opinionated agent skill for clean-code Apex guidance focused on readability and maintainable structure.

## Scope

- Naming clarity and role suffixes
- 3-tier architecture: entry-point → service → OO layer
- DML boundary: service layer only; no DML in OO classes
- SOQL + DI: OO classes use injected selector dependencies for testability
- Error propagation to entry-point handlers
- Unit vs integration test separation

## Pattern Packs

- **REST**: `CleanOrderApi` + `CleanOrderService` + `CleanOrderBuilder`
- **Batch/Queueable**: `CleanOrderAsyncBatch` + `CleanOrderAsyncQueueable` + `CleanOrderAsyncService` + `CleanOrdersProcessor`
- **Trigger/Action**: `CleanOrderTrigger` + `CleanOrderTriggerAction` + `CleanOrderTriggerService` + `CleanOrderNameNormalizer`

## Contents

- `SKILL.md` — agent instructions and workflow
- `references/` — focused guidance on architecture, naming, SOQL/DI, error handling, exceptions
- `templates/` — generation-ready sanitized Apex templates (see `TEMPLATE_INDEX.md`)
- `examples-sanitized/` — masked examples safe to review and share

## Safe Sharing

- `examples-sanitized/` contains masked examples safe to review and share.
- `templates/` contains generation-ready sanitized templates.
- Generated output uses generic names unless user provides org-specific ones.
