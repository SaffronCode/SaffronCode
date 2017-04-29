package darkBox
{
	import appManager.displayContentElemets.TitleText;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import nativeClasses.player.DistriqtMediaPlayer;
	
	import netManager.urlSaver.URLSaverEvent;
	
	import stageManager.StageManager;
	import stageManager.StageManagerEvent;
	
	import videoShow.StageVideo;
	
	public class DarkBox extends MovieClip
	{
		
		
		private static var ME:DarkBox ;
		
		private static var noNetTitle:String,
							noImageTitle:String;
							
							
		private var stageVideo:StageVideo;

		
		private var images:Vector.<ImageFile> ;
		
		private var box_flat:FlatImage,
					box_pano:PanoramaImage,
					box_shp:SphereImage,
					box_binary:BinaryFile,
					box_stageWeb:WebOpener,
					box_vid:VideoImage,
					box_vid2:DistriqtMediaPlayer;
					
		private var bannerMC:MovieClip,
					titleMC:TitleText,
					downloadMC:MovieClip,
					backMC:MovieClip,
					nextMC:MovieClip,
					prevMC:MovieClip,
					precentMC:MovieClip,
					preLoderMC:MovieClip,
					closeMC:MovieClip;
					
		private var _Watermarkdark_mc:MovieClip;
		
		
		private static var rtf:Boolean ; 
		
		/**Control this on mouse up*/
		private var mouseDownTime:Number;
		private const mouseUpMinimomTime:uint=100;
					
		//private var maskMC:MovieClip ;
					
					
		private var currentImage:uint = 0 ,
					totalImages:uint;
		private var timeOutId:uint;
					
		private static var saveButtonFunction:Function;
		private static var showTitleInFullLine:Boolean;
		private var closeFunction:Function;

		private var imageSize:Rectangle;
					
		/**Get the current file*/
		public static function get currentMedia():ImageFile
		{
			return ME.currentMedia();
		}
		
		public static function getCurrentImageIndex():uint
		{
			return ME.currentImage ;
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
		public static function setUp(newSize:Rectangle,noNetHintText:String='No Internet Connection Available',noImageHereText:String='',downloadFunction:Function=null,titleInFullLine:Boolean=false,RightToLeft:Boolean=true,activateAutoSize:Boolean=true):void
		{
			rtf = RightToLeft ;
			showTitleInFullLine = titleInFullLine ;
			saveButtonFunction = downloadFunction ; 
			noNetTitle = noNetHintText ;
			noImageTitle = noImageHereText ;
			ME.setUp(newSize);
			
			if((true || DevicePrefrence.isAndroid()) && activateAutoSize)
			{
				StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED,updateStageSize);
			}
			
			if(DevicePrefrence.isItPC && DevicePrefrence.appDescriptor.toString().indexOf("<android>")!=-1 &&  DevicePrefrence.appDescriptor.toString().indexOf('android:hardwareAccelerated="true')==-1)
			{
				throw 'You have to add below permition to Android manifest to make StageVideo works:\n<application android:enabled="true" android:hardwareAccelerated="true"/>\n\nor\n\n<application android:enabled="true" android:hardwareAccelerated="true">'
			}
		}
		
		protected static function updateStageSize(event:Event):void
		{
			ME.setUp(StageManager.stageRect);
			ME.x = StageManager.stageDelta.width/-2;
			ME.y = StageManager.stageDelta.height/-2;
		}
		
		public static function show(Images:Vector.<ImageFile>,currentIndex:uint=0,onClosed:Function=null):void
		{
			ME.show(Images,currentIndex,onClosed);
		}
		
		public function DarkBox()
		{
			trace("Dark box initialized");
			super();
			/*initMask();*/
			ME = this ;
			
			_Watermarkdark_mc = Obj.get("Watermarkdark_mc",this);
			bannerMC = Obj.get("banner_mc",this);
			precentMC = Obj.get("percent_mc",this);
			backMC = Obj.get("back_mc",this);
			closeMC = Obj.get("close_mc",this);
			titleMC = Obj.get("title_mc",this);
			preLoderMC = Obj.get("wait_mc",this);
			downloadMC = Obj.get("download_mc",this);
			downloadMC.buttonMode = true ;
			downloadMC.addEventListener(MouseEvent.CLICK,downloadCurrentMedia);
			preLoderMC.visible = false ;
			precentMC.visible = false;
			
			if(_Watermarkdark_mc !== null){
				_Watermarkdark_mc.mouseChildren = false
				_Watermarkdark_mc.mouseEnabled = false
			}
			
			closeMC.addEventListener(MouseEvent.CLICK,closeMe);
			backMC.addEventListener(MouseEvent.MOUSE_DOWN,startCloseTimer);
			backMC.addEventListener(MouseEvent.MOUSE_UP,mouseUpEventControll);
			
			box_flat = Obj.findThisClass(FlatImage,this);
			box_pano = Obj.findThisClass(PanoramaImage,this);
			box_shp = Obj.findThisClass(SphereImage,this);
			box_binary = Obj.findThisClass(BinaryFile,this);
			box_vid = Obj.findThisClass(VideoImage,this);
			box_stageWeb = new WebOpener();
			this.addChild(box_stageWeb);
			
				
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
		
		/**Controll mouse up on back ground*/
		protected function mouseUpEventControll(event:MouseEvent):void
		{
			if(getTimer()-mouseDownTime<mouseUpMinimomTime)
			{
				closeMe(event);
			}
		}
		
		/**Set the current time on mouse down*/
		protected function startCloseTimer(event:MouseEvent):void
		{
			mouseDownTime = getTimer();
		}
		
		protected function catchBackButton(event:KeyboardEvent):void
		{
			
			if(this.visible)
			{
				if(event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.HOME )
				{
					event.stopImmediatePropagation();
					event.preventDefault();
					hide();
				}
			}
		}
		
		protected function downloadCurrentMedia(event:MouseEvent):void
		{
			
			//images[currentImage].target
			if(saveButtonFunction!=null)
			{
				saveButtonFunction();
			}
		}
		
		protected function closeMe(event:MouseEvent):void
		{
			
			hide();
		}
		
		/**Hide all boxes*/
		private function hideAll():void
		{
			for(var i = 0 ; images!=null && i<images.length ; i++)
			{
				images[i].cansel();
			}
			box_flat.hide();
			box_pano.hide();
			box_binary.hide();
			box_stageWeb.hide();
			box_shp.hide();
			if(box_vid2)
				box_vid2.close();
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
			
			if(nextMC)
			{
				nextMC.removeEventListener(MouseEvent.CLICK,nextImage);
				prevMC.removeEventListener(MouseEvent.CLICK,prevImage);
			}
			
			if(rtf)
			{
				nextMC = Obj.get("next_mc",this);
				prevMC = Obj.get("prev_mc",this);
			}
			else
			{
				nextMC = Obj.get("prev_mc",this);
				prevMC = Obj.get("next_mc",this);
			}
			
			prevMC.buttonMode = nextMC.buttonMode = closeMC.buttonMode = true ;
			
			nextMC.addEventListener(MouseEvent.CLICK,nextImage);
			prevMC.addEventListener(MouseEvent.CLICK,prevImage);
				
			this.x = newSize.x;
			this.y = newSize.y;
			
			imageSize = new Rectangle(0,bannerMC.height,newSize.width,newSize.height-bannerMC.height);
			
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
			box_stageWeb.setUp(imageSize);
			box_shp.setUp(imageSize);
			if(box_vid)
				box_vid.setUp(imageSize);
			/*if(box_vid2)
				box_vid2 = new DistriqtMediaPlayer(imageSize.width,imageSize.height);*/
			
			
			MouseDrag.setUp(stage);
			
			if(rtf)
			{
				MouseDrag.addFunctions(mouseDragedRight,mouseDraggedLeft,newSize);
			}
			else
			{
				MouseDrag.addFunctions(mouseDraggedLeft,mouseDragedRight,newSize);
			}
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
			var imageItem:ImageFile = images[currentImage];
			return this.mouseEnabled && imageItem.type!=ImageFile.TYPE_PANORAMA && imageItem.type!=ImageFile.TYPE_SPHERE ;
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
			if(closeFunction!=null)
			{
				closeFunction();
			}
			clearTimeout(timeOutId);
			hideAll();
			
			if(images!=null && images.length>currentImage)
			{
				images[currentImage].cansel();
			}
			
			this.mouseChildren = false ;
			this.mouseEnabled =false ;
			AnimData.fadeOut(this,onHide);
			
			if(stageVideo!=null)
			{
				stageVideo.unLoad()
			}
		}
			private function onHide():void
			{
				this.visible = false ;
			}
		
		public function show(Images:Vector.<ImageFile>,index:uint=0,onClosed:Function=null):void
		{
			closeFunction = onClosed ;
			images = Images.concat() ;
			if(images.length == 0)
			{
				titleMC.setUp(noImageTitle,true,true);
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
			manageCurrentImage(currentImage-1);
		}
		
		protected function nextImage(event:MouseEvent):void
		{
			manageCurrentImage(currentImage+1);
		}
		
		private function manageCurrentImage(imageIndex:int=-1):void
		{
			
			if(imageIndex!=-1)
			{
				currentImage = Math.min(totalImages-1,Math.max(0,imageIndex)) ;
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
		
		private function loadImage(imageItem:ImageFile):void
		{
			titleMC.setUp(imageItem.title,true,true) ;
			if(imageItem.storeOffline)
			{
				trace("Download image first");
				preLoderMC.visible = true ;
				precentMC.visible = true ;
				precentMC.width = 0 ;
				imageItem.addEventListener(URLSaverEvent.LOAD_COMPLETE,imageDownloaded);
				imageItem.addEventListener(URLSaverEvent.NO_INTERNET,noInternet);
				imageItem.addEventListener(URLSaverEvent.LOADING,showPrecent);
				imageItem.download();
			}
			else
			{
				preLoderMC.visible = false ;
				precentMC.visible = false ;
				showReadyImage(imageItem);
			}
		}
		
		protected function showPrecent(event:URLSaverEvent):void
		{
			trace("donwloading");
			
			precentMC.width = event.precent*backMC.width ;
		}
		
		protected function noInternet(event:Event):void
		{
			
			titleMC.setUp(noNetTitle,true,true);
			
			//Reload this image if every thing is allright
			//timeOutId = setTimeout(manageCurrentImage,10000);
		}
		
		protected function imageDownloaded(event:URLSaverEvent):void
		{
			trace("Image is downloaded");
			
			showReadyImage(event.target as ImageFile);
		}
		
		private function showReadyImage(imageItem:ImageFile):void
		{
			preLoderMC.visible = false ;
			precentMC.visible = false ;
			trace("show this image");
			downloadMC.visible = (saveButtonFunction!=null);
			switch(imageItem.type)
			{
				case ImageFile.TYPE_FLAT:
					box_flat.show(imageItem.target);
					break;
				case ImageFile.TYPE_PANORAMA:
					box_pano.show(imageItem.target);
					break;
				case ImageFile.TYPE_SPHERE:
					box_shp.show(imageItem.target);
					break;
				case ImageFile.TYPE_VIDEO:
					downloadMC.visible = false ;
					if(DevicePrefrence.isItPC || !DistriqtMediaPlayer.isSupports)
					{
						if(DevicePrefrence.isIOS() && imageItem.target.toLocaleLowerCase().indexOf('.flv')==-1)
						{						
							stageVideo = new StageVideo(imageSize.width,imageSize.height)	
							this.addChild(stageVideo)
							stageVideo.x = imageSize.x
							stageVideo.y =imageSize.y	
								
							stageVideo.loadThiwVideo(imageItem.target)
						}
						else if(box_vid)
						{
							box_vid.setUp(imageSize);
							box_vid.show(imageItem.target);
						}
					}
					else
					{
						if(box_vid2)
						{
							box_vid2.close();
							Obj.remove(box_vid2);
							box_vid2 = null ;
						}
						box_vid2 = new DistriqtMediaPlayer(imageSize.width,imageSize.height);
						box_vid2.x = imageSize.x ;
						box_vid2.y = imageSize.y ;
						this.addChild(box_vid2);
							
						box_vid2.playVideo(imageItem.target);
					}
					break;
				case ImageFile.TYPE_BINARY:
					box_binary.show(imageItem.target);
					break;
				case ImageFile.TYPE_PDF:
					box_stageWeb.show(imageItem.target);
					break;
					
				default:
					trace("This image is unknown");
					break;
			}
		}
		
		public static function saveCurrentImageToGallery():void
		{
			if(DevicePrefrence.isItPC)
			{
				FileManager.seveFile(File.desktopDirectory.resolvePath('SavedFileFrom'+DevicePrefrence.appName+'.jpg'),ME.images[ME.currentImage].targetBytes,true,onImageSaved);
			}
			else
			{
				DeviceImage.saveImageToGallery(ME.images[ME.currentImage].targetBytes,onImageSaved);
			}
		}
		
			private static function onImageSaved():void
			{
				AnimData.fadeOut(ME.downloadMC,showDownloadAgain,0.334);
				function showDownloadAgain():void
				{
					AnimData.fadeIn(ME.downloadMC,showDownloadAgain,0.2);
				}
			}
	}
}