package netManager
{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import netManager.urlSaver.URLSaver;
	import netManager.urlSaver.URLSaverEvent;
	
	[Event(name="IMAGE_LOADED", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	[Event(name="IMAGE_URL_NOT_FOUNDS", type="com.mteamapp.loader.urlSaver.URLSaverEvent")]
	
	public class ImageLoader extends MovieClip
	{
		public static const IMAGE_LOADED:String = "IMAGE_LOADED";
		
		public static const IMAGE_URL_NOT_FOUNDS:String = "IMAGE_URL_NOT_FOUNDS";
		
		private var imageURL:String ;
		
		private var myWidth:Number,
					myHeight:Number;
					
		private var loader:Loader;
		
		/**If this boolean is true , that means your image have to fit in the area box , but if not , your area box will fit in the ratio of image*/
		private var loadIn:Boolean ;
		
		private var myURLSaver:URLSaver ;
		
		private var myPreLoader:DisplayObject ;
		
		private var preLoaderClass:Class ;
		
		/**if you whant to resize image in each ratio , set your size on it*/
		public function ImageLoader(MyWidth:Number=0,MyHeight:Number=0,loadInThisArea:Boolean = false , myPreLoaderClassItem:Class = null)
		{
			super();
			
			preLoaderClass = myPreLoaderClassItem ;
			
			myURLSaver = new URLSaver(true);
			
			//this.alpha = 0.5 ;
			
			loadIn = loadInThisArea;
			
			myWidth = MyWidth ;
			myHeight = MyHeight ;
			
			trace('Create image width '+MyWidth+' width.');
			
			loader = new Loader();
			
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
			imageURL = url ;
			stageTest();
		}
		
		private function stageTest(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,stageTest);
			// TODO Auto Generated method stub
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
			trace("Cansel "+imageURL+" downloading");
			// TODO Auto-generated method stub
			myURLSaver.cansel();
			try
			{
				loader.close();
			}catch(e){};
		}
		
		private function loadImage():void
		{
			// TODO Auto Generated method stub
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
		
		protected function imageLoadingStarted(event:URLSaverEvent):void
		{
			// TODO Auto-generated method stub
			trace('downloading : '+event.precent);
			if(myPreLoader!=null && myPreLoader.hasOwnProperty('setUp'))
			{
				(myPreLoader['setUp'] as Function).apply(event.precent);
			}
		}
		
		/**Generate pre loader*/
		private function showPreLoader():void
		{
			trace("ask to load pre loader");
			// TODO Auto Generated method stub
			if(myPreLoader == null && preLoaderClass!=null)
			{
				trace("this is pre loader");
				myPreLoader = new preLoaderClass() ;
				this.addChild(myPreLoader) ;
				myPreLoader.x = myWidth/2 ;
				myPreLoader.y = myHeight/2 ;
			}
		}
		
		protected function imageURLChagedToLocal(event:URLSaverEvent):void
		{
			myURLSaver.cansel();
			// TODO Auto-generated method stub
			imageURL = event.offlineTarget ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,urlProblem);
			loader.load(new URLRequest(imageURL));
			
			if(myPreLoader!=null)
			{
				this.removeChild(myPreLoader);
			}
		}
		
		protected function urlProblem(event:*):void
		{
			// TODO Auto-generated method stub
			trace('cansel!!');
			myURLSaver.cansel();
			myURLSaver.deletFileIfExists(imageURL);
			this.dispatchEvent(new Event(IMAGE_LOADED));
		}
		
		protected function imageLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			var image:Bitmap = loader.content as Bitmap ;
			image.smoothing = true ;
			this.addChild(image);
			
			trace("myWidth : "+myWidth+" , myHeight : "+myHeight+" > "+imageURL);
			
			if(myWidth!=0)
			{
				image.width = myWidth ;
			}
			if(myHeight !=0)
			{
				image.height = myHeight ;
			}
			
			trace("image current hieght : "+image.height);
			
			if(loadIn)
			{
				image.scaleX = image.scaleY = Math.min(image.scaleX,image.scaleY);
			}
			else
			{
				trace("Wrong proccess");
				image.scaleX = image.scaleY = Math.max(image.scaleX,image.scaleY);
			}
			
			trace("image final hieght : "+image.height);
			
			if(myWidth==0)
			{
				myWidth = image.width ;
			}
			if(myHeight == 0)
			{
				myHeight = image.height ;
			}
			
			image.x = (myWidth-image.width)/2 ;
			image.y = (myHeight-image.height)/2 ;
			
			
			this.dispatchEvent(new Event(IMAGE_LOADED));
		}
	}
}