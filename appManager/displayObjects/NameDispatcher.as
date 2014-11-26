package appManager.displayObjects
{
	import appManager.event.AppEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class NameDispatcher extends MovieClip
	{
		public function NameDispatcher()
		{
			super();
			this.mouseChildren = false ;
			this.buttonMode = true ;
			
			this.addEventListener(MouseEvent.CLICK,imSelected);
		}
		
		protected function imSelected(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new AppEvent(this.name));
		}
	}
}