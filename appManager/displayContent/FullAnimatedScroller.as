package appManager.displayContent
	//appManager.displayContent.FullAnimatedScroller
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	/**Change the name of the MovieClip to make the speed variables changes.<br>
	 * sample : _0_100 >> xScrollSpeed = 0  and yScrollSpeed = 100<br>
	 * You have to add an movieClip named area_mc to this object to clear the scroll area*/
	public class FullAnimatedScroller extends MovieClip
	{
		private var xSpeed:Number,
					ySpeed:Number;
					
		private var areaMC:MovieClip;
		
		private var _currentFrame:Number;
		
		private var firstX:Number,firstY:Number ;
		
		private var lastX:Number,lastY:Number;
		
		private var Vx:Number = 0 ; 
		private var Vy:Number = 0 ;
		
		private const F:Number = 5,
					Mu:Number = 0.9,
					MuStop:Number=0.7 ;
		
		private const acceptableDelta:Number = 5 ;
		
		private var isDragging:Boolean ;
		
		private var isLock:Boolean = false ;
		
		public function FullAnimatedScroller()
		{
			super();
			this.stop();
			_currentFrame = 1 ;
			isLock = false ;
			
			var speeds:Array = this.name.split('_');
			if(speeds.length<2)
			{
				throw "Correct the FullAnimatedScroller name to make the speed values be correct"
			}
			xSpeed = uint(speeds[1])/100;
			ySpeed = uint(speeds[2])/100;
			areaMC = Obj.get("area_mc",this);
			areaMC.visible = false ;
			if(areaMC==null)
			{
				throw "You have to add an object named   \"area_mc\" on the FullAnimated Class to defin the scroll area"
			}
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,startScroll);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.addEventListener(MouseEvent.MOUSE_WHEEL,startDraggingWill);
			this.addEventListener(Event.ENTER_FRAME,animate);
			this.addEventListener(ScrollMT.LOCK_SCROLL_TILL_MOUSE_UP,lockMeTillMouseUp);
		}
		
		protected function lockMeTillMouseUp(event:Event):void
		{
			stopDragging(null);
			isLock = true ;
			stage.addEventListener(MouseEvent.MOUSE_UP,unLockMe);
		}		
		
		protected function unLockMe(event:MouseEvent):void
		{
			isLock = false ;
		}
		
		protected function unLoad(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,startDragging);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL,startDraggingWill);
		}
		
			protected function startScroll(event:MouseEvent):void
			{
				if(thisIsOnArea() && !isLock)
				{
					isDragging = true ;
					firstX = stage.mouseX;
					firstY = stage.mouseY;
					saveMousePose();
					Vx = Vy = 0 ;
					stage.addEventListener(MouseEvent.MOUSE_MOVE,startDragging);
					stage.addEventListener(MouseEvent.MOUSE_UP,stopDragging);
				}
			}
			
			/**Remove both event listeners*/
			protected function stopDragging(event:MouseEvent):void
			{
				isDragging = false ;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,startDragging);
				stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragging);
				setTimeout(enableClickesAgain,10);
			}
			
			protected function startDraggingWill(event:MouseEvent):void
			{
				if(thisIsOnArea())
				{
					Vx += event.delta*xSpeed/10 ;
					Vy += event.delta*ySpeed/10 ;
				}
			}
			
			/**Controll the mouse position*/
			private function thisIsOnArea():Boolean
			{
				return areaMC.hitTestPoint(stage.mouseX,stage.mouseY,true) ;
			}
			
			private function enableClickesAgain():void
			{
				this.mouseChildren = true ;
			}
			
				protected function startDragging(event:MouseEvent):void
				{
					saveMousePose();
					setPosition();
					event.updateAfterEvent();
					if(this.mouseChildren && (Math.abs(firstX-stage.mouseX)>acceptableDelta || Math.abs(firstY-stage.mouseY)<acceptableDelta))
					{
						this.mouseChildren = false ;
					}
				}
				
				private function saveMousePose():void
				{
					Vx += (lastX-stage.mouseX)/F*xSpeed ;
					Vy += (lastY-stage.mouseY)/F*ySpeed ;
					lastX = stage.mouseX ;
					lastY = stage.mouseY ;
				}
				
				private function animate(e:Event):void
				{
					setPosition();
				}
				
				private function setPosition():void
				{
					if(isDragging)
					{
						Vx*=MuStop;
						Vy*=MuStop;
					}
					else
					{
						Vx *= Mu ;
						Vy *= Mu ;
					}
					_currentFrame+=Vx+Vy;
					_currentFrame = Math.min(this.totalFrames,Math.max(1,_currentFrame));
					this.gotoAndStop(Math.round(_currentFrame));
				}
	}
}