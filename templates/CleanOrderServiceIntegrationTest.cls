/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC,COMMENT_NOISE
 *
 * Template: CleanOrderServiceIntegrationTest
 * Layer: test
 * Purpose: Integration test for CleanOrderService with database operations
 * Usage Pattern: Test
 * Dependencies: CleanOrderService, CleanOrderBuilder, CleanOrderPricingSelector (real)
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Test service layer with real DML and SOQL
 * 3. Set up test data (insert prerequisites)
 * 4. Use Test.startTest()/Test.stopTest() for governor limit reset
 * 5. Assert database state after operations
 * 6. Remove this header once customized
 */
@IsTest
private class CleanOrderServiceIntegrationTest {
    @IsTest
    static void createOrder_insertsOpportunity() {
        Account account = new Account(Name = 'Template Account');
        insert account;

        CleanOrderService.RequestEnvelope request = new CleanOrderService.RequestEnvelope();
        request.accountId = account.Id;
        request.orderName = 'Integration Template Order';
        request.productCode = 'PREMIUM';
        request.closeDate = Date.today().addDays(5);

        Test.startTest();
        CleanOrderService.ResponseEnvelope response = CleanOrderService.createOrder(request);
        Test.stopTest();

        Opportunity insertedRecord = [
            SELECT Id, Name, AccountId, StageName, Amount
            FROM Opportunity
            WHERE Id = :response.orderId
            LIMIT 1
        ];

        System.assertEquals('Integration Template Order', insertedRecord.Name);
        System.assertEquals(account.Id, insertedRecord.AccountId);
        System.assertEquals('Prospecting', insertedRecord.StageName);
        System.assertEquals(199, insertedRecord.Amount);
    }
}
