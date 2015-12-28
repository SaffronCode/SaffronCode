package appManager.event
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		/**The page menu is created*/
		public static const MENU_READY:String = "MENU_READY" ;
		
		/**Thie page menu is removed*/
		public static const MENU_DELETED:String = "MENU_DELETED" ;
		
		public var menuTarget:DisplayObject ;
		
		public function MenuEvent(type:String,MenuTarget:DisplayObject,bubble:Boolean=false)
		{
			super(type,bubble);
			menuTarget = MenuTarget ;
		}
	}
}