package reversTimer
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	[Event(name="REVERSE",type="reversTimer.ReverseTimerEvent")]
	public class ReverseTime extends EventDispatcher
	{
		private var _setIntervalId:uint;
		private var _minuts:Number;
		private var _startTime:Number;

		private var _revertTime:Number;
		private var _h:Number;
		private var _m:Number;
		private var _s:Number;
		private var _showTime:String;
		
		public function ReverseTime(minuts:Number)
		{
			super(null);
			_minuts = minuts;
			_startTime = 0;
			_setIntervalId = setInterval(time,1000);
			
		}
		public function dispos():void
		{
			clearInterval(_setIntervalId);
		}
		private function time():void
		{
			_revertTime = (_minuts*60)-_startTime++;
			_h = Math.floor(_revertTime/(60*60));
			_m = Math.floor((_revertTime-(_h*60*60))/60);
			_s = (_revertTime-(_h*60*60)-(_m*60));
			
			if(_minuts>=60)
			{
				_showTime = Add_Zero_Behind.add(2,_h)+':'+Add_Zero_Behind.add(2,_m)+':'+Add_Zero_Behind.add(2,_s);
			}
			else if(_minuts>=1)
			{
				_showTime = Add_Zero_Behind.add(2,_m)+':'+Add_Zero_Behind.add(2,_s);
			}
			else 
			{
				_showTime = Add_Zero_Behind.add(2,_s);
			}
			this.dispatchEvent(new ReverseTimerEvent(ReverseTimerEvent.REVERSE,_showTime,_h,_m,_s));
		}
	}
}