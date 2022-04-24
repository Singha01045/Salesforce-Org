global class ActivityWrapper
{
    public cls_Activity[] Activity;
    global class cls_Activity 
    {
        public String activity_type;	//Test Registered
        public String search_by_value;	//Can-12345hqqdfdqjh12qr9
        public string exam_date;	//2018-03-29T13:34:00.000
        public String activity_note;	//Ashu tosh signed up on Thursday
        public String exam_name;	//Front End
        public String exam_slug;	//front end
        public String subject;	//Test Registered
        public String exam_score;	//34.90
        public decimal skill_based_exam_score;	//89
        public boolean is_qualified_in_exam;  //true
    }
	
	public static ActivityWrapper parse(String json){
		return (ActivityWrapper) System.JSON.deserialize(json, ActivityWrapper.class);
	}
}