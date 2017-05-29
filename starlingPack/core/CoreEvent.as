package starlingPack.core
{
	import flash.events.Event;
	
	public class CoreEvent extends Event
	{
		public function CoreEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}