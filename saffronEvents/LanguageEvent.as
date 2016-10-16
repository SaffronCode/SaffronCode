package saffronEvents
{
	import flash.events.Event;
	
	public class LanguageEvent extends Event
	{
		/**Language changed. this event will dispatches on the stage to*/
		public static const LANGUAGE_CHANGED:String = "LANGUAGE_CHANGED" ;
		
		public function LanguageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}