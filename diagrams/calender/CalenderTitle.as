package diagrams.calender
{
	import flash.display.MovieClip;
	
	internal class CalenderTitle extends MovieClip
	{
		private var myText:CalenderText ;
		
		public function CalenderTitle()
		{
			super();
			
			myText = new CalenderText(CalenderConstants.Color_TitleText,
				CalenderConstants.Font_size_titles);
			
			this.addChild(myText);
		}
		
		public function set text(newText:String)
		{
			TextPutter.OnButton(myText,newText,true,true,true);
			//myText.text = UnicodeStatic.convert(newText);
		}
		
		override public function set width(value:Number):void
		{
			myText.width = value;
		}
		
		override public function set height(value:Number):void
		{
			myText.height = value ;
		}
	}
}