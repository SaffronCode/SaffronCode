package number3D
{//number3D.Clock3D
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Clock3D extends MovieClip
	{
		private var _hours:MovieClip,
					_minutes:MovieClip,
					_secounds:MovieClip;

		private var newDate:Date;
		public function Clock3D()
		{
			super();
			_hours = Obj.get('hours_mc',this)
			_minutes = Obj.get('minutes_mc',this)
			_secounds = Obj.get('secounds_mc',this)	
			
		}
		public function setup(Date_p:Date=null):void
		{
			if(Date_p!=null)
			{
				newDate = new Date(Date_p.time)
			}
			else
			{
				newDate = new Date()
			}
			if(_hours!=null)
			{				
				var hours:Number3D = new Number3D(_hours,'numberMovie3D',0,newDate.hours,23,450,170,2,2)
				hours.addEventListener(Number3DEvent.CHANGE,hours_fun)
				hours.setup()
			}
			else
			{
				newDate.hours = 0
			}
			
			if(_minutes!=null)
			{				
				var minutes:Number3D = new Number3D(_minutes,'numberMovie3D',0,newDate.minutes,59,450,170,2)
				minutes.addEventListener(Number3DEvent.CHANGE,minutes_fun)
				minutes.setup()
			}
			else
			{
				newDate.minutes = 0
			}
			if(_secounds!=null)
			{			
				var secounds:Number3D = new Number3D(_secounds,'numberMovie3D',0,newDate.seconds,59,450,170,2)
				secounds.addEventListener(Number3DEvent.CHANGE,secounds_fun)
				secounds.setup()	
			}
			else
			{
				newDate.seconds = 0
			}

		}
		
		protected function secounds_fun(event:Number3DEvent):void
		{
			
			newDate.seconds = event.value.numberValue
			dispachDate()	
		}
		
		protected function minutes_fun(event:Number3DEvent):void
		{
			
			newDate.minutes = event.value.numberValue
			dispachDate()
		}
		
		protected function hours_fun(event:Number3DEvent):void
		{
			
			newDate.hours = event.value.numberValue
			dispachDate()
		}
		private function dispachDate():void
		{
			this.dispatchEvent(new Number3DEvent(Number3DEvent.DATE,null,newDate))	
		}
	}
}