package componentStatic
{

	
	import flash.events.Event;
	
	public class TextBoxEvent extends Event
	{
		public static const TEXT:String = "TEXT";
		private var _text:String;
		public function get text():String
		{
			return _text
		}
		public function TextBoxEvent(type:String,text:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_text = text
		}
	}
}