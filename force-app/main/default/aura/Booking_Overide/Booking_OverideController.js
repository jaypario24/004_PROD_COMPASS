({
    init: function(component, event, helper) {
        console.log('Init called');
        var flow = component.find("flowData");
        flow.startFlow("Book_Interview_From_Calendar");
    }
})