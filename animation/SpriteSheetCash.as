package animation
{
	import flash.display.BitmapData;

	internal class SpriteSheetCash
	{
		public var frames:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		public var id:String ;
		
		public function SpriteSheetCash(id:String)
		{
			this.id = id ;
		}
	}
}