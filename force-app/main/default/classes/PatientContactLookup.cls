public without sharing class PatientContactLookup {

    public class PatientContactWrapper {
        @InvocableVariable
        public String Id;
        @InvocableVariable
        public String FirstName;
        @InvocableVariable
        public String LastName;
        @InvocableVariable
        public String Email;
    }

    public class Input {
        @InvocableVariable(required=true)
        public String firstName;
        @InvocableVariable(required=true)
        public String lastName;
    }

    @InvocableMethod(label='Get Contact by Name' description='Returns the first contact based on first and last name')
    public static List<PatientContactWrapper> getContactByName(List<Input> inputList) {
        List<PatientContactWrapper> results = new List<PatientContactWrapper>();
        
        if (!inputList.isEmpty()) {
            Input input = inputList[0];
            
            List<Contact> contacts = [
                SELECT Id, First_Name__c, Last_Name__c, Email 
                FROM Contact 
                WHERE First_Name__c = :input.firstName AND Last_Name__c = :input.lastName 
                LIMIT 1
            ];

            if (!contacts.isEmpty()) {
                Contact contact = contacts[0];
                PatientContactWrapper pcw = new PatientContactWrapper();
                pcw.Id = contact.Id;
                pcw.FirstName = contact.First_Name__c;
                pcw.LastName = contact.Last_Name__c;
                pcw.Email = contact.Email;
                results.add(pcw);
            }
        }

        return results;
    }
}