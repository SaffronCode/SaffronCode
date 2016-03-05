package file
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
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
			var _encoder:Base64Encoder = new Base64Encoder()
			_encoder.encodeBytes(_byte);
			return _encoder.toString()
		}
	}
}