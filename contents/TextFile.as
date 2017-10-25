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
			if(fileTarget.exists)
			{
				var fileLoader:FileStream = new FileStream();
				fileLoader.open(fileTarget,FileMode.READ);
				//trace("2. debug time : "+getTimer());
				return fileLoader.readUTFBytes(fileLoader.bytesAvailable);
			}
			else
			{
				trace(fileTarget.name+' file is not exists');
				return '' ;
			}
		}
		
		public static function save(fileTarget:File,text:String):String
		{
			var textBytes:ByteArray = new ByteArray();
			textBytes.writeUTFBytes(text);
			var stat:String = FileManager.seveFile(fileTarget,textBytes);
			trace("File save status : "+stat);
			return stat ;
		}
	}
}