global class mappingWrapper
{
	public String mobile_number;	//7084615451
	public String name;	//Sanchit
	public String Status;	//2021-05-14T20:22:46.988+05:30
	public String email;	//nil
	public Integer locations;	//b
	public boolean Need_Intel;
    
	public cls_companies[] companies;
	public cls_subscriptions[] subscriptions;
	public cls_Contacts[] Contacts;
    
	global class cls_companies {
		public String role_type;	//partner
		public String name;	//Ghanshyam enterprises
		public String gst_number;	//nil
		public String industry_type;	//construction
		//public cls_address address;
	}
    
	global class cls_subscriptions {
		public String subscription_type;	//silver
		public date expired_at;	//2021-05-14
		public String amount;	//0.471e3
        public String StageName;
	}
	
	global class cls_Contacts {
		public String FName;	
		public String LName;	
		public String Job_Title;	
        public string mailing_street;
        public string mobile_Number;
        public datetime date_Time;
	}
	global static mappingWrapper parse(String json){
		return (mappingWrapper) System.JSON.deserialize(json, mappingWrapper.class);
	}

}