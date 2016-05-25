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
		
		private var lastImage:SliderImageItem ;
		
		private var lastImageLoaded:String ;
		
		private var H:Number;
		
		public function SliderGalleryElements(rect:Rectangle)
		{
			super();
			myArea = rect.clone() ;
			lightImage = new LightImage();
			//lightImage.animated = false ;
			this.addChild(lightImage);
			//this.graphics.beginFill(0x000000,0.5);
			//this.graphics.drawRect(0,0,rect.width,rect.height);
		}
		
		override public function set height(value:Number):void
		{
			myArea.height = value ;
			Obj.remove(lightImage);
			lightImage = new LightImage();
			this.addChild(lightImage);
			load();
		}
		
		override public function get height():Number
		{
			return myArea.height ;
		}
		
		public function load(image:SliderImageItem=null):void
		{
			if((image==null && lastImage!=null) || image!=lastImage)
			{
				if(image==null)
				{
					image = lastImage ;
				}
				if(image.image is BitmapData)
				{
					lightImage.setUpBitmapData(image.image,false,myArea.width,myArea.height,0,0,true);
				}
				else if(image.image is ByteArray)
				{
					lightImage.setUpBytes(image.image,false,myArea.width,myArea.height,0,0,true);
				}
				else if(image.image is String)
				{
					lightImage.setUp(image.image,false,myArea.width,myArea.height,0,0,true);
				}
				lastImage = image ;
			}
		}
	}
}