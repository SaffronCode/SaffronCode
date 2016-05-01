package appManager.displayContent
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	internal class SliderGalleryElements extends MovieClip
	{
		private var lightImage:LightImage ;
		
		private var myArea:Rectangle ;
		
		public function SliderGalleryElements(rect:Rectangle)
		{
			super();
			myArea = rect.clone() ;
			lightImage = new LightImage();
			this.addChild(lightImage);
		}
		
		public function load(image:*):void
		{
			if(image is BitmapData)
			{
				lightImage.setUpBitmapData(image,false,myArea.width,myArea.height,0,0,true);
			}
			else if(image is ByteArray)
			{
				lightImage.setUpBytes(image,false,myArea.width,myArea.height,0,0,true);
			}
			else if(image is String)
			{
				lightImage.setUp(image,false,myArea.width,myArea.height,0,0,true);
			}
		}
	}
}