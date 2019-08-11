package file
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import com.Base64;
	
	public class ToBase64Encoder
	{
		private var _byte:ByteArray;
		public function ToBase64Encoder()
		{
		}
		public function setup(Url_p:String):String
		{
			var _file:File = File.desktopDirectory.resolvePath(Url_p)
			_byte = Read_Write.read(_file)	
			return Base64.EncodeByte(_byte);
		}
	}
}