
package movieClipAssist
//movieClipAssist.RandomFrameClip
{
	import flash.display.MovieClip;

	public class RandomFrameClip extends MovieClip
	{
		public function RandomFrameClip()
		{
			super();
			this.gotoAndStop(Math.floor(Math.random()*this.totalFrames+1));
		}
	}
}