package popForm
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="popMenuShows", type="popForm.PopMenuEvent")]
	[Event(name="popClosed", type="popForm.PopMenuEvent")]
	[Event(name="buttonSelecte", type="popForm.PopMenuEvent")]
	
	public class PopMenuDispatcher extends EventDispatcher
	{
		public function PopMenuDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}