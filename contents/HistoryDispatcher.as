package contents
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	public class HistoryDispatcher extends EventDispatcher
	{
		public function HistoryDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}