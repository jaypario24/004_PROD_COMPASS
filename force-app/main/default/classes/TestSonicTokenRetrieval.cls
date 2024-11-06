@isTest
private class TestSonicTokenRetrieval {

    @isTest static void testGetAuthToken() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        SonicTokenRetrieval.AuthRequest request = new SonicTokenRetrieval.AuthRequest();
        request.username = 'testuser';
        request.password = 'testpass';
        request.grant_type = 'password';
        request.client_id = 'testclientid';
        request.client_secret = 'testclientsecret';

        List<SonicTokenRetrieval.AuthRequest> requests = new List<SonicTokenRetrieval.AuthRequest>{request};

        // Act
        Test.startTest();
        List<SonicTokenRetrieval.TokenResponse> responses = SonicTokenRetrieval.getAuthToken(requests);
        Test.stopTest();

        // Assert
        System.assertEquals(1, responses.size());
        SonicTokenRetrieval.TokenResponse response = responses[0];
        System.assertEquals('test_access_token', response.access_token);
        System.assertEquals('Bearer', response.token_type);
        System.assertNotEquals(null, response.expires_in);
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{' +
                '"access_token":"test_access_token",' +
                '"token_type":"Bearer",' +
                '"expires_in":3600,' +
                '"issued":"test_issued_date",' +
                '"expires":"test_expires_date"' +
            '}');
            return response;
        }
    }
}