package appManager.animatedPages
{//appManager.animatedPages.Intro
	import flash.display.MovieClip;
	import flash.events.Event;
	import stageManager.StageManager;
	import contents.alert.Alert;
	
	[Event(name="imFinished", type="flash.events.Event")]
	public class Intro extends MovieClip
	{
		public static const EVENT_FINISHED:String = "imFinished" ;
		public function Intro()
		{
			super();
			stop();
			
			this.addFrameScript(this.totalFrames-1,introIsOver);
			this.addFrameScript(Math.ceil((this.totalFrames/3)*2),controlStage);
		}
		
		private function introIsOver():void
		{
			this.stop();
			this.dispatchEvent(new Event(EVENT_FINISHED));
			controlStage();
		}

		private function controlStage():void
		{
			if(StageManager.isSatUp())
			{
				StageManager.controllStageSizes(null,false,true);
			}
		}
	}
}