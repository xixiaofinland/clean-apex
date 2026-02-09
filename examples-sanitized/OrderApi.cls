@RestResource(urlMapping='/api/v1/orders')
global with sharing class OrderApi {
    @HttpPost
    global static void postOrder() {
        RestResponse response = RestContext.response;
        Savepoint sp = Database.setSavepoint();

        try {
            String body = RestContext.request.requestBody.toString();
            OrderService.RequestEnvelope request = OrderService.parseRequest(body);
            OrderService.ResponseEnvelope result = OrderService.createOrder(request);

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
