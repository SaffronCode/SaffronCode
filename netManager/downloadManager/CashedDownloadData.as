// *************************
// * COPYRIGHT
// * DEVELOPER: MTEAM ( info@mteamapp.com )
// * ALL RIGHTS RESERVED FOR MTEAM
// * YOU CAN'T USE THIS CODE IN ANY OTHER SOFTWARE FOR ANY PURPOSE
// * YOU CAN'T SHARE THIS CODE
// *************************

package netManager.downloadManager
{
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	[Event(name="downloadComplete", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="downloadProgress", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="urlIsNotExists", type="com.mteamapp.downloadManager.DownloadManagerEvents")]
	[Event(name="NO_INTERNET_CONNECTION_AVAILABLE", type="com.mteamapp.downloadManager.DownloadManagerEvents")]

	/**this class will store , url id , starts downloadManager , store downloade file and ...*/
	public class CashedDownloadData extends EventDispatcher
	{
///////////////////////////////////shared object variable
		private static var savedFiles:SharedObject;
		
		private static const shValName:String = "file";
		
		private static const shID:String = "downloadManagerShared"; 
		
////////////////////////////////////////////////
		/**stored url id*/
		private var url:String;
		/**stored file*/
		private var file:ByteArray;
		
		/**myDownloader class*/
		private var downloader:FileDownloader ;
		
		public function CashedDownloadData()
		{
			//now parent class have to call setUp() funciton
		}
		
		/**setting up the class*/
		public function setUp(URL:String):void
		{
			url = URL ;
			loadIfExist();
			//startOver();
			//this function will ↓ check if file download is completed
			resume();
		}
		
		/**start over download manager*/
		private function startOver():void
		{
			//trace('start loading');
			downloader = new FileDownloader(url,file.length);
			downloader.addEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,someDataLoaded);
			downloader.addEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,fileIsComplete);
			downloader.addEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,fileIsNotExists);
			downloader.addEventListener(DownloadManagerEvents.RELOAD_REQUIRED,resume);
		}
		
		private function fileIsNotExists(e:DownloadManagerEvents)
		{
			trace('file is not exists on server');
			this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.URL_IS_NOT_EXISTS,0,null,url));
		}
										 
		
		/**stop downloading of this file*/
		public function stop():void
		{
			if(downloader!=null)
			{
				downloader.close();
			}
			downloader = null ;
		}
		
		/**forget evety thing abput this file*/
		public function forget(URL:String=''):void
		{
			if(URL!='')
			{
				url = URL ;
			}
			trace('cansel loading');
			stop();
			removeMyCashedFile();
		}
		
		/**forget every thing and every files*/
		public function forgetAll():void
		{
			loadSavedFiles(true)
		}
		
		
		/**cash this data*/
		private function someDataLoaded(e:DownloadManagerEvents):void
		{
			//trace('download precent is : '+e.precent+' new bytes are : '+e.loadedFile.length);
			saveNewBytes(e.loadedFile);
			this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_PROGRESS,e.precent,null,url));
		}
		
		/***start or resume download*/
		public function resume(e:*=null):void
		{
			if(tellIfCompleted())
			{
				//trace('this file is completed befor');
				fileIsComplete();
			}
			else
			{
				this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE));
				startOver();
			}
		}
		
		/**file is downloaded*/
		private function fileIsComplete(e:DownloadManagerEvents=null):void
		{
			//trace('tell that the file is completed');
			markCompletedDownload();
			this.dispatchEvent(new DownloadManagerEvents(DownloadManagerEvents.DOWNLOAD_COMPLETE,1,file,url));
		}
		
		
		
		/**returns url id*/
		public function get myURL():String
		{
			return url ;
		}
		
/////////////////////////////////////////sharedobject manager
		/**load sharedOBject if it wasnot*/
		private function loadSavedFiles(forceToRemove:Boolean=false):void
		{
			if(savedFiles == null || forceToRemove)
			{
				savedFiles = SharedObject.getLocal(shID,'/');
				
				if(forceToRemove || savedFiles.data[shValName]==undefined)
				{
					savedFiles.data[shValName] = [];
					savedFiles.flush();
				}
			}
		}
		
		/**load the byteArray of currentID , it will load shared object from static shared object*/
		private function loadIfExist():void
		{
			//trace('try to load cashed download file');
			loadSavedFiles() ;
			file = new ByteArray();
			for(var i:uint = 0 ; i<(savedFiles.data[shValName] as Array).length ; i++)
			{
				if(savedFiles.data[shValName][i][0] == url && savedFiles.data[shValName][i][1]!=undefined)
				{
					file.writeBytes((savedFiles.data[shValName][i][1] as ByteArray));
					file.position = 0 ;
					//trace('cashed file is : '+file.length);
					break ;
				}
			}
		}
		
		/**save these nea bytes*/
		private function saveNewBytes(newBytes:ByteArray):void
		{
			loadSavedFiles() ;
			newBytes.position = 0 ;
			file.position = file.length ;
			file.writeBytes(newBytes);
			var foundedI:uint = (savedFiles.data[shValName] as Array).length ;
			for(var i:uint = 0 ; i<foundedI ; i++)
			{
				if(savedFiles.data[shValName][i][0] == url )
				{
					foundedI = i ;
					break ;
				}
			}
			//trace('foundedI : '+foundedI);
			file.position = 0 ;
			savedFiles.data[shValName][foundedI] = [url,file];
			//trace('saved file is : '+(savedFiles.data[shValName][foundedI][1] as ByteArray).length);
			savedFiles.flush();
		}
		
		/**remove cashed data from shared object*/
		private function removeMyCashedFile():void
		{
			loadSavedFiles() ;
			for(var i:uint = 0 ; i<(savedFiles.data[shValName] as Array).length ; i++)
			{
				if(savedFiles.data[shValName][i][0] == url )
				{
					(savedFiles.data[shValName] as Array).splice(i,1);
					savedFiles.flush();
					break ;
				}
			}
		}
		
		/**mark the completed file*/
		private function markCompletedDownload():void
		{
			loadSavedFiles() ;
			for(var i:uint = 0 ; i<(savedFiles.data[shValName] as Array).length ; i++)
			{
				if(savedFiles.data[shValName][i][0] == url )
				{
					savedFiles.data[shValName][i][3] = true ;
					savedFiles.flush();
					break ;
				}
			}
		}
		
		/**tell if this file is downloaded completly befor*/
		private function tellIfCompleted():Boolean
		{
			loadSavedFiles() ;
			for(var i:uint = 0 ; i<(savedFiles.data[shValName] as Array).length ; i++)
			{
				if(savedFiles.data[shValName][i][0] == url )
				{
					if(savedFiles.data[shValName][i][3]==undefined)
					{
						return false;
					}
					else
					{
						return true ;
					}
					break ;
				}
			}
			return false;
		}
	}
}