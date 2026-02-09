/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderPricingSelector
 * Layer: selector
 * Purpose: SOQL query layer for pricing data retrieval
 * Usage Pattern: Selector
 * Dependencies: None
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrderPricing" with your data domain
 * 2. Add query methods that return data from database or configuration
 * 3. Make methods virtual for mockability in tests
 * 4. Keep all SOQL in this layer (no SOQL in OO or service)
 * 5. Inject this selector into OO classes that need data
 * 6. Remove this header once customized
 */
public virtual with sharing class CleanOrderPricingSelector {
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
