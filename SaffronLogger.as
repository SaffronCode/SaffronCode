package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import com.mteamapp.StringFunctions;
	import diagrams.calender.MyShamsi;
	import flash.utils.getTimer;
	import flash.permissions.PermissionStatus;
	import flash.events.PermissionEvent;

	public class SaffronLogger
	{
		private static var todayFile:File ;
		
		private static var todayFileStream:FileStream ;

		private static var _trace:Boolean = true ;

		private static var _logs:Boolean = false ;

		public static function traceIsActive():Boolean
		{
			return _trace;
		}

		public static function deactiveTraces():void
		{
			_trace = false ;
		}

		public static function activateTraces():void
		{
			_trace = true ;
		}

		public static function activateLogs():void
		{
			_logs = true ;
		}

		public static function deactiveLogs():void
		{
			_logs = false ;
		}
		
		private static function init():void
		{
			if(todayFileStream!=null)
			{
				return ;
			}
			var shamsiDate:MyShamsi = MyShamsi.miladiToShamsi(new Date());
			var fileName:String = shamsiDate.fullYear
				+StringFunctions.numToString(shamsiDate.month+1)
				+StringFunctions.numToString(shamsiDate.date)
				+StringFunctions.numToString(shamsiDate.hours)
				+StringFunctions.numToString(shamsiDate.minutes)
				+StringFunctions.numToString(shamsiDate.seconds)+".log";
			var projectFolderName:String = DevicePrefrence.appID;
			if(DevicePrefrence.isIOS())
			{
				todayFile = File.applicationStorageDirectory;
			}
			else
			{
				todayFile = File.userDirectory;
				todayFile = todayFile.resolvePath(projectFolderName);
				trace("create a folder : "+todayFile.nativePath+" > "+todayFile.exists);
				if(!todayFile.exists)
				{
					todayFile.createDirectory();
				}
				if(!todayFile.isDirectory)
				{
					todayFile = todayFile.parent ;
				}
				trace("todayFile : "+todayFile.nativePath);
			}
			todayFile = todayFile.resolvePath(fileName);

			if(todayFile.exists)
			{
				todayFile.deleteFile();
			}

			var _file:File = new File() ;
			trace("File.permissionStatus : "+File.permissionStatus);
			if (File.permissionStatus != PermissionStatus.GRANTED)
			{
				_file.addEventListener(PermissionEvent.PERMISSION_STATUS,
					function(e:PermissionEvent):void {
						if (e.status == PermissionStatus.GRANTED)
						{
							filePermissionGranted();
						}
						else
						{
							trace("permission denied");
						}
					}
				);
				
				trace("Ask user for permission");
				try {
					_file.requestPermission();
				} catch(e:Error)
				{
					trace("another request is in progress");
				}
			}
			else
			{
				trace("File permission granted");
				filePermissionGranted();
			}

			function filePermissionGranted():void
			{
				trace("Log file located on "+todayFile.nativePath);
				todayFileStream = new FileStream();
				todayFileStream.openAsync(todayFile,FileMode.WRITE);
				todayFileStream.writeShort(-2);
			}
		}
		
		public static function log(...str):void
		{
			if(_logs)
				init();
			if(_trace)
				trace.apply(null,str);
			if(_logs && todayFileStream)
				todayFileStream.writeUTFBytes("<<getTimer:"+getTimer()+">>\n"+str.toString()+'\n');
		}
	}
}