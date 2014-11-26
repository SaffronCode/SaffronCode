package contents
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	
	public class Contents
	{
		public static var eventDispatcher:ContentEventDispatcher = new ContentEventDispatcher();
		
		public static const homeID:String = "home" ;
		
		public static const id_music:uint = 1,
							id_soundEffects:uint=2;
		
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
		
		
		public static function setUp(OnLoaded:Function)
		{
			onLoaded = OnLoaded ;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT ;
			loader.addEventListener(Event.COMPLETE,xmlLoaded);
			loader.load(new URLRequest(dataFile));
			
		}
		
		/**xml file loaded*/
		private static function xmlLoaded(e:Event)
		{
			loadedXML = XML(loader.data);
			
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
			return homeLink;
		}
		
		
	}
}