package contents.displayPages
	//contents.displayPages.LinkItemButtons
{
	import contents.LinkData;
	
	import flash.display.MovieClip;
	
	public class LinkItemButtons extends MovieClip
	{
		protected var myLinkData:LinkData ;
		
		public function LinkItemButtons()
		{
			super();
			stop();
		}
		
		public function setUp(linkData:LinkData):void
		{
			myLinkData = linkData ;
		}
		
		internal function setAnimate(precent:Number):void
		{
			this.gotoAndStop(Math.floor(precent*this.totalFrames)+1);
		}
	}
}