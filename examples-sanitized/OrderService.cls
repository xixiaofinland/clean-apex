public with sharing class OrderService {
    public static RequestEnvelope parseRequest(String requestBody) {
        try {
            return (RequestEnvelope) JSON.deserialize(requestBody, RequestEnvelope.class);
        } catch (Exception ex) {
            throw new OrderServiceException('Request body deserialization failed.', ex);
        }
    }

    public static ResponseEnvelope createOrder(RequestEnvelope request) {
        validateRequest(request);

        OrderBuilder builder = new OrderBuilder(request);
        Opportunity orderRecord = builder.build();

        try {
            insert orderRecord;
        } catch (Exception ex) {
            throw new OrderServiceException('Failed to create order record.', ex);
        }

        return new ResponseEnvelope(orderRecord.Id, 'CREATED');
    }

    private static void validateRequest(RequestEnvelope request) {
        if (request == null) {
            throw new OrderServiceException('Request cannot be null.');
        }
        if (String.isBlank(request.orderName)) {
            throw new OrderServiceException('orderName is required.');
        }
        if (String.isBlank(request.productCode)) {
            throw new OrderServiceException('productCode is required.');
        }
    }

    public class RequestEnvelope {
        public String accountId;
        public String orderName;
        public String productCode;
        public Date closeDate;
    }

    public class ResponseEnvelope {
        public String orderId;
        public String status;

        public ResponseEnvelope(String orderId, String status) {
            this.orderId = orderId;
            this.status = status;
        }
    }

    public class OrderServiceException extends Exception {
    }
}
