package contents.contentUpdate
{
	import contents.PageData;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import netManager.urlSaver.URLSaver;
	import contents.Contents;

	public class ContentUpdateFromSameXML
	{
		private static var xmlURL:URLRequest ;
		private static var versionFileURL:URLRequest ;
		
		private static var failds:Function;
		private static var success:Function;
		
		
		private static var versionLoader:URLLoader ;
		
		private static var mainLoader:URLLoader ;
		
		private static var oldData:SharedObject = SharedObject.getLocal('oldContents','/');
		private static const contentObjectName:String = 'contents';
		private static var loadedXML:XML;
		
		/**Update content from other file in this location*/
		public static function update(fileURL:String,onSuccess:Function,onFaild:Function,versionControllerURL:String='')
		{
			xmlURL = new URLRequest(fileURL) ;
			versionFileURL = new URLRequest(versionControllerURL) ;
			
			success = onSuccess ;
			failds = onFaild ;
			
			//updage Contents with latest downloaded datas
			if(oldData.data[contentObjectName] != undefined)
			{
				injectStoredDatas(oldData.data[contentObjectName]);
			}
			
			startDownloadVersion();
		}
		
		private static function startDownloadVersion():void
		{
			
			if(versionFileURL.url == '')
			{
				startDownloadMain();
			}
			else
			{
				SaffronLogger.log("activate version contro first on ContentUpdateFromSameXML");
			}
		}
		
		/**download the main xml file*/
		private static function startDownloadMain()
		{
			SaffronLogger.log('try to load : '+xmlURL.url);
			//stati download version if exists
			mainLoader = new URLLoader();
			mainLoader.addEventListener(Event.COMPLETE,downloadComplete);
			mainLoader.addEventListener(IOErrorEvent.IO_ERROR,downloadFaild);
			mainLoader.load(xmlURL);
		}
		
		/**url is not exists*/
		private static function downloadFaild(e:IOErrorEvent)
		{
			SaffronLogger.log("downloading are not successfull");
			failds();
		}
		
		private static function downloadComplete(e:Event)
		{
			//save downloaded file
			SaffronLogger.log('file is loaded');
			try
			{
				loadedXML = new XML(mainLoader.data);
				oldData.data[contentObjectName] = mainLoader.data ;
				oldData.flush();
				
				injectStoredDatas(mainLoader.data,true);
				saveComplete();
			}
			catch(e)
			{
				downloadFaild(null);
			}
		}
		
		
		
		
		
		
	////////////////new xml receved . try to check all old images
		
		
		/**Inject stored datas to Contents class - this will not remove images*/
		private static function injectStoredDatas(xmlString:String,deleteImages:Boolean=false):void
		{
			
			
			try
			{
				var storedXML:XML = XML(xmlString);
				SaffronLogger.log("loaded contents length : "+storedXML.page.length());
				for(var j = 0 ; j<storedXML.page.length() ; j++)
				{
					var pageData:PageData = new PageData(storedXML.page[j]);
					if(deleteImages)
					{
						var samePage:PageData = Contents.getPage(pageData.id);
						if(pageData.export() != samePage.export())
						{
							var myDeleter:URLSaver = new URLSaver();
							myDeleter.deletFileIfExists(samePage.imageTarget);
							for(var i = 0 ; i<samePage.images.length ; i++)
							{
								myDeleter.deletFileIfExists(samePage.images[i].targURL);
							}
							for(i = 0 ; i<samePage.links1.length ; i++)
							{
								myDeleter.deletFileIfExists(samePage.links1[i].iconURL);
							}
							for(i = 0 ; i<samePage.links2.length ; i++)
							{
								myDeleter.deletFileIfExists(samePage.links2[i].iconURL);
							}
							SaffronLogger.log("try to delete old images");
						}
					}
					SaffronLogger.log('content updated');
					Contents.addMoreData(pageData.export());
				}
			}
			catch(e)
			{
				SaffronLogger.log('no xml changes');
			}
		}
		
		
		
		
		
		
		
		private static function saveComplete():void
		{
			
			success();
		}		
		
	}
}