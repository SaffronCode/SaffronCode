package diagrams.calender
{
	import com.mteamapp.StringFunctions;

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
		
		
		/**Returns a time lable 1396_4_17T11_22_30*/
		public function timeLable():String
		{
			return fullYear+'_'+(month+1)+'_'+(date)+'T'+hours+'_'+minutes+'_'+seconds ;
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
		
		public function showStringFormat(showClock:Boolean=true,showSeconds:Boolean=true):String
		{
			var str:String = fullYear+'/'+TimeToString.numToString(month+1)+'/'+TimeToString.numToString(date);
			if(showClock)
			{
				str+='    '+TimeToString.numToString(hours)+':'+TimeToString.numToString(minutes);//
				if(showSeconds)
				{
					str+=':'+TimeToString.numToString(seconds);
				}
			}
			return str ;
		}
		/** add functoin for create miladi string format*/
		public function showStringFormatMiladi(date:Date,showClock:Boolean=true,showSeconds:Boolean=true):String
		{
			var str:String = TimeToString.numToString(date.date)+'/'+TimeToString.numToString(date.month+1)+'/'+date.fullYear;
			if(showClock)
			{
				str+='    '+TimeToString.numToString(date.hours)+':'+TimeToString.numToString(date.minutes);//
				if(showSeconds)
				{
					str+=':'+TimeToString.numToString(date.seconds);
				}
			}
			return str ;
		}
		
		/**Show clock format*/
		public function showClock(showSecond:Boolean=false):String
		{
			var str:String = '';
			str += TimeToString.numToString(hours)+':'+TimeToString.numToString(minutes);
			if(showSecond)
			{
				str+=':'+TimeToString.numToString(seconds);
			}
			return str ;
		}
		
		
		public function toString(e=null):String
		{
			return fullYear+'/'+(month+1)+'/'+date+'   '+hours+':'+minutes+':'+seconds;
		}
		
		public static function timeLable():String
		{
			// TODO Auto Generated method stub
			return null;
		}
	}
}