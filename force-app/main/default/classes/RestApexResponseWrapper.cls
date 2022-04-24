global with sharing class RestApexResponseWrapper 
{
    global class ReponseWrapper
    {
        global list<account> success_account_list;
        global list<account> success_companies_list;
        global list<opportunity> success_opportunity_list;
        global list<Contact> success_contact_list;
        
        global list<failure_contact> failed_contact_list;
        global list<failure_account> failed_account_list;
        global list<failure_companies> failed_comapanies_list;
        global list<failure_subscription> failed_subscription_list;
    }
 
    global class failure_account
    {
        global account account_details;
        global string error_msg;
    }
    
    global class failure_contact
    {
        global contact contact_details;
        global string error_msg;
    }
 
    global class failure_companies
    {
        global account company_details;
        global string error_msg;
    }
    global class failure_subscription
    {
        global opportunity subscription_details;
        global string error_msg;
    }
}