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
		
		private var frameHandler:Number ;
		
		public function LinkItemButtons()
		{
			super();
			stop();
			frameHandler = visibleFrame = 1 ;
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
			frameHandler+=(visibleFrame-frameHandler)/4;
			this.gotoAndStop(Math.round(frameHandler));
		}
		
		public function setUp(linkData:LinkData):void
		{
			myLinkData = linkData ;
		}
		
		public function setAnimate(precent:Number):void
		{
			precent = Math.max(-1,Math.min(1,precent));
			visibleFrame = Math.floor(Math.min(1,Math.abs(precent))*(this.totalFrames-1))+1;
			//SaffronLogger.log("*precent : "+precent+' : '+visibleFrame);
		}
	}
}