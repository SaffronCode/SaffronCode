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