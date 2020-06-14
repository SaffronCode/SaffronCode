package darkBox
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import myMultiTouch.zoomer2;
	
	public class FlatImage extends DefaultImage
	{

		private var imageLoader:Loader;

		private var imageMC:MovieClip;
		
		public function FlatImage()
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
			image.smoothing = true ;
			imageMC.addChild(image);
			image.width = rect.width;
			image.height = rect.height ;
			image.scaleX = image.scaleY = Math.min(image.scaleX,image.scaleY);
			image.x = (rect.width-image.width)/2;
			image.y = (rect.height-image.height)/2;
			
			zoomer2.zoomAct(imageMC,rect.clone());
		}
		
		protected function imageNotLoaded(event:IOErrorEvent):void
		{
			
			SaffronLogger.log("Image type is unknown");
		}
	}
}