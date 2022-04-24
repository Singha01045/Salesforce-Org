({
	doInit : function(component, event, helper) 
    {
		component.set("v.myColumns", [
			{label : 'SNo' , fieldName : 'sno' , type : 'number'},
			{label : 'Name of Source' , fieldName : 'source' , type : 'text'},
			{label : 'Amount' , fieldName : 'amount', type : 'number'}
		]);
        component.set('v.incomes', [
          {
            sno: 1,
            source: 'Regular Job',
            amount: 10000
          },
          {
            sno: 2,
            source: 'Part Time Job',
            amount: 2000
          }
        ]);
	},
    handleOwnEvent: function(component, event, helper)
    {
      alert('Event is handled and fired by Source/Child Component'); 
      //event.stopPropagation();
    },
    toggleIncomeForm:function(component, event, helper)
    {
        var inForm=component.find('incomeForm');
        $A.util.toggleClass(inForm, 'hide');
    },
    addIncome:function(component, event, helper)
    {
        var incomes=component.get('v.incomes');
        var newIncome={
            sno:incomes.length+1,
            source:component.find('source').get('v.value'),
            amount:parseFloat(component.find('amount').get('v.value'))
        }
        if(newIncome.source!='' && newIncome.amount!='' && newIncome.source!=null && newIncome.amount!=null)
        {
            incomes.push(newIncome);
            component.set('v.incomes', incomes);
            component.find('source').set('v.value','');
            component.find('amount').set('v.value','');
        }
    },
    fireOwnEvent:function(component, event, helper)     //the event is captured by the Child Component itself...
    {
        var incomes=component.get('v.incomes');
        var totalIncomes=0;
        for(var i=0; i<incomes.length;i++)
        {
            totalIncomes +=incomes[i].amount;
        }
        //alert('Total Income is: ' +totalIncomes);
        var totalIncomeComponentEventz= component.getEvent('totalIncomeComponentEvent');
        totalIncomeComponentEventz.setParams({
            "totalIncome": totalIncomes
        })
        totalIncomeComponentEventz.fire();
    }
})