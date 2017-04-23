package file
{
	import flash.filesystem.File;
	public class CheckExistsPaht
	{
		/**applicationStorageDirectory*/
		public static function check(Path_p:String,Name_p:String):File
		{
			var path:File = File.applicationStorageDirectory.resolvePath(Path_p);
			if(!path.exists)
			{
				path.createDirectory()
			}
			path = File.applicationStorageDirectory.resolvePath(Path_p+Name_p)
			
			return path		
		}
		/**applicationDirectory*/
		public static function check2(Path_p:String,Name_p:String):File
		{
			var bases:Array = File.getRootDirectories()
			var basePath:File = bases[0] as File;
			var path:File = basePath.resolvePath(Path_p);
	
			if(!path.exists)
			{
				path.createDirectory()
			}
			path = basePath.resolvePath(Path_p+Name_p)
			
			return path		
		}
	}
}