public virtual with sharing class OrderPricingSelector {
    private static final Map<String, Decimal> productCodeToAmount = new Map<String, Decimal>{
        'BASIC' => 99,
        'PREMIUM' => 199
    };

    public virtual Decimal getBaseAmount(String productCode) {
        Decimal configuredAmount = productCodeToAmount.get(productCode);
        if (configuredAmount != null) {
            return configuredAmount;
        }

        // Placeholder query to illustrate selector ownership of SOQL.
        [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return 0;
    }
}
