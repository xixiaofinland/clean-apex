public with sharing class OrderAsyncService {
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
        
        OrdersProcessor processor = new OrdersProcessor(orders);
        List<Opportunity> processedOrders = processor.process();
        
        update processedOrders;
    }
}
