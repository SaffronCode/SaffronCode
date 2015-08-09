package restService
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="CONNECTION_ERROR", type="restService.RestEvent")]
	/**Server returns error, use Error code or msg list*/
	[Event(name="SERVER_ERROR", type="restService.RestEvent")]
	public class RestEventDispatcher extends EventDispatcher
	{
		public function RestEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}