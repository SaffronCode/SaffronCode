package diagrams.calender
{
	public class CalenderConstants
	{

		public static const Debug_instantShow:Boolean = true;

		/**Calender box contents will apear under masked area. You will loose performance*/
		public static const maskAvailable:Boolean = false;
		
		/**Inner box parameters*/
		public static var 	padding:Number = 1,
							maskPadding:Number = 5,
							maskPaddingT:Number = 20,
							ellipse:Number = 10 ;
		
		private static const 	d0:String = "شنبه",
								d1:String = "یک شنبه",
								d2:String = "دو شنبه",
								d3:String = "سه شنبه",
								d4:String = "چهار شنبه",
								d5:String = "پنج شنبه",
								d6:String = "جمعه";
		
		private static const 	dd0:DayNamesModel  = new DayNamesModel("شنبه","ش"),
								dd1:DayNamesModel  = new DayNamesModel("یک شنبه","ی"),
								dd2:DayNamesModel  = new DayNamesModel("دو شنبه","د"),
								dd3:DayNamesModel  = new DayNamesModel("سه شنبه","س"),
								dd4:DayNamesModel  = new DayNamesModel("چهار شنبه","چ"),
								dd5:DayNamesModel  = new DayNamesModel("پنج شنبه","پ"),
								dd6:DayNamesModel  = new DayNamesModel("جمعه","ج");
		
		
		public static var dayNames:Array = [d0,d1,d2,d3,d4,d5,d6];
		
		public static var dayNames2:Vector.<DayNamesModel> = new Vector.<DayNamesModel>();
		dayNames2.push(dd0,dd1,dd2,dd3,dd4,dd5,dd6);
		
		public static var dayNamesMiladi:Array = [d1,d2,d3,d4,d5,d6,d0];
		
		private static const 	m0:String = "فروردین",
								m1:String = "اردیبهشت",
								m2:String = "خرداد",
								m3:String = "تیر",
								m4:String = "مرداد",
								m5:String = "شهریور",
								m6:String = "مهر",
								m7:String = "آبان",
								m8:String = "آذر",
								m9:String = "دی",
								m10:String = "بهمن",
								m11:String = "اسفند";
		
		public static var monthNames:Array = [m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11];
									
		
		
		/**Special font for calender title*/
		
 
		
		public static var Font_title:String = "B Yekan Bold Bold",
							Font_boxNames:String = "B Yekan Regular",
							Font_contents_name:String = "B Yekan Regular";
		
		public static var Color_boxBackGround:uint = 0xffffff,
							Color_boxBackGround_friday:uint = 0x555555,
							Color_boxBackGround_currentDay:uint = 0xF46E31,
							Color_TitleText:uint = 0,
							Color_boxNames:uint = 0x0,
							Color_boxNames_friday:uint = 0x0,
							Color_boxNames_currentDay:uint = 0x0,
							Color_content_text:uint = 0x222222;
		
		
		public static var Font_size_contents:Number = 20;
		public static var LineSpacing_content_box:Number = -8 ;
		public static var Font_size_titles:Number = 25;
		public static var Font_size_dates:Number = 17;
		
		
		/**0 is long
		 * 1 is short*/
		public static var  dayNameTitle:int = 0;
		
		
		public static function generateColor(seed:String):uint
		{
			var baseColor:uint = 0xaaaaaa;
			var num:uint = 0 ;
			for(var i = 0 ; i<seed.length ; i++)
			{
				num*=10;
				num+=seed.charCodeAt(i);
			}
			
			var plusNum:uint = num*20;
			plusNum = plusNum%0x555555;
			var returnedColor:uint = baseColor+plusNum ;
			
			return returnedColor ;
		}
	}
}