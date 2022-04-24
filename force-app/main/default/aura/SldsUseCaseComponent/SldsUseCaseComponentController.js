({
    //Preparing MAP in JS Controller
	doCreateMap : function(component, event, helper) 
    {
        var mapArray=[];
        for(var i=1; i<11; i++)
        {
            mapArray.push
            ({
                key:i, value:'Test'+i   
            });    
        }
		component.set('v.mapVar', mapArray);
	}
})