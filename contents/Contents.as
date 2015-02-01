/***Version
 * 1.1 : Instant data.xml laoded
 * 
 */
package contents 
{
	import appManager.event.AppEvent;
	
	import contents.soundControll.ContentSoundManager;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;

	
	public class Contents
	{
		public static var eventDispatcher:ContentEventDispatcher = new ContentEventDispatcher();
		
		public static var homeID:String = AppEvent.home ;
		
		/**The only cause that these values are staing here is the old applications that used them from here.*/
		public static var 	id_music:uint = ContentSoundManager.MusicID,
							id_soundEffects:uint=ContentSoundManager.EffectsID;
		
	/////////////////////////////////////////////////////	
	
		public static const dataFile:String = "Data/data.xml";
		
		private static var loadedXML:XML,
							loader:URLLoader ;
							
		private static var onLoaded:Function ;
		
		
		
	//////////////////////////////////////////////////////↓
		
		private static var pages:Vector.<PageData>;
		
		
		/**returns true if data is ready*/
		public static function get isReady():Boolean
		{
			if(loadedXML == null)
			{
				return false;
			}
			else
			{
				return true ;
			}
		}
		
		/**From this version, content.xml will load instantly and there is no need to wail till onLoaded function calls.*/
		public static function setUp(OnLoaded:Function=null)
		{
			onLoaded = OnLoaded ;
			if(OnLoaded==null)
			{
				onLoaded = new Function();
			}
			var fileLoader:FileStream = new FileStream();
			var fileTarger:File = File.applicationDirectory.resolvePath(dataFile);
			fileLoader.open(fileTarger,FileMode.READ);
			
			xmlLoaded(null,fileLoader.readUTFBytes(fileLoader.bytesAvailable));
			
			
			
			/*loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT ;
			loader.addEventListener(Event.COMPLETE,xmlLoaded);
			loader.load(new URLRequest(dataFile));*/
			
		}
		
		/**xml file loaded*/
		private static function xmlLoaded(e:Event,myInstantData:String='')
		{
			if(myInstantData!='')
			{
				loadedXML = XML(myInstantData);
			}
			else
			{	
				loadedXML = XML(loader.data);
			}
			
			pages = new Vector.<PageData>();
			
			for(var i = 0 ; i<loadedXML.page.length() ; i++)
			{
				var pageData:PageData = new PageData(loadedXML.page[i]);
				pages.push(pageData);
			}
			
			onLoaded() ;
			eventDispatcher.dispatchEvent(new ContentsEvent());
		}
		
		/**add these datas to pageContents*/
		public static function addMoreData(morePageDataOnXML:String)
		{
			//trace("morePageDataOnXML : "+morePageDataOnXML)
			var cashedXML = XMLList(morePageDataOnXML);
			
			//pages = new Vector.<PageData>();
			
			for(var i = 0 ; i<cashedXML.length() ; i++)
			{
				//trace('each page data : '+cashedXML[i]);
				var pageData:PageData = new PageData(cashedXML[i]);
				var pageFounds:Boolean = dropPage(pageData.id);
				//trace('page '+pageData.id+' added to content and it was there befor? '+pageFounds);
				pages.push(pageData);
			}
		}
		
		/**add this page Data*/
		public static function addSinglePageData(pageData:PageData)
		{
			var pageFounds:Boolean = dropPage(pageData.id);
			pages.push(pageData);
		}
		
		
		
		
		
		
		/**this will returns page data based on input id*/
		public static function getPage(pageID:String):PageData 
		{
			for(var i = 0 ; i<pages.length ;i++)
			{
				if(pages[i].id == pageID )
				{
					return pages[i];
				}
			}
			return new PageData();
		}
		
		/**remove pages with this id from the contents<br>
		 * tells if this page founded on pages conten xml or not*/
		private static function dropPage(pageID:String):Boolean
		{
			for(var i = 0 ; i<pages.length ;i++)
			{
				if(pages[i].id == pageID )
				{
					pages.splice(i,1);
					return true;
				}
			}
			return false;
		}
		
		/**this will returns lind , that will generate home page*/
		public static function get homeLink():LinkData
		{
			var homeLink:LinkData = new LinkData();
			homeLink.id = Contents.homeID ;
			homeLink.level = 0 ;
			return homeLink;
		}
		
		/**This function will returns the homePage data*/
		public static function get homePage():PageData
		{
			return getPage(homeID);
		}
		
		
		public static function exportAll():String
		{
			// TODO Auto Generated method stub
			var exports:String = '';
			for(var i = 0 ; i<pages.length ; i++)
			{
				exports += pages[i].export()+'\n';
			}
			return exports;
		}
	}
}