package file
{
	import flash.filesystem.File;
	public class CheckExistsPaht
	{
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
	}
}