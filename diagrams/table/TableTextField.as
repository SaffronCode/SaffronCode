package diagrams.table
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	internal class TableTextField extends TextField
	{
		private var myFormat:TextFormat ;
		
		public function TableTextField(color:uint=TableConstants.Color_TitleText,size:Number=TableConstants.titleFontSize,Font:String = TableConstants.fontName,align:String = TextFormatAlign.CENTER , lineSpacing:Number = 0 )
		{
			super();
			
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