package diagrams.table
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	internal class TableTextField extends TextField
	{
		private var myFormat:TextFormat ;
		
		public function TableTextField(color:int=-1,size:Number=-1,Font:String = '',align:String = '' , lineSpacing:Number = 0 )
		{
			super();

			
			if(align=='')
			{
				align = TextFormatAlign.CENTER ;
			}
			if(Font=='')
			{
				Font = TableConstants.fontName ;
			}
			if(color==-1)
			{
				color = TableConstants.Color_TitleText ;
			}
			if(size==-1)
			{
				TableConstants.titleFontSize
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