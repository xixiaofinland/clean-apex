# Template Index

This file provides a comprehensive guide to all templates in the clean-apex skill, organized by architectural layer and usage pattern.

## Quick Reference Table

| Template                             | Layer       | Purpose                        | Typical Pair                                  |
| ------------------------------------ | ----------- | ------------------------------ | --------------------------------------------- |
| CleanOrderApi.cls                    | entry-point | REST API endpoint              | CleanOrderService                             |
| CleanOrderAsyncBatch.cls             | entry-point | Batch job entry-point          | CleanOrderAsyncService + CleanOrdersProcessor |
| CleanOrderAsyncQueueable.cls         | entry-point | Queueable job entry-point      | CleanOrderAsyncService + CleanOrdersProcessor |
| CleanOrderTrigger.trigger            | entry-point | Trigger entry-point            | CleanOrderTriggerAction                       |
| CleanOrderService.cls                | service     | Business logic + DML           | CleanOrderBuilder + CleanOrderPricingSelector |
| CleanOrderAsyncService.cls           | service     | Async processing logic + DML   | CleanOrdersProcessor                          |
| CleanOrderTriggerService.cls         | service     | Trigger business logic         | CleanOrderNameNormalizer                      |
| CleanOrderBuilder.cls                | oo          | Domain object builder          | CleanOrderService + CleanOrderPricingSelector |
| CleanOrderNameNormalizer.cls         | oo          | Data transformation logic      | CleanOrderTriggerService                      |
| CleanOrdersProcessor.cls             | oo          | Bulk order processing logic    | CleanOrderAsyncService                        |
| CleanOrderTriggerAction.cls          | entry-point | Trigger action router          | CleanOrderTriggerService                      |
| CleanOrderPricingSelector.cls        | selector    | SOQL query layer               | CleanOrderBuilder (injected)                  |
| CleanOrderBuilderTest.cls            | test        | OO unit test (no DML)          | CleanOrderBuilder                             |
| CleanOrderNameNormalizerTest.cls     | test        | OO unit test (no DML)          | CleanOrderNameNormalizer                      |
| CleanOrdersProcessorTest.cls         | test        | OO unit test (no DML)          | CleanOrdersProcessor                          |
| CleanOrderServiceIntegrationTest.cls | test        | Service integration test (DML) | CleanOrderService                             |
| CleanOrderTriggerIntegrationTest.cls | test        | Trigger integration test (DML) | CleanOrderTrigger                             |

## Layers

### Entry-Point Layer

Entry-points receive external requests and delegate to the service layer. They handle error boundaries.

- **CleanOrderApi.cls** - REST API endpoint with @RestResource
- **CleanOrderAsyncBatch.cls** - Batch job implementing Database.Batchable
- **CleanOrderAsyncQueueable.cls** - Queueable job implementing Queueable
- **CleanOrderTrigger.trigger** - Trigger that delegates to action handler
- **CleanOrderTriggerAction.cls** - Trigger action router (technically entry-point)

### Service Layer (Static)

Service classes contain business logic orchestration and DML operations.

- **CleanOrderService.cls** - Core business logic with DML (insert/update/delete)
- **CleanOrderAsyncService.cls** - Async processing logic with DML
- **CleanOrderTriggerService.cls** - Trigger-specific business logic

### OO Layer

Object-oriented classes encapsulate data and behavior without DML.

- **CleanOrderBuilder.cls** - Builder pattern for constructing sObjects
- **CleanOrderNameNormalizer.cls** - Data transformation and normalization

### Selector/Query Layer

Selectors isolate SOQL queries for dependency injection and testing.

- **CleanOrderPricingSelector.cls** - Query layer for pricing data

### Test Layer

Test classes cover business logic (unit tests) and database operations (integration tests).

- **CleanOrderBuilderTest.cls** - Unit test for builder (no DML, mocked selectors)
- **CleanOrderNameNormalizerTest.cls** - Unit test for normalizer (no DML)
- **CleanOrderServiceIntegrationTest.cls** - Integration test for service (DML allowed)
- **CleanOrderTriggerIntegrationTest.cls** - Integration test for trigger (DML allowed)

## Pattern Packs

Pattern packs group related templates for common scenarios.

### REST API Pattern Pack

**Use when**: Building a REST API endpoint

**Templates**:

1. `CleanOrderApi.cls` (entry-point) - Handles HTTP request/response
2. `CleanOrderService.cls` (service) - Business logic and DML
3. `CleanOrderBuilder.cls` (oo) - Builds domain objects
4. `CleanOrderPricingSelector.cls` (selector) - Queries pricing data
5. `CleanOrderBuilderTest.cls` (test) - Unit test for builder
6. `CleanOrderServiceIntegrationTest.cls` (test) - Integration test for service

**Flow**: REST endpoint → Service method → Builder → Selector (injected)

### Async Processing Pattern Pack

**Use when**: Building batch or queueable jobs for async operations

**Templates**:

1. `CleanOrderAsyncBatch.cls` (entry-point) - Batch job for scheduled/large-scale processing
2. `CleanOrderAsyncQueueable.cls` (entry-point) - Queueable for on-demand/chainable processing
3. `CleanOrderAsyncService.cls` (service) - Async processing logic with DML
4. `CleanOrdersProcessor.cls` (oo) - Bulk data transformation and business logic
5. `CleanOrdersProcessorTest.cls` (test) - Unit test for processor (no DML)

**Flow**: Batch OR Queueable → Async Service → Processor (OO)

**Note**: Batch and queueable are separate entry-point examples that share the same service and OO layers. Choose based on your trigger type (scheduled vs on-demand), not performance optimization. Both demonstrate proper 3-tier architecture.

### Trigger/Action Pattern Pack

**Use when**: Building trigger handlers

**Templates**:

1. `CleanOrderTrigger.trigger` (entry-point) - Trigger definition
2. `CleanOrderTriggerAction.cls` (entry-point) - Action router
3. `CleanOrderTriggerService.cls` (service) - Trigger business logic
4. `CleanOrderNameNormalizer.cls` (oo) - Data transformations
5. `CleanOrderTriggerIntegrationTest.cls` (test) - Integration test for trigger

**Flow**: Trigger fires → Action handler → Service logic → OO transformations

## Usage Guidelines

### Choosing the Right Template

1. **Identify your entry-point**:
   - REST API → `CleanOrderApi.cls`
   - Batch job → `CleanOrderAsyncBatch.cls`
   - Queueable job → `CleanOrderAsyncQueueable.cls`
   - Trigger → `CleanOrderTrigger.trigger` + `CleanOrderTriggerAction.cls`

2. **Add service layer**:
   - Business logic + DML → `CleanOrderService.cls`
   - Async processing → `CleanOrderAsyncService.cls`
   - Trigger logic → `CleanOrderTriggerService.cls`

3. **Add OO classes as needed**:
   - Building objects → `CleanOrderBuilder.cls`
   - Transforming data → `CleanOrderNameNormalizer.cls`

4. **Add selectors for data access**:
   - SOQL queries → `CleanOrderPricingSelector.cls`
   - Inject into OO classes for testability

5. **Add tests**:
   - OO/Service logic → Unit tests (no DML)
   - Service/Trigger with DB → Integration tests (DML allowed)

### Customization Steps

For each template you use:

1. **Copy the template** to your project directory
2. **Replace "CleanOrder"** with your entity name (find/replace)
3. **Update field assignments** for your sObject
4. **Customize business logic** for your use case
5. **Remove the metadata header** after customization

### Template Metadata Headers

All templates include a metadata header:

```apex
/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: [Name]
 * Layer: [layer]
 * Purpose: [Description]
 * Usage Pattern: [Pattern]
 * Dependencies: [Related classes]
 *
 * INSTRUCTIONS:
 * ...
 */
```

**Important**: Remove this header once you've customized the template for your use case. The suppression directive `clean-apex: allow=AUTO_JAVADOC` prevents validator warnings on template headers.

## Naming Conventions

All templates follow clean-apex naming conventions:

- **Role suffixes**: Service, Builder, Selector, Action, Normalizer
- **Entry-point hints**: Api, Batch, Queueable, Trigger
- **Test suffixes**: Test (with "Unit" or "Integration" in method names)

See `references/naming-conventions.md` for complete naming guidance.

## Architecture Principles

Templates enforce 3-tier architecture:

- **Entry-point**: Receives requests, handles errors
- **Service**: Contains business logic, performs DML
- **OO**: Encapsulates data/behavior, no DML

See `references/architecture.md` for architecture details.

## Testing Strategy

Templates demonstrate testing best practices:

- **Unit tests**: Test OO/service logic without database (mock selectors)
- **Integration tests**: Test service/triggers with real DML and SOQL
- **Naming**: Include "Unit" or "Integration" in test method names

See `references/clean-testing.md` for testing guidance.

## Contributing New Templates

To contribute a new template:

1. **Follow existing patterns**: Match structure and style of current templates
2. **Add metadata header**: Include all required metadata fields
3. **Use "CleanOrder" prefix**: Keep templates generic and reusable
4. **Add to this index**: Update Quick Reference Table and appropriate section
5. **Document pattern pack**: If template is part of a pattern, document the flow
6. **Add suppression**: Include `clean-apex: allow=AUTO_JAVADOC` in header

### Template Contribution Checklist

- [ ] Template uses "CleanOrder" prefix for entity name
- [ ] Metadata header present with all fields
- [ ] Layer classification clear (entry-point, service, oo, selector, test)
- [ ] Dependencies documented in header
- [ ] Customization instructions in header
- [ ] Added to Quick Reference Table
- [ ] Added to appropriate Layer section
- [ ] Pattern pack documented if applicable

## Template Maintenance

When updating templates:

- Maintain backward compatibility where possible
- Update metadata header if purpose/dependencies change
- Bump skill version in SKILL.md if templates change significantly

## Notes

- Keep template filenames in `templates/` directory
- Prefer `CleanOrder*` prefix for safe, shareable generation defaults
- Templates are sanitized and safe to share (no org-specific details)
- See `examples-sanitized/` for complete working examples
- Consult `references/` for architecture and naming guidance
