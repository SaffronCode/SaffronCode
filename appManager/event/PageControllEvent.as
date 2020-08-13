package appManager.event
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class PageControllEvent extends Event
	{
		/**Calls when an internal page fade in animation is over<br>
		 * You can listen to this event on the internal pages or root*/
		public static const PAGE_ANIMATION_READY:String = "PAGE_ANIMATION_READY" ;
		
		/**This event makes App lock the page changing and call the permition function ( if preventerPage is steal on the stage ) to make it makes desition about changint the page or not.<br>
		 * When the page desided to let app change its page, it has to call LET_PAGE_CHANGE function*/
		public static const PREVENT_PAGE_CHANGING:String = "PREVENT_PAGE_CHANGING" ;
		
		/**This will let the prevented page to change and it will remove the current prevent permition from the App class*/
		public static const LET_PAGE_CHANGE:String = "LET_PAGE_CHANGE";
		
		/**Call this function to get user permition*/
		public var permitionReceiver:Function ;
		
		/**This is the page that prevents App to change its page. controll it's stage to make sure it is steal accessable*/
		public var preventerPage:DisplayObject ;

		public var let_cashed_requested_page_activate:Boolean = true ;
		
		/**Feel the getPermition and preventerDisplayObject on PREVENT_PAGE_CHANGING event*/
		public function PageControllEvent(type:String,getPermition:Function=null,preventerDisplayObject:DisplayObject=null,let_requested_page_to_open:Boolean=true)
		{
			super(type,true);
			let_cashed_requested_page_activate = let_requested_page_to_open;
			permitionReceiver = getPermition ;
			preventerPage = preventerDisplayObject ;
		}
	}
}