package animation
	//animation.PixelComeInEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class PixelComeInEffect extends MovieClip
	{
		/**Pixel widths*/
		private static var W:Number = 30 ;
		
		/**Pixel delay to change in miliseconds*/
		private static var pixelDelay:uint = 50 ;
		/**Number of pixels that comes in in a single time*/
		private static var pixelPerTime:uint = 4 ;
		/**Pixels color*/
		private static var pixelsColor:uint = 0xE15E3A;
		
		private var myBitmapData:BitmapData,
					myBitmap:Bitmap;
					
		private var maskEffect:Sprite ;
		private var maskSprite:Sprite ;
		
		/**All pixels in the stage*/
		private var pixels:Vector.<Sprite> ;
		
		/**Visible pixels*/
		private var lastPixels:Vector.<Sprite> ;
		
		/**Pixels in the mask sprite*/
		private var maskedPixels:Vector.<Sprite> ;
		
		private var intervalId:uint ;
		
		public function PixelComeInEffect()
		{
			super();
			
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,2,2);
			
			myBitmapData = new BitmapData(Math.ceil(this.width),Math.ceil(this.height),true,0x000000ff);
			myBitmapData.draw(this);
			
			this.removeChildren();
			myBitmap = new Bitmap(myBitmapData);
			this.addChild(myBitmap);
			
			maskSprite = new Sprite();
			this.addChild(maskSprite);
			
			maskEffect = new Sprite();
			this.addChild(maskEffect);
			
			myBitmap.mask = maskSprite ;
			
			
			var width0:Number = this.width ;
			var height0:Number = this.height ;
			
			pixels = new Vector.<Sprite>();
			lastPixels = new Vector.<Sprite>();
			
			for(var i:int = 0 ; i<width0 ; i+=W)
			{
				for(var j:int = 0 ; j<height0 ; j+=W)
				{
					if(myBitmapData.hitTest(new Point(0,0),200,new BitmapData(W+2,W+2,false,0xffffff),new Point(i-1,j-1),255))
					{
						var aPixel:Sprite = new Sprite();
						aPixel.graphics.beginFill(pixelsColor,1);
						aPixel.graphics.drawRect(0,0,W,W);
						aPixel.x = i ;
						aPixel.y = j ;
						aPixel.visible = false ;
						pixels.push(aPixel);
						this.addChild(aPixel);
					}
				}
			}
			
			clearInterval(intervalId);
			intervalId = setInterval(showOnePixel,pixelDelay);
		}
		
		
		/**Activate a pixel*/
		private function showOnePixel():void
		{
			var currentPixel:Sprite ;
			var i:int ;
			
			for(i = 0 ; i<lastPixels.length ; i++)
			{
				currentPixel = lastPixels[i] ;
				maskSprite.addChild(currentPixel);
			}
			//Clear visible sprite list, all of them moved to the mask sprite
			lastPixels = new Vector.<Sprite>();
			
			if(pixels.length<=0)
			{
				clearInterval(intervalId);
				return ;
			}
			
			for(i = 0 ; i<Math.min(pixels.length,pixelPerTime) ; i++)
			{
				currentPixel = pixels.removeAt(Math.floor(Math.random()*pixels.length)) as Sprite ; 
				lastPixels.push(currentPixel);
				currentPixel.visible = true ;
			}
			
			
		}
	}
}