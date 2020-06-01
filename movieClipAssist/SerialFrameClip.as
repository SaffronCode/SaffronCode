
package movieClipAssist
//movieClipAssist.SerialFrameClip
{
	import flash.display.MovieClip;

	public class SerialFrameClip extends MovieClip
	{
		private static var lastFrame:uint = 0 ;
		public function SerialFrameClip()
		{
			super();
			this.gotoAndStop((lastFrame%this.totalFrames)+1);
			lastFrame++
		}
	}
}