package tabMenu
{
	import flash.events.Event;
	
	public class TabMenuEvent extends Event
	{
		public static const SELECT:String = "SELECT";
		
		private var _group:String;
		public function get group():String
		{
			return _group;
		}
		private var _name:String;
		public function get name():String
		{
			return _name;
		}
		
		private var _senderEvent:String;
		public function get senderEvent():String
		{
			return _senderEvent;
		}
		public function TabMenuEvent(type:String,group:String=null,name:String=null,senderEvent:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_group = group
			_name = name
			_senderEvent = senderEvent	
		}
	}
}