public class SonicTokenRetrieval {

    public class AuthRequest {
        @InvocableVariable(label='Username')
        public String username;

        @InvocableVariable(label='Password')
        public String password;

        @InvocableVariable(label='Grant Type')
        public String grant_type;

        @InvocableVariable(label='Client ID')
        public String client_id;

        @InvocableVariable(label='Client Secret')
        public String client_secret;
    }

    public class TokenResponse {
        @InvocableVariable
        public String access_token;

        @InvocableVariable
        public String token_type;

        @InvocableVariable
        public Integer expires_in;

        @InvocableVariable
        public String issued;

        @InvocableVariable
        public String expires;
    }

    @InvocableMethod(label='Get Authentication Token' description='Retrieves the authentication token from the Pathology API')
    public static List<TokenResponse> getAuthToken(List<AuthRequest> requests) {
        AuthRequest request = requests[0];
        
        Map<String, String> requestBody = new Map<String, String>{
            'username' => request.username,
            'password' => request.password,
            'grant_type' => request.grant_type,
            'client_id' => request.client_id,
            'client_secret' => request.client_secret
        };
        
        String endpoint = 'https://fetchapi-r1.uat.sonichealthcare.com/ET/api/account/token';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(requestBody));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            TokenResponse tokenResponse = new TokenResponse();
            tokenResponse.access_token = (String)responseMap.get('access_token');
            tokenResponse.token_type = (String)responseMap.get('token_type');
            tokenResponse.expires_in = Integer.valueOf(responseMap.get('expires_in'));
            tokenResponse.issued = (String)responseMap.get('issued');
            tokenResponse.expires = (String)responseMap.get('expires');

            return new List<TokenResponse>{ tokenResponse };
        } else {
            return new List<TokenResponse>{ new TokenResponse() };
        }
    }
}