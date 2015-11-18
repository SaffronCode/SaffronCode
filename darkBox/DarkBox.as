package darkBox
{
	import appManager.displayContentElemets.TitleText;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netManager.urlSaver.URLSaverEvent;
	
	public class DarkBox extends MovieClip
	{
		private static var ME:DarkBox ;
		
		private static var noNetTitle:String,
							noImageTitle:String;
		
		private var images:Vector.<ImageFile> ;
		
		private var box_flat:FlatImage,
					box_pano:PanoramaImage,
					box_shp:SphereImage,
					box_binary:BinaryFile,
					box_vid:VideoImage;
					
		private var bannerMC:MovieClip,
					titleMC:TitleText,
					downloadMC:MovieClip,
					backMC:MovieClip,
					nextMC:MovieClip,
					prevMC:MovieClip,
					precentMC:MovieClip,
					preLoderMC:MovieClip,
					closeMC:MovieClip;
					
		//private var maskMC:MovieClip ;
					
					
		private var currentImage:uint = 0 ,
					totalImages:uint;
		private var timeOutId:uint;
					
		private static var saveButtonFunction:Function;
		private static var showTitleInFullLine:Boolean;
					
		/**Get the current file*/
		public static function get currentMedia():ImageFile
		{
			return ME.currentMedia();
		}
		
		public function currentMedia():ImageFile
		{
			if(images.length>currentImage)
			{
				return images[currentImage] ;
			}
			return null ; 
		}
					
		/**Initialize the DarkBox area*/
		public static function setUp(newSize:Rectangle,noNetHintText:String='No Internet Connection Available',noImageHereText:String='',downloadFunction:Function=null,titleInFullLine:Boolean=false):void
		{
			showTitleInFullLine = titleInFullLine ;
			saveButtonFunction = downloadFunction ; 
			noNetTitle = noNetHintText ;
			noImageTitle = noImageHereText ;
			ME.setUp(newSize);
		}
		
		public static function show(Images:Vector.<ImageFile>,currentIndex:uint=0):void
		{
			ME.show(Images,currentIndex);
		}
		
		public function DarkBox()
		{
			trace("Dark box initialized");
			super();
			/*initMask();*/
			ME = this ;
			
			bannerMC = Obj.get("banner_mc",this);
			precentMC = Obj.get("percent_mc",this);
			backMC = Obj.get("back_mc",this);
			nextMC = Obj.get("next_mc",this);
			prevMC = Obj.get("prev_mc",this);
			closeMC = Obj.get("close_mc",this);
			titleMC = Obj.get("title_mc",this);
			preLoderMC = Obj.get("wait_mc",this);
			downloadMC = Obj.get("download_mc",this);
			downloadMC.buttonMode = true ;
			downloadMC.addEventListener(MouseEvent.CLICK,downloadCurrentMedia);
			preLoderMC.visible = false ;
			precentMC.visible = false;
			
			prevMC.buttonMode = nextMC.buttonMode = closeMC.buttonMode = true ;
			
			closeMC.addEventListener(MouseEvent.CLICK,closeMe);
			nextMC.addEventListener(MouseEvent.CLICK,nextImage);
			prevMC.addEventListener(MouseEvent.CLICK,prevImage);
			
			box_flat = Obj.findThisClass(FlatImage,this);
			box_pano = Obj.findThisClass(PanoramaImage,this);
			box_shp = Obj.findThisClass(SphereImage,this);
			box_binary = Obj.findThisClass(BinaryFile,this);
			box_vid = Obj.findThisClass(VideoImage,this);
				
			
			/*box_flat.mask = box_pano.mask = box_shp.mask = box_vid.mask = maskMC ;
			box_shp.mask = maskMC ;
			box_vid.mask = maskMC ;*/
			
			//Hide box
			//hideAll();
			this.alpha = 0 ;
			hide();
			//Video box will make a bug if hide function didn't call agin
			setTimeout(hide,100);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,catchBackButton,false,100000);
		}
		
		protected function catchBackButton(event:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			if(this.visible)
			{
				if(event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.HOME )
				{
					event.stopImmediatePropagation();
					hide();
				}
			}
		}
		
		protected function downloadCurrentMedia(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//images[currentImage].target
			if(saveButtonFunction!=null)
			{
				saveButtonFunction();
			}
		}
		
		protected function closeMe(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			hide();
		}
		
		/**Hide all boxes*/
		private function hideAll():void
		{
			box_flat.hide();
			box_pano.hide();
			box_binary.hide();
			box_shp.hide();
			if(box_vid)
				box_vid.hide();
		}
		
		/*private function initMask():void
		{
			if(maskMC==null)
			{
				maskMC = new MovieClip();
				this.addChild(maskMC);
			}
		}*/
		
		public function setUp(newSize:Rectangle):void
		{
			/*initMask();
			maskMC.graphics.beginFill(0);
			maskMC.graphics.drawRect(0,0,newSize.width,newSize.height);*/
				
			this.x = newSize.x;
			this.y = newSize.y;
			
			var imageSize:Rectangle = new Rectangle(0,bannerMC.height,newSize.width,newSize.height-bannerMC.height);
			
			bannerMC.x = 0 ;
			//closeMC.y = nextMC.y = prevMC.y = bannerMC.y = titleMC.y = 0 ;
			closeMC.x = newSize.width-closeMC.width ;
			downloadMC.x = closeMC.x - downloadMC.width ;
			downloadMC.visible = (saveButtonFunction!=null);
			if(showTitleInFullLine)
			{
				titleMC.x = 0 ;
			}
			else
			{
				titleMC.x = prevMC.x + prevMC.width ;
			}
			preLoderMC.x = imageSize.width/2;
			preLoderMC.y = imageSize.y+imageSize.height/2;
			precentMC.x = 0 ;
			precentMC.y = newSize.height ;
			
			backMC.width = newSize.width;
			backMC.height = newSize.height ;
			if(showTitleInFullLine)
			{
				titleMC.width = newSize.width ;
			}
			else
			{
				titleMC.width = newSize.width - (closeMC.width + prevMC.x + prevMC.width + downloadMC.width ) ;
			}
			bannerMC.width = newSize.width ;
			
			box_flat.setUp(imageSize);
			box_pano.setUp(imageSize);
			box_binary.setUp(imageSize);
			box_shp.setUp(imageSize);
			if(box_vid)
				box_vid.setUp(imageSize);
			
			
			MouseDrag.setUp(stage);
			
			MouseDrag.addFunctions(mouseDragedRight,mouseDraggedLeft,newSize);
		}
		
		private function mouseDraggedLeft()
		{
			if(this.visible && nextMC.visible && mouseSwipEnambed())
			{
				nextMC.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		private function mouseSwipEnambed():Boolean
		{
			var image:ImageFile = images[currentImage];
			return this.mouseEnabled && image.type!=ImageFile.TYPE_PANORAMA && image.type!=ImageFile.TYPE_SPHERE ;
		}
		
		private function mouseDragedRight()
		{
			if(this.visible && prevMC.visible && mouseSwipEnambed())
			{
				prevMC.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public static function hide():void
		{
			ME.hide();
		}
		
		public function hide():void
		{
			clearTimeout(timeOutId);
			hideAll();
			
			if(images!=null && images.length>currentImage)
			{
				images[currentImage].cansel();
			}
			
			this.mouseChildren = false ;
			this.mouseEnabled =false ;
			AnimData.fadeOut(this,onHide);
		}
			private function onHide():void
			{
				this.visible = false ;
			}
		
		public function show(Images:Vector.<ImageFile>,index:uint=0):void
		{
			
			images = Images.concat() ;
			if(images.length == 0)
			{
				titleMC.setUp(noImageTitle);
			}
			
			currentImage = index ;
			totalImages = images.length ;
			this.mouseChildren = true ;
			this.mouseEnabled = true ;
			this.visible = true ;
			AnimData.fadeIn(this);
			
			manageCurrentImage();
		}
		
		protected function prevImage(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			manageCurrentImage(currentImage-1);
		}
		
		protected function nextImage(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			manageCurrentImage(currentImage+1);
		}
		
		private function manageCurrentImage(imageIndex:int=-1):void
		{
			// TODO Auto Generated method stub
			if(imageIndex!=-1)
			{
				currentImage = Math.min(totalImages,Math.max(0,imageIndex)) ;
			}
			
			clearTimeout(timeOutId);
			
			hideAll();
			prevMC.visible = true ;
			nextMC.visible = true ;
			if(currentImage<=0)
			{
				prevMC.visible = false ;
			}
			if(currentImage>=totalImages-1)
			{
				nextMC.visible = false ;
			}
			
			loadImage(images[currentImage]);
		}
		
		private function loadImage(image:ImageFile):void
		{
			titleMC.setUp(image.title) ;
			if(image.storeOffline)
			{
				trace("Download image first");
				preLoderMC.visible = true ;
				precentMC.visible = true ;
				precentMC.width = 0 ;
				image.addEventListener(URLSaverEvent.LOAD_COMPLETE,imageDownloaded);
				image.addEventListener(URLSaverEvent.NO_INTERNET,noInternet);
				image.addEventListener(URLSaverEvent.LOADING,showPrecent);
				image.download();
			}
			else
			{
				preLoderMC.visible = false ;
				precentMC.visible = false ;
				showReadyImage(image);
			}
		}
		
		protected function showPrecent(event:URLSaverEvent):void
		{
			trace("donwloading");
			// TODO Auto-generated method stub
			precentMC.width = event.precent*backMC.width ;
		}
		
		protected function noInternet(event:Event):void
		{
			// TODO Auto-generated method stub
			titleMC.setUp(noNetTitle);
			
			//Reload this image if every thing is allright
			//timeOutId = setTimeout(manageCurrentImage,10000);
		}
		
		protected function imageDownloaded(event:URLSaverEvent):void
		{
			trace("Image is downloaded");
			// TODO Auto-generated method stub
			showReadyImage(event.target as ImageFile);
		}
		
		private function showReadyImage(image:ImageFile):void
		{
			preLoderMC.visible = false ;
			precentMC.visible = false ;
			trace("show this image");
			switch(image.type)
			{
				case ImageFile.TYPE_FLAT:
					box_flat.show(image.target);
					break;
				case ImageFile.TYPE_PANORAMA:
					box_pano.show(image.target);
					break;
				case ImageFile.TYPE_SPHERE:
					box_shp.show(image.target);
					break;
				case ImageFile.TYPE_VIDEO:
					if(box_vid)
						box_vid.show(image.target);
					break;
				case ImageFile.TYPE_BINARY:
					box_binary.show(image.target);
					break;
					
				default:
					trace("This image is unknown");
					break;
			}
		}
	}
}