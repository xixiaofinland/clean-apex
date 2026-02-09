/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderBuilder
 * Layer: oo
 * Purpose: Domain object builder pattern for constructing sObjects with validation and defaults
 * Usage Pattern: OO
 * Dependencies: CleanOrderService (RequestEnvelope), CleanOrderPricingSelector
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name throughout the file
 * 2. Update field assignments in build() method for your sObject
 * 3. Add withXxx methods for optional field injections
 * 4. Inject selectors via constructor or with methods for testability
 * 5. Remove this header once customized
 */
public with sharing class CleanOrderBuilder {
    private final CleanOrderService.RequestEnvelope request;
    private CleanOrderPricingSelector pricingSelector;

    public CleanOrderBuilder(CleanOrderService.RequestEnvelope request) {
        this.request = request;
        this.pricingSelector = new CleanOrderPricingSelector();
    }

    public CleanOrderBuilder withPricingSelector(CleanOrderPricingSelector pricingSelector) {
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
