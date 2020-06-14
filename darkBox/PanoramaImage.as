package darkBox
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import myMultiTouch.zoomer2;

	public class PanoramaImage extends DefaultImage
	{
		private var imageLoader:Loader;
		
		private var imageMC:MovieClip,
					dragableImage:MovieClip;
		
		public function PanoramaImage()
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
			SaffronLogger.log("show this image : "+target);
			
			super.show();
			this.removeChildren();
			
			
			
			imageMC = new MovieClip();
			this.addChild(imageMC);
			dragableImage = new MovieClip();
			imageMC.addChild(dragableImage);
			
			
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
			dragableImage.addChild(image);
			image.height = rect.height ;
			image.scaleX = image.scaleY ;
			//dragableImage.x = (rect.width-image.width)/2;
			dragableImage.addEventListener(MouseEvent.MOUSE_DOWN,startImageDrag);
			dragableImage.addEventListener(MouseEvent.MOUSE_UP,stopImageDrag);
			
			zoomer2.zoomAct(imageMC,rect.clone());
		}
		
		protected function stopImageDrag(event:MouseEvent):void
		{
			
			dragableImage.stopDrag();
		}
		
		protected function startImageDrag(event:MouseEvent):void
		{
			
			dragableImage.startDrag(false,new Rectangle(rect.width-dragableImage.width,0,dragableImage.width-rect.width,0));
		}
		
		protected function imageNotLoaded(event:IOErrorEvent):void
		{
			
			SaffronLogger.log("Image type is unknown");
		}
	}
}