package photoEditor
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.geom.Point;
	
	public class StampItem extends LightImage
	{
		public var firstPoint:Point ;
		
		public function StampItem(BackColor:uint=0x000000, BackAlpha:Number=0)
		{
			super(BackColor, BackAlpha);
		}
	}
}