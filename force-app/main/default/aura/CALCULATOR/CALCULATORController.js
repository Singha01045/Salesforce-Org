({
    
	doAdd : function(component, event, helper) 
    {
        
        /*=============== 3 METHODS to find out the values from the Input Components through JS ===============
        ************FOR GETTING THE VALUES FROM THE INPUT, USE get**************
		var fnumber = component.find("fnum").get("v.value");
        var snumber = component.find("snum").get("v.value");
        var res = component.find("Result");
        res.set("v.value", fnumber+snumber);
        
        //FOR GETTING THE VALUES FROM THE ATTRIBUTE
		var fnum = component.get("v.fnumber");
        var snum = component.get("v.snumber");
        
        ######set method requires 2 params=> key:attribute  value:that we want to set in that attribute##########
        component.set("v.result", fnum+snum);*/
        
        //*********** FOR GETTING VALUES FROM APEX METHOD ***********
        alert(component.isValid());
        alert(component.getName());
        var fnum = component.get("v.fnumber");
        var snum = component.get("v.snumber");
        var act = component.get("c.calculateSum");
        act.setParams({"fn":fnum, "sn":snum});    //JSON Format to pass the parameters in APEX Mthd
        act.setCallback(this, function(response)     //a method that is called after the request has been completed from the server/Apex Method
                           {
                               var state= response.getState();    //gets the current state of the Action
                               if(state==="SUCCESS")
                               {
                                   component.set("v.result", response.getReturnValue());   //Returns the value of the action/server/Apex Method
                               }
                           });
        $A.enqueueAction(act); //Sending the action to the Server
	},
    doSub : function(component, event, helper) 
    {
        var fnum = component.get("v.fnumber");
        var snum = component.get("v.snumber");     
        component.set("v.result", fnum-snum);
    },
    doMul : function(component, event, helper) 
    {
        var fnumber = component.get("v.fnumber");
        var snumber = component.get("v.snumber");     
        component.set("v.result", fnumber*snumber);
    },
    doDiv : function(component, event, helper) 
    {
        var fnumber = component.get("v.fnumber");
        var snumber = component.get("v.snumber");     
        component.set("v.result", fnumber/snumber);
    }
    
})