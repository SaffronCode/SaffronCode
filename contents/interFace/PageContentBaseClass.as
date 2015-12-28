package contents.interFace
{
	import appManager.event.MenuEvent;
	
	import contents.PageData;
	
	import flash.display.MovieClip;
	
	[Event(name="MENU_READY", type="appManager.event.MenuEvent")]
	public class PageContentBaseClass extends MovieClip implements DisplayPageInterface
	{
		public function PageContentBaseClass()
		{
			super();
			this.addEventListener(MenuEvent.MENU_READY,menuIsReady);
		}
		
		public function setUp(pageData:PageData):void
		{
		}
		
		protected function menuIsReady(menuEvent:MenuEvent):void
		{
		}
	}
}