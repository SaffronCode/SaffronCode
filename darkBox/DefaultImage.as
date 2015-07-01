package darkBox
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	internal class DefaultImage extends MovieClip
	{
		protected var rect:Rectangle ;
		
		
		
		public function setUp(newSize:Rectangle):void
		{
			this.x = newSize.x;
			this.y = newSize.y;
			rect = newSize;
		}
		
		/**Hide this class*/
		public function hide():void
		{
			this.mouseChildren = false ;
			this.mouseEnabled = false ;
			this.visible = false ;
		}
		
		/**Show current class and show this file on it*/
		public function show(target:String=''):void
		{
			this.mouseChildren = true ;
			this.mouseEnabled = true ;
			this.visible = true ;
			//...
		}
		
		
		
		public function DefaultImage()
		{
			super();
		}
	}
}