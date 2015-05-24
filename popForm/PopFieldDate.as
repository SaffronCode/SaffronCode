package popForm
{
	import DateManager.DateShamsi;
	
	import diagrams.calender.MyShamsi;
	
	import flash.display.MovieClip;
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
		
		public function changeColor(colorFrame:uint)
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		public function PopFieldDate(tagName:String,defaultDate:Date=null,isArabic:Boolean=false,languageFrame:uint=1,color:uint=1)
		{
			super();
			
			IsArabic = isArabic ;
			
			myTitle = tagName ;
			
			this.gotoAndStop(languageFrame);
			
			backMC = Obj.get("back_mc",this);
			backMC.stop();
			changeColor(color);
			
			tagTF = Obj.get("tag_txt",Obj.get("tag_txt",this));
			
			TextPutter.OnButton(tagTF,tagName,isArabic,true,false);
			
			yearTF = Obj.get("year_txt",this);
			monthTF = Obj.get("month_txt",this);
			dayTF = Obj.get("day_txt",this);
			
			
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
			
			FarsiInputCorrection.setUp(yearTF,SoftKeyboardType.NUMBER,IsArabic,true,clearAfterSelects);
			FarsiInputCorrection.setUp(monthTF,SoftKeyboardType.NUMBER,IsArabic,true,clearAfterSelects);
			FarsiInputCorrection.setUp(dayTF,SoftKeyboardType.NUMBER,IsArabic,true,clearAfterSelects);
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
	}
}