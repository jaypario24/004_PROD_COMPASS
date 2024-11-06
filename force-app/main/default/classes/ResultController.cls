public with sharing class ResultController {
    @AuraEnabled(cacheable=true)
    public static List<Result__c> getResults(Id caseId) {
        return [
            SELECT Id, E2__c, LH__c, P4__c, HCG__c
            FROM Result__c
            WHERE Cycle__c = :caseId AND Result_Type__c IN ('Blood Test Result', 'Pregnancy Test Result', 'Where in Cycle Blood')
            ORDER BY Collected__c DESC
            LIMIT 2
        ];
    }
}