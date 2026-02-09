global with sharing class OrderAsyncBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext context) {
        return OrderAsyncService.getPendingOrders();
    }

    global void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Id> orderIds = new List<Id>();
        for (SObject row : scope) {
            orderIds.add((Id) row.get('Id'));
        }
        System.enqueueJob(new OrderAsyncQueueable(orderIds));
    }

    global void finish(Database.BatchableContext context) {
    }
}
