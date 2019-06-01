package file
{
	import flash.filesystem.File;
	public class CheckExistsPaht
	{
		/**applicationStorageDirectory. will creates a directory on userDirectory for androids and applicationStorageDirectory for other platforms, then return a File pointed to your requested Name*/
		public static function check(Path_p:String,Name_p:String):File
		{
			var path:File;
			if (!DevicePrefrence.isAndroid())
			{
				path=File.applicationStorageDirectory.resolvePath(Path_p);
			}
			else
			{
				path=File.userDirectory.resolvePath(Path_p);
			}
			if(!path.exists)
			{
				path.createDirectory()
			}
			if (!DevicePrefrence.isAndroid())
			{
				path=File.applicationStorageDirectory.resolvePath(Path_p+Name_p);
			}
			else
			{
				path=File.userDirectory.resolvePath(Path_p+Name_p);
			}
			
			return path	
		}
		/**applicationDirectory*/
		
		
		/**applicationStorageDirectory. will creates a directory on applicationStorageDirectory for androids and userDirectory for other platforms, then return a File pointed to your requested Name*/
		public static function check2(Path_p:String,Name_p:String):File
		{
			var path:File 
			if (DevicePrefrence.isAndroid())
			{
				path=File.userDirectory.resolvePath(Path_p);
			}
			else
			{
				path=File.applicationStorageDirectory.resolvePath(Path_p);
				
			}
			
			if(!path.exists)
			{
				path.createDirectory();
			}
			if (DevicePrefrence.isAndroid())
			{
				path=File.userDirectory.resolvePath(Path_p+Name_p);
			}
			else
			{
				path=File.applicationStorageDirectory.resolvePath(Path_p+Name_p);
				
			}
			
			return path		
		}
		public static function saveToApplicationStorate(Path_p:String,Name_p:String):File
		{
			var path:File = path=File.applicationStorageDirectory.resolvePath(Path_p);
			if(!path.exists)
			{
				path.createDirectory();
			}
			path=File.applicationStorageDirectory.resolvePath(Path_p+Name_p);
			return path	;
		}
		
		public static function saveTodocumentsDirectory(Path_p:String,Name_p:String):File
		{
			var path:File = path=File.documentsDirectory.resolvePath(Path_p);
			if(!path.exists)
			{
				path.createDirectory();
			}
			path=File.documentsDirectory.resolvePath(Path_p+Name_p);
			return path	;
		}
	}
}