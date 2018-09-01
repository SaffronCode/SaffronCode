package animation
	//animation.SpriteSheetMovieClip
{
	import contents.alert.Alert;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class SpriteSheetMovieClip extends MovieClip
	{
		private static var frames:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		private var view:Bitmap ;
		
		private var _currentFrame:uint ;
		
		private var _playStatus:Boolean = true ;
		
		public function SpriteSheetMovieClip()
		{
			super();
			trace(">> "+getQualifiedClassName(this));
			if(frames.length==0)
			{
				for(var i:int = 0 ; i<this.totalFrames ; i++)
				{
					super.gotoAndStop(i+1);
					var capturedBitmapData:BitmapData = new BitmapData(this.width,this.height,true,0x00000000);
					capturedBitmapData.draw(this);
					frames.push(capturedBitmapData);
				}
			}
			
			this.removeChildren();
			this.graphics.clear();
			view = new Bitmap();
			this.addChild(view);
			
			controlStage();
			
			this.gotoAndPlay(1);
		}
		
		private function controlStage(e:*=null):void
		{
			if(this.stage==null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controlStage);
			}
			else
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				this.addEventListener(Event.ENTER_FRAME,anim);
			}
		}
		
		override public function get currentFrame():int
		{
			return _currentFrame ;
		}
		
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,anim);
		}
		
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			_playStatus = true ;
			goto(frame);
		}
		
		protected function anim(event:Event):void
		{
			if(_playStatus)
			{
				goto(_currentFrame+1)
			}
		}
		
		private function goto(frame:Object):void
		{
			if(frame is Number)
			{
				_currentFrame = (frame as uint)%totalFrames ;
				frame = Math.max(1,(frame as uint),Math.min(this.totalFrames,(frame as uint)));
				view.bitmapData = frames[(frame as uint)-1];
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			_playStatus = false ;
			goto(frame);
		}
	}
}