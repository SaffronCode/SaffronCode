package
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ContDown extends MovieClip
	{	
		private var countDownDate:Number;
		private var now:Number;
		private var timer:Timer;
		
		private var weekS:Boolean,
					daysS:Boolean,
					hoursS:Boolean,
					minutesS:Boolean,
					secondsS:Boolean;
		
		
		public var contDown:String;
		private var onContDownFun:Function;
		
		
		public function ContDown()
		{
			super();
		}
		public function setup(StartDate_p:Date,onContDownFun_p:Function,week_p:Boolean=true,days_p:Boolean=true,hours_p:Boolean=true,minutes_p:Boolean=true,seconds_p:Boolean=true):void
		{
			weekS = week_p;
			daysS = days_p;
			hoursS = hours_p;
			minutesS = minutes_p;
			secondsS = seconds_p;
			onContDownFun = onContDownFun_p;
			countDownDate = StartDate_p.time
			timer = new Timer(1000)
			timer.addEventListener(TimerEvent.TIMER,contDownTimer);	
			timer.start();	
		}
		protected function contDownTimer(event:TimerEvent):void
		{
			
			now = new Date().time
			var distance:Number = countDownDate - now;
			var days:Number = Math.floor(distance / (1000 * 60 * 60 * 24));
			var hours:Number = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
			var minutes:Number = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
			var seconds:Number = Math.floor((distance % (1000 * 60)) / 1000);
			var week:Number = Math.floor(days/7);
			contDown = '';
			if(weekS)
			{
				contDown = Add_Zero_Behind.add(2,week) + "w ";
			}
			if(daysS)
			{
				contDown += Add_Zero_Behind.add(2,days) + "d ";
			}
			if(hoursS)
			{
				contDown += Add_Zero_Behind.add(2,hours) + "h ";
			}
			if(minutesS)
			{
				contDown += Add_Zero_Behind.add(2,minutes) + "m ";
			}
			if(secondsS)
			{
				contDown += Add_Zero_Behind.add(2,seconds) + "s ";
			}
			onContDownFun();
		}
		public function remove():void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER,contDownTimer);	
		}
	}
}