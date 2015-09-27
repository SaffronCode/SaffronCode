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
		
		/**0: no error*/
		public var errorCode:int ;
		
		public function UserEvent(type:String,ErrorCode:int=0)
		{
			super(type);
			errorCode = ErrorCode ;
		}
	}
}