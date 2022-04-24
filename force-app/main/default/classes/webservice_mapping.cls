@RestResource(urlMapping='/createRecord/*')
global class webservice_mapping 
{
    @httpPost         
    global static RestApexResponseWrapper.ReponseWrapper recordAccountCreate()
    {
        system.debug('RecordRequestList:: ' + RestContext.request.requestBody.tostring());
        RestApexResponseWrapper.ReponseWrapper response = new RestApexResponseWrapper.ReponseWrapper();
        mappingWrapper recInfoWrap = mappingWrapper.parse(RestContext.request.requestBody.tostring());
        
        system.debug('recInfoWrap:: '+recInfoWrap);
        system.debug('recInfoWrap Phone :: '+recInfoWrap.mobile_number);
        
        list<Account> accListToBeInserted = new list<Account>();
        list<Opportunity> oppListToBeInserted = new list<Opportunity>();
        list<Contact> conListToBeInserted = new list<Contact>();
        list<Account> companyListToBeInserted = new list<Account>();
        
        Account accRec = new Account();
        accRec.Name = recInfoWrap.name;
        accRec.Phone = recInfoWrap.mobile_number;
        accRec.Email__c= recInfoWrap.email;
        accRec.No_of_Locations__c = recInfoWrap.locations;
        accRec.Need_Intel__c = recInfoWrap.Need_Intel;
        accListToBeInserted.add(accRec);
           
        if(recInfoWrap.companies != null && !recInfoWrap.companies.isEmpty()){
            for(mappingWrapper.cls_companies compRecDetails: recInfoWrap.companies)
            {
                Account compRec = new Account();
                compRec.Name = compRecDetails.name;
                compRec.Industry = compRecDetails.industry_type;
                compRec.AccountNumber = compRecDetails.gst_number;
                compRec.Type = compRecDetails.role_type;
                companyListToBeInserted.add(compRec);
            }
        }
        
        if(recInfoWrap.subscriptions != null && !recInfoWrap.subscriptions.isEmpty()){
            for(mappingWrapper.cls_subscriptions oppRecDetails: recInfoWrap.subscriptions)
            {
                opportunity oppRec = new opportunity();
                oppRec.Name = oppRecDetails.subscription_type + ' Opportunity';
                oppRec.Amount = Decimal.valueOf(oppRecDetails.amount);
                oppRec.StageName = oppRecDetails.StageName;
                oppRec.CloseDate = oppRecDetails.expired_at;
                oppListToBeInserted.add(oppRec);
            }
        }
        
        if(recInfoWrap.Contacts != null && !recInfoWrap.Contacts.isEmpty()){
            for(mappingWrapper.cls_Contacts conRecDetails: recInfoWrap.Contacts)
            {
                Contact conRec = new Contact();
                conRec.FirstName = conRecDetails.FName;
                conRec.LastName = conRecDetails.LName;
                conRec.Job_Title__c = conRecDetails.Job_Title;
                conRec.MailingStreet = conRecDetails.mailing_street;
                conRec.Phone = conRecDetails.mobile_Number;
                conRec.Date_Time__c = conRecDetails.date_Time;
                conListToBeInserted.add(conRec);
            }
        }
        
        if(!accListToBeInserted.isEmpty())
        {
            Database.SaveResult[] accountResult = database.insert(accListToBeInserted, false);
            response.success_account_list = new list<Account>();
            response.failed_account_list = new list<RestApexResponseWrapper.failure_account>();
            
            for(Integer index =0; index < accountResult.size(); index++)
            {
                if(accountResult[index].isSuccess())
                { 
                    response.success_account_list.add(accListToBeInserted[index]);
                    
                    if(!oppListToBeInserted.isEmpty())
                    {
                        for(opportunity opp : oppListToBeInserted)
                        {
                            opp.AccountId = accListToBeInserted[index].id;
                        }
                        
                        Database.SaveResult[] OppResult = database.insert(oppListToBeInserted, false);
                        response.success_opportunity_list = new list<Opportunity>();
                        response.failed_subscription_list = new list<RestApexResponseWrapper.failure_subscription>();
                        
                        for(integer i =0; i<OppResult.size();i++)
                        {
                            if(OppResult[i].isSuccess())
                            {
                                response.success_opportunity_list.add(oppListToBeInserted[i]);
                            }
                            else
                            {
                                for(Database.Error err : OppResult[i].getErrors())
                                {
                                    RestApexResponseWrapper.failure_subscription failedOpp = new RestApexResponseWrapper.failure_subscription();
                                    failedOpp.subscription_details = oppListToBeInserted[i];
                                    failedOpp.error_msg = err.getMessage();
                                    response.failed_subscription_list.add(failedOpp);
                                }
                            }
                        }
                    }
                    
                    if(!conListToBeInserted.isEmpty())
                    {
                        for(Contact con : conListToBeInserted)
                        {
                            con.AccountId = accListToBeInserted[index].id;
                        }
                        Database.SaveResult[] contactResult = database.insert(conListToBeInserted, false);
                        response.success_contact_list = new list<Contact>();
                        response.failed_contact_list = new list<RestApexResponseWrapper.failure_contact>();
                        for(integer i =0; i<contactResult.size();i++)
                        {
                            if(contactResult[i].isSuccess())
                            {
                                response.success_contact_list.add(conListToBeInserted[i]);
                            }
                            else
                            {
                                for(Database.Error err : contactResult[i].getErrors())
                                {
                                    RestApexResponseWrapper.failure_contact failedContact = new RestApexResponseWrapper.failure_contact();
                                    failedContact.contact_details=conListToBeInserted[i];
                                    failedContact.error_msg=err.getMessage();
                                    response.failed_contact_list.add(failedContact);
                                }
                            }
                        }
                    }
                    
                    if(!companyListToBeInserted.isEmpty())
                    {
                        for(Account comp : companyListToBeInserted)
                        {
                            comp.ParentId = accListToBeInserted[index].id;
                        }
                        Database.SaveResult[] companyResult = Database.insert(companyListToBeInserted, false);
                        response.success_companies_list = new list<Account>();
                        response.failed_comapanies_list = new list<RestApexResponseWrapper.failure_companies>();
                        for(integer i=0; i<companyResult.size(); i++)
                        {
                            if(companyResult[i].isSuccess())
                            {
                                response.success_companies_list.add(companyListToBeInserted[i]);
                            }
                            else
                            {
                                for(Database.Error err : companyResult[i].getErrors())
                                {
                                    RestApexResponseWrapper.failure_companies failedCompany= new RestApexResponseWrapper.failure_companies();
                                    failedCompany.company_details=companyListToBeInserted[i];
                                    failedCompany.error_msg=err.getMessage();
                                    response.failed_comapanies_list.add(failedCompany);
                                }
                            }
                        }
                    }
                }
                else
                {
                    for(Database.Error err : accountResult[index].getErrors())
                    {
                        RestApexResponseWrapper.failure_account failedAccount = new RestApexResponseWrapper.failure_account();
                        failedAccount.account_details=accListToBeInserted[index];
                        failedAccount.error_msg=err.getMessage();
                        response.failed_account_list.add(failedAccount);
                    }
                }
            } 
        }
        return response;
    }
}