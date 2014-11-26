package contents.fileSystem
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**This class is saving each data on seperated files , so it is beter to use this class on huge datas.*/
	public class SaveFileData
	{
		private static const folderName:String = "saveFileDatas" ;
		
		private static var mainFolder:File ;
		
		
		private static function setUp()
		{
			if(mainFolder == null)
			{
				mainFolder = File.applicationStorageDirectory.resolvePath(folderName);
				if(!mainFolder.exists)
				{
					mainFolder.createDirectory();
				}
			}
		}
		
		/**Save this data , use this class to save huge files*/
		public static function save(fileID:String,data:String):void
		{
			
			setUp();
			
			var fileStream:FileStream = new  FileStream();
			var currentFile:File = mainFolder.resolvePath(fileID);
			
			if(currentFile.exists)
			{
				currentFile.deleteFile();
			}
			
			fileStream.open(currentFile,FileMode.WRITE);
			trace("data : "+data);
			fileStream.writeUTFBytes(data);
			fileStream.close();
		}
		
		/**load this file*/
		public static function load(fileID):String
		{
			setUp();
			var fileStream:FileStream = new  FileStream();
			var currentFile:File = mainFolder.resolvePath(fileID);
			if(!currentFile.exists)
			{
				return '';
			}
			
			fileStream.open(currentFile,FileMode.READ);
			var cash:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			return cash ;
		}
	}
}