package contents.alert
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class SaffronLogger
	{
		private static var todayFile:File ;
		
		private static var todayFileStream:FileStream ;
		
		private static function init():void
		{
			if(todayFile!=null)
			{
				return ;
			}
			var fileName:String = "SaffronCodeLog"+new Date().time;
			if(DevicePrefrence.isIOS())
			{
				todayFile = File.applicationStorageDirectory.resolvePath(fileName);
			}
			else
			{
				todayFile = File.userDirectory.resolvePath(fileName);
			}
			if(todayFile.exists)
			{
				todayFile.deleteFile();
			}
			Alert.show("Log file located on "+todayFile.nativePath);
			todayFileStream = new FileStream();
			todayFileStream.openAsync(todayFile,FileMode.WRITE);
		}
		
		public static function log(str:*):void
		{
			init();
			todayFileStream.writeUTFBytes(str+'\n\n');
		}
	}
}