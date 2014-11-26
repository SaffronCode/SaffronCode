package contents
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="contentsAreReady", type="contents.ContentsEvent")]
	
	public class ContentEventDispatcher extends EventDispatcher
	{
		public function ContentEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}