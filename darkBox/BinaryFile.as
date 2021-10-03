package darkBox
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class BinaryFile extends DefaultImage
	{
		private var hintMC:MovieClip ;
		
		public function BinaryFile()
		{
			super();
			
			hintMC = Obj.get("hint_txt",this);
		}
		
		override public function setUp(newSize:Rectangle):void
		{
			super.setUp(newSize);
			hintMC.x = (rect.width-hintMC.width)/2;
			hintMC.y = (rect.height-hintMC.height)/2;
		}
		
	}
}