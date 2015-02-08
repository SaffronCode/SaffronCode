package diagrams.instagram
{
	import flash.display.MovieClip;
	
	public class DiagramValueInterface extends MovieClip
	{

		private var myTitle:InstaTitle;
		public function DiagramValueInterface(color:uint)
		{
			super();
			
			myTitle = new InstaTitle(color,InstagramConstants.Diagram_values_size,true) ;
			this.addChild(myTitle) ;
			myTitle.width = InstagramConstants.Diagram_values_width ;
			myTitle.y = myTitle.height/-2;
			//myTitle.x-=InstagramConstants.Diagram_values_width/2;
			//setTitle(String(value)) ;
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0,InstagramConstants.Diagram_Circle_width);
		}
		
		public function setTitle(text:String)
		{
			myTitle.text = text ;
		}
		
		public function blurColor(color:uint):uint
		{
			var multy:uint = 0x55 ;
			var red:uint = color&0xff0000;
			red = Math.min(0xff0000,red+multy*0x010000);
			var green:uint = color&0x00ff00;
			green = Math.min(0x00ff00,green+multy*0x000100);
			var blue:uint = color&0x0000ff;
			blue = Math.min(0x0000ff,blue+multy);
			
			
			return red+green+blue ;
		}
	}
}