package appManager.event
{
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		private static const id_not_set:String = "id_not_set" ;
		
		/**Event name*/
		public static const PAGE_CHANGES:String = "PAGE_CHANGES" ;
		
		
		/**Intro is over and now main menu is available*/
		public static const APP_STARTS:String = "APP_STARTS" ; 
		
		public static const MAIN_ANIM_IS_READY:String = "MAIN_ANIM_IS_READY" ;
		
		/**app event types , PageManager will listtening tho these variable*/
		public static const home:String = 'home' ;
		
		public static const refresh:String = "ReffreshCurrentPage" ;
		
		/**This variable is not unic */
		public var myType:String ;
		
		/**This is the page id and this is unic , you have to detect home types from myType<br>
		 * this variable is just on Content base applications*/
		public var myID:String ;
		
		
		public function AppEvent(pageType:String=home,eventType:String=PAGE_CHANGES,pageID:String=id_not_set)
		{
			myType = pageType ;
			
			if(pageID == id_not_set)
			{
				pageID = myType ;
			}
			
			myID = pageID ;
			
			//trace("AppEvent trace : "+pageType+" vs "+pageID);
			
			super(eventType,true);
		}
	}
}