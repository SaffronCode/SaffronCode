package restDoaService
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="CONNECTION_ERROR", type="restService.RestEvent")]
	/**Server returns error, use Error code or msg list*/
	[Event(name="SERVER_ERROR", type="restService.RestEvent")]
	[Event(name="httpResponseStatus", type="flash.events.HTTPStatusEvent")]
	public class RestDoaEventDispatcher extends EventDispatcher
	{
		public function RestDoaEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}