/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderTrigger
 * Layer: entry-point
 * Purpose: Trigger entry-point that delegates to action handler
 * Usage Pattern: Trigger
 * Dependencies: CleanOrderTriggerAction
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Update sObject type (Opportunity, Account, etc.)
 * 3. Add/remove trigger events as needed (before/after insert/update/delete/undelete)
 * 4. Delegate all logic to action handler (no logic in trigger body)
 * 5. Keep trigger simple - one line per event delegation
 * 6. Remove this header once customized
 */
trigger CleanOrderTrigger on Opportunity (before insert, before update) {
    CleanOrderTriggerAction.beforeUpsert(Trigger.new);
}
