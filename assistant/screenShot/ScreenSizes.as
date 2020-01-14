package assistant.screenShot
{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class ScreenSizes
	{
		public var name:String ;
		public var sizes:Array ;
		public function ScreenSizes(name:String,...screenSizes):void
		{
			this.name = name ;
			this.sizes = screenSizes ;
		}
	}
}