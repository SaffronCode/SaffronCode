package contents
{
	import appManager.event.AppEventContent;

	public class History
	{
		public static var history:Vector.<LinkData> ;
		
		public static function pushHistory(currentLink:LinkData):void
		{
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
		}
		
		
		private static function resetHistory():void
		{
			// TODO Auto Generated method stub
			
			if(history==null)
			{
				reset();
			}
		}
		
		public static function reset():void
		{
			history = new Vector.<LinkData>();
			history.push(Contents.homeLink);
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
			resetHistory()
			
			if(history.length>1)
			{
				history.pop();
				return new AppEventContent(history[history.length-1],true);
			}
			else
			{
				return new AppEventContent(Contents.homeLink,true);
			}
		}
		
	}
}