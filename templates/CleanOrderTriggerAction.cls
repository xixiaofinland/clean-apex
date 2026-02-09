/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderTriggerAction
 * Layer: entry-point
 * Purpose: Trigger action handler that routes to service layer
 * Usage Pattern: Trigger
 * Dependencies: CleanOrderTriggerService
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Add public static methods for each trigger event (beforeInsert, afterUpdate, etc.)
 * 3. Delegate all logic to service layer (no business logic here)
 * 4. Keep action methods thin - just routing and type conversion
 * 5. Remove this header once customized
 */
public with sharing class CleanOrderTriggerAction {
    public static void beforeUpsert(List<Opportunity> records) {
        CleanOrderTriggerService.normalizeNames(records);
    }
}
