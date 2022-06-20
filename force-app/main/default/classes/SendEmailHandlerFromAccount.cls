public class SendEmailHandlerFromAccount {
    
    @AuraEnabled
    public static string processEmail(String email, String Subject, String Message, list<String> DepartmemberList){
        String sMessage='';
        try{
            
            //List<Department_Member__c> EmailMemberList = [Select Contact_Email__c From Department_Member__c Where Contact_First_Name__c LIKE Name];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {email}; 
            toAddresses.addAll(DepartmemberList);
            mail.setToAddresses(toAddresses);
            
            mail.setSubject(Subject);
            String htmlBody = Message;
            mail.setHtmlBody(htmlBody);
            Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            sMessage='Success';
            
        }
        catch(Exception ex){
            sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString();
        }
        return sMessage;
    }
    @auraEnabled
    public static emailAndEmailTemp fetchAccountDetails(Id AccId){
        try{
            emailAndEmailTemp wrap;
            string emailId;
            List<String> templateNames = new List<String>();
            List<Email_template_Name__c> emailTemplateName = new List<Email_template_Name__c>();
            List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
            List<Account> accList = New List<Account>();
            List<Department__c> DepartWithMemberList = [Select id, Name,
                                                        (Select id, Contact__c, Contact_Email__c, Contact_First_Name__c, Contact_Last_Name__c, Department__c From Department_Members__r) 
                                                        From Department__c];
            List<Department__c> DepartmentListOnly = new List<Department__c>();
            List<Department_Member__c> DepartmentMemberListOnly = new List<Department_Member__c>();
            
            if(!DepartWithMemberList.isEmpty()){
                for(Department__c DWML : DepartWithMemberList){
                    DepartmentListOnly.add(DWML);
                    for(Department_Member__c DMs : DWML.Department_Members__r)
                        DepartmentMemberListOnly.add(DMs);
                }
            }
            
            String userEmailId = UserInfo.getUserEmail();
            if(!string.isBlank(AccId)){
                accList = [Select id,Name, Dealer_Distributor__r.Email__c, Owner.email From Account Where id =: AccId limit 1];
                //emailId = accList[0].Dealer_Distributor__r.Email__c;
                //emailId = [Select FirstName, LastName, Email from Contact where id =: oppList[0].Primary_Contact__c].email;
                
            }
            if(accList[0].Dealer_Distributor__r.Email__c != NUll){
                emailId = accList[0].Dealer_Distributor__r.Email__c;
            }
            else if(accList[0].Dealer_Distributor__r.Email__c == NUll){
                emailId = accList[0].Owner.email;
            }
            
            /*emailTemplateName = [select Template_Name__c From Email_template_Name__c];
            
            if(!emailTemplateName.isEmpty()){
                for(Email_template_Name__c tempName : emailTemplateName){
                    templateNames.add(tempName.Template_Name__c);
                }  
                if(!templateNames.isEmpty()){
                    emailTemplates = [SELECT Body,Description,DeveloperName,HtmlValue,Name,Subject FROM EmailTemplate WHERE Name in : templateNames];
                    
                }
            }*/
            
            Schema.SObjectType sObjName = AccId.getsobjecttype();
            string foldername = String.valueOf(sObjName);
            emailTemplates = [SELECT Body,Description,DeveloperName,HtmlValue,Name,Subject FROM EmailTemplate WHERE Folder.Name =: foldername];
            
            List<EmailTemplate> UpdatedEmailTemplates = new List<EmailTemplate>();
            
            for(EmailTemplate EmTemp : emailTemplates){
                EmailTemplate UpdatedemailTemp = new EmailTemplate();
                String updatedEmailTempBody = DynamicEmailTempBody.ParseDynamicEmailTempBody(EmTemp.Body, AccId);
                UpdatedemailTemp.Body = updatedEmailTempBody;
                String updatedSubject = DynamicEmailTempBody.ParseDynamicEmailTempBody(EmTemp.Subject, AccId);
                UpdatedemailTemp.Subject = updatedSubject;
                UpdatedemailTemp.Name = EmTemp.Name;
                UpdatedemailTemp.Description = EmTemp.Description;
                UpdatedemailTemp.DeveloperName = EmTemp.DeveloperName;
                UpdatedemailTemp.HtmlValue = EmTemp.HtmlValue;
                UpdatedEmailTemplates.add(UpdatedemailTemp);
            }
            
            system.debug('UpdatedEmailTemplates ::' + UpdatedEmailTemplates);
                wrap = new emailAndEmailTemp(emailId, UpdatedEmailTemplates, templateNames, accList[0], DepartmentListOnly, DepartmentMemberListOnly);
                  
            return wrap;
        }
        catch(Exception ex){
            system.debug(ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString());
            return null;
        }
        
    }
    
    public class emailAndEmailTemp{
        @auraEnabled
        public String Email;
        @auraEnabled 
        public List<EmailTemplate> emailTemplateList;
        @auraEnabled
        public List<String> emailTemplateName;
        @auraEnabled
        public Account AccRec;
        @auraEnabled
        public List<Department__c> DepartDetails;
        @auraEnabled
        public List<Department_Member__c> DepartMemberdetails;
        
        public emailAndEmailTemp(String Email, List<EmailTemplate> emailTemplateList,List<String> emailTemplateName, Account AccRec, List<Department__c> DepartDetails, List<Department_Member__c> DepartMemberdetails){
            this.Email = Email;
            this.emailTemplateList = emailTemplateList;
            this.emailTemplateName = emailTemplateName;
            this.AccRec = AccRec;
            this.DepartDetails = DepartDetails;
            this.DepartMemberdetails = DepartMemberdetails;
        }
        
    }

}