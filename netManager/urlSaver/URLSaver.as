package netManager.urlSaver
{
	
	///import contents.fileSystem.SavedDatas;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import netManager.downloadManager.DownloadManager;
	import netManager.downloadManager.DownloadManagerEvents;

	
	[Event(name="LOADING", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	[Event(name="NO_INTERNET", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	[Event(name="LOAD_COMPLETE", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	
	public class URLSaver extends EventDispatcher
	{
		private static var storage:SharedObject = SharedObject.getLocal('URLSaverSharedObject','/');
		
		
		private static const offlineFolderName:String = "offlines";
		
		public var onlineURL:String ,
					offlineURL:String ;
					
		private var myLoadedBytes:ByteArray ;
		/**if this variable was false , load the image in byte array and pass it on event , else , just pass the ofline url*/
		private var justOfflineURL:Boolean;
		
					
		/**you have to call load() function to start file loading proccess<br>
		 * if you set true in this value , it will not load byte array of your file and it will just return URL*/
		public function URLSaver(justReturnOfflineURL:Boolean = false )
		{
			justOfflineURL = justReturnOfflineURL ;
		}
		
		/**Start to load my file<br>
		 * this function will return true if image was offline*/
		public function load(url:String):Boolean
		{
			onlineURL = url ;
			offlineURL = null ;
			
			
			trace("Requested image url is : "+onlineURL);
			var localFileChecker:File;
			try
			{
				localFileChecker = new File(onlineURL);
			}
			catch(e)
			{
				try
				{
					localFileChecker = File.applicationDirectory.resolvePath(onlineURL);
				}
				catch(e)
				{
					localFileChecker = null ;
				}
			}
			
			
			if(localFileChecker!=null && localFileChecker.exists)
			{
				//This file is local already
				offlineURL = localFileChecker.url ;
			}
			else
			{
				//This file is loaded befor
				//offlineURL = SavedDatas.load(onlineURL) ;
				offlineURL = storage.data[onlineURL];
			}
			
			if( offlineURL == null )
			{
				//downloadThisFile
				DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,downloadCompletes);
				DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,downloading);
				DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,noFileExists);
				DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE,noInternetConnection);
				trace('listen to download manager : '+onlineURL);
				DownloadManager.download(onlineURL);
				
				return false ;
			}
			else
			{
				//return itsByteArray
				//Do not save online location again on shared objects
					//SavedDatas.save(onlineURL,offlineURL);
				
				loadOflineFile();
				
				return true ;
			}
			
		}
		
		/**Cansel current download*/
		public function cansel()
		{
			trace('Cansel donwload manager : '+onlineURL);
			
			DownloadManager.stopDwonload(onlineURL);
			DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,downloadCompletes);
			DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,downloading);
			DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,noFileExists);
			DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE,noInternetConnection);
		}
		
		
		protected function noInternetConnection(event:DownloadManagerEvents):void
		{
			// TODO Auto-generated method stub
			if(event.urlID == onlineURL)
			{
				//This will dispatch this event just to tell parent to make desition on canseling download
				trace("no internet deteted : "+onlineURL);
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.NO_INTERNET));
			}
		}
		
		protected function downloadCompletes(event:DownloadManagerEvents):void
		{
			// TODO Auto-generated method stub
			if(event.urlID == onlineURL)
			{
				cansel();
				
				myLoadedBytes = new ByteArray();
				myLoadedBytes.writeBytes(event.loadedFile,0,event.loadedFile.bytesAvailable);
				myLoadedBytes.position = 0 ;
				
				saveLoadedBytes();
				DownloadManager.forget(onlineURL);
				loadOflineFile();
			}
		}
		
		protected function downloading(event:DownloadManagerEvents):void
		{
			// TODO Auto-generated method stub
			if(event.urlID == onlineURL)
			{
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.LOADING,event.precent));
			}
		}
		
		protected function noFileExists(event:DownloadManagerEvents):void
		{
			// TODO Auto-generated method stub
			if(event.urlID == onlineURL)
			{
				cansel();
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.NO_INTERNET));
			}
		}
		
	//////////////////////////////////Network process are completed now ↓
		
		private function saveLoadedBytes():void
		{
			// TODO Auto Generated method stub
			var oflineFolder:File = File.applicationStorageDirectory.resolvePath(offlineFolderName);
			if(!oflineFolder.exists)
			{
				oflineFolder.createDirectory();
			}
			var nameCash:String = onlineURL.split('\\').join('/');
			var offlineURLFileName:String = nameCash.substring(nameCash.lastIndexOf('/')+1);
			offlineURLFileName = offlineURLFileName.split('?').join('');
			trace("name : "+offlineURLFileName);
			var oflineFile:File = oflineFolder.resolvePath(offlineURLFileName);
			offlineURL = oflineFile.url; 
			
			if(oflineFile.exists)
			{
				oflineFile.deleteFile();
			}
			
			//Now save loaded file on hard
			myLoadedBytes.position = 0 ;
			var fileSaver:FileStream = new FileStream();
			fileSaver.open(oflineFile,FileMode.WRITE);
			fileSaver.writeBytes(myLoadedBytes,0,myLoadedBytes.bytesAvailable);
			
			//SavedDatas.save(onlineURL,offlineURL);
			storage.data[onlineURL] = offlineURL ;
			storage.flush();
		}
		
		
		/**load offline file as user wished*/
		private function loadOflineFile():void
		{
			// TODO Auto Generated method stub
			if(!justOfflineURL)
			{
				//load byte array
				if(myLoadedBytes == null || myLoadedBytes.length == 0)
				{
					var fileLoader:FileStream = new FileStream();
					var fileTarger:File = new File(offlineURL);
					fileLoader.open(fileTarger,FileMode.READ);
					myLoadedBytes = new ByteArray();
					fileLoader.readBytes(myLoadedBytes,0,fileLoader.bytesAvailable);
				}
				myLoadedBytes.position = 0 ;
			}
			else
			{
				myLoadedBytes = null ;
			}
			this.dispatchEvent(new URLSaverEvent(URLSaverEvent.LOAD_COMPLETE,1,myLoadedBytes,offlineURL));
		}
		
		
//////////////////////////////////////////////delete temporary
		/**Delete images older than this date
		public static function deleteDatasOlderThan(date:Date)
		{
			var imageList:Array = SavedDatas.getDatasOlderThan(date);
			var fileChecker:File ; 
			for(var i = 0 ; i<imageList.length ; i++)
			{
				fileChecker = new File(imageList[i]);
				if(fileChecker.exists)
				{
					fileChecker.deleteFile();
					//trace("this file deleted : "+imageList[i]);
				}
				else
				{
					//trace("File not found : "+imageList[i]);
				}
			}
			//Delete all saved datas whenever all provess tested
				SavedDatas.removeDatasOlderThan(date);
		}*/
		
		
		/**returns true if file was exist*/
		public function deletFileIfExists(fileURL:String):Boolean
		{
			var localFileURL:String = storage.data[fileURL] ;
			if(localFileURL == null)
			{
				return false ;
			}
			else
			{
				var fileChecker:File = new File(localFileURL);
				if(fileChecker.exists)
				{
					trace("this file is deleted : "+fileChecker.url);
					fileChecker.deleteFile();
				}
				trace("this file is not deleted : "+fileChecker.url);
				
				storage.data[fileURL] = undefined ;
				
				ScrollMT
				
				return true ;
			}
		}
	}
}
