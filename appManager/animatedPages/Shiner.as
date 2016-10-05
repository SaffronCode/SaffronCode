package appManager.animatedPages
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Shiner extends Sprite
	{
		private var shineList:Vector.<ShineElement> ; 
		
		public function Shiner()
		{
			super();
			this.mouseChildren = this.mouseEnabled = false ;
			shineList = new Vector.<ShineElement>();
			
			this.addEventListener(Event.ENTER_FRAME,updateShines);
		}
		
		/**Update shine positions and animation*/
		protected function updateShines(event:Event):void
		{
			for(var i = 0 ; i<shineList.length ; i++)
			{
				shineList[i].update();
			}
		}		
		
		/**Add shine to this area*/
		public function add(button:Sprite):void
		{
			var shine:ShineElement = new ShineElement()
				shine.addEventListener(Event.REMOVED,removeShine);//Dont change the orders
				this.addChild(shine);
				shineList.push(shine);
			shine.setUp(button as MovieClip);
		}
		
		private function removeShine(event:Event):void
		{
			trace("***Remove shine");
			var shine:ShineElement = event.target as ShineElement ;
			//shine.removeEventListener(Event.REMOVED,removeShine);
			Obj.remove(shine);
			var shineIndex:int = shineList.indexOf(shine);
			if(shineIndex>=0)
			{
				shineList.splice(shineIndex,1);
			}
		}
	}
}