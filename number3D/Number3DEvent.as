package number3D
{
	import flash.events.Event;
	
	public class Number3DEvent extends Event
	{
		public static const CHANGE:String = "CHANGE";
		
		public static const DATE:String = "DATE";
		
		private var _value:Number3D;
		public function get value():Number3D
		{
			return _value
		}
		private var _date:Date;
		public function get date():Date
		{
			return _date
		}
		public function Number3DEvent(type:String,value:Number3D=null,date:Date=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_value = value
			_date = date	
		}
	}
}