package animation
	//animation.PixelComeInEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import contents.alert.Alert;
	
	public class PixelComeInEffect extends MovieClip
	{
		/**Pixel widths*/
		public static var W:Number = 30 ;
		
		/**Pixel delay to change in miliseconds*/
		public static var pixelDelay:uint = 40 ;
		/**Number of pixels that comes in in a single time*/
		public static var pixelPerTimePrecent:Number = 0.1 ;
		/**Pixels color*/
		public static var pixelsColor:uint = 0xffffff;//0xE15E3A;
		
		/**Dynamic variable*/
		private static var pixelPerTime:uint ;
		
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
		
		private var myParent:DisplayObjectContainer ;
		
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
			
			pixels.sort(randomSort);
			
			pixelPerTime = Math.ceil(pixels.length*pixelPerTimePrecent);
			
			this.addEventListener(Event.ADDED_TO_STAGE,controlStage);
		}
		
			/**Random sort function*/
			private function randomSort(a:*=null,b:*=null):int
			{
				return Math.floor(3*Math.random())-1;
			}
		
		/**Control when object joined to the stage*/
		private function controlStage(e:Event):void
		{
			if(this.stage!=null)
			{
				myParent = this.parent as DisplayObjectContainer;
				clearInterval(intervalId);
				intervalId = setInterval(showOnePixel,pixelDelay);
				
				this.addEventListener(Event.REMOVED_FROM_STAGE,handleRemoveEffect);
			}
		}
		
			/**Remove object with effect*/
			private function handleRemoveEffect(e:Event):void
			{
				SaffronLogger.log("Item removed");
				clearInterval(intervalId);
				this.removeEventListener(Event.REMOVED_FROM_STAGE,handleRemoveEffect);
				//Prevent saffron code to remove my bitmap
				e.stopImmediatePropagation();
				try
				{
					//Cause a crash!!
					myBitmap.x = maskSprite.x = this.x;
					myBitmap.y = maskSprite.y = this.y;
					myParent.addChild(myBitmap);
					myParent.addChild(maskSprite);
					
					lastPixels = new Vector.<Sprite>();
					intervalId = setInterval(removeThemOneByOnePixel,pixelDelay);
				}catch(e)
				{
					SaffronLogger.log("Error : "+e);
				}
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
				
				for(i = Math.min(pixels.length,pixelPerTime) ; i>0 ; i--)
				{
					currentPixel = pixels.removeAt(0) as Sprite ; 
					lastPixels.push(currentPixel);
					currentPixel.visible = true ;
				}
				
				
			}
			
			/**Remove pixels one by one*/
			private function removeThemOneByOnePixel():void
			{
				var i:int ;
				var currentPixel:Sprite ;
				
				for(i = 0 ; i<lastPixels.length ; i++)
				{
					myParent.removeChild(lastPixels[i]);
				}
				lastPixels = new Vector.<Sprite>();
				
				for(i = Math.min(pixelPerTime,maskSprite.numChildren) ; i>0 ; i--)
				{
					currentPixel = maskSprite.removeChildAt(0) as Sprite ;
					lastPixels.push(currentPixel);
					myParent.addChild(currentPixel);
					currentPixel.visible = true ;
					currentPixel.x = currentPixel.x+maskSprite.x ;
					currentPixel.y = currentPixel.y+maskSprite.y ;
				}
				
				if(maskSprite.numChildren==0 && lastPixels.length == 0)
				{
					clearInterval(intervalId);
					myParent.removeChild(maskSprite);
					myBitmap.bitmapData.dispose();
					myParent.removeChild(myBitmap);
				}
			}
	}
}