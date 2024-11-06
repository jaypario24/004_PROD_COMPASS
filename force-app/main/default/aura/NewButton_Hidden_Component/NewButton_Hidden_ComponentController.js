({

    closeModel: function(component, event, helper) {

        var navEvent = $A.get("e.force:navigateToList");

        navEvent.setParams({

            "listViewName": null,

            "scope": "Options__c"

        });

        navEvent.fire();

    },

})