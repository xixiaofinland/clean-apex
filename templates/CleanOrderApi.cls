/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderApi
 * Layer: entry-point
 * Purpose: REST API endpoint for order creation
 * Usage Pattern: REST
 * Dependencies: CleanOrderService
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrder" with your entity name
 * 2. Update urlMapping to match your API path
 * 3. Add additional HTTP methods (@HttpGet, @HttpPut, etc.) as needed
 * 4. Delegate all business logic to Service layer
 * 5. Keep error handling in entry-point (try/catch with rollback)
 * 6. Remove this header once customized
 */
@RestResource(urlMapping='/api/v1/orders')
global with sharing class CleanOrderApi {
    @HttpPost
    global static void postOrder() {
        RestResponse response = RestContext.response;
        Savepoint sp = Database.setSavepoint();

        try {
            String body = RestContext.request.requestBody.toString();
            CleanOrderService.RequestEnvelope request = CleanOrderService.parseRequest(body);
            CleanOrderService.ResponseEnvelope result = CleanOrderService.createOrder(request);

            response.addHeader('Content-Type', 'application/json;charset=UTF-8');
            response.responseBody = Blob.valueOf(JSON.serialize(result));
            response.statusCode = 201;
        } catch (Exception ex) {
            Database.rollback(sp);
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(
                JSON.serialize(new Map<String, String>{ 'error' => ex.getMessage() })
            );
        }
    }
}
