package netManager.urlSaver
{
	
	///import contents.fileSystem.SavedDatas;
	
	//import com.mteamapp.downloadManager.DownloadManager;
	//import com.mteamapp.downloadManager.DownloadManagerEvents;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	
	[Event(name="LOADING", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	[Event(name="NO_INTERNET", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	[Event(name="LOAD_COMPLETE", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	
	public class URLSaver extends EventDispatcher
	{
		private static var storage:SharedObject = SharedObject.getLocal('URLSaverSharedObject','/');
		private static var datestorage:SharedObject = SharedObject.getLocal('URLSaverSharedObjectForDate','/') ;
		
		private static var acceptableDate:Number = 0 ;
		
		public static function activateDateControll(noOlder:Date)
		{
			acceptableDate = noOlder.time ;
		}
		
		private static const offlineFolderName:String = "offlines";
		
		public var onlineURL:String ,
					offlineURL:String ;
					
		private var myLoadedBytes:ByteArray ;
		/**if this variable was false , load the image in byte array and pass it on event , else , just pass the ofline url*/
		private var justOfflineURL:Boolean;
		
		private var urlLoader:URLLoader ;
		
		private var maxNameLength:uint = 100 ;
		
		/**If this variable was ture, it means the URLSaver dispatched old file but it is downloading new file to override that*/
		private var justDownlaodToUpdate:Boolean ;
					
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
			
			justDownlaodToUpdate = false ;
			
			
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
				if(datestorage != null && (datestorage.data[onlineURL] == undefined || datestorage.data[onlineURL]<acceptableDate))
				{
					trace('let try to download this image : '+datestorage.data[onlineURL]+" vs "+acceptableDate);
					justDownlaodToUpdate = true ;
				}
				else
				{
					trace('the data is so fresh : '+datestorage.data[onlineURL]+" vs "+acceptableDate);
				}
				offlineURL = storage.data[onlineURL];
			}
			
			if( offlineURL == null || justDownlaodToUpdate)
			{
				//downloadThisFile
				//DownloadManager.autoReload = false ;
				urlLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY ;
				
					//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,downloadCompletes);
				urlLoader.addEventListener(Event.COMPLETE,downloadCompletes);
				
				if(!justDownlaodToUpdate)
				{
						//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,downloading);
					urlLoader.addEventListener(ProgressEvent.PROGRESS,downloading);
				}
					//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,noFileExists);
				//We don't have this Event type on urlLoaders
					//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE,noInternetConnection);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,noInternetConnection);
				//trace('listen to download manager : '+onlineURL);
					//DownloadManager.download(onlineURL);
				urlLoader.load(new URLRequest(onlineURL));
				
				if(offlineURL==null)
				{
					return false ;
				}
				else
				{
					loadOflineFile();
					
					return true ;
				}
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
			
			if(urlLoader != null)
			{
				try
				{
					urlLoader.close();
				}catch(e){};
			}
			urlLoader = null ;
			
			//DownloadManager.stopDwonload(onlineURL);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,downloadCompletes);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,downloading);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,noFileExists);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE,noInternetConnection);
		}
		
		
		protected function noInternetConnection(ev:IOErrorEvent/*DownloadManagerEvents*/):void
		{
			if(justDownlaodToUpdate)
			{
				//This image is dispatched befor
				return ;
			}
			// TODO Auto-generated method stub
			/*if(ev.urlID == onlineURL)
			{*/
				//This will dispatch this event just to tell parent to make desition on canseling download
			trace("no internet deteted : "+onlineURL);
			if(datestorage != null)
			{
				offlineURL = storage.data[onlineURL];
				if( offlineURL != null )
				{
					loadOflineFile();
					return ;
				}
			}
			this.dispatchEvent(new URLSaverEvent(URLSaverEvent.NO_INTERNET));
			/*}*/
		}
		
		protected function downloadCompletes(ev:Event/*DownloadManagerEvents*/):void
		{
			// TODO Auto-generated method stub
			/*if(ev.urlID == onlineURL)
			{*/
				
				//myLoadedBytes = new ByteArray();
				//myLoadedBytes.writeBytes(ev.loadedFile,0,ev.loadedFile.bytesAvailable);
				//trace("urlLoader.data : "+urlLoader.data);
				myLoadedBytes = urlLoader.data;
				myLoadedBytes.position = 0 ;
				
				saveLoadedBytes();
				//DownloadManager.forgetWithDilay(onlineURL);
				if(!justDownlaodToUpdate)
				{
					loadOflineFile();
				}
				else
				{
					loadOflineFile();
					trace("Image URL is updated. so be carfull for errors");
				}
				
				cansel();
			/*}*/
		}
		
		protected function downloading(ev:ProgressEvent/*DownloadManagerEvents*/):void
		{
			// TODO Auto-generated method stub
			/*if(ev.urlID == onlineURL)
			{*/
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.LOADING,urlLoader.bytesLoaded/urlLoader.bytesTotal/*ev.precent*/));
			/*}*/
		}
		
		/*protected function noFileExists(ev:DownloadManagerEvents):void
		{
			// TODO Auto-generated method stub
			if(ev.urlID == onlineURL)
			{
				cansel();
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.NO_INTERNET));
			}
		}*/
		
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
			trace("oflineFolder : "+oflineFolder.nativePath); 
			var offlineURLFileName:String = nameCash.substring(nameCash.indexOf('/')+1);
			offlineURLFileName = offlineURLFileName.split('?').join('').split('/').join('');
			offlineURLFileName = offlineURLFileName.substr(offlineURLFileName.length-Math.min(maxNameLength,offlineURLFileName.length),offlineURLFileName.length);
			trace("offlineURLFileName : "+offlineURLFileName);
			var oflineFile:File = oflineFolder.resolvePath(offlineURLFileName);
			offlineURL = oflineFile.url; 
			trace("Offline file is : "+oflineFile.nativePath);
			if(oflineFile.exists)
			{
				try
				{
					oflineFile.deleteFile();
				}
				catch(e)
				{
					storage.data[onlineURL] = offlineURL ;
					trace('***** i cannot delete this file');
					return ;
				}
			}
			
			//Now save loaded file on hard
			myLoadedBytes.position = 0 ;
			var fileSaver:FileStream = new FileStream();
			fileSaver.open(oflineFile,FileMode.WRITE);
			fileSaver.writeBytes(myLoadedBytes,0,myLoadedBytes.bytesAvailable);
			
			//SavedDatas.save(onlineURL,offlineURL);
			//trace('offile file saved on : '+onlineURL);
			storage.data[onlineURL] = offlineURL ;
			datestorage.data[onlineURL] = new Date().time ;
			//trace("datestorage.data[onlineURL] : " +datestorage.data[onlineURL]);
			datestorage.flush();
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
		/**Delete images older than this date*/
		public static function deleteDatasOlderThan(date:Date)
		{
			for(var i in datestorage.data)
			{
				if(datestorage.data[i] < date.time)
				{
					trace("This file is old : "+i);
					deletFileIfExists(i);
				}
			}
			
			/*var imageList:Array = SavedDatas.getDatasOlderThan(date);
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
				SavedDatas.removeDatasOlderThan(date);*/
		}
		
		/**This will refer back to static function with the same name*/
		public function deletFileIfExists(fileURL:String):Boolean
		{
			return deletFileIfExists(fileURL);
		}
		
		
		/**returns true if file was exist*/
		public static function deletFileIfExists(fileURL:String):Boolean
		{
			var localFileURL:String = storage.data[fileURL] ;
			if(localFileURL == null)
			{
				trace("i can not find your image");
				return false ;
			}
			else
			{
				var fileChecker:File = new File(localFileURL);
				if(fileChecker.exists)
				{
					trace("this file is deleted : "+fileChecker.url);
					try
					{
						fileChecker.deleteFile();
					}catch(e){};
				}
				trace("this file is not deleted : "+fileChecker.url);
				
				storage.data[fileURL] = undefined ;
				datestorage.data[fileURL] = undefined ;
				datestorage.flush();
				storage.flush();
				
				return true ;
			}
		}
	}
}
