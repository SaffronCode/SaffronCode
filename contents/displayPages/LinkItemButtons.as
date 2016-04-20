package contents.displayPages
	//contents.displayPages.LinkItemButtons
{
	import contents.LinkData;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LinkItemButtons extends MovieClip
	{
		protected var myLinkData:LinkData ;
		
		protected var visibleFrame:uint ;
		
		public function LinkItemButtons()
		{
			super();
			stop();
			visibleFrame = 1 ;
			this.addEventListener(Event.ENTER_FRAME,animTimeLine);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Cansel the listeners*/
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,animTimeLine);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Animate the timeline*/
		protected function animTimeLine(event:Event):void
		{
			this.gotoAndStop(Math.floor(this.currentFrame+(visibleFrame-this.currentFrame)/4));
		}
		
		public function setUp(linkData:LinkData):void
		{
			myLinkData = linkData ;
		}
		
		internal function setAnimate(precent:Number):void
		{
			trace("precent : "+precent);
			visibleFrame = Math.floor(Math.min(1,Math.abs(precent))*this.totalFrames)+1;
		}
	}
}