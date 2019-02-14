package animation
	//animation.PixelComeInEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PixelComeInEffect extends MovieClip
	{
		/**Pixel widths*/
		private static var W:Number = 5 ;
		
		private var myBitmapData:BitmapData,
					myBitmap:Bitmap;
					
		private var maskEffect:Sprite ;
		private var maskSprite:Sprite ;
		
		private var pixels:Vector.<Sprite> ;
		
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
			
			//myBitmap.mask = maskSprite ;
			
			
			var width0:Number = this.width ;
			var height0:Number = this.height ;
			
			for(var i:int = 0 ; i<width0 ; i+=W)
			{
				for(var j:int = 0 ; j<height0 ; j+=W)
				{
					if(myBitmapData.hitTest(new Point(0,0),200,new BitmapData(W,W,false,0xffffff),new Point(i,j),255))
					{
						var aPixel:Sprite = new Sprite();
						aPixel.graphics.beginFill(0xffffff,1);
						aPixel.graphics.drawRect(0,0,W,W);
						aPixel.x = i ;
						aPixel.y = j ;
						this.addChild(aPixel);
					}
				}
			}
		}
	}
}