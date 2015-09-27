package appManager.animatedPages
{
	
	import appManager.event.AppEvent;
	import appManager.mains.App;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	[Event(name="MAIN_ANIM_IS_READY", type="appManager.event.AppEvent")]
	
	public class MainAnim extends MovieClip
	{
		public static var ME:MainAnim;
		
		
		private var currentPage:uint = 1; 
		
		private var frame_home:uint,
					frame_internal:uint;
					
		private var eventDispatched:Boolean = true ;
		
		public function MainAnim()
		{
			super();
			
			ME = this ;
			
			ME.stop();
			
			var frames:Array = this.currentLabels ;
			frame_home = FrameLabel(frames[0]).frame;
			frame_internal = FrameLabel(frames[1]).frame;
			
			this.addEventListener(Event.ENTER_FRAME,anim);
		}
		
		/**animate the frames*/
		private function anim(e:Event)
		{
			if(App.skipAnimations)
			{
				this.gotoAndStop(currentPage);
			}
			if(this.currentFrame<currentPage)
			{
				this.nextFrame();
			}
			else if(this.currentFrame>currentPage)
			{
				this.prevFrame();
			}
			else if(!eventDispatched)
			{
				eventDispatched = true ;
				this.dispatchEvent(new AppEvent(null,AppEvent.MAIN_ANIM_IS_READY));
			}
		}
		
		/**take main animation to home frame*/
		public function goHome()
		{
			currentPage = frame_home ;
			eventDispatched = false ;
		}
		
		/**take main menu animation to internal pages frame , it will dispatch app event after animation gone to currect frame*/
		public function goInternalPage()
		{
			currentPage = frame_internal ;
			eventDispatched = false ;
		}
	}
}