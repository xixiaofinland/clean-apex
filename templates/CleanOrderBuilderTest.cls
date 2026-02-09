/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC,COMMENT_NOISE
 *
 * Template: CleanOrderBuilderTest
 * Layer: test
 * Purpose: Unit test for CleanOrderBuilder (OO layer) with mocked dependencies
 * Usage Pattern: Test
 * Dependencies: CleanOrderBuilder, CleanOrderPricingSelector (mocked)
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Test builder logic without DML (pure unit test)
 * 3. Mock all selectors and dependencies with stub classes
 * 4. Assert field assignments and business logic
 * 5. No database operations - test in isolation
 * 6. Remove this header once customized
 */
@IsTest
private class CleanOrderBuilderTest {
    @IsTest
    static void build_setsFieldsFromRequestWithoutDml() {
        CleanOrderService.RequestEnvelope request = new CleanOrderService.RequestEnvelope();
        request.orderName = 'Template Order';
        request.productCode = 'BASIC';
        request.closeDate = Date.newInstance(2026, 2, 10);

        Opportunity record = new CleanOrderBuilder(request)
            .withPricingSelector(new StubPricingSelector(145))
            .build();

        System.assertEquals('Template Order', record.Name);
        System.assertEquals(145, record.Amount);
        System.assertEquals(Date.newInstance(2026, 2, 10), record.CloseDate);
        System.assertEquals('Prospecting', record.StageName);
    }

    private class StubPricingSelector extends CleanOrderPricingSelector {
        private Decimal baseAmount;

        StubPricingSelector(Decimal baseAmount) {
            this.baseAmount = baseAmount;
        }

        public override Decimal getBaseAmount(String productCode) {
            return baseAmount;
        }
    }
}
