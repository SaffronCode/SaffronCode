package diagrams.calender
{
	

	internal class CalenderDateData
	{
		private var onReady:Function ;
		
		/**this is the date , that is added at the first*/
		private var enteredDate:Date ;
		
		
		public var firstDate:Date;
		
		/**This is the first day after this month*/
		public var lastDate:Date;
		
		public var firstDateShamsi:MyShamsi,
					lastDateShamsi:MyShamsi;
					
		public var firstDayOfTheWeek:uint ;
		
		public var lengthOfTheMonth:uint ;
		
		/**مناسبت های هر روز*/
		public var eachDayData:Vector.<CalenderDayData>;
		
		/**if this variable has any contnents , this is the current day of the month*/
		//public var currentDate:Date ;
		
		/**لیست تمام جلسات به ازای هر روز، یک روز می تواند چندید مناسبت داشته باشد. مناسبت ها هم از سرور دانلود می شوند و هم از دیتا بیس آفلاین به ازای هر روز استخراج می شوند*/
		public var eachDayMeeting:Vector.<Object>;
		
		/**this is today date*/
		private var today :Date;
					
		
		public function CalenderDateData(){}
		
		
		public function setUp( onDateReady:Function , dateOnMonth:Date , TodayDate:Date):void
		{
			// TODO Auto Generated method stub
			onReady = onDateReady ;
			
			/*if(todayDate.fullYear == dateOnMonth.fullYear && todayDate.month == dateOnMonth.month && todayDate.date == dateOnMonth.date)
			{
				trace('current day is on this month');
				currentDate = dateOnMonth ;
			}
			else
			{
				currentDate = null ;
			}*/
			
			today = TodayDate;
			
			enteredDate = dateOnMonth;
			
			
			detectFirstAndLastDatesOfMonth();
		}
		
		
		private function detectFirstAndLastDatesOfMonth():void
		{
			//Set each day lenght
			//var dayLenght:Number = new Date(0,0,1).time ;
			
			// TODO Auto Generated method stub
			/**It is dayli data , so it dosent need to get houres and minutse*/
			var testDate:Date = new Date(enteredDate.fullYear,enteredDate.month,enteredDate.date);
			var testShamsiDate:MyShamsi = MyShamsi.miladiToShamsi(testDate) ;
			var currentShamsiMonth:uint = testShamsiDate.month ;
			
			//resetting date datas :
			eachDayData = new Vector.<CalenderDayData>() ;
			
			//I will add current date on the eachDayData
			//eachDayData.push(new CalenderDayData(testDate,testShamsiDate,today));

			
			//find the first date of this month
			do
			{
				//trace(testDate+" vs "+testShamsiDate);
				eachDayData.unshift(new CalenderDayData(testDate,testShamsiDate,today));
				
				testDate.date--;
				testShamsiDate = MyShamsi.miladiToShamsi(testDate) ;
			}while(testShamsiDate.month == currentShamsiMonth);
			testDate.date++;
			//eachDayData.shift();
			
			firstDate = new Date(testDate.fullYear,testDate.month,testDate.date);
			//trace("firstDate : "+firstDate);
			firstDateShamsi = MyShamsi.miladiToShamsi(firstDate);
			
			//detect first day of the week
			
			firstDayOfTheWeek = (firstDate.day+1)%7 ;
			
			//find the last date of the mon
			testDate = new Date(enteredDate.fullYear,enteredDate.month,enteredDate.date);
			testShamsiDate = MyShamsi.miladiToShamsi(testDate) ;
			
			do
			{
				testDate.date++;
				testShamsiDate = MyShamsi.miladiToShamsi(testDate) ;
				
				//trace(testDate+" vs "+testShamsiDate);
				
				eachDayData.push(new CalenderDayData(testDate,testShamsiDate,today));
				
			}while(testShamsiDate.month == currentShamsiMonth);
			testDate.date--;
			eachDayData.pop();
			
			lengthOfTheMonth = eachDayData.length;
			
			lastDate = new Date(testDate.fullYear,testDate.month,testDate.date+1);
			lastDateShamsi = MyShamsi.miladiToShamsi(lastDate);
			
			
			findDateMeetings();
		}
		
		
		/**Server side function*/
		private function findDateMeetings():void
		{
			// TODO Auto Generated method stub
			findDateDatas();
		}
		
		private function findDateDatas():void
		{
			// TODO Auto Generated method stub
			onReady();
		}
		
		
	////////////////////////////Manage months
		
		/**miladi dates*/
		public function get prevMonth():Date
		{
			var date:Date = new Date(firstDate.fullYear,firstDate.month,firstDate.date-1);
			return date ;
		}
		
		/**miladi dates*/
		public function get nextMonth():Date
		{
			var date:Date = new Date(lastDate.fullYear,lastDate.month,lastDate.date);
			return date ;
		}
		
		/**miladi dates*/
		public function get currentMonth():Date
		{
			var date:Date = new Date(firstDate.fullYear,firstDate.month,firstDate.date);
			return date ;
		}
		
		/**it is true if today is in this month*/
		public function get todayIsInThisMonth():Boolean
		{
			if(today.time>=firstDate.time && today.time<lastDate.time)
			{
				trace("today is here");
				return true ;
			}
			else 
			{
				trace("today is not here");
				return false ;
			}
		}
		
		
	}
}