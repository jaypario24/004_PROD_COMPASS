import { LightningElement, api, wire, track } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class PicklistButtons extends LightningElement {
    @api objectName;
    @api picklistField;
    @api columnLayout;
    @track picklistOptions = [];
    @track selectedValue;
    @track error;
    @track objectInfo;

    @wire(getObjectInfo, { objectApiName: '$objectName' })
    objectInfo({ error, data }) {
        if (error) {
            this.error = 'Failed to retrieve object info: ' + error;
        } else if (data) {
            this.objectInfo = data;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.defaultRecordTypeId',
        fieldApiName: '$constructedFieldApiName'
    })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.picklistOptions = data.values.map(item => ({
                label: item.label,
                value: item.value,
                icon: 'utility:check'  // Placeholder for icon, adjust as necessary
            }));
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.picklistOptions = [];  // Clear on error to provide visual feedback
        }
    }

    get constructedFieldApiName() {
        return this.objectName ? `${this.objectName}.${this.picklistField}` : '';
    }

    handleButtonClick(event) {
        this.selectedValue = event.target.value;
        // Send value back to Flow
        const valueChangeEvent = new CustomEvent('valuechange', {
            detail: { value: this.selectedValue }
        });
        this.dispatchEvent(valueChangeEvent);
    }    

    get isTwoColumn() {
        return this.columnLayout === 'Two Columns';
    }

    get containerClass() {
        return this.columnLayout === 'Two Columns' ? 'two-columns' : 'one-column';
    }
    
}