package sliderMenu
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SliderButtonSwitcher extends MovieClip
	{
		
		public function SliderButtonSwitcher()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK,clicked);
		}
		
		protected function clicked(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(SliderManager.isOpen())
			{
				SliderManager.hide();
			}
			else
			{
				SliderManager.openMenu();
			}
		}
	}
}