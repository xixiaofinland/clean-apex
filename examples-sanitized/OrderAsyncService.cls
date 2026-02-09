public with sharing class OrderAsyncService {
    public static Database.QueryLocator getPendingOrders() {
        return Database.getQueryLocator([
            SELECT Id
            FROM Opportunity
            WHERE StageName != 'Closed Won'
            LIMIT 200
        ]);
    }

    public static void processOrders(List<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return;
        }

        List<Opportunity> recordsToUpdate = [
            SELECT Id, Description
            FROM Opportunity
            WHERE Id IN :orderIds
        ];
        for (Opportunity record : recordsToUpdate) {
            record.Description = 'Queued follow-up scheduled.';
        }
        update recordsToUpdate;
    }
}
