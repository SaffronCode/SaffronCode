package restDoaService
{
	import flash.events.Event;
	

	public class RestDoaEvent extends Event
	{
		/**Server connection error*/
		public static const	CONNECTION_ERROR:String = "CONNECTION_ERROR" ;
		
		/**Server error dispatches*/
		public static const	SERVER_ERROR:String = "SERVER_ERROR" ;
		
		/**Server connection error*/
		public static const SERVER_RESULT:String = "SERVER_RESULT" ;
		
		/**Server connection error*/
		public static const SERVER_RESULT_UPDATE:String = "SERVER_RESULT_UPDATE" ;
		
		/**Look for error codes on ErrorEnum class.
		<br>
		noError:int = 0 ;
		<br>
		SignInFailed:int = 1 ;
		<br>
		MemberIsDisabled:int = 2 ;
		<br>
		UserIsNotAuthorized:int = 3 ;
		<br>
		UserIsNotAuthenticated:int = 4 ;
		<br>
		PasswordIsNotConfirmedCorrectly:int = 5 ;
		<br>
		CurrentPasswordIsWrong:int = 6 ;
		<br>
		RequiredFieldsIsEmpty:int = 7 ;
		<br>
		UsernameIsDuplicated:int = 8 ;
		<br>
		DeviceIsNotAuthenticated:int = 9 ;
		<br>
		EmailIsNotValid:int = 10 ;
		<br>
		MobileIsNotValid:int = 11 ;*/
		public var errorCode:int ;
		public static var SERVER_RESULT_puInquiry_fun:String;
		
		public function RestDoaEvent(type:String,ErrorCode:int=ErrorEnum.noError)
		{
			errorCode = ErrorCode ;
			super(type,false);
		}
		
		override public function clone():Event
		{
			return new RestDoaEvent(type,errorCode);
		}
	}
}