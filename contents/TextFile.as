package contents
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class TextFile
	{
		public static function load(fileTarget:File,skipChar:uint=0):String
		{
			if(fileTarget.exists)
			{
				var fileLoader:FileStream = new FileStream();
				fileLoader.open(fileTarget,FileMode.READ);
				//SaffronLogger.log("2. debug time : "+getTimer());
				fileLoader.position = skipChar ;
				return fileLoader.readUTFBytes(fileLoader.bytesAvailable-skipChar);
			}
			else
			{
				SaffronLogger.log(fileTarget.name+' file is not exists');
				return null ;
			}
		}
		
		public static function save(fileTarget:File,text:String):String
		{
			var textBytes:ByteArray = new ByteArray();
			textBytes.writeUTFBytes(text);
			var stat:String = FileManager.seveFile(fileTarget,textBytes);
			SaffronLogger.log("File save status : "+stat);
			return stat ;
		}
	}
}