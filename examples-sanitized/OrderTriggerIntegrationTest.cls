@IsTest
private class OrderTriggerIntegrationTest {
    @IsTest
    static void beforeInsert_normalizesOpportunityName() {
        Opportunity record = new Opportunity(
            Name = '   unclean   trigger   order   ',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(7)
        );

        insert record;

        Opportunity insertedRecord = [
            SELECT Name
            FROM Opportunity
            WHERE Id = :record.Id
            LIMIT 1
        ];
        System.assertEquals('Unclean Trigger Order', insertedRecord.Name);
    }
}
