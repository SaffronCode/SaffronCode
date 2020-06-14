package panorama
{
	import appManager.displayContentElemets.LightImage;
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	//import maskan.elements.PreLoader;
	
	import netManager.ImageLoader;
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;
	
	public class PanoramaPage extends MovieClip implements DisplayPageInterface
	{
		private var panoramaID:uint = 1431412;
		
		private var myPageData:PageData ;
		
		private var urlSaver:URLSaver ;
		
		private var images:Vector.<Bitmap> ;
		
		private var centerImage:uint ;
		
		private var imageLoader:Loader ;
		
		public function PanoramaPage()
		{
			super();
			
			images = new Vector.<Bitmap>();
		}
		
		public function setUp(pageData:PageData):void
		{
			myPageData = pageData ;
			
			
			urlSaver = new URLSaver(true);
			urlSaver.addEventListener(URLSaverEvent.LOAD_COMPLETE,imageLoaded);
			urlSaver.addEventListener(URLSaverEvent.NO_INTERNET,imageNotFound);
			
			urlSaver.load(pageData.images[0].targURL);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			
			urlSaver.cansel();
		}
		
		protected function imageNotFound(event:Event):void
		{
			
			SaffronLogger.log("Cant load this image : "+myPageData.images[0].targURL);
			//Hints.hint(Contents.lang.t.image_not_loaded,myPageData.title);
			this.dispatchEvent(AppEventContent.lastPage());
		}
		
		protected function imageLoaded(event:URLSaverEvent):void
		{
			
			SaffronLogger.log("All images loaded");
			generatePage(event.offlineTarget);
		}
		
		private function generatePage(imageTarget:String):void
		{
			
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageIsLoadedToShow);
			imageLoader.load(new URLRequest(imageTarget));
		}
		
		protected function imageIsLoadedToShow(event:Event):void
		{
			
			var bitmap:Bitmap = imageLoader.content as Bitmap; 
			var bitmapData:BitmapData = bitmap.bitmapData ;
			
			for(var i = 0 ; i<3 ; i++)
			{
				var newBitmap:Bitmap = new Bitmap(bitmapData);
				this.addChild(newBitmap);
				images.push(newBitmap);
			}
			centerImage = 1 ;
		}
	}
}