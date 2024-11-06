({
    doInit : function(component, event, helper) {
       component.set('v.isOpen', true);
       var flow = component.find('flow');
       flow.startFlow('Create_New_Semen_Sample');
    },

    closeFlowModal : function(component, event, helper) {
        component.set("v.isOpen", false);
        
        //redirect to Account Home
        /*var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
        "scope": "Lead"
        });
        homeEvent.fire();*/
        
        var eUrl = $A.get("e.force:navigateToURL");
        var u;
        
        if(event.getParam("status") === "FINISHED"){
            let url;
            let outputVar;
            const output = event.getParam("outputVariables");
            console.log(output);
            for(var i = 0; i < output.length; i++) {
                outputVar = output[i];
                console.log(outputVar);
                if(outputVar.name === "var_redirect_url"){
                    if(outputVar.value != null){
                        url = outputVar.value;
                        var n = url.lastIndexOf("/lightning/");
                             u = url.substr(n,url.length);
                        console.log(u);
                    }
                }
                  
            }
            if(u != null){
                eUrl.setParams({
                "url": u
                });
                eUrl.fire();
                //dismissActionPanel.fire();
            }
        }
    },
    
    closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isOpen", false);
            
            //redirect to Lead Home
            /*var homeEvent = $A.get("e.force:navigateToObjectHome");
            homeEvent.setParams({
                "scope": "Lead"
            });
            homeEvent.fire();*/
            
            var eUrl = $A.get("e.force:navigateToURL");
            var u;
            
            let url;
            let outputVar;
            const output = event.getParam("outputVariables");
            console.log(output);
            for(var i = 0; i < output.length; i++) {
                outputVar = output[i];
                console.log(outputVar);
                if(outputVar.name === "var_redirect_url"){
                    if(outputVar.value != null){
                        url = outputVar.value;
                        var n = url.lastIndexOf("/lightning/");
                        u = url.substr(n,url.length);
                        console.log(u);
                    }
                }
                
            }
            if(u != null){
                eUrl.setParams({
                    "url": u
                });
                eUrl.fire();
                //dismissActionPanel.fire();
            }
        }
    }
})