package appManager.displayObjects
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import multiMediaManager.MultiMediaManager;
	
	public class ExitButton extends MovieClip
	{
		public function ExitButton()
		{
			super();
			
			this.visible = DevicePrefrence.isItPC;
			
			this.buttonMode = true ;
			this.addEventListener(MouseEvent.CLICK,MultiMediaManager.closeApp);
		}
	}
}