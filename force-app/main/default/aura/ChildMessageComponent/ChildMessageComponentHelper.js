({
	showMessageHelper : function(component, event, severity) 
    {
		var msgs= event.getParam("arguments");
        var displayMessage='';
        if(msgs)
            displayMessage= msgs.message;
        
        var messagePanel= component.find("msgID");  //finding Aura ID of child component...
        $A.createComponents
        (
          [  
            [    
                "ui:message", {"title": severity.toUpperCase(), 'severity': severity, closable:'true'}
            ],
            [ 
              "ui:outputText", {'value':displayMessage }
            ]
          ],
          function(components, status, statusMessageList) 
          {
              if(status === "SUCCESS")
                {
                   var uiMessage = components[0];
                   var uiOutput = components[1];
                   uiMessage.set("v.body", uiOutput);
                   messagePanel.set("v.body", uiMessage);
                }
          }
       );
	},
    
    removeMessageHelper : function(component) 
    {
		var messagePanel= component.find("msgID");
        messagePanel.set("v.body", []);
	}
})