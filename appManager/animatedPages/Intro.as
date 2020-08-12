package appManager.animatedPages
{//appManager.animatedPages.Intro
	import flash.display.MovieClip;
	import flash.events.Event;
	
	[Event(name="imFinished", type="flash.events.Event")]
	public class Intro extends MovieClip
	{
		public static const EVENT_FINISHED:String = "imFinished" ;
		public function Intro()
		{
			super();
			stop();
			
			this.addFrameScript(this.totalFrames-1,introIsOver);
		}
		
		private function introIsOver()
		{
			this.stop();
			this.dispatchEvent(new Event(EVENT_FINISHED));
		}
	}
}