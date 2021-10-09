
package movieClipAssist
//movieClipAssist.RandomFrameClipPlay
{
	import flash.display.MovieClip;
	import contents.alert.Alert;

	public class RandomFrameClipPlay extends MovieClip
	{
		public function RandomFrameClipPlay()
		{
			super();
			this.gotoAndPlay(Math.floor(Math.random()*this.totalFrames+1));
		}
	}
}