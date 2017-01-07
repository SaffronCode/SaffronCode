package sliderMenu
{//sliderMenu.SliderButtonSwitcher
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SliderButtonSwitcher extends MovieClip
	{
		
		public function SliderButtonSwitcher()
		{
			super();
			this.buttonMode = true ;
			
			this.addEventListener(MouseEvent.CLICK,clicked);
		}
		
		protected function clicked(event:MouseEvent):void
		{
			
			if(SliderManager.isOpen())
			{
				trace("Hide the menu");
				SliderManager.hide();
			}
			else
			{
				trace("Show the menu");
				SliderManager.openMenu();
			}
		}
	}
}