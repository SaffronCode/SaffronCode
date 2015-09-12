package appManager.event
{
	import flash.events.Event;
	
	public class TitleEvent extends Event
	{
		public static const CHANGE_TITLE:String = "CHANGE_TITLE" ;
		
		public var title:String ;
		
		public function TitleEvent(newTitle:String)
		{
			title = newTitle ;
			super(CHANGE_TITLE, true);
		}
	}
}