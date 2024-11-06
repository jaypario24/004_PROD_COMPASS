import { LightningElement, wire, api, track } from 'lwc';
import getResults from '@salesforce/apex/ResultController.getResults';

export default class MyComponent extends LightningElement {
    @api recordId;
    @track results;
    @track advice;
    @track error; // Track an error variable
    @track lastResultId; // Track the Id of the last result
    @track secondLastResultId; // Track the Id of the second last result

    connectedCallback() {
        this.loadResults();
    }
    
    loadResults() {
        getResults({ caseId: this.recordId })
        .then(result => {
            this.results = result;
            this.evaluateResults();
        })
        .catch(error => {
            // Update the error variable with the error message
            this.error = error.body.message;
        });
    }

    evaluateResults() {
        let advice = '';
    
        // No results found
        if (!this.results || this.results.length === 0) {
            advice = 'This cycle does not have any results.';
        } 
        // Only one result and P4 is over 3.8
        else if (this.results.length === 1 && this.results[0].P4__c > 3.7) {
            advice = 'Ovulation has occurred.';
        }
        // Only one result and P4 is under 3.8
        else if (this.results.length === 1 && this.results[0].P4__c < 3.8) {
            advice = 'Ovulation has not yet occurred.';
        } 
        // More than one result, proceed as before
        else {
            const lastResult = this.results[0];
            const secondLastResult = this.results[1];
            this.lastResultId = lastResult.Id;
            this.secondLastResultId = secondLastResult.Id;

            const { E2__c: E2_current, LH__c: LH_current, P4__c: P4_current, HCG__c: HCG_current } = lastResult;
            const { E2__c: E2_previous, LH__c: LH_previous, P4__c: P4_previous, HCG__c: HCG_previous } = secondLastResult;
    
            if (HCG_current > 50) {
                advice = 'This patient is pregnant and should be referred back to doctors rooms.';
            } else if (HCG_current > 6) {
                advice = 'There is a high chance of pregnancy.';
            } else if (HCG_current < HCG_previous && HCG_previous > 6) {
                advice = 'This is likely a biochem pregnancy.';
            } else if (LH_current > LH_previous && E2_current > E2_previous && P4_current > 1.5 && P4_current < 5) {
                advice = 'Ovulation is likely occurring now, as there is an increase in both E2 and LH levels and a slight rise in P4. Please advise the patient to have intercourse.';
            } else if (LH_current > LH_previous && E2_current > E2_previous && P4_current < 1.5) {
                advice = 'Ovulation is likely to occur soon, as there is an increase in both E2 and LH levels. Please advise the patient to have intercourse.';
            } else if (P4_current > P4_previous) {
                advice = 'Ovulation has likely occurred, as P4 levels have increased.';
            } else {
                advice = 'The current hormone levels do not clearly indicate ovulation or pregnancy. This should be referred to the doctor for advice.';
            }
        }
    
        this.advice = advice;
    }
}