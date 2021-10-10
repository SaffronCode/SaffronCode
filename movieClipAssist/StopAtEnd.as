
package movieClipAssist
//movieClipAssist.StopAtEnd
{
	import flash.display.MovieClip;

	public class StopAtEnd extends MovieClip
	{
		public function StopAtEnd()
		{
			super();
			this.addFrameScript(this.totalFrames-1,stopMe);
		}

		private function stopMe():void
		{
			this.stop();
		}
	}
}