package restDoaService
	//restDoaService.RestDoaEvent
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
		
		/**The web service result was update, no need to change the result*/
		public static const SERVER_WAS_UPDATED:String = "SERVER_WAS_UPDATED" ;

		public static const SERVER_UNAUTHORIZED:String = "SERVER_UNAUTHORIZED" ;
		
		
		public static const TITLE_ERROR:String = "TITLE_ERROR";
		
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
		MobileIsNotValid:int = 11 ;<br><br>
		 <br><br> 200:Ok<br>
		 * 404:NotFound<br>
		 * 400:Bad Request<br>
		 * 401:Unautorized<br>
		 * 502:Connection Failed<br>
		 * For read full list, please visit <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes">https://en.wikipedia.org/wiki/List_of_HTTP_status_codes</a>*/
		public var errorCode:int,
					isConnect:Boolean,
					getRequestedData:Object,
					resultData:Object;
		//public static var SERVER_RESULT_puInquiry_fun:String;
		
		/***ErrorEnum.noError**/
		public function RestDoaEvent(type:String,ErrorCode:int=0,isConnected:Boolean=true,RequestData:Object=null,ResultData:Object=null)
		{
			errorCode = ErrorCode ;
			isConnect = isConnected ;
			getRequestedData = RequestData;
			resultData = ResultData;
			super(type,false);
		}
		
		override public function clone():Event
		{
			return new RestDoaEvent(type,errorCode,isConnect,getRequestedData,resultData);
		}
	}
}