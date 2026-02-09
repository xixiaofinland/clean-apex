public with sharing class OrderBuilder {
    private final OrderService.RequestEnvelope request;
    private OrderPricingSelector pricingSelector;

    public OrderBuilder(OrderService.RequestEnvelope request) {
        this.request = request;
        this.pricingSelector = new OrderPricingSelector();
    }

    public OrderBuilder withPricingSelector(OrderPricingSelector pricingSelector) {
        this.pricingSelector = pricingSelector;
        return this;
    }

    public Opportunity build() {
        Opportunity record = new Opportunity();
        record.Name = request.orderName;
        record.StageName = 'Prospecting';
        record.CloseDate = request.closeDate == null ? Date.today().addDays(14) : request.closeDate;
        record.Amount = pricingSelector.getBaseAmount(request.productCode);

        if (String.isNotBlank(request.accountId)) {
            record.AccountId = request.accountId;
        }

        return record;
    }
}
