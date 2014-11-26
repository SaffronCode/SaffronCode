// *************************
// * COPYRIGHT
// * DEVELOPER: MTEAM ( info@mteamapp.com )
// * ALL RIGHTS RESERVED FOR MTEAM
// * YOU CAN'T USE THIS CODE IN ANY OTHER SOFTWARE FOR ANY PURPOSE
// * YOU CAN'T SHARE THIS CODE
// *************************

package netManager.downloadManager
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class DownloadManagerEvents extends Event
	{
		public static const DOWNLOAD_COMPLETE:String = "downloadComplete";
		
		public static const RELOAD_REQUIRED:String = "reloadRequired";
		
		public static const DOWNLOAD_PROGRESS:String = "downloadProgress";
		
		public static const URL_IS_NOT_EXISTS:String = "urlIsNotExists";
		
		public static const NO_INTERNET_CONNECTION_AVAILABLE:String = "NO_INTERNET_CONNECTION_AVAILABLE";
		
		/**downloaded file precent 0 - 1*/
		public var precent:Number;
		
		/**downloaded file*/
		public var loadedFile:ByteArray;
		
		/**the event url id*/
		public var urlID:String ;
		
		/**total size of the content*/
		public var totalBytes:Number ;
		
		/**size of loaded file*/
		public var loadedBytes:Number ; 
		
		/**return downloaded file precent and downloaded file*/
		public function DownloadManagerEvents(type:String,Precent:Number=0,file:ByteArray=null,UrlID:String='',LoadedBytes:Number = 0 , TotalBytes:Number = 0)
		{
			precent = Precent ;
			urlID = UrlID ;
			loadedFile = new ByteArray();
			if(file!=null)
			{
				loadedFile.writeBytes(file);
				loadedFile.position = 0 ;
			}
			super(type);
		}

	}
}