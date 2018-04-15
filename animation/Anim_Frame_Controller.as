package animation
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Anim_Frame_Controller
	{
		private var mc:MovieClip ;
		
		private var frameLables:Vector.<FrameLabel> ;
		
		private var targetFrame:uint,
					currentFrame:Number;
		
		private var V:Number = 0 ;
		
		public var animSpeed:Number = 5 ;
		
		/**is it using built in accelerator or not*/
		private var acc:Boolean ;
		
		public function Anim_Frame_Controller(yourMovieClip:MovieClip,firstLableIndexToGo:uint = 0,withAccelerator:Boolean=true)
		{
			mc = yourMovieClip;
			
			acc = withAccelerator ;
			
			var framesL:Array = mc.currentLabels ;
			frameLables = new Vector.<FrameLabel>();
			for(var i:int = 0 ; framesL!=null && i<framesL.length ; i++)
			{
				frameLables.push(framesL[i]);
			}
			
			mc.stop();
			if(frameLables!=null && frameLables.length>0)
			{
				mc.gotoAndStop(frameLables[firstLableIndexToGo].frame);
			}
			else
			{
				mc.gotoAndStop(firstLableIndexToGo);
			}
			mc.addEventListener(Event.ENTER_FRAME,anim);
			mc.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			currentFrame = targetFrame = mc.currentFrame ;
		}
		
		protected function unLoad(event:Event):void
		{
			trace("Animation for "+mc+" is removed");
			mc.removeEventListener(Event.ENTER_FRAME,anim);
			mc.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function anim(event:Event):void
		{
			if(acc)
			{
				V = (targetFrame-mc.currentFrame)/animSpeed ;
				currentFrame += V ;
				mc.gotoAndStop(Math.round(currentFrame));
			}
			else
			{
				if(targetFrame>mc.currentFrame)
				{
					mc.nextFrame();
				}
				else if(targetFrame<mc.currentFrame)
				{
					mc.prevFrame();
				}
			}
		}	
		
		public function gotoFrame(frameIndex:uint):void
		{
			targetFrame = frameIndex ;
		}
		
		public function gotoFrameLableIndex(index:uint):void
		{
			targetFrame = frameLables[index].frame ;
		}
	}
}