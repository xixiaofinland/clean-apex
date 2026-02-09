/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC,COMMENT_NOISE
 *
 * Template: CleanOrderNameNormalizerTest
 * Layer: test
 * Purpose: Unit test for CleanOrderNameNormalizer (OO layer) without database
 * Usage Pattern: Test
 * Dependencies: CleanOrderNameNormalizer
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrderNameNormalizer" with your OO class name
 * 2. Test transformation logic without DML (pure unit test)
 * 3. No mocks needed if class is stateless
 * 4. Assert expected transformations
 * 5. Remove this header once customized
 */
@IsTest
private class CleanOrderNameNormalizerTest {
    @IsTest
    static void normalize_formatsNameWithoutDml() {
        CleanOrderNameNormalizer normalizer = new CleanOrderNameNormalizer();

        String normalized = normalizer.normalize('   eNterprise   sample   ORDER  ');

        System.assertEquals('Enterprise Sample Order', normalized);
    }
}
