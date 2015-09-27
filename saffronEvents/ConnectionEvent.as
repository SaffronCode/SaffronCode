package saffronEvents
{
	import flash.events.Event;
	
	public class ConnectionEvent extends Event
	{
		/**No internet connection*/
		public static const CONNECTION_FAILD:String = "CONNECTION_FAILD" ;
		
		public function ConnectionEvent(type:String)
		{
			super(type);
		}
	}
}