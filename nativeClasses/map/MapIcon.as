package nativeClasses.map
{
	import flash.display.BitmapData;
	import flash.filesystem.File;

	public class MapIcon
	{
		internal var Id:String;
		
		internal var bitmapData:BitmapData ;
		
		public function MapIcon(imageBitmap:BitmapData,id:String)
		{
			Id = id ;
			bitmapData = imageBitmap.clone();
		}
		
	}
}