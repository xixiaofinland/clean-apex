trigger OrderTrigger on Opportunity (before insert, before update) {
    OrderTriggerAction.beforeUpsert(Trigger.new);
}
