package socketJ
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**SocketJ Closed*/
	[Event(name="close", type="flash.events.Event")]
	/**SocketJ connected*/
	[Event(name="connect", type="flash.events.Event")]
	public class SocketJDispatcher extends EventDispatcher
	{
		public function SocketJDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}