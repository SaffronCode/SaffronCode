package webService3
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	[Event(name="CONNECTED", type="webService.WebEvent")]
	[Event(name="NO_CONNECTTION", type="webService.WebEvent")]
	//[Event(name="TICKET_PROBLEM", type="webService.WebEvent")]
	
	[Event(name="RESULT", type="webService.WebEvent")]
	
	public class WebEventDispatcher3 extends EventDispatcher
	{
		public function WebEventDispatcher3()
		{
			super(null);
		}
	}
}