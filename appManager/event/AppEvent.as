package appManager.event
{
	import contents.LinkData;
	
	import flash.events.Event;
	
	public class AppEvent extends Event
	{
		private static const id_not_set:String = "id_not_set" ;
		
		/**Event name*/
		public static const PAGE_CHANGES:String = "PAGE_CHANGES" ;
		
		
		/**Intro is over and now main menu is available*/
		public static const APP_STARTS:String = "APP_STARTS" ; 
		
		
		/**Home page is ready to call other pages*/
		public static const HOME_IS_READY:String = "HOME_IS_READY" ; 
		
		public static const MAIN_ANIM_IS_READY:String = "MAIN_ANIM_IS_READY" ;
		
		/**app event types , PageManager will listtening tho these variable*/
		public static const home:String = 'home' ;
		
		public static const developer_static_pageid:String = "developer_static_page";
		
		public static const refresh:String = "ReffreshCurrentPage" ;
		
		/**This variable is not unic - this is the class name that application needs to create it. */
		public var myType:String ;
		
		/**This is the page id and this is unic , you have to detect home types from myType<br>
		 * this variable is just on Content base applications*/
		public var myID:String ;
		
		public var reload:Boolean = false ;
		
		/**Returns the refrest event*/
		public static function refreshEvent():AppEvent
		{
			var newAppEventContent:AppEventContent = new AppEventContent(null,true);
			newAppEventContent.myType = refresh ;
			newAppEventContent.myID = id_not_set ;
			
			return newAppEventContent;
		}
		
		/**Returns true if the current event is a refresh event*/
		public static function isRefereshEvent(event:AppEvent):Boolean
		{
			return event!= null && (event.myID == id_not_set || event.myType == refresh) ;
		}
		
		public function AppEvent(pageType:String=home,eventType:String=PAGE_CHANGES,pageID:String=id_not_set,reloadNeeded:Boolean=false)
		{
			myType = pageType ;
			
			reload = reloadNeeded ;
			
			if(pageID == id_not_set)
			{
				pageID = myType ;
			}
			
			myID = pageID ;
			
			//SaffronLogger.log("AppEvent trace : "+pageType+" vs "+pageID);
			
			super(eventType,true);
		}
		
		override public function clone():Event
		{
			return new AppEvent(myType,type,myID,reload);
		}
	}
}