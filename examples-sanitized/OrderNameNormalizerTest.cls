@IsTest
private class OrderNameNormalizerTest {
    @IsTest
    static void normalize_formatsNameWithoutDml() {
        OrderNameNormalizer normalizer = new OrderNameNormalizer();

        String normalized = normalizer.normalize('   eNterprise   sample   ORDER  ');

        System.assertEquals('Enterprise Sample Order', normalized);
    }
}
