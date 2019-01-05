package contents
{
	import appManager.event.AppEventContent;
	
	import flash.events.Event;

	public class History
	{
		public static var historyDispatcher:HistoryDispatcher = new HistoryDispatcher();
		
		public static var history:Vector.<LinkData> ;
		
		private static var lastPopedHistory:Vector.<LinkData> ;
		
		public static function pushHistory(currentLink:LinkData):void
		{
			lastPopedHistory = null ;
			trace("Yes, the history is changing");
			resetHistory();
			if(currentLink.level==-1)
			{
				history.push(currentLink);
			}
			else if(currentLink.level == -2)//New level on 9/12/2015
			{
				trace("current page replaced with last page level");
				if(history.length>0)
				{
					history.pop();
				}
				history.push(currentLink);
			}
			else
			{
				//trace("♠ split : "+currentLink.level+' , '+history.length+' - '+currentLink.level);
				history.splice(currentLink.level/*-1*/,Math.max(history.length-currentLink.level/*+1*/,0));
				history.push(currentLink);
			}
			historyDispatcher.dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		private static function resetHistory():void
		{
			if(history==null)
			{
				reset();
			}
		}
		
		public static function reset():void
		{
			history = new Vector.<LinkData>();
			history.push(Contents.homeLink);
			lastPopedHistory=null;
			historyDispatcher.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**You can predect if back is availabe*/
		public static function backAvailable():Boolean
		{
			//trace("history : "+JSON.stringify(history));
			//This situation will not ocure on any pages but home
			if(history!=null && ( history.length>1 /*|| (history.length>0 && history[0].id == home)*/))
			{
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
		public static function get length():uint
		{
			if(history == null)
			{
				return 0;
			}
			else
			{
				return history.length ;
			}
		}
		
		/**returns lastPageEvent*/
		public static function lastPage():AppEventContent
		{
			//trace("dispatch last page");
			/*for(var i = 0 ; i<history.length ; i++)
			{
			trace('history['+i+'] : '+history[i].id);
			}*/
			resetHistory();
			
			lastPopedHistory = history.concat();
			
			if(history.length>1)
			{
				history.pop();
				historyDispatcher.dispatchEvent(new Event(Event.CHANGE));
				return new AppEventContent(history[history.length-1],true);
			}
			else
			{
				historyDispatcher.dispatchEvent(new Event(Event.CHANGE));
				return new AppEventContent(Contents.homeLink,true);
			}
		}
		
		/**undo the history on prvented pages<br>
		 * Returns true if the unod history was available that mean last call was last page
		 */
		public static function undoLastPageHisotry():Boolean
		{
			if(lastPopedHistory!=null)
			{
				history = lastPopedHistory ;
				return true ;
			}
			else
			{
				return false ;
			}
		}
		
	///////////////////////////////////
		
		/**Returns true if this page was on history*/
		public static function isHistoryContainsThePageNamed(pageId:String,maxDepthToSearch:uint=uint.MAX_VALUE):Boolean
		{
			if(pageId == Contents.homeID)
			{
				return (history==null || history.length==0 || (history.length==1 && history[0].id == pageId)) ;
			}
			for(var i:int = 0 ; history!=null && i<Math.min(maxDepthToSearch,history.length) ; i++)
			{
				if(history[i].id == pageId)
				{
					return true ;
				}
			}
			return false ;
		}
		
		/**Returns true if this page was on history*/
		public static function isCurrentPageNamed(pageId:String):Boolean
		{
			if(history!=null && history.length>0 && history[history.length-1].id == pageId)
			{
				return true ;
			}
			return false ;
		}
		
	}
}