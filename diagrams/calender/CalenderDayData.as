/**Version 1.1 , isContaining changed
 * 
 * 
 */

package diagrams.calender
{
	internal class CalenderDayData
	{
		public static const CalenderDataType_day:uint = 1 ;
		
		public var Mdate:Date ;
		private var SHdate:MyShamsi ;
		
		private var _title:String ;
		
		private var _isFriday:Boolean = false ;
		
		private var _isCurrentDay:Boolean = false ;

		/**begining of this day
		private var from:Date;*/

		/**endig of this day*/
		public var to:Date;
		
		/**miladiDate + this variable make the last date 
		private var unitLength:uint ;*/
		
		/**returns true if this DayData is containing this date*/
		public function isContaining(begin:Date,end:Date):Boolean
		{
			trace("begin : "+begin+' > '+begin.time);
			trace("end : "+end+' > '+end.time);
			trace(".Mdate : "+Mdate+' > '+Mdate.time);
			trace(".to : "+to+' > '+to.time);
			//Version 1.1 change : if(begin.time<  =  to.time && end.time>=Mdate.time)
			if(begin.time<  to.time && end.time>=Mdate.time)
			{
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		public function CalenderDayData(miladiDate:Date,shamsiDate:MyShamsi,currentDay:Date , dataType:uint = CalenderDataType_day)
		{
			Mdate = DateManager.copy(miladiDate) ;
			SHdate = new MyShamsi(shamsiDate.fullYear,shamsiDate.month,shamsiDate.date,shamsiDate.hours,shamsiDate.minutes,shamsiDate.seconds,shamsiDate.milliseconds) ;
			
			if(dataType == CalenderDataType_day)
			{
				to = DateManager.copy(Mdate);
				to.date++;
			}
			//unitLength = unitTimeLength ;
			
			if(currentDay.fullYear == miladiDate.fullYear && currentDay.month == miladiDate.month && currentDay.date == miladiDate.date)
			{
				_isCurrentDay = true ;
			}
			else
			{
				_isCurrentDay = false ;
			}
			
			_title = SHdate.date.toString();
			if(Mdate.day == 5)
			{
				_isFriday = true ;
			}
		}
		
		public function get isCurrentDay():Boolean
		{
			return _isCurrentDay;
		}

		public function get title():String
		{
			return _title;
		}


		public function get isFriday():Boolean
		{
			return _isFriday ;
		}
	}
}