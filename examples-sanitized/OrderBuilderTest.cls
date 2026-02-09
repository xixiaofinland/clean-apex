@IsTest
private class OrderBuilderTest {
    @IsTest
    static void build_setsFieldsFromRequestWithoutDml() {
        OrderService.RequestEnvelope request = new OrderService.RequestEnvelope();
        request.orderName = 'Sanitized Order';
        request.productCode = 'BASIC';
        request.closeDate = Date.newInstance(2026, 2, 10);

        Opportunity record = new OrderBuilder(request)
            .withPricingSelector(new StubPricingSelector(145))
            .build();

        System.assertEquals('Sanitized Order', record.Name);
        System.assertEquals(145, record.Amount);
        System.assertEquals(Date.newInstance(2026, 2, 10), record.CloseDate);
        System.assertEquals('Prospecting', record.StageName);
    }

    private class StubPricingSelector extends OrderPricingSelector {
        private Decimal baseAmount;

        StubPricingSelector(Decimal baseAmount) {
            this.baseAmount = baseAmount;
        }

        public override Decimal getBaseAmount(String productCode) {
            return baseAmount;
        }
    }
}
