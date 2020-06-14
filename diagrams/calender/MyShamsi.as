package diagrams.calender
{
	import com.mteamapp.StringFunctions;
	
	/**All months are 0 indexed*/
	public class MyShamsi
	{
		public static function shamsiToMiladi(date:*):Date
		{
			if (date == null)
			{
				return null;
			}
			if (date is MyShamsi || date is Date)
			{
				var miladi:Array = Shamsi.ShamsiToMiladi(date.fullYear, date.month + 1, date.date);
				var generatedDate:Date = new Date(miladi[0], miladi[1] - 1, miladi[2], date.hours, date.minutes, date.seconds, date.milliseconds);
				return generatedDate;
			}
			else
			{
				SaffronLogger.log(new Error(date + " is not in standard form"));
				return new Date();
			}
		}
		
		public static function miladiToShamsi(date:Date):MyShamsi
		{
			if (date == null)
			{
					return null;
			}
			var shamsi:Array = Shamsi.MiladiToShamsi(date.fullYear, date.month + 1, date.date);
			
			var generatedDate:MyShamsi = new MyShamsi(shamsi[0], shamsi[1] - 1, shamsi[2], date.hours, date.minutes, date.seconds, date.milliseconds);
			generatedDate.day = date.day;
			switch (date.day)
			{
			case 0: 
				generatedDate.day = 1;
				break;
			case 1: 
				generatedDate.day = 2;
				break;
			case 2: 
				generatedDate.day = 3;
				break;
			case 3: 
				generatedDate.day = 4;
				break;
			case 4: 
				generatedDate.day = 5;
				break;
			case 5: 
				generatedDate.day = 6;
				break;
			case 6: 
				generatedDate.day = 0;
				break;
			}
			return generatedDate;
		}
		
		/**Returns a time lable 1396_4_17T11_22_30*/
		public function timeLable():String
		{
			return fullYear + '_' + (month + 1) + '_' + (date) + 'T' + hours + '_' + minutes + '_' + seconds;
		}
		
		////////////////////////////////////
		private var _month:Number;
		public var fullYear:Number, date:Number, day:Number, hours:Number, minutes:Number, seconds:Number, milliseconds:Number;
		
		public function get month():Number
		{
			return _month ;
		}

		public function set month(value:Number):void
		{
			if(value<0)
			{
				_month = 11;
				fullYear--;
			}
			else
			{
				_month = value ;
			}
		}

		public function MyShamsi(year_v:* = null, month_v:* = null, date_v:* = null, hours_v:* = null, minutes_v:* = null, seconds_v:* = null, ms_v:* = null)
		{
			fullYear = (year_v == null) ? 0 : year_v;
			month = (month_v == null) ? 0 : month_v;
			date = (date_v == null) ? 0 : date_v;
			hours = (hours_v == null) ? 0 : hours_v;
			minutes = (minutes_v == null) ? 0 : minutes_v;
			seconds = (seconds_v == null) ? 0 : seconds_v;
			milliseconds = (ms_v == null) ? 0 : ms_v;
		}
		
		/**you can just compair it with other Shamsi Dates*/
		public function get shamsiTime():Number
		{
			var precent:Number = 1;
			var time:Number = 0;
			
			time += milliseconds * precent;
			precent *= 1000;
			
			time += seconds * precent;
			precent *= 60;
			
			time += minutes * precent;
			precent *= 60;
			
			time += hours * precent;
			precent *= 24;
			
			time += date * precent;
			precent *= 32;
			
			time += month * precent;
			precent *= 13;
			
			time += fullYear * precent;
			
			return time;
		}
		
		/**1397/02/19 15:23:10*/
		public function showStringFormat(showClock:Boolean = true, showSeconds:Boolean = true, houreDateDevider:String = '    '):String
		{
			var str:String = fullYear + '/' + TimeToString.numToString(month + 1) + '/' + TimeToString.numToString(date);
			if (showClock)
			{
				str += houreDateDevider + TimeToString.numToString(hours) + ':' + TimeToString.numToString(minutes);//
				if (showSeconds)
				{
					str += ':' + TimeToString.numToString(seconds);
				}
			}
			return str;
		}
		
		/** add functoin for create miladi string format*/
		public function showStringFormatMiladi(date:Date, showClock:Boolean = true, showSeconds:Boolean = true):String
		{
			var str:String = TimeToString.numToString(date.date) + '/' + TimeToString.numToString(date.month + 1) + '/' + date.fullYear;
			if (showClock)
			{
				str += '    ' + TimeToString.numToString(date.hours) + ':' + TimeToString.numToString(date.minutes);//
				if (showSeconds)
				{
					str += ':' + TimeToString.numToString(date.seconds);
				}
			}
			return str;
		}
		
		/**Show clock format*/
		public function showClock(showSecond:Boolean = false):String
		{
			var str:String = '';
			str += TimeToString.numToString(hours) + ' : ' + TimeToString.numToString(minutes);
			if (showSecond)
			{
				str += ':' + TimeToString.numToString(seconds);
			}
			return str;
		}
		
		public function monthName(month:int):String
		{
			var mounthName:String;
			switch (month) 
			{
				case -1:
					mounthName = "اسفند";
					break;
				case 0:
					mounthName = "فروردین";
					break;
				case 1:
					mounthName = "اردیبهشت";
					break;
				case 2:
					mounthName = "خرداد";
					break;
				case 3:
					mounthName = "تیر";
					break;
				case 4:
					mounthName = "مرداد";
					break;
				case 5:
					mounthName = "شهریور";
					break;
				case 6:
					mounthName = "مهر";
					break;
				case 7:
					mounthName = "آبان";
					break;
				case 8:
					mounthName = "آذر";
					break;
				case 9:
					mounthName = "دی";
					break;
				case 10:
					mounthName = "بهمن";
					break;
				case 11:
					mounthName = "اسفند";
					break;
				break;
			}
			return mounthName;
		}
		
		public function toString(e = null):String
		{
			return fullYear + '/' + (month + 1) + '/' + date + '   ' + hours + ':' + minutes + ':' + seconds;
		}
		
		public static function timeLable():String
		{
			// TODO Auto Generated method stub
			return null;
		}
	}
}