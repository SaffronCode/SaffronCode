package diagrams.calender
{
	/**All months are 0 indexed*/
	public class MyShamsi
	{
		public static function shamsiToMiladi(date:*):Date
		{
			if(date is MyShamsi || date is Date)
			{
				var miladi:Array = Shamsi.ShamsiToMiladi(date.fullYear,date.month+1,date.date);
				var generatedDate:Date = new Date(miladi[0],miladi[1]-1,miladi[2],date.hours,date.minutes,date.seconds,date.milliseconds);
				return generatedDate ;
			}
			else
			{
				trace(new Error(date+" is not in standard form"));
				return new Date();
			}
		}
		
		public static function miladiToShamsi(date:Date):MyShamsi
		{
			var shamsi:Array = Shamsi.MiladiToShamsi(date.fullYear,date.month+1,date.date);
			var generatedDate:MyShamsi = new MyShamsi(shamsi[0],shamsi[1]-1,shamsi[2],date.hours,date.minutes,date.seconds,date.milliseconds);
			return generatedDate ;
		}
		
		
		
		
		
		
		
		
	////////////////////////////////////
		
		public var 	fullYear:Number,
					month:Number,
					date:Number,
					hours:Number,
					minutes:Number,
					seconds:Number,
					milliseconds:Number;
					
		public function MyShamsi(year_v:*=null, month_v:*=null, date_v:*=null, hours_v:*=null, minutes_v:*=null, seconds_v:*=null, ms_v:*=null)
		{
			fullYear = (year_v==null)?0:year_v;
			month = (month_v==null)?0:month_v;
			date = (date_v==null)?0:date_v;
			hours = (hours_v==null)?0:hours_v;
			minutes = (minutes_v==null)?0:minutes_v;
			seconds = (seconds_v==null)?0:seconds_v;
			milliseconds = (ms_v==null)?0:ms_v;
		}
		
		/**you can just compair it with other Shamsi Dates*/
		public function get shamsiTime():Number
		{
			var precent:Number = 1;
			var time:Number = 0;
			
			time += milliseconds*precent;
			precent*=1000;
			
			time+= seconds*precent;
			precent*=60;
			
			time+= minutes*precent;
			precent*=60;
			
			time+= hours*precent;
			precent*=24;
			
			time+= date*precent;
			precent*=32;
			
			time+= month*precent;
			precent*=13;
			
			time+= fullYear*precent;
			
			return time;
		}
		
		
		public function toString(e=null):String
		{
			return fullYear+'/'+month+'/'+date+'   '+hours+':'+minutes+':'+seconds;
		}
	}
}