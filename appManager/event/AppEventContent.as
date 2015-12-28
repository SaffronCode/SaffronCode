package appManager.event
{
	import contents.Contents;
	import contents.History;
	import contents.LinkData;
	import contents.PageData;

	/**This event is using when application has contents*/
	public class AppEventContent extends AppEvent
	{
		public static var currentLink:LinkData;
		
		//public static var history:Vector.<LinkData> ;
		
		public var linkData:LinkData;
		
		public var pageData:PageData ;
		
		public var SkipHistory:Boolean ;
		
		//public var myID:String ;
		
		/**Enter null here to make refresh event*/
		public function AppEventContent(pageLink:LinkData,skipHistory:Boolean = false,reload:Boolean=false)
		{
			if(pageLink == null)
			{
				pageLink = new LinkData();
				pageLink.id == refresh ;
				skipHistory = true ;
				pageData = new PageData();
			}
			else
			{
				pageData = Contents.getPage(pageLink.id);
			}
			
			SkipHistory = skipHistory ;
			
			linkData = currentLink = pageLink.clone() ;
			
			if(pageLink.id == home)
			{
				pageLink.level = 0 ;
			}
			
			
			super(pageData.type, PAGE_CHANGES,pageLink.id,reload);
		}
		
		/*private static function resetHistory():void
		{
			// TODO Auto Generated method stub
			
			if(history==null)
			{
				history = new Vector.<LinkData>();
				
				history.push(Contents.homeLink);
			}
		}*/
		
		/**return current page*/
		public static function get currentPage():String
		{
			if(currentLink!=null)
			{
				return currentLink.id;
			}
			else
			{
				return Contents.homeID;
			}
		}
		
		/**You can predect if back is availabe*/
		public static function backAvailable():Boolean
		{
			trace("backAvailable methode is moved from AppEventContent to History Class");
			return History.backAvailable();
			/*//trace("history : "+JSON.stringify(history));
			//This situation will not ocure on any pages but home
			if(history!=null && ( history.length>1 ))
			{
				return true ;
			}
			else
			{
				return false ;
			}*/
		}
		
		/**returns lastPageEvent*/
		public static function lastPage():AppEventContent
		{
			trace("lastPage methode is moved from AppEventContent to History Class");
			return History.lastPage();
			//trace("dispatch last page");
			/*for(var i = 0 ; i<history.length ; i++)
			{
				trace('history['+i+'] : '+history[i].id);
			}*/
			/*resetHistory()
			
			if(history.length>1)
			{
				history.pop();
				return new AppEventContent(history[history.length-1],true);
			}
			else
			{
				return new AppEventContent(Contents.homeLink,true);
			}*/
		}
	}
}