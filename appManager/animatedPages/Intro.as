package appManager.animatedPages
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	[Event(name="imFinished", type="flash.events.Event")]
	public class Intro extends MovieClip
	{
		public function Intro()
		{
			super();
			stop();
			
			this.addFrameScript(this.totalFrames-1,introIsOver);
		}
		
		private function introIsOver()
		{
			this.stop();
			this.dispatchEvent(new Event("imFinished"));
		}
	}
}