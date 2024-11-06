public class TextFieldReplacer {

    @InvocableMethod
    public static List<String> replaceFieldReferences(List<Request> requests) {
        List<String> results = new List<String>();
        
        for (Request req : requests) {
            String updatedText = req.text;

            // Get the SObjectType from the objectApiName (e.g., 'Lead')
            SObjectType objType = Schema.getGlobalDescribe().get(req.objectApiName);
            if (objType == null) {
                // If the object type is invalid, skip or throw an error
                continue;
            }
            
            // Dynamically query the record by ID and fields
            String query = 'SELECT ' + getFields(updatedText) + ' FROM ' + req.objectApiName + ' WHERE Id = :recordId LIMIT 1';
            SObject record = Database.query(query.replace(':recordId', '\'' + req.recordId + '\''));
            
            // Find field references in the format {!Field_API_Name}
            Matcher m = Pattern.compile('\\{!([\\w\\.]+)\\}').matcher(updatedText);
            while (m.find()) {
                String fieldApiName = m.group(1);
                Object fieldValue = record.get(fieldApiName);
                
                // If the field value is null, replace it with an empty string or some default value
                if (fieldValue == null) {
                    updatedText = updatedText.replace(m.group(0), '');
                } else {
                    updatedText = updatedText.replace(m.group(0), String.valueOf(fieldValue));
                }
            }
            results.add(updatedText);
        }
        return results;
    }

    // Utility method to extract the field API names for querying
    private static String getFields(String text) {
        Set<String> fields = new Set<String>();
        Matcher m = Pattern.compile('\\{!([\\w\\.]+)\\}').matcher(text);
        while (m.find()) {
            fields.add(m.group(1));
        }
        return String.join(fields, ',');
    }

    public class Request {
        @InvocableVariable
        public String text;

        @InvocableVariable
        public String objectApiName;

        @InvocableVariable
        public Id recordId;
    }
}