package animation
	//animation.SpriteSheetMovieClip
{
	import contents.alert.Alert;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	public class SpriteSheetMovieClip extends MovieClip
	{
		private static var cashes:Vector.<SpriteSheetCash> = new Vector.<SpriteSheetCash>();
		
		private var view:Bitmap ;
		
		private var _currentFrame:uint ;
		
		private var _playStatus:Boolean = true ;
		
		private var myCash:SpriteSheetCash ;
		
		public function SpriteSheetMovieClip()
		{
			super();
			controlStage();
		}
		
		private function reDrawMe():void
		{
			myCash = findMyCash();
			
			if(myCash==null)
			{
				myCash = new SpriteSheetCash(id());
				for(var i:int = 0 ; i<this.totalFrames ; i++)
				{
					super.gotoAndStop(i+1);
					var mat:Matrix = new Matrix();
					var capturedBitmapData:BitmapData = new BitmapData(this.width,this.height,true,0x00000000);
					mat.scale(this.scaleX,this.scaleY);
					capturedBitmapData.draw(this,mat);
					myCash.frames.push(capturedBitmapData);
				}
				cashes.push(myCash);
			}
			view.scaleX = 1/this.scaleX;
			view.scaleY = 1/this.scaleY;
		}
		
		/**Creats unique id for this elemet*/
		private function id():String
		{
			return getQualifiedClassName(this)+this.scaleX+'.'+this.scaleY;
		}
		
		private function findMyCash():SpriteSheetCash
		{
			for(var i:int = 0 ; i<cashes.length ; i++)
			{
				if(cashes[i].id==id())
				{
					return cashes[i] ;
				}
			}
			return null ;
		}
		
		override public function stop():void
		{
			_playStatus = false ;
		}
		
		override public function play():void
		{
			_playStatus = true ;
		}
		
		private function controlStage(e:*=null):void
		{
			if(this.stage==null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controlStage);
			}
			else
			{
				
				view = new Bitmap();
				
				reDrawMe();
				
				super.gotoAndStop(1);
				this.goto(1);
				
				this.removeChildren();
				
				this.addChild(view);
				
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				this.addEventListener(Event.ENTER_FRAME,anim);
			}
		}
		
		override public function get isPlaying():Boolean
		{
			return _playStatus ;
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
				view.bitmapData = myCash.frames[(frame as uint)-1];
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			_playStatus = false ;
			goto(frame);
		}
	}
}