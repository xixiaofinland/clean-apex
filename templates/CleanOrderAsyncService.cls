/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderAsyncService
 * Layer: service
 * Purpose: Business logic and DML for async batch/queueable operations
 * Usage Pattern: Async Service
 * Dependencies: CleanOrdersProcessor
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Add query methods for batch start (return Database.QueryLocator)
 * 3. Add processing methods for execute logic (DML, callouts, etc.)
 * 4. Keep bulk-safe (process lists, not single records)
 * 5. All DML operations belong in this service layer
 * 6. Remove this header once customized
 */
public with sharing class CleanOrderAsyncService {
    public static Database.QueryLocator getPendingOrders() {
        return Database.getQueryLocator([
            SELECT Id
            FROM Opportunity
            WHERE StageName != 'Closed Won'
            LIMIT 10000
        ]);
    }

    public static void processOrders(List<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }

        List<Opportunity> orders = [
            SELECT Id, Name, Description
            FROM Opportunity
            WHERE Id IN :orderIds
        ];
        
        CleanOrdersProcessor processor = new CleanOrdersProcessor(orders);
        List<Opportunity> processedOrders = processor.process();
        
        update processedOrders;
    }
}
