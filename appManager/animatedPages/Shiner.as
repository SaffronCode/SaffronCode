package appManager.animatedPages
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class Shiner extends Sprite
	{
		public function Shiner()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
		}
		
		
		/**Add shine to this area*/
		public function add(button:Sprite):void
		{
			var shine:MovieClip = new MovieClip();
			var spriteRect:Rectangle = button.getBounds(stage);
			
			this.addChild(shine);
			shine.graphics.beginFill(0xffffff,1);
			shine.graphics.drawRect(spriteRect.x,spriteRect.y,spriteRect.width,spriteRect.height);
			AnimData.fadeOut(shine,removeShine);
		}
		
		private function removeShine(shine:MovieClip):void
		{
			trace("Remove shine");
			Obj.remove(shine);
		}
	}
}