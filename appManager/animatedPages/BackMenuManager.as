package appManager.animatedPages
{
	import contents.History;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BackMenuManager extends MovieClip
	{
		public function BackMenuManager()
		{
			super();
			
			this.stop();
			if(History.backAvailable())
			{
				this.gotoAndStop(this.totalFrames);
			}
			this.addEventListener(Event.ENTER_FRAME,anim);
			
			History.backAvailable()
		}
		
		protected function anim(event:Event):void
		{
			// TODO Auto-generated method stub
			if(History.backAvailable())
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