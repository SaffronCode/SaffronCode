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
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	[Event(name="downloadComplete", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="downloadProgress", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="reloadRequired", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="urlIsNotExists", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	
	/***/
	public class FileDownloader extends EventDispatcher
	{
		private var loader:URLStream ;
		
		private var downloadRequest:URLRequest ;
		
		/**this is a download url that will use as uniqe id*/
		private var urlID:String;
		
		/**zero index of range of download*/
		private var indexByte:uint;
		
		/**start to download targeted file and continue to loadedFile*/
		public function FileDownloader(target:String,indexRangeOfDownload:uint=0):void
		{
			loader = new URLStream();
			loader.addEventListener(Event.COMPLETE,downloaderIsCompleted);
			
			indexByte  = indexRangeOfDownload ;
			
			var header:URLRequestHeader = new URLRequestHeader("range","bytes="+indexRangeOfDownload+"-");
			SaffronLogger.log('start download from : '+indexRangeOfDownload);
			downloadRequest = new URLRequest(target);
			downloadRequest.requestHeaders.push(header);
			
			loader.addEventListener(ProgressEvent.PROGRESS,tellPrecent);
			loader.addEventListener(IOErrorEvent.IO_ERROR,reLoad);
			loader.load(downloadRequest);
			SaffronLogger.log('try to load '+downloadRequest.url);
		}
		
		/**close this downloader
		public function close():void
		{
			SaffronLogger.log('close downloader');
			if(loader.
		}*/
		
		/**start over the downloading*/
		private function reLoad(e:*=null):void
		{
			SaffronLogger.log('reload');
			//this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_PROGRESS));
			this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.RELOAD_REQUIRED));
		}
		
		
		private function tellPrecent(e:ProgressEvent):void
		{
			if(false && e.bytesTotal<e.bytesLoaded)
			{
				SaffronLogger.log('over flowing : '+e.bytesTotal+' vs '+e.bytesLoaded);
				close();
				completeEvent();
				return ;
			}
			var calculatedPrecent:Number = ((e.bytesLoaded+indexByte)/(e.bytesTotal+indexByte));
			var downloadedFiles:ByteArray = new ByteArray();
			loader.position = 0 ;
			loader.readBytes(downloadedFiles);
			
			var strTest:String = downloadedFiles.toString();
			if(strTest.indexOf("404 - File or directory not found.")!=-1)
			{
				this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_PROGRESS));
				this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.URL_IS_NOT_EXISTS));
			}
			else
			{
				downloadedFiles.position = 0; 
				this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_PROGRESS,calculatedPrecent,downloadedFiles,'',e.bytesLoaded,e.bytesTotal));
			}
		}
		
		
		
		/**downloader is connected to file*/
		private function downloaderIsCompleted(e:Event):void
		{
			SaffronLogger.log('file is complete');
			close();
			completeEvent();
		}
		
		
		/**loading is finished and dowloader is closed*/
		public function close():void
		{
			if(loader != null)
			{
				loader.close();	
				loader = null ;
			}
		}
		
		/**dispatching complete event*/
		private function completeEvent():void
		{
			this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_COMPLETE,1,new ByteArray()));
		}
	}
}