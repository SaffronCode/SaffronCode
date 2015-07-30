package contents
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class TextFile
	{
		public static function load(fileTarget:File):String
		{
			var fileLoader:FileStream = new FileStream();
			fileLoader.open(fileTarget,FileMode.READ);
			//trace("2. debug time : "+getTimer());
			return fileLoader.readUTFBytes(fileLoader.bytesAvailable);
		}
		
		public static function save(fileTarget:File,text:String):void
		{
			var textBytes:ByteArray = new ByteArray();
			textBytes.writeUTFBytes(text);
			FileManager.seveFile(fileTarget,textBytes);
		}
	}
}