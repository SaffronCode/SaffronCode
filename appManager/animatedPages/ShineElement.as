package appManager.animatedPages
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**Request to remove this elemet from page*/
	[Event(name="remove", type="flash.events.Event")]
	internal class ShineElement extends MovieClip
	{
		private var myTarget:MovieClip ;

		private var spriteRect:Rectangle;
		
		public function ShineElement()
		{
		}
		
		public function setUp(controller:MovieClip):void
		{
			myTarget = controller ;
			spriteRect = controller.getBounds(stage);
			
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(spriteRect.x,spriteRect.y,spriteRect.width,spriteRect.height);
			AnimData.fadeOut(this,removeMe);
		}
		
		private function removeMe():void
		{
			this.dispatchEvent(new Event(Event.REMOVED));
		}
		
		public function update():void
		{
			trace("Update shine");
		}
	}
}