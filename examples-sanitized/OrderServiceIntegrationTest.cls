@IsTest
private class OrderServiceIntegrationTest {
    @IsTest
    static void createOrder_insertsOpportunity() {
        Account account = new Account(Name = 'Sanitized Account');
        insert account;

        OrderService.RequestEnvelope request = new OrderService.RequestEnvelope();
        request.accountId = account.Id;
        request.orderName = 'Integration Order';
        request.productCode = 'PREMIUM';
        request.closeDate = Date.today().addDays(5);

        Test.startTest();
        OrderService.ResponseEnvelope response = OrderService.createOrder(request);
        Test.stopTest();

        Opportunity insertedRecord = [
            SELECT Id, Name, AccountId, StageName, Amount
            FROM Opportunity
            WHERE Id = :response.orderId
            LIMIT 1
        ];

        System.assertEquals('Integration Order', insertedRecord.Name);
        System.assertEquals(account.Id, insertedRecord.AccountId);
        System.assertEquals('Prospecting', insertedRecord.StageName);
        System.assertEquals(199, insertedRecord.Amount);
    }
}
