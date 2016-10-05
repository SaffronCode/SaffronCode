package appManager.animatedPages
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**Request to remove this elemet from page*/
	[Event(name="remove", type="flash.events.Event")]
	internal class ShineElement extends MovieClip
	{
		private var myTarget:Sprite ;

		private var spriteRect:Rectangle;
		
		private var myMask:MovieClip;
		
		private var animateMC:MovieClip ;
		
		private var firstX:Number,firstY:Number ;
		
		private var firstRadius:Number = 5,
					radiusStep:Number = NaN,//Its dynamic
					fadeSpeed:Number = 0.05 ;
		
		public function ShineElement()
		{
		}
		
		public function setUp(controller:Sprite):void
		{
			myTarget = controller ;
			
			firstX = stage.mouseX ;
			firstY = stage.mouseY ;
			
			spriteRect = myTarget.getBounds(stage);
			var maxAreaDymention:Number = Math.max(spriteRect.width,spriteRect.height);
			radiusStep = maxAreaDymention/(1/fadeSpeed);
			
			
			myMask = new MovieClip();
			animateMC = new MovieClip();
			
			animateMC.mask = myMask;
			
			this.addChild(myMask);
			this.addChild(animateMC);
			
			
			if(myTarget.stage==null)
			{
				removeMe();
			}
			else
			{
				myTarget.addEventListener(Event.REMOVED_FROM_STAGE,removeMe);
				update();
			}
		}
		
		protected function removeMe(event:Event=null):void
		{
			this.dispatchEvent(new Event(Event.REMOVED));
		}		
		
		public function update():void
		{
			spriteRect = myTarget.getBounds(stage);
			
			myMask.graphics.clear();
			myMask.graphics.beginFill(0xffffff,1);
			myMask.graphics.drawRect(spriteRect.x,spriteRect.y,spriteRect.width,spriteRect.height);
			//animateMC.mask = myMask ;
			
			
			firstRadius+=radiusStep ;
			
			animateMC.graphics.clear();
			animateMC.graphics.beginFill(0xffffff,0.5);
			animateMC.graphics.drawCircle(firstX,firstY,firstRadius);
			//animateMC.graphics.drawRect(spriteRect.x,spriteRect.y,spriteRect.width,spriteRect.height);
			
			animateMC.alpha-=fadeSpeed;
			if(animateMC.alpha<0 || Math.min(spriteRect.width,spriteRect.height)>500)
			{
				removeMe();
			}
		}
	}
}