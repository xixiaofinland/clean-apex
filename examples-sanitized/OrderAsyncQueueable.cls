public with sharing class OrderAsyncQueueable implements Queueable {
    private List<Id> orderIds;

    public OrderAsyncQueueable(List<Id> orderIds) {
        this.orderIds = orderIds == null ? new List<Id>() : orderIds;
    }

    public void execute(QueueableContext context) {
        OrderAsyncService.processOrders(orderIds);
    }
}
