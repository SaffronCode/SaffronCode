package webService2
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	[Event(name="CONNECTED", type="webService.WebEvent")]
	[Event(name="NO_CONNECTTION", type="webService.WebEvent")]
	//[Event(name="TICKET_PROBLEM", type="webService.WebEvent")]
	
	[Event(name="RESULT", type="webService.WebEvent")]
	
	public class WebEventDispatcher2 extends EventDispatcher
	{
		public function WebEventDispatcher2()
		{
			super(null);
		}
	}
}