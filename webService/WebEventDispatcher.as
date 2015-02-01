package webService
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	[Event(name="onConnectedToServer", type="webService.WebEvent")]
	[Event(name="onConnectioFaild", type="webService.WebEvent")]
	
	[Event(name="LoginResult", type="webService.WebEvent")]
	[Event(name="GetUsersProfileResult", type="webService.WebEvent")]
	[Event(name="GetTasksResult", type="webService.WebEvent")]
	[Event(name="GetServerDateResult", type="webService.WebEvent")]
	
	[Event(name="Result", type="webService.WebEvent")]
	
	public class WebEventDispatcher extends EventDispatcher
	{
		public function WebEventDispatcher()
		{
			super(null);
		}
	}
}