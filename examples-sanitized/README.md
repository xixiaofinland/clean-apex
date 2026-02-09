# Sanitized Examples

These files are intentionally generic and safe to share.

- Object model uses standard Salesforce objects only.
- Product codes, endpoint paths, and class names are placeholders.
- No org-specific custom objects, fields, IDs, or business terms are included.

Use these examples as style references for clean-apex patterns:

- `OrderApi.cls`: entry-point layer
- `OrderService.cls`: static service layer
- `OrderBuilder.cls`: OO layer
- `OrderPricingSelector.cls`: selector/query layer
- `OrderBuilderTest.cls`: OO unit test (no DML)
- `OrderServiceIntegrationTest.cls`: integration test (DML allowed)
- `OrderAsyncBatch.cls`, `OrderAsyncQueueable.cls`, `OrderAsyncService.cls`: batch/queueable entry-point pack
- `OrderTrigger.trigger`, `OrderTriggerAction.cls`, `OrderTriggerService.cls`, `OrderNameNormalizer.cls`: trigger/action entry-point pack
- `OrderNameNormalizerTest.cls`: OO unit test for trigger OO helper
- `OrderTriggerIntegrationTest.cls`: trigger integration test
