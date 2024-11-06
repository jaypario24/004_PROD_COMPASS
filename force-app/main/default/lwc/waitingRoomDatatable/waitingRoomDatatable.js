import { LightningElement } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class WaitingRoomDatatable extends LightningElement {
    channelName = '/event/Refresh_Waiting_Room_Components__e';
    subscription = {};

    connectedCallback() {
        // Register error listener
        onError(error => {
            console.error('EMP API error: ', error);
        });

        // Subscribe to platform event
        this.handleSubscribe();
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('New message received: ', response);
            this.handleFlowNavigation();
        };

        // Subscribe to the channel
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
            console.log('Subscribed to channel ', this.channelName);
        });
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribed from channel ', response);
        });
    }

    handleFlowNavigation() {
        // Optionally, navigate to the next screen in the flow
        const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent);
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }
}