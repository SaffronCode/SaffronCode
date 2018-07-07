package diagrams.calender
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	[Event(name="DATE_SELECTED", type="diagrams.calender.CalenderEvent")]
	
	public class Calender extends MovieClip
	{
		public static const MONTHLY:String = "MONTHLY";
		
		private var W:Number,
					H:Number ;
					
		//private var areaMC:MovieClip;
		
		private var myType:String ;
		
		private var storedTitles:Vector.<CalenderTitle> ;
		
		private var storedBoxes:Vector.<CalenderBox> ;
		
		/**list of boxes in the calender that have to delete*/
		private var trashBoxes:Vector.<CalenderBox> ;
		
		private var showDelay:uint = 50;
		
		
		private var dateData:CalenderDateData ;
		
		/**you can load this pages on Calender - removed , you can not load any page , you can just load next and prev pages*/
		//public var availableCalenderPaged:Vector.<CalendetPagesData> ;
		
		/**This is the date of current day*/
		public var todayDate:Date ;

		/**data of meeting or eny thing that shows in valender boxes*/
		private var calenderData:CalenderContents;
		
		public function Calender( myAreaRectangle:Rectangle , TodayDate:Date , type:String = MONTHLY)
		{
			super();
			
			//this.buttonMode = true ;
			
			trashBoxes = new Vector.<CalenderBox>();
			
			//areaMC = new MovieClip();
			
			calenderData = new CalenderContents();
			
			myType = type ;
			W = myAreaRectangle.width;
			H = myAreaRectangle.height;
			
			todayDate = TodayDate ;
			
			//this.removeChildren();
			
			if(myType == MONTHLY)
			{
				dateData = new CalenderDateData();
				dateData.setUp(generateCalender,todayDate,todayDate);
			}
			else
			{
				trace('this kind of calender is not defined yet 2');
			}
			
			//return areaMC ;
		}
		
		
		
		
		/**Generate next month in shamsi*/
		public function nextMonth()
		{
			clearOldBoxes();
			dateData.setUp(generateCalender,dateData.nextMonth,todayDate);
		}
		
		/**load the exact date to the calender*/
		public function showDate(date:Date):void
		{
			clearOldBoxes();
			dateData.setUp(generateCalender,date,todayDate);
		}
		
		public function preveMonth()
		{
			clearOldBoxes();
			dateData.setUp(generateCalender,dateData.prevMonth,todayDate);
		}
		
		/**Show current month again*/
		public function currentMonth()
		{
			if(!dateData.todayIsInThisMonth )
			{
				clearOldBoxes();
				dateData.setUp(generateCalender,todayDate,todayDate);
			}
		}
		
		
		
		
		
		
		
		
		
		/**now , every thing is ready to generate real calender*/
		private function generateCalender():void
		{
			
			if(myType == MONTHLY)
			{
				generateMontlyCalender(dateData.lengthOfTheMonth,dateData.firstDayOfTheWeek);
				updateCalenderContentInterFace();
			}
			else
			{
				trace('this kind of calender is not defined yet 2');
			}
		}
		
		
		/**returns the current month name in shamsi*/
		public function get currentMonthName():String
		{
			return CalenderConstants.monthNames[dateData.firstDateShamsi.month];
		}
		
		/**returns the current month name in shamsi*/
		public function get currentMonthID():uint
		{
			return dateData.firstDateShamsi.month;
		}
		
		/**returns year name on shamsi*/
		public function get currentYear():String
		{
			return dateData.firstDateShamsi.fullYear.toString() ;
		}
		
		public function get currentShamsiDate():MyShamsi
		{
			return dateData.firstDateShamsi;
		}
		public function get currentDate():Date
		{
			return dateData.firstDate;
		}
		public function getFirstDateOfMonth():Date
		{
			return dateData.firstDate;
		}
		
		public function getLastDateOfMonth():Date
		{
			return dateData.lastDate ;
		}
		
		public function get currentDayOfTheWeek():uint
		{
			return dateData.firstDayOfTheWeek;
		}
		
		/**Generate monthly calender*/
		private function generateMontlyCalender(currentMonthDays:uint = 31,firstDay:uint = 5):void
		{
			
			var titleNumber:uint = CalenderConstants.dayNames.length ;
			var titleWidth:Number = W/titleNumber ;
			var titlesHeight:Number = 0 ;
			
			storedTitles = new Vector.<CalenderTitle>();
			
			var i:uint ;
			
			//I forgot to clear calender each time ↓
				this.removeChildren();
			
			for(i = 0 ; i<titleNumber ; i++)
			{
				var newTitle:CalenderTitle = new CalenderTitle();
				//areaMC.addChild(newTitle);
				this.addChild(newTitle);
				newTitle.width = titleWidth ;
				newTitle.x = titleWidth*(titleNumber-i-1) ;
				if(CalenderConstants.dayNameTitle==0)
				{
					newTitle.text = CalenderConstants.dayNames[i];
				}
				else if(CalenderConstants.dayNameTitle==1)
				{
					newTitle.text = CalenderConstants.dayNames2[i].short ;
				}
				storedTitles.push(newTitle);
				
				titlesHeight = newTitle.height; 
			}
			
			
			var restOfHeight:Number = H- titlesHeight;
			var boxesNumLines:uint = Math.ceil(currentMonthDays/titleNumber) ;
			var boxHeight:Number = restOfHeight / boxesNumLines ;
			
			//Remove old calenderBoxes
			
			//1- remove oldest boxes
			for(i = 0 ; i<trashBoxes.length ; i++)
			{
				if(trashBoxes[i].parent == this)
				{
					this.removeChild(trashBoxes[i]);
				}
			}
			
			trashBoxes = new Vector.<CalenderBox>();
			
			//2- remove current boxes with delay
			clearOldBoxes();
			
			for(i = 0 ; i<currentMonthDays ; i++)
			{
				var newBox:CalenderBox = new CalenderBox(dateData.eachDayData[i],titleWidth,boxHeight);
				//areaMC.addChild(newBox);
				this.addChild(newBox);
				
				var I:uint = i+firstDay ;
				
				if(Math.floor(I/titleNumber)==boxesNumLines)
				{
					newBox.y = titlesHeight ;
				}
				else
				{
					newBox.y = Math.floor(I/titleNumber)*boxHeight+titlesHeight ;
				}
				newBox.x = (titleNumber-(I%titleNumber)-1)*titleWidth;
				
				newBox.show(i*showDelay);
				
				storedBoxes.push(newBox);
			}
		}
		
		
		
		/**Update calender interface from calenderData.content*/
		private function updateCalenderContentInterFace():void
		{
			
			//the only things that is necesary to check are storedBoxes on the stage
			for(var i = 0 ; i<storedBoxes.length ; i++)
			{
				var boxData:CalenderContents = new CalenderContents();
				for(var j = 0 ; j<calenderData.contents.length ; j++)
				{
					//Cross checking
					if(storedBoxes[i].data.isContaining(calenderData.contents[j].begin,calenderData.contents[j].end))
					{
						boxData.addContent(calenderData.contents[j].id,
							calenderData.contents[j].title,
							calenderData.contents[j].begin,
							calenderData.contents[j].end,
							calenderData.contents[j].color,
							calenderData.contents[j].data,
							calenderData.contents[j].isHollyday
						);

					}
				}
				storedBoxes[i].addContents(boxData);
			}
		}
		
		
		
		/**Cear old boxes*/
		private function clearOldBoxes():void
		{
			
			for(var i = 0 ; storedBoxes!=null && i<storedBoxes.length ; i++)
			{
				storedBoxes[i].hide(storedBoxes[i].showSpeed/10);
				trashBoxes.push( storedBoxes[i] );
			}
			
			storedBoxes = new Vector.<CalenderBox>();
		}
		
		
		/**update calender data on this*/
		public function updateCalendetContents(calContents:CalenderContents):void
		{
			
			calenderData = calContents ;
			
			updateCalenderContentInterFace();
		}
		
		/**Update calender data*/
		public function setUp(calContents:CalenderContents):void
		{
			updateCalendetContents(calContents);
		}
	}
}