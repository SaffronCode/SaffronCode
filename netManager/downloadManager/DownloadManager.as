// *************************
// * COPYRIGHT
// * DEVELOPER: MTEAM ( info@mteamapp.com )
// * ALL RIGHTS RESERVED FOR MTEAM
// * YOU CAN'T USE THIS CODE IN ANY OTHER SOFTWARE FOR ANY PURPOSE
// * YOU CAN'T SHARE THIS CODE
// *************************
/**varsion log 1.1
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * */
package netManager.downloadManager
{
	import flash.net.SharedObject;
	import flash.utils.ByteArray;

	public class DownloadManager
	{
		/**all events will dispatch here*/
		public static var contentLoaderInfo:DownLoadManagerDispatcher = new DownLoadManagerDispatcher();
		
		/**list of available download stream files*/
		private static var downloadList:Vector.<CashedDownloadData> ;
		
		
		/***start to download this file , check the correction of target , because this 
		 * class will not ever drop downloading , it will try and try and try till download completed*/
		public static function download(urlTarget:String):void
		{
			if(downloadList == null)
			{
				downloadList = new Vector.<CashedDownloadData>();
			}
			
			var oldFile:Boolean = false;
			for(var i:uint = 0 ; i<downloadList.length ; i++)
			{
				if(downloadList[i].myURL == urlTarget)
				{
					downloadList[i].resume();
					oldFile = true ;
				}
			}
			if(!oldFile)
			{
				//trace('sart load');
				var downlaodCatcher:CashedDownloadData = new CashedDownloadData();
				downloadList.push(downlaodCatcher);
				downlaodCatcher.addEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,manageProgress);
				downlaodCatcher.addEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,manageFinished);
				downlaodCatcher.addEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,manageWrongURLs);
				downlaodCatcher.setUp(urlTarget);
			}
		}
		
		/**stop the downloader for this file*/
		public static function stopDwonload(urlTarget:String):void
		{
			if(downloadList != null)
			{
				for(var i:uint = 0 ; i<downloadList.length ; i++)
				{
					if(downloadList[i].myURL == urlTarget)
					{
						downloadList[i].stop();
					}
				}
			}
		}
		
		/**forget the downloaded file*/
		public static function forget(urlTarget:String):void
		{
			
			if(downloadList!=null)
			{
				for(var i:uint = 0 ; i<downloadList.length ; i++)
				{
					if(downloadList[i].myURL == urlTarget)
					{
						downloadList[i].forget();
						downloadList.splice(i,1);
					}
				}
			}
			else
			{
				var closer:CashedDownloadData = new CashedDownloadData();
				//closer.setUp(urlTarget);
				closer.forget(urlTarget);
				closer = null ;
			}
		}
		
		/**forget the downloaded file*/
		public static function forgetAll():void
		{
			if(downloadList!=null)
			{
				for(var i:uint = 0 ; i<downloadList.length ; i++)
				{
					downloadList[i].forget();
				}
				downloadList = new Vector.<CashedDownloadData>();
			}
			else
			{
				var closer:CashedDownloadData = new CashedDownloadData();
				closer.forgetAll();
				closer = null ;
			}
		}
		
		
		
		
		
		
		
		/**send feed back of any rpogress*/
		private static function manageProgress(e:DownloadManagerEvents):void
		{
			//trace('loading ... ');
			contentLoaderInfo.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_PROGRESS,e.precent,null,e.urlID));
		}
		
		
		/**send feed back of any download finishing*/
		private static function manageFinished(e:DownloadManagerEvents):void
		{
			//trace('load finished');
			contentLoaderInfo.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_COMPLETE,e.precent,e.loadedFile,e.urlID));
		}
		
		
		/**send feed back of any download finishing*/
		private static function manageWrongURLs(e:DownloadManagerEvents):void
		{
			trace('file url is wrong');
			forget(e.urlID);
			contentLoaderInfo.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.URL_IS_NOT_EXISTS,0,null,e.urlID));
		}	
		
	}
}