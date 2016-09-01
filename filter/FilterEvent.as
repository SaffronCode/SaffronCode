package filter
{
	import flash.events.Event;
	
	public class FilterEvent extends Event
	{
		public static const SELECT:String = "SELECT"
			
		private var _id:int;
		public function get  id():int{
			return _id
		}
		public function FilterEvent(type:String,id:int=1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_id = id
		}
	}
}