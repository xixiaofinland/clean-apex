/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC,COMMENT_NOISE
 *
 * Template: CleanOrderTriggerIntegrationTest
 * Layer: test
 * Purpose: Integration test for trigger with database operations
 * Usage Pattern: Test
 * Dependencies: CleanOrderTrigger, CleanOrderTriggerAction, CleanOrderTriggerService
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Test trigger behavior with real DML (insert/update/delete)
 * 3. Verify field transformations or validations applied by trigger
 * 4. Query database to assert trigger effects
 * 5. Remove this header once customized
 */
@IsTest
private class CleanOrderTriggerIntegrationTest {
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
