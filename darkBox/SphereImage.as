package darkBox
{
	import com.flashandmath.bitmaps.BitmapSphere;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import myMultiTouch.zoomer2;

	public class SphereImage extends DefaultImage
	{
		
		private var imageLoader:Loader;
		
		private var imageMC:MovieClip;
		
		public function SphereImage()
		{
			super();
		}
		
		override public function hide():void
		{
			super.hide();
			if(imageLoader!=null)
			{
				try
				{
					imageLoader.close();
				}
				catch(e){};
			}
		}
		
		override public function show(target:String=''):void
		{
			super.show();
			this.removeChildren();
			
			
			imageMC = new MovieClip();
			this.addChild(imageMC);
			
			
			imageLoader = new Loader();
			var loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageNotLoaded);
			imageLoader.load(new URLRequest(target),loaderContext);
		}
		
		protected function imageLoaded(event:Event):void
		{
			
			var image:Bitmap = (imageLoader.content) as Bitmap ;
			
			var imageW:Number = Math.max(rect.width,rect.height)*4 ;
			
			var resizedBit:BitmapData = BitmapEffects.changeSize(image.bitmapData,imageW,imageW/2,false); 
			
			var rotatedBit:BitmapData = new BitmapData(resizedBit.width,resizedBit.height,false) ;
			rotatedBit.draw(resizedBit,new Matrix(-1,0,0,1,resizedBit.width));
			
			var sphere:BitmapSphere = new BitmapSphere(rotatedBit);
			sphere.x = rect.width/2;
			sphere.y = rect.height/2;
			imageMC.addChild(sphere);
			/*image.width = rect.width;
			image.height = rect.height ;
			image.scaleX = image.scaleY = Math.min(image.scaleX,image.scaleY);
			image.x = (rect.width-image.width)/2;
			image.y = (rect.height-image.height)/2;*/
			
			zoomer2.zoomAct(imageMC,rect.clone());
		}
		
		protected function imageNotLoaded(event:IOErrorEvent):void
		{
			
			trace("Image type is unknown");
		}
		
	}
}