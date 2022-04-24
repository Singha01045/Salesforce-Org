global class LeadRecordInfo 
{
    public String FirstName;
    public String LastName;
    public String EmailAddress;
    public String Phone;
    public string Company;
    public String mx_Class_Course;
    public String mx_State;
    public String mx_School_Name;
    public String mx_Syllabus;
    public String mx_Student_Type;
    public String mx_Exam_Type;
    public String SourceCampaign;
    public String mx_RegistrationJoinUs;
    public String mx_RegistrationDemo;
    public String mx_RegistrationHAT;
    public String mx_RegistrationGKGM;
    public String mx_RegistrationMock;
    
    global static LeadRecordInfo parse(String json) 
    {
        return (LeadRecordInfo) System.JSON.deserialize(json, LeadRecordInfo.class);
    }
    
}