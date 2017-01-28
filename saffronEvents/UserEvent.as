package saffronEvents
{
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		/**User is logged in*/
		public static const LOGGED_IN:String = "LOGGED_IN" ;
		
		/**User is logged out*/
		public static const LOGGED_OUT:String = "LOGGED_OUT" ;
		
		/**User profile is updated*/
		public static const PROFILE_UPDATED:String = "PROFILE_UPDATED" ;
		
		/**User information is not correct to make him loggin*/
		public static const LOGIN_FAILD:String = "LOGIN_FAILD" ;
		
		/**Register done*/
		public static const REGISTER_COMPLETED:String = "REGISTER_COMPLETED" ;
		
		/**Register faild*/
		public static const REGISTER_FAILD:String = "REGISTER_FAILD" ;
		
		/**User updatet to the server*/
		public static const USER_UPDATED:String  = "USER_UPDATED" ;
		/**User update fails*/
		public static const USER_UPDAT_FAILS:String  = "USER_UPDAT_FAILS" ;
		
		/**Password changed*/
		public static const PASSWORD_CHAGNED:String = "PASSWORD_CHAGNED" ;
		/**Password changing error*/
		public static const PASSWORD_ERROR:String = "PASSWORD_ERROR" ;
		
		/**0: no error*/
		public var errorCode:int ;
		
		/**You can pass any error string on this parameter*/
		public var errorText:String ;
		
		public function UserEvent(type:String,ErrorCode:int=0,ErrorText:String='')
		{
			super(type);
			errorCode = ErrorCode ;
			errorText = ErrorText ;
		}
	}
}