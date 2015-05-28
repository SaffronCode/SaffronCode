package appManager.displayContentElemets
	//appManager.displayContentElemets.LightImage
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;

	/**Image loading completed*/
	[Event(name="complete", type="flash.events.Event")]
	/**image loadin faild*/
	[Event(name="unload", type="flash.events.Event")]
	/**This class will resize the loaded image to its size to prevent gpu process and also it will crop the image to.*/
	public class LightImage extends Image
	{
		/**If the image item name contains below string, it will make it show image in the area and do not crop it*/
		public static const _full:String = "_full";
		
		
		/**This will make image to load in the stage with fade in animation*/
		public static var acitvateAnimation:Boolean = true ;
		
		/**You can cansel all animation by changing the static value activateAnimation*/
		public var animated:Boolean = true ;
		
		private var loader:Loader ,
					urlSaver:URLSaver; 
		
		private var W:Number=0,H:Number=0,URL:String,
					LoadInThisArea:Boolean;
					
		private var timeOutValue:uint ;
		
		public function LightImage()
		{
			super();
		}
		
		override public function get height():Number
		{
			if(H==0)
			{
				return super.height;
			}
			return H ;
		}
		
		override public function get width():Number
		{
			if(W==0)
			{
				return super.width;
			}
			return W ;
		}
		
		/**Second setting up the LightImage class*/
		public function setUp2(doAnimation:Boolean = true)
		{
			animated = doAnimation ;
		}
		
		
		/**This class will resize the loaded image to its size to prevent gpu process and also it will crop the image to.*/
		override public function setUp(imageURL:String, loadInThisArea:Boolean=false, imageW:Number=0, imageH:Number=0, X:Number=0, Y:Number=0):*
		{
			//trace("Load this image : "+imageURL);
			if(URL == imageURL)
			{
				trace("current image is same as old image on lightImage");
				return ;
			}
			URL = imageURL;
			if(imageW!=0)
			{
				W = imageW;
			}
			else
			{
				W = super.width ;
			}
			if(imageH!=0)
			{
				H = imageH;
			}
			else
			{
				H = super.height;
			}
			//I dont want to remove content for this 
				this.removeChildren();

			this.graphics.clear();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,W,H);
			
			LoadInThisArea = loadInThisArea ;
			if(this.name.indexOf(_full)!=-1)
			{
				trace("Load in this area type changed because of its name");
				LoadInThisArea = true ;
			}
			
			if(X!=0)
			{
				this.x = X ;
			}
			if(Y!=0)
			{
				this.y=Y;
			}
			if(this.stage!=null)
			{
				startWork(null);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,startWork);
			}
			this.scaleX = this.scaleY = 1 ;
		}
		
		protected function startWork(event:Event=null):void
		{
			//trace("Start to load");
			// TODO Auto-generated method stub
			urlSaver = new URLSaver(true);
			urlSaver.addEventListener(URLSaverEvent.LOAD_COMPLETE,imageSaved);
			urlSaver.addEventListener(URLSaverEvent.NO_INTERNET,imageNotFound);
			urlSaver.load(URL);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function imageSaved(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			var loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			//trace("Load this image : "+event.offlineTarget);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageNotFound);
			loader.load(new URLRequest(event.offlineTarget),loaderContext);
		}
		
		protected function imageNotFound(event:*):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new Event(Event.UNLOAD));
			
			timeOutValue = setTimeout(startWork,10000);
		}
		
		protected function imageLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			var newBitmap:Bitmap = (loader.content as Bitmap);
			var bitmapData:BitmapData = newBitmap.bitmapData ;
			
			var newBitmapData:BitmapData = BitmapEffects.changeSize(bitmapData,W,H,true,LoadInThisArea) ;
			newBitmap = new Bitmap(newBitmapData);
			newBitmap.smoothing = true ;
			//this.addChild(newBitmap);
			
			//I will try to load image in imageContainer to controll mask but on Android
			var imageContainer:Sprite = new Sprite();
			this.addChild(imageContainer);
			imageContainer.addChild(newBitmap);
			
			if(acitvateAnimation && animated)
			{
				this.alpha = 0 ;
				//trace("make it come with animation : "+this);
				AnimData.fadeIn(this);
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			clearTimeout(timeOutValue);
			
			urlSaver.removeEventListener(URLSaverEvent.LOAD_COMPLETE,imageSaved);
			urlSaver.removeEventListener(URLSaverEvent.NO_INTERNET,imageNotFound);
			try
			{
				loader.close();
			}
			catch(e)
			{
				trace("LightImage problem : "+e);
			}
		}
	}
}