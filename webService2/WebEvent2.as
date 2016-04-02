package webService2
{
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;

	/**take status value to check if this process is successful*/
	public class WebEvent2 extends Event
	{
		
		public static const	CONNECTED:String = "CONNECTED",
							NO_CONNECTTION:String = "NO_CONNECTTION",
							//TICKET_PROBLEM:String = "TICKET_PROBLEM",
							RESULT:String = "RESULT";
							
		
		
		//Problems list
		/**default connection problem*/
		public static const error_connection_problem:uint = 0 ;
		/**null receved from web service that means current tocken is expired*/
		public static const error_loginProblem:uint = 1 ;
		/**if Boolean data receved and it was false*/
		public static var error_not_done:uint = 2 ;
		
		
		/**User problem list from WebEvent class <br>
		 * error_connection_problem<br>
		 * error_login_problerm<br>
		 * error_not_done*/
		public var connectionProblemCode:uint ;
		
		public var token:AsyncToken ;
		
		public var pureData:Array ;
		
		public var problemHint:String ;
		
		public function WebEvent2(type:String,pureString:Array=null,myToken:AsyncToken=null,ConnectionProblemCode:uint = error_connection_problem,ProblemHint:String='')
		{
			pureData = pureString ;
			
			token = myToken;
			
			problemHint = ProblemHint ;
			
			connectionProblemCode = ConnectionProblemCode ;
			
			super(type,true);
		}
		
		override public function clone():Event
		{
			var newEvent:WebEvent2 = new WebEvent2(type,pureData,token,connectionProblemCode,problemHint);
			return newEvent ;
		}
	}
}