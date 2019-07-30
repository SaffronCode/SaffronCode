package reversTimer
{//reversTimer.ReverseTimerEvent
	import flash.events.Event;
	
	public class ReverseTimerEvent extends Event
	{
		public static const REVERSE:String = "REVERSE";
		public static const REVERSE_END:String = "REVERSE_END";
		
		private var _hour:Number;
		public function get hour():Number
		{
			return _hour;
		}
		
		private var _minutes:Number;
		public function get minutes():Number
		{
			return _minutes;
		}
		
		private var _second:Number;
		public function get second():Number
		{
			return _second;
		}
		
		private var _showTime:String;
		public function get showTime():String
		{
			return _showTime;
		}
		public function ReverseTimerEvent(type:String,showTime:String=null,hour:Number=0,minutes:Number=0,second:Number=0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_showTime = showTime;
			_hour = hour;
			_minutes = minutes;
			_second = second;
			super(type, bubbles, cancelable);
		}
	}
}