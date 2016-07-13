/**Version 1.0
	There is no need to trace urls any more
 * **/



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
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.utils.Base64Encoder;
	
	
	[Event(name="LOADING", type="netManager.urlSaver.URLSaverEvent")]
	[Event(name="NO_INTERNET", type="netManager.urlSaver.URLSaverEvent")]
	[Event(name="LOAD_COMPLETE", type="netManager.urlSaver.URLSaverEvent")]
	[Event(name="UPDATED", type="netManager.urlSaver.URLSaverEvent")]
	
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
					offlineURL:String,
					fileExtention:String,
					fileNameOnStorage:String;
					
		private var myLoadedBytes:ByteArray ;
		/**if this variable was false , load the image in byte array and pass it on event , else , just pass the ofline url*/
		private var justOfflineURL:Boolean;
		
		private var urlLoader:URLLoader ;
		
		private var maxNameLength:uint = 100 ;
		
		/**If this variable was ture, it means the URLSaver dispatched old file but it is downloading new file to override that*/
		private var justDownlaodToUpdate:Boolean ;
		
		
		/**The loader will not close till the image is loaded*/
		private var reloadTimeOutId:uint,
					reloadTime:uint = 10000;

					/**Async file saver*/
		private var fileSaver:FileStream;

		/**File loader manager*/
		private var fileLoader:FileStream;

		/**File target manager*/
		private var fileTarger:File;
					
		/**you have to call load() function to start file loading proccess<br>
		 * if you set true in this value , it will not load byte array of your file and it will just return URL*/
		public function URLSaver(justReturnOfflineURL:Boolean = false )
		{
			justOfflineURL = justReturnOfflineURL ;
		}
		
		/**Start to load my file<br>
		 * this function will return true if image was offline*/
		public function load(url:String,myAcceptableDate:Date=null,extention:String=null,fileName:String=null):Boolean
		{
			onlineURL = url ;
			offlineURL = null ;
			fileExtention = extention ;
			fileNameOnStorage = fileName ;
			
			if(url=='')
			{
				trace("Requested Url is ''. are you serius??");
				return false;
			}
			
			if(myAcceptableDate==null)
			{
				myAcceptableDate = new Date();
				myAcceptableDate.time = acceptableDate ;
			}
			
			justDownlaodToUpdate = false ;
			
			
			//trace("Requested image url is : "+onlineURL);
			var localFileChecker:File;
			if(onlineURL.indexOf('http')!=0)
			{
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
			}
			
			
			if(localFileChecker!=null && localFileChecker.exists)
			{
				//This file is local already
				//trace("The file is exists");
				offlineURL = localFileChecker.url ;
			}
			else
			{
				//This file is loaded befor
				//offlineURL = SavedDatas.load(onlineURL) ;
				if(datestorage != null && (datestorage.data[onlineURL] == undefined || datestorage.data[onlineURL]<myAcceptableDate.time))
				{
					//trace('let try to download this image : '+datestorage.data[onlineURL]+" vs "+acceptableDate);
					justDownlaodToUpdate = true ;
				}
				else
				{
					//trace('the data is so fresh : '+datestorage.data[onlineURL]+" vs "+acceptableDate);
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
				
				/*if(!justDownlaodToUpdate)
				{
						//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,downloading);
					trace("Listen to progress");
					urlLoader.addEventListener(ProgressEvent.PROGRESS,downloading);
				}*///Why?? I whant you to listen to this event any way
				urlLoader.addEventListener(ProgressEvent.PROGRESS,downloading);
				
				//trace("justDownlaodToUpdate : "+justDownlaodToUpdate);
					//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,noFileExists);
				//We don't have this Event type on urlLoaders
					//DownloadManager.contentLoaderInfo.addEventListener(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE,noInternetConnection);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,noInternetConnection);
				//trace('listen to download manager : '+onlineURL);
					//DownloadManager.download(onlineURL);
				//urlLoader.load(new URLRequest(onlineURL));
				//trace("Load url");
				reLoadUrlLoader();
				
				//trace("offlineURL : "+offlineURL);
				if(offlineURL==null)
				{
					return false ;
				}
				else
				{
					//trace("Load the offline url");
					loadOflineFile();
					
					return true ;
				}
			}
			else
			{
				//return itsByteArray
				//Do not save online location again on shared objects
					//SavedDatas.save(onlineURL,offlineURL);
				//trace("Load offline file2");
				loadOflineFile();
				
				return true ;
			}
			
		}
		
		/**reload the image*/
		private function reLoadUrlLoader():void
		{
			clearTimeout(reloadTimeOutId);
			//trace("Reload the url : "+onlineURL);
			urlLoader.load(new URLRequest(onlineURL));
		}
		
		/**Cansel current download*/
		public function cansel()
		{
			//trace('Cansel donwload manager : '+onlineURL);
			if(fileSaver)
			{
				fileSaver.close();
			}
			if(fileLoader)
			{
				fileLoader.close();
			}
			clearTimeout(reloadTimeOutId);
			if(urlLoader != null)
			{
				try
				{
					//trace("URL is closed for "+onlineURL);
					urlLoader.close();
				}catch(e){};
			}
			//trace("URI loaded is null for : "+onlineURL);
			urlLoader = null ;
			
			//DownloadManager.stopDwonload(onlineURL);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.DOWNLOAD_COMPLETE,downloadCompletes);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.DOWNLOAD_PROGRESS,downloading);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.URL_IS_NOT_EXISTS,noFileExists);
			//DownloadManager.contentLoaderInfo.removeEventListener(DownloadManagerEvents.NO_INTERNET_CONNECTION_AVAILABLE,noInternetConnection);
		}
		
		
		protected function noInternetConnection(ev:IOErrorEvent/*DownloadManagerEvents*/):void
		{
			//trace("Connection error");
			if(justDownlaodToUpdate)
			{
				//This image is dispatched befor
				//trace("The image was dispatched befor");
				return ;
			}
			// TODO Auto-generated method stub
			/*if(ev.urlID == onlineURL)
			{*/
				//This will dispatch this event just to tell parent to make desition on canseling download
			//trace("no internet deteted : "+onlineURL);
			if(datestorage != null)
			{
				offlineURL = storage.data[onlineURL];
				if( offlineURL != null )
				{
					loadOflineFile();
					return ;
				}
			}
			//trace("Reload download request for "+onlineURL+" for the next "+reloadTime+" miliseconds later");
			reloadTimeOutId = setTimeout(reLoadUrlLoader,reloadTime);
			return ;
			//Do not dispatch NO_INTERNET ever!!
			this.dispatchEvent(new URLSaverEvent(URLSaverEvent.NO_INTERNET));
			/*}*/
		}
		
		protected function downloadCompletes(ev:Event/*DownloadManagerEvents*/):void
		{
			//trace("URL file is downloaded : "+urlLoader+' ..... ');
			// TODO Auto-generated method stub
			/*if(ev.urlID == onlineURL)
			{*/
			if(urlLoader==null || urlLoader.data == null || urlLoader.data.length==0)
			{
				//trace("No file loaded : "+onlineURL);
				noInternetConnection(null);
				return ;
			}
				
				//myLoadedBytes = new ByteArray();
				//myLoadedBytes.writeBytes(ev.loadedFile,0,ev.loadedFile.bytesAvailable);
				//trace("urlLoader.data : "+urlLoader.data);
				myLoadedBytes = urlLoader.data;
				myLoadedBytes.position = 0 ;
				
				//trace("Downloaded bytes are : "+myLoadedBytes.length);
				
				saveLoadedBytes();
				//Moved to the above function 
				//loadOflineFile();
				
			/*}*/
		}
		
		protected function downloading(ev:ProgressEvent/*DownloadManagerEvents*/):void
		{
			//trace("Somthing downloaded");
			// TODO Auto-generated method stub
			/*if(ev.urlID == onlineURL)
			{*/
			//trace("Downloading");
			if(urlLoader!=null)
			{
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.LOADING,urlLoader.bytesLoaded/urlLoader.bytesTotal/*ev.precent*/));
			}
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
			var oflineFolder:File;
			if(fileExtention!=null && fileExtention.toLowerCase().indexOf('pdf')!=-1)
			{
				oflineFolder = File.documentsDirectory.resolvePath(offlineFolderName);			
			}
			else
			{
				oflineFolder = File.applicationStorageDirectory.resolvePath(offlineFolderName);
			}
			if(!oflineFolder.exists)
			{
				oflineFolder.createDirectory();
			}
			var nameCash:String = onlineURL.split('\\').join('/');
			//trace("oflineFolder : "+oflineFolder.nativePath); 
			var offlineURLFileName:String = nameCash.substring(nameCash.indexOf('/')+1);
			offlineURLFileName = offlineURLFileName.split('?').join('Q').split('/').join('').split('=').join('').split(':').join('');
			offlineURLFileName = offlineURLFileName.substr(offlineURLFileName.length-Math.min(maxNameLength,offlineURLFileName.length),offlineURLFileName.length);
			//offlineURLFileName = Base64.Encode(offlineURLFileName);
			//trace("offlineURLFileName : "+offlineURLFileName);
			
			var offlineFileNameWithExtention:String ;
			
			if(false && fileNameOnStorage!=null)
			{
				offlineFileNameWithExtention = fileNameOnStorage;
			}
			else
			{
				offlineFileNameWithExtention = offlineURLFileName;
			}
			
			if(fileExtention!=null)
			{
				offlineFileNameWithExtention+=fileExtention;
			}
			
			
			var oflineFile:File = oflineFolder.resolvePath(offlineFileNameWithExtention);
			offlineURL = oflineFile.url; 
			//trace("Offline file is : "+oflineFile.nativePath);
			//trace("Offline file url is "+offlineURL);
			if(oflineFile.exists)
			{
				try
				{
					oflineFile.deleteFile();
				}
				catch(e)
				{
					storage.data[onlineURL] = offlineURL ;
					//trace('***** i cannot delete this file');
					return ;
				}
			}
			
			//Now save loaded file on hard
			myLoadedBytes.position = 0 ;
			if(fileSaver)
			{
				fileSaver.close();
				fileSaver = null ;
			}
			fileSaver = new FileStream();
			fileSaver.addEventListener(Event.CLOSE,fileIsSaved);
			fileSaver.addEventListener(IOErrorEvent.IO_ERROR,fileSaverError);
			fileSaver.openAsync(oflineFile,FileMode.WRITE);
			fileSaver.writeBytes(myLoadedBytes);
			fileSaver.close();
			//trace("Save the imafe on device...................................... : "+oflineFile.url+' > '+myLoadedBytes.bytesAvailable);
			
			//SavedDatas.save(onlineURL,offlineURL);
			//trace('offile file saved on : '+onlineURL);
			storage.data[onlineURL] = offlineURL ;
			datestorage.data[onlineURL] = new Date().time ;
			//trace("datestorage.data[onlineURL] : " +datestorage.data[onlineURL]);
			datestorage.flush();
			storage.flush();
		}
		
		protected function fileSaverError(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			//trace("URL saver file is not write able. saveLoadedByte");
			fileSaver.close();
			loadOflineFile();
		}
		
		protected function fileIsSaved(event:Event):void
		{
			//trace("******************************** File is ready to save on the device ****************");
			// TODO Auto-generated method stub
			loadOflineFile();
		}		
		
		/**load offline file as user wished*/
		private function loadOflineFile():void
		{
			// TODO Auto Generated method stub
			
			try
			{
				fileTarger = new File(offlineURL);
			}
			catch(e)
			{
				trace("I cannot find this offline file");
			}
			var waitTillFileLoaded:Boolean = false ;
			//I have to open the file to contrill the file size
			if(!justOfflineURL && fileTarger!=null && fileTarger.exists)
			{
				//load byte array
				if(myLoadedBytes == null || myLoadedBytes.length == 0)
				{
					if(fileLoader)
					{
						fileLoader.close();
						fileLoader = null ;
					}
					waitTillFileLoaded = true ;
					fileLoader = new FileStream();
					fileLoader.addEventListener(Event.COMPLETE,fileLoaded);
					fileLoader.addEventListener(IOErrorEvent.IO_ERROR,fileCannotLoad);
					fileLoader.openAsync(fileTarger,FileMode.READ);
				}
				//myLoadedBytes.position = 0 ;
			}
			else
			{
				myLoadedBytes = null ;
			}
			//trace("File size : "+fileTarger.size+" urlLoader : "+urlLoader);
			if(!waitTillFileLoaded)
			{
				completeLoadRequestAndDispatchEvent();
			}
		}
		
		private function completeLoadRequestAndDispatchEvent():void
		{
			if(fileTarger!=null && fileTarger.exists && (fileTarger.size!=0 || (myLoadedBytes!=null && myLoadedBytes.length!=0) || (urlLoader!=null && urlLoader.data !=null && urlLoader.data.length!=0))) 
			{
				//trace("offlineURL : "+offlineURL);
				
				//Cansel the file aftre downloaded file contrilled
				cansel();
				this.dispatchEvent(new URLSaverEvent(URLSaverEvent.LOAD_COMPLETE,1,myLoadedBytes,offlineURL));
			}
			else
			{
				trace("Offline url is not exists : "+offlineURL);
				URLSaver.deletFileIfExists(onlineURL);
				trace("So I have to download it again from "+onlineURL);
				load(onlineURL);
			}
		}
		
		protected function fileCannotLoad(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			trace("Unable to load file");
			fileLoader.close();
			completeLoadRequestAndDispatchEvent();
		}
		
		protected function fileLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			//trace("***********************************************File is ready to load***************");
			myLoadedBytes = new ByteArray();
			fileLoader.readBytes(myLoadedBytes,0,fileLoader.bytesAvailable);
			fileLoader.close();
			completeLoadRequestAndDispatchEvent();
		}		
		
//////////////////////////////////////////////delete temporary
		/**Delete images older than this date*/
		public static function deleteDatasOlderThan(date:Date)
		{
			for(var i in datestorage.data)
			{
				if(datestorage.data[i] < date.time)
				{
					//trace("This file is old : "+i);
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
					}catch(e)
					{
						trace("this file is not deleted : "+fileChecker.url);
					};
				}
				
				storage.data[fileURL] = undefined ;
				datestorage.data[fileURL] = undefined ;
				datestorage.flush();
				storage.flush();
				
				return true ;
			}
		}
	}
}
