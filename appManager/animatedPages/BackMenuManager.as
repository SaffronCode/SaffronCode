package appManager.animatedPages
	//appManager.animatedPages.BackMenuManager
{
	import contents.History;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BackMenuManager extends MovieClip
	{
		protected var minHistoryRequired:uint = 1 ;
		
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
			
			if((minHistoryRequired == 1 && History.backAvailable()) || minHistoryRequired<History.length)
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