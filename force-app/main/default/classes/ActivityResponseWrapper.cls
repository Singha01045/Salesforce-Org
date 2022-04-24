global class ActivityResponseWrapper 
{
    global class ReponseWrapper
    {
        global list<task> success_activity_list;
        global list<failure_activity_cls> failed_activity_list;
    }
    
    global  class failure_activity_cls
    {
        global ActivityWrapper.cls_Activity failure_activity_details;
        global string error_msg;
    }
    
}