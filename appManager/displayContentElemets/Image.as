package appManager.displayContentElemets
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Image extends MovieClip
	{
		protected var URL:String ;
		
		public function Image()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK,openMe);
		}
		
		protected function openMe(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new ImageEvent(ImageEvent.IMAGE_SELECTED,URL));
		}
		
		public function setUp(imageURL:String,loadInThisArea:Boolean = false ,imageW:Number=0,imageH:Number=0,X:Number=0,Y:Number=0,keepRatio:Boolean=true)
		{
		}
	}
}