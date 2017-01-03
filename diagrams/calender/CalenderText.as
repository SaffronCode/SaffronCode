package diagrams.calender
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	internal class CalenderText extends TextField
	{
		private var myFormat:TextFormat ;
		
		public function CalenderText(color:uint=uint.MAX_VALUE,size:Number=20,Font:String = null,align:String = TextFormatAlign.CENTER , lineSpacing:Number = 0 )
		{
			super();
			
			if(Font==null)
			{
				Font = CalenderConstants.Font_title ;
			}
			if(color == uint.MAX_VALUE)
			{
				color = CalenderConstants.Color_TitleText ;
			}
			
			//1 generate required textFormat
			myFormat = this.getTextFormat() ;
			myFormat.size = size ;
			myFormat.font = Font ;
			myFormat.align = align ;
			myFormat.leading = lineSpacing ;
			
			this.textColor = color ;
			//2 set sample text to set format
			this.text = '1234' ;
			//3 set text  format in two ways
			this.setTextFormat(myFormat) ;
			this.defaultTextFormat = myFormat ;
			
			//4 initialize the textField
			this.embedFonts = true ;
			this.selectable = false;
			this.multiline = false ;
			this.wordWrap = false ;
			
			//5 set textField height
			this.height = this.textHeight ;
			
			//6 Clear the textField
			this.text = '' ;
		}
	}
}