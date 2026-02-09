/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderService
 * Layer: service
 * Purpose: Business logic orchestration and DML operations for order management
 * Usage Pattern: Service
 * Dependencies: CleanOrderBuilder (OO)
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Add public static methods for business operations
 * 3. Perform all DML operations in this layer (insert, update, delete)
 * 4. Throw custom exceptions for business rule violations
 * 5. Keep methods static for simplicity
 * 6. Remove this header once customized
 */
public with sharing class CleanOrderService {
    public static RequestEnvelope parseRequest(String requestBody) {
        try {
            return (RequestEnvelope) JSON.deserialize(requestBody, RequestEnvelope.class);
        } catch (Exception ex) {
            throw new CleanOrderServiceException('Request body deserialization failed.', ex);
        }
    }

    public static ResponseEnvelope createOrder(RequestEnvelope request) {
        validateRequest(request);

        CleanOrderBuilder builder = new CleanOrderBuilder(request);
        Opportunity orderRecord = builder.build();

        try {
            insert orderRecord;
        } catch (Exception ex) {
            throw new CleanOrderServiceException('Failed to create order record.', ex);
        }

        return new ResponseEnvelope(orderRecord.Id, 'CREATED');
    }

    private static void validateRequest(RequestEnvelope request) {
        if (request == null) {
            throw new CleanOrderServiceException('Request cannot be null.');
        }
        if (String.isBlank(request.orderName)) {
            throw new CleanOrderServiceException('orderName is required.');
        }
        if (String.isBlank(request.productCode)) {
            throw new CleanOrderServiceException('productCode is required.');
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

    public class CleanOrderServiceException extends Exception {
    }
}
