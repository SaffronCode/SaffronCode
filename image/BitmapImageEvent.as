package image
{
	import flash.events.Event;
	
	public class BitmapImageEvent extends Event
	{
		public static const EDIT_IMAGE:String = "EDIT_IMAGE";
		public static const DELET_IMAGE:String = "DELET_IMAGE";
		public static const BASE64_COMPELETED:String = "BASE64_COMPELETED"
		private var _id:String;
		public function get id():String
		{
			return _id
		}
		public function BitmapImageEvent(type:String,id:String='', bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_id = id
		}
	}
}