public with sharing class OrderTriggerService {
    public static void normalizeNames(List<Opportunity> records) {
        OrderNameNormalizer normalizer = new OrderNameNormalizer();
        for (Opportunity record : records) {
            record.Name = normalizer.normalize(record.Name);
        }
    }
}
