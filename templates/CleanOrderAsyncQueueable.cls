/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderAsyncQueueable
 * Layer: entry-point
 * Purpose: Queueable job entry-point for async order processing
 * Usage Pattern: Queueable
 * Dependencies: CleanOrderAsyncService, CleanOrdersProcessor
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Pass necessary context via constructor (IDs, parameters, etc.)
 * 3. Implement execute() to delegate work to service layer
 * 4. Keep this class thin - all logic in service layer
 * 5. Use queueable for: on-demand async, HTTP callouts, or dynamic job scheduling
 * 6. Remove this header once customized
 */
public with sharing class CleanOrderAsyncQueueable implements Queueable {
    private List<Id> orderIds;

    public CleanOrderAsyncQueueable(List<Id> orderIds) {
        this.orderIds = orderIds == null ? new List<Id>() : orderIds;
    }

    public void execute(QueueableContext context) {
        CleanOrderAsyncService.processOrders(orderIds);
    }
}
