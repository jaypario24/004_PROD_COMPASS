@isTest
public class TestTextFieldReplacer {

    @isTest
    static void testReplaceFieldReferences() {
        // Step 1: Create a test lead record
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Acme Inc.',
            Email = 'john.doe@acme.com'
        );
        insert testLead;

        // Step 2: Prepare the text with field references
        String inputText = 'Lead Name: {!FirstName} {!LastName}, Company: {!Company}, Email: {!Email}';

        // Step 3: Create a request for the invocable action
        TextFieldReplacer.Request request = new TextFieldReplacer.Request();
        request.text = inputText;
        request.objectApiName = 'Lead';
        request.recordId = testLead.Id;

        // Step 4: Call the invocable method
        List<TextFieldReplacer.Request> requests = new List<TextFieldReplacer.Request>{request};
        List<String> results = TextFieldReplacer.replaceFieldReferences(requests);

        // Step 5: Verify the results
        System.assertEquals(1, results.size());
        String expectedOutput = 'Lead Name: John Doe, Company: Acme Inc., Email: john.doe@acme.com';
        System.assertEquals(expectedOutput, results[0]);
    }
}