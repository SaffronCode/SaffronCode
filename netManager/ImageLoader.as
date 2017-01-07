package netManager
{
	
	import appManager.displayContentElemets.ImageEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;
	
	[Event(name="IMAGE_LOADED", type="flash.events.Event")]
	[Event(name="IMAGE_URL_NOT_FOUNDS", type="flash.events.Event")]
	
	public class ImageLoader extends MovieClip
	{
		public static const IMAGE_LOADED:String = "IMAGE_LOADED";
		
		public static const IMAGE_URL_NOT_FOUNDS:String = "IMAGE_URL_NOT_FOUNDS";
		
		private var imageURL:String ;
		
		private var onlineURL:String ;
		
		private var myWidth:Number,
					myHeight:Number;
					
		public var loader:Loader;
		
		/**If this boolean is true , that means your image have to fit in the area box , but if not , your area box will fit in the ratio of image*/
		private var loadIn:Boolean ;
		
		private var myURLSaver:URLSaver ;
		
		private var myPreLoader:DisplayObject ;
		
		private var preLoaderClass:Class ;
		private var resizeBitmapFlag:Boolean;
		
		
		/**if you whant to resize image in each ratio , set your size on it*/
		public function ImageLoader(MyWidth:Number=0,MyHeight:Number=0,loadInThisArea:Boolean = false , myPreLoaderClassItem:Class = null,resizeBitmap:Boolean=false)
		{
			super();
			
			resizeBitmapFlag = resizeBitmap ;
			
			preLoaderClass = myPreLoaderClassItem ;
			
			myURLSaver = new URLSaver(true);
			
			//this.alpha = 0.5 ;
			loadIn = loadInThisArea;
			//trace("ImageLoader Initialize : "+loadIn);
			
			myWidth = MyWidth ;
			myHeight = MyHeight ;
			
			//trace('Create image width '+MyWidth+' width.');
			
			loader = new Loader();
			
			this.addEventListener(MouseEvent.CLICK,imSelected);
		}
		
		protected function imSelected(event:MouseEvent):void
		{
			
			var target:String ;
			if(imageURL!=null)
			{
				target = imageURL ;
			}
			else
			{
				target = onlineURL ;
			}
			this.dispatchEvent(new ImageEvent(ImageEvent.IMAGE_SELECTED,target));
		}
		
		override public function get height():Number
		{
			return myHeight ;
		}
		
		override public function get width():Number
		{
			return myWidth ;
		}
		
		public function load(url:String)
		{
			onlineURL = imageURL = url ;
			stageTest();
		}
		
		private function stageTest(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,stageTest);
			
			if(this.stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,stageTest);
			}
			else
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				loadImage();
			}
		}
		
		protected function unLoad(event:Event):void
		{
			//trace("Cansel "+imageURL+" downloading");
			
			this.removeChildren();
			myURLSaver.cansel();
			try
			{
				loader.close();
			}catch(e){};
		}
		
		private function loadImage():void
		{
			
			unLoad(null);
			if(imageURL == "")
			{
				this.dispatchEvent(new Event(IMAGE_URL_NOT_FOUNDS));
			}
			else
			{
				myURLSaver.addEventListener(URLSaverEvent.LOAD_COMPLETE,imageURLChagedToLocal);
				myURLSaver.addEventListener(URLSaverEvent.LOADING,imageLoadingStarted);
				myURLSaver.addEventListener(URLSaverEvent.NO_INTERNET,urlProblem);
				var imageIsOffline:Boolean = myURLSaver.load(imageURL);
				
				if(!imageIsOffline)
				{
					showPreLoader();
				}
			}
		}
		
		protected function imageLoadingStarted(ev:URLSaverEvent):void
		{
			
			//trace('downloading : '+ev.precent);
			if(myPreLoader!=null && myPreLoader.hasOwnProperty('setUp'))
			{
				(myPreLoader['setUp'] as Function).apply(ev.precent);
			}
		}
		
		/**Generate pre loader*/
		private function showPreLoader():void
		{
			//trace("ask to load pre loader");
			
			if(myPreLoader == null && preLoaderClass!=null)
			{
				//trace("this is pre loader");
				myPreLoader = new preLoaderClass() ;
				this.addChild(myPreLoader) ;
				myPreLoader.x = myWidth/2 ;
				myPreLoader.y = myHeight/2 ;
			}
		}
		
		protected function imageURLChagedToLocal(ev:URLSaverEvent):void
		{
			myURLSaver.cansel();
			//return ;
			
			imageURL = ev.offlineTarget ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,urlProblem);
			var loaderContext:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			loader.load(new URLRequest(imageURL),loaderContext);
			
			if(myPreLoader!=null)
			{
				this.removeChild(myPreLoader);
			}
		}
		
		protected function urlProblem(event:*):void
		{
			
			//trace('cansel!!');
			myURLSaver.cansel();
			myURLSaver.deletFileIfExists(imageURL);
			//Bug found, i was dispatched IMAGE_LOADED by mistake.
			this.dispatchEvent(new Event(IMAGE_URL_NOT_FOUNDS));
		}
		
		protected function imageLoaded(event:Event):void
		{
			
			var image:Bitmap ;
			if(resizeBitmapFlag)
			{
				var resizedPhoto:BitmapData = BitmapEffects.changeSize((loader.content as Bitmap).bitmapData,myWidth,myHeight,true) ;
				image = new Bitmap(resizedPhoto);
				image.smoothing = true ;
				this.addChild(image) ;
			}
			else
			{
				//trace("myWidth : "+myWidth+" , myHeight : "+myHeight+" > "+imageURL);
				image = loader.content as Bitmap ;
				
				if(myWidth!=0)
				{
					image.width = myWidth ;
				}
				if(myHeight !=0)
				{
					image.height = myHeight ;
				}
				//
				//trace("image current hieght : "+image.height);
				//
				//trace("loadIn : "+loadIn);
				
				if(loadIn)
				{
					image.scaleX = image.scaleY = Math.min(image.scaleX,image.scaleY);
				}
				else
				{
					image.scaleX = image.scaleY = Math.max(image.scaleX,image.scaleY);
				}
				
				//trace("image final hieght : "+image.height);
				
				if(myWidth==0)
				{
					myWidth = image.width ;
				}
				if(myHeight == 0)
				{
					myHeight = image.height ;
				}
				
				
				image.smoothing = true ;
				this.addChild(image) ;
				
				image.x = (myWidth-image.width)/2 ;
				image.y = (myHeight-image.height)/2 ;
				
			}
			
			
			this.dispatchEvent(new Event(IMAGE_LOADED));
		}
		
		public function deleteImageIfItsCashed():void
		{
			
			myURLSaver.deletFileIfExists(onlineURL);
		}
	}
}