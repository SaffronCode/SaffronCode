package sliderMenu
{//sliderMenu.SliderButtonSwitcher
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class SliderButtonSwitcher extends MovieClip
	{
		/**Event.OPEN and Event.CLOSE*/
		internal static var lockDispatcher:EventDispatcher = new EventDispatcher();
		
		
		public function SliderButtonSwitcher()
		{
			super();
			
			lockDispatcher.addEventListener(Event.OPEN,imUnLock);
			lockDispatcher.addEventListener(Event.CLOSE,imLock);
			
			this.buttonMode = true ;
			
			this.addEventListener(MouseEvent.CLICK,clicked);
			this.visible = !SliderManager.lock_flag ;
			this.buttonMode = true ;
		}
		
		protected function imUnLock(event:Event):void
		{
			this.visible = true ;
		}
		
		protected function imLock(event:Event):void
		{
			this.visible = false ;
		}
		
		protected function clicked(event:MouseEvent):void
		{
			if(SliderManager.isOpen())
			{
				SaffronLogger.log("Hide the menu");
				SliderManager.hide();
			}
			else
			{
				SaffronLogger.log("Show the menu");
				if(!SliderManager.lock_flag)
				{
					SliderManager.openMenu();
				}
			}
		}
	}
}