package diagrams.instagram
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	public class InstaTitle extends MovieClip
	{
		private var myText:InstaText ;
		
		public function InstaTitle(color:uint = InstagramConstants.Diagram_colors , size:Number = InstagramConstants.DiagramMainTitles_size , glow:Boolean = false )
		{
			super();
			
			/*this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0,0,2);*/
			
			myText = new InstaText(color,size);
			
			if(glow)
			{
				var glowFilter:GlowFilter = new GlowFilter(0xffffff,1,5,5,1000,1);
				myText.filters = [glowFilter];
			}
			
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
		
		public function addVerticalLeverMeter():void
		{
			
			this.graphics.lineStyle(InstagramConstants.Diagram_guide_line_thickness,InstagramConstants.Diagram_colors);
			//SaffronLogger.log("myText.width : "+myText.width);
			this.graphics.moveTo(myText.width,myText.height/2);
			this.graphics.lineTo(myText.width+InstagramConstants.Diagram_title_lineWidth,myText.height/2);
		}
		
		public function addHorizontalLeverMeter():void
		{
			
			this.graphics.lineStyle(InstagramConstants.Diagram_guide_line_thickness,InstagramConstants.Diagram_colors);
			//SaffronLogger.log("myText.width : "+myText.width);
			this.graphics.moveTo(myText.width/2,0);
			this.graphics.lineTo(myText.width/2,-InstagramConstants.Diagram_title_lineHeight);
		}
	}
}