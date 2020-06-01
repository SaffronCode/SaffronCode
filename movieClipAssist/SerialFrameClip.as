
package movieClipAssist
//movieClipAssist.SerialFrameClip
{
	import flash.display.MovieClip;
	import contents.alert.Alert;

	public class SerialFrameClip extends MovieClip
	{
		private static var lastFrame:uint = 0 ;
		public function SerialFrameClip()
		{
			super();
			Alert.show("HIII "+((lastFrame%this.totalFrames)+1));
			this.gotoAndStop((lastFrame%this.totalFrames)+1);
			lastFrame++
		}
	}
}