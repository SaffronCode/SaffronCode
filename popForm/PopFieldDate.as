package popForm
{
	import DateManager.DateShamsi;
	
	import diagrams.calender.MyShamsi;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	
	import soundPlayer.SoundPlayer;
	
	public class PopFieldDate extends PopFieldInterface
	{
		public var tagTF:TextField,
					yearTF:TextField,
					monthTF:TextField,
					dayTF:TextField,
					myTitle:String;
		
		private var backMC:MovieClip;
		private var IsArabic:Boolean;
		private var yearKeyboard:FarsiInputCorrection;
		private var monthKeyboard:FarsiInputCorrection;
		private var dayKeyboard:FarsiInputCorrection;
		private var OnTypedFunction:Function;
		private var ReturnKey:String;
		
		public function changeColor(colorFrame:uint)
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		public function PopFieldDate(tagName:String=null,defaultDate:Date=null,isArabic:Boolean=false,languageFrame:uint=1,color:uint=1)
		{
			super();
			
			if(tagName!=null)
			{
				setUp(tagName,defaultDate,isArabic,languageFrame,color);
			}
		}
		
		public function setUp(tagName:String,defaultDate:Date=null,isArabic:Boolean=false,languageFrame:uint=1,color:uint=1,returnKey:String=ReturnKeyLabel.DEFAULT,onTypedFunction:Function=null):void
		{
			
			IsArabic = isArabic ;
			
			myTitle = tagName ;
			
			this.gotoAndStop(languageFrame);
			
			backMC = Obj.get("back_mc",this);
			backMC.stop();
			changeColor(color);
			
			tagTF = Obj.get("tag_txt",Obj.get("tag_txt",this));
			
			TextPutter.OnButton(tagTF,tagName,isArabic,true,false);
			
			yearTF = Obj.get("year_txt",this);
			yearTF.maxChars = 4 ;
			monthTF = Obj.get("month_txt",this);
			monthTF.maxChars = 2 ;
			dayTF = Obj.get("day_txt",this);
			dayTF.maxChars = 2 ;
			
			ReturnKey = returnKey;
			OnTypedFunction = onTypedFunction;
			
			update(defaultDate);
		}
		
		override public function update(data:*):void
		{
			var clearAfterSelects:Boolean = false ;
			var defaultDate:Date = data as Date ;
			if(defaultDate!=null)
			{
				if(IsArabic)
				{
					var shamsi:MyShamsi = MyShamsi.miladiToShamsi(defaultDate);
					yearTF.text = String(shamsi.fullYear);
					monthTF.text = String(shamsi.month+1);
					dayTF.text = String(shamsi.date);
				}
				else
				{
					yearTF.text = String(defaultDate.fullYear);
					monthTF.text = String(defaultDate.month+1);
					dayTF.text = String(defaultDate.date);
				}
			}
			else
			{
				clearAfterSelects = true ;
				yearTF.text = 'yyyy';
				monthTF.text = 'mm';
				dayTF.text = 'dd';
			}
			
			yearKeyboard = FarsiInputCorrection.setUp(yearTF,SoftKeyboardType.NUMBER,IsArabic,true,clearAfterSelects,false,true,true,ReturnKeyLabel.NEXT,selectMonth);
			yearTF.addEventListener(Event.CHANGE,imUpdated);
			monthKeyboard = FarsiInputCorrection.setUp(monthTF,SoftKeyboardType.NUMBER,IsArabic,true,clearAfterSelects,false,true,true,ReturnKeyLabel.NEXT,selectDay);
			monthTF.addEventListener(Event.CHANGE,imUpdated);
			dayKeyboard = FarsiInputCorrection.setUp(dayTF,SoftKeyboardType.NUMBER,IsArabic,true,clearAfterSelects,false,true,true,ReturnKey,OnTypedFunction);
			dayTF.addEventListener(Event.CHANGE,imUpdated);
		}
		
		private function selectMonth():void
		{
			monthKeyboard.focuseOnStageText();
		}
		
		private function selectDay():void
		{
			dayKeyboard.focuseOnStageText();
		}
		
		protected function imUpdated(event:Event):void
		{
			if(yearKeyboard.editing && yearTF.text.length>=4)
			{
				yearKeyboard.closeKeyBoard();
				selectMonth();
			}
			else if(monthKeyboard.editing && monthTF.text.length>=2)
			{
				monthKeyboard.closeKeyBoard();
				selectDay();
			}
			else if(dayKeyboard.editing && dayTF.text.length>=2)
			{
				dayKeyboard.closeKeyBoard();
				if(OnTypedFunction!=null)
				{
					OnTypedFunction();
				}
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function get title():String
		{
			return myTitle ;
		}
		
		override public function get data():*
		{
			//trace("Get my date : "+date);
			return date ;
		}
		
		public function get date():Date
		{
			//trace("yearTF.text == "+yearTF.text+"  monthTF.text == "+monthTF.text+"    dayTF.text == "+dayTF.text);
			if(yearTF.text == '' || monthTF.text == '' || dayTF.text == '')
			{
				return null ;
			}
			
			var yearNum:Number = Number(yearTF.text);
			var monthNum:Number = Number(monthTF.text);
			var dayNum:Number = Number(dayTF.text);
			
			
			if(isNaN(yearNum) || isNaN(monthNum) || isNaN(dayNum))
			{
				return null;
			}
			
			if(yearNum<100)
			{
				yearNum+=1300 ;
			}
			
			if(yearNum<1200 || yearNum>2100 || (yearNum>1500 && yearNum<1850))
			{
				return null 
			}
			
			if(monthNum<1 || monthNum>12)
			{
				return null ;
			}
			
			if(dayNum<1 || dayNum>31)
			{
				return null ;
			}
			
			
			var finalDate:Date ;
			//trace("yearNum : "+yearNum);
			if(yearNum<1500)
			{
				var shamsiDate:DateShamsi = new DateShamsi(yearNum,(monthNum-1),dayNum);
				finalDate = DateShamsi.shamsiToMiladi(shamsiDate);
				//trace("This was shamsi : "+finalDate);
			}
			else
			{
				finalDate = new Date(yearNum,monthNum-1,dayNum);
			}
			
			
			return finalDate ;
		}
		
		
		/**Open the device key board*/
		public function activateKeyBoard():void
		{
			if(yearKeyboard)
			{
				yearKeyboard.focuseOnStageText();
			}
		}
	}
}