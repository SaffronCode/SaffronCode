package diagrams.calender
{
	import flash.display.MovieClip;
	import flash.text.TextFormatAlign;
	
	internal class CelenderBoxContent extends MovieClip
	{
		public function CelenderBoxContent(W:Number,H:Number,cashedContents:CalenderContents )
		{
			super();
			
			
			var maxH:Number = H/cashedContents.contents.length ;
			var l:uint = cashedContents.contents.length ;
			var currentContent:CalenderContent ;
			var lastY:Number = 0 ;
			for(var i = 0 ; i<l ; i++)
			{
				currentContent = cashedContents.contents[i];
				this.graphics.beginFill(currentContent.color);
				this.graphics.drawRect(0,lastY,W,maxH);
				
				var newTitle:CalenderText = new CalenderText(CalenderConstants.Color_content_text,
					CalenderConstants.Font_size_contents,
					CalenderConstants.Font_contents_name,
					TextFormatAlign.CENTER,
					CalenderConstants.LineSpacing_content_box
				);
				newTitle.width = W ;
				newTitle.height = maxH;
				newTitle.y = lastY ;
				
				UnicodeStatic.fastUnicodeOnLines(newTitle,currentContent.title,false);
				this.addChild(newTitle);
				
				lastY+=maxH ;
			}
		}
	}
}