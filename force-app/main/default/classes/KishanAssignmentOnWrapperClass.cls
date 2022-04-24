public class KishanAssignmentOnWrapperClass 
{
    public void callingMethod(String idAcc)
    {
        system.debug(calledMethod(idAcc));
    }
	 
    public wrapperClass calledMethod(String AccID)
    {
        wrapperClass wrap=new wrapperClass();  
        List<Contact> conList= new List<Contact>();
        conList=[SELECT FirstName, LastName FROM Contact WHERE AccountId=: AccID];
        wrap.myCon=conList;
        
        List<Opportunity> oppList= new List<Opportunity>();
        oppList=[SELECT Name, CloseDate FROM Opportunity WHERE AccountId=: AccID];
        wrap.myOpp=oppList;
        
        List<Case> caseList= new List<Case>();
        caseList=[SELECT ContactEmail, Status FROM Case WHERE AccountId=: AccID];
        wrap.myCase=caseList;
        
        return wrap;
    }

    public class wrapperClass
    {
        public List<Contact> myCon;
        public List<Opportunity> myOpp;
        public List<Case> myCase;
    }
}