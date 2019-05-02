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
		
		public static const INPUT_PASSWORD:String = "INPUT_PASSWORD" ;	
		
		public static const NEW_PASSWORD:String = "NEW_PASSSWORD";
		
		/**This is the request to open the loggin page*/
		public static const OPEN_LOGIN_PAGE:String = "OPEN_LOGIN_PAGE" ;
		
		/**Verify code is sent from server to user*/
		public static const VERIFY_CODE_SENT_FROM_SERVER:String = "VERIFY_CODE_SENT_FROM_SERVER" ;
		/**Verify code sending faild*/
		public static const VERIFY_CODE_FAILD:String = "VERIFY_CODE_FAILD" ;
		/**Verify code is accepted by server*/
		public static const VERIFY_CODE_ACCEPTED:String = "VERIFY_CODE_ACCEPTED" ;
		/**Verify code is not accepted by server*/
		public static const VERIFY_CODE_NOT_ACCEPTED:String = "VERIFY_CODE_NOT_ACCEPTED" ;
		
		public static const RECOVER_PASSWORD:String = "RECOVERY_PASSWORD";
		
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