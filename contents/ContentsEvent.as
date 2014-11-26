package contents
{
	import flash.events.Event;
	
	public class ContentsEvent extends Event
	{
		public static const CONTENT_READY_EVENT:String = "contentsAreReady";
		
		
		public function ContentsEvent(type:String=CONTENT_READY_EVENT)
		{
			super(type);
		}
	}
}