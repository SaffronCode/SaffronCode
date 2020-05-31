package popForm
{
	import flash.display.MovieClip;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	
	public class PopFieldTime extends PopFieldInterface
	{
		public var 	tagTF:TextField,
					houreTF:TextField,
					minutesTF:TextField,
					myTitle:String;
		
		private var backMC:MovieClip;
		
		
		
		public function changeColor(colorFrame:uint)
		{
			backMC.gotoAndStop(colorFrame);
		}
		
		override public function get title():String
		{
			return myTitle ;
		}
		
		override public function get data():*
		{
			return date ;
		}
		
		
		public function PopFieldTime(tagName:String=null,defaultTime:Date=null,isArabic:Boolean=false,languageFrame:uint=1,color:uint=1)
		{
			super();
			
			if(tagName!=null)
			{
				setUp(tagName,defaultTime,isArabic,languageFrame,color);
			}

		}
		
		public function setUp(tagName:String,defaultTime:Date=null,isArabic:Boolean=false,languageFrame:uint=1,color:uint=1):void
		{
			myTitle = tagName ;
			this.gotoAndStop(languageFrame);
			
			backMC = Obj.get("back_mc",this);
			backMC.stop();
			changeColor(color);
					
			var tagContainer:MovieClip = Obj.getAllChilds("tag_txt",this,true)[0];
			tagTF = Obj.getAllChilds("tag_txt",tagContainer,true)[0];
			
			TextPutter.OnButton(tagTF,tagName,isArabic,true,false);

			
			houreTF = Obj.get("houre_txt",this);
			minutesTF = Obj.get("minutes_txt",this);
			
			var clearAfterSelects:Boolean = false ;
			
			if(defaultTime!=null)
			{
				houreTF.text = String(defaultTime.hours);
				minutesTF.text = String(defaultTime.minutes);
			}
			else
			{
				clearAfterSelects = true ;
				houreTF.text = "hh";
				minutesTF.text = "mm";
			}
			
			FarsiInputCorrection.setUp(houreTF,SoftKeyboardType.NUMBER,isArabic,true,clearAfterSelects);
			FarsiInputCorrection.setUp(minutesTF,SoftKeyboardType.NUMBER,isArabic,true,clearAfterSelects);
		}
		public function get date():Date
		{
			if(houreTF.text == '' || minutesTF.text == '')
			{
				return null ;
			}
			var houreNum:Number = Number(houreTF.text);
			var minutesNum:Number = Number(minutesTF.text);
			
			
			if(isNaN(houreNum) || isNaN(minutesNum))
			{
				return null;
			}
			
			if(houreNum<0 || houreNum>24)
			{
				return null 
			}
			
			if(minutesNum<0 || minutesNum>60)
			{
				return null ;
			}
			
			
			
			var finalDate:Date ;
			finalDate = new Date();
			finalDate.hours = houreNum ;
			finalDate.minutes = minutesNum ;
			finalDate.seconds = 0 ;
			finalDate.milliseconds = 0 ;
			
			
			return finalDate ;
		}
	}
}