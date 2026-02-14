/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderAsyncBatch
 * Layer: entry-point
 * Purpose: Batch job entry-point for async order processing
 * Usage Pattern: Batch
 * Dependencies: CleanOrderAsyncService, CleanOrdersProcessor
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Update start() to query records for processing
 * 3. Implement execute() to delegate work to service layer
 * 4. Add error handling in finish() if needed
 * 5. Keep this class thin - delegate logic to service layer
 * 6. Remove this header once customized
 */
global with sharing class CleanOrderAsyncBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext context) {
        return CleanOrderAsyncService.getPendingOrders();
    }

    global void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Id> orderIds = new List<Id>();
        for (SObject row : scope) {
            orderIds.add((Id) row.get('Id'));
        }
        CleanOrderAsyncService.processOrders(orderIds);
    }

    global void finish(Database.BatchableContext context) {
    }
}
