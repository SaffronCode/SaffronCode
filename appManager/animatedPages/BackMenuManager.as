package appManager.animatedPages
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BackMenuManager extends MovieClip
	{
		public function BackMenuManager()
		{
			super();
			
			this.stop();
			if(AppEventContent.backAvailable())
			{
				this.gotoAndStop(this.totalFrames);
			}
			this.addEventListener(Event.ENTER_FRAME,anim);
			
			AppEventContent.backAvailable()
		}
		
		protected function anim(event:Event):void
		{
			// TODO Auto-generated method stub
			if(AppEventContent.backAvailable())
			{
				this.nextFrame();
			}
			else
			{
				this.prevFrame();
			}
		}
	}
}