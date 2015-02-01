package webService
{
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;

	/**take status value to check if this process is successful*/
	public class WebEvent extends Event
	{
		
		public static const	EVENT_CONNECTED:String = "onConnectedToServer",
							EVENT_DISCONNECTED:String = "onConnectioFaild",
		
							LoginResult:String = "LoginResult",
							GetTasksResult:String = "GetTasksResult",
							GetUsersProfileResult:String = "GetUsersProfileResult",
							GetServerDateResult:String = "GetServerDateResult",
							
							Result:String = "Result";
							
		
		
		
		
		public var pureData:String ;
		
		public var token:AsyncToken ;
		
		public function WebEvent(type:String,pureString:String='',myToken:AsyncToken=null)
		{
			pureData = pureString ;
			
			token = myToken;
			
			super(type,true);
		}
	}
}