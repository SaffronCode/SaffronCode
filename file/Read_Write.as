package file
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class Read_Write
	{
		public static function read(Path_p:File):ByteArray
		{	
			if(!Path_p.exists)
			{
				return null
			}
			var _byteArray:ByteArray = new ByteArray()
			var _stream:FileStream = new FileStream()
				_stream.open(Path_p,FileMode.READ)
				_stream.readBytes(_byteArray)
				_stream.close()
				_byteArray.position = 0
			return _byteArray	
			
		}
		public static function write(Path_p:File,ByteArray_p:ByteArray):String
		{
			try
			{
				if(Path_p.exists)
				{
					Path_p.deleteFile()
				}
				var _stream:FileStream = new FileStream()
					_stream.open(Path_p,FileMode.WRITE)
					ByteArray_p.position = 0
					_stream.writeBytes(ByteArray_p,0,ByteArray_p.bytesAvailable)
					_stream.close()	
			}
			catch(event:Error)
			{
				return event.message;
			}
			return '';
		}
	}	
}