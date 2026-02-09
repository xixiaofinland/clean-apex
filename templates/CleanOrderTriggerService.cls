/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderTriggerService
 * Layer: service
 * Purpose: Business logic for trigger operations (validation, field updates, etc.)
 * Usage Pattern: Trigger
 * Dependencies: CleanOrderNameNormalizer (OO)
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Add public static methods for trigger business logic
 * 3. Perform field updates, validations, and cross-object operations here
 * 4. DML operations belong here if needed (bulk insert/update related records)
 * 5. Use OO layer classes for complex transformations
 * 6. Remove this header once customized
 */
public with sharing class CleanOrderTriggerService {
    public static void normalizeNames(List<Opportunity> records) {
        CleanOrderNameNormalizer normalizer = new CleanOrderNameNormalizer();
        for (Opportunity record : records) {
            record.Name = normalizer.normalize(record.Name);
        }
    }
}
