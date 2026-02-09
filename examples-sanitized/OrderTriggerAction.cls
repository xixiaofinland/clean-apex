public with sharing class OrderTriggerAction {
    public static void beforeUpsert(List<Opportunity> records) {
        OrderTriggerService.normalizeNames(records);
    }
}
