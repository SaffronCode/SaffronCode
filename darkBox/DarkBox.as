package darkBox
{
	import appManager.displayContentElemets.TitleText;
	import contents.alert.Alert;
	
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
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import nativeClasses.pdfReader.DistriqtPDFReader;
	import nativeClasses.player.DistriqtMediaPlayer;
	
	import netManager.urlSaver.URLSaverEvent;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	import stageManager.StageManager;
	import stageManager.StageManagerEvent;
	
	import videoShow.StageVideo;
	
	public class DarkBox extends MovieClip
	{
		
		public static var ME:DarkBox;
		
		private static var noNetTitle:String, noImageTitle:String;
		
		private static var mouseDragId:uint;
		
		private var stageVideo:StageVideo;
		
		private var images:Vector.<ImageFile>;
		
		private var box_flat:FlatImage, box_pano:PanoramaImage, box_shp:SphereImage, box_binary:BinaryFile, box_stageWeb:WebOpener, box_vid:VideoImage, box_vid2:DistriqtMediaPlayer;
		
		private var bannerMC:MovieClip, titleMC:TitleText, downloadMC:MovieClip, backMC:MovieClip, nextMC:MovieClip, prevMC:MovieClip, precentMC:MovieClip, preLoderMC:MovieClip, closeMC:MovieClip, autoQ:MovieClip, HQ:MovieClip, MQ:MovieClip, LQ:MovieClip;
		
		private var _Watermarkdark_mc:MovieClip;
		
		private var qualityDegree:int;
		private var videoCount:int;
		private static var rtf:Boolean;
		
		/**Control this on mouse up*/
		private var mouseDownTime:Number;
		private const mouseUpMinimomTime:uint = 100;
		
		//private var maskMC:MovieClip ;
		
		private var currentImage:uint = 0, totalImages:uint;
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
			return ME.currentImage;
		}
		
		public function currentMedia():ImageFile
		{
			if (images.length > currentImage)
			{
				return images[currentImage];
			}
			return null;
		}
		
		/**Initialize the DarkBox area*/
		public static function setUp(newSize:Rectangle, noNetHintText:String = 'No Internet Connection Available', noImageHereText:String = '', downloadFunction:Function = null, titleInFullLine:Boolean = false, RightToLeft:Boolean = true, activateAutoSize:Boolean = true):void
		{
			if (!StageManager.isSatUp())
			{
				throw "You should sat the StageManager to use DarkBox.\n\n\n";
				return;
			}
			trace("Update darkbox stage area : " + newSize);
			rtf = RightToLeft;
			showTitleInFullLine = titleInFullLine;
			saveButtonFunction = downloadFunction;
			noNetTitle = noNetHintText;
			noImageTitle = noImageHereText;
			ME.setUp(newSize);
			
			if ((true || DevicePrefrence.isAndroid()) && activateAutoSize)
			{
				StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED, updateStageSize);
			}
			
			PermissionControl.VideoTagForStageWebView();
		}
		
		protected static function updateStageSize(event:Event):void
		{
			ME.x = StageManager.stageDelta.width / -2;
			ME.y = StageManager.stageDelta.height / -2 + StageManager.stageDelta.y;
			ME.setUp(StageManager.stageRect);
		}
		
		public static function show(Images:Vector.<ImageFile>, currentIndex:uint = 0, onClosed:Function = null):void
		{
			updateStageSize(null);
			ME.show(Images, currentIndex, onClosed);
		}
		
		public function DarkBox()
		{
			trace("Dark box initialized");
			super();
			/*initMask();*/
			ME = this;
			
			_Watermarkdark_mc = Obj.get("Watermarkdark_mc", this);
			autoQ = Obj.get("AutoQ_mc", this);
			HQ = Obj.get("HQ_mc", this);
			MQ = Obj.get("MQ_mc", this);
			LQ = Obj.get("LQ_mc", this);
			bannerMC = Obj.get("banner_mc", this);
			precentMC = Obj.get("percent_mc", this);
			backMC = Obj.get("back_mc", this);
			closeMC = Obj.get("close_mc", this);
			titleMC = Obj.get("title_mc", this);
			preLoderMC = Obj.get("wait_mc", this);
			downloadMC = Obj.get("download_mc", this);
			downloadMC.buttonMode = true;
			downloadMC.addEventListener(MouseEvent.CLICK, downloadCurrentMedia);
			preLoderMC.visible = false;
			precentMC.visible = false;
			
			if (_Watermarkdark_mc != null)
			{
				_Watermarkdark_mc.mouseChildren = false
				_Watermarkdark_mc.mouseEnabled = false
			}
			
			if (autoQ != null)
			{
				autoQ.buttonMode = true;
				autoQ.addEventListener(MouseEvent.CLICK, setDegreeQuality);
				autoQ.visible = false;
				autoQ.gotoAndStop(2);
			}
			if (HQ != null)
			{
				HQ.buttonMode = true;
				HQ.addEventListener(MouseEvent.CLICK, setDegreeQuality);
				HQ.visible = false;
			}
			if (MQ != null)
			{
				MQ.buttonMode = true;
				MQ.addEventListener(MouseEvent.CLICK, setDegreeQuality);
				MQ.visible = false;
			}
			if (LQ != null)
			{
				LQ.buttonMode = true;
				LQ.addEventListener(MouseEvent.CLICK, setDegreeQuality);
				LQ.visible = false;
			}
			closeMC.addEventListener(MouseEvent.CLICK, closeMe);
			backMC.addEventListener(MouseEvent.MOUSE_DOWN, startCloseTimer);
			backMC.addEventListener(MouseEvent.MOUSE_UP, mouseUpEventControll);
			
			box_flat = Obj.findThisClass(FlatImage, this);
			box_pano = Obj.findThisClass(PanoramaImage, this);
			box_shp = Obj.findThisClass(SphereImage, this);
			box_binary = Obj.findThisClass(BinaryFile, this);
			box_vid = Obj.findThisClass(VideoImage, this);
			box_stageWeb = new WebOpener();
			this.addChild(box_stageWeb);
			
			/*box_flat.mask = box_pano.mask = box_shp.mask = box_vid.mask = maskMC ;
			   box_shp.mask = maskMC ;
			   box_vid.mask = maskMC ;*/
			
			//Hide box
			//hideAll();
			this.alpha = 0;
			hide();
			//Video box will make a bug if hide function didn't call agin
			setTimeout(hide, 100);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, catchBackButton, false, 100000);
		}
		
		private function showQuailyBtn(qualityCount:uint):void
		{
			switch (qualityCount)
			{
			case 0: 
			case 1: 
				if(autoQ)autoQ.visible = false;
				if(HQ)HQ.visible = false;
				if(MQ)MQ.visible = false;
				if(LQ)LQ.visible = false;
				break;
			case 2: 
				if(autoQ)autoQ.visible = true;
				if(HQ)HQ.visible = true;
				if(MQ)MQ.visible = true;
				if(LQ)LQ.visible = false;
				break;
			case 3: 
			default: 
				if(autoQ)autoQ.visible = true;
				if(HQ)HQ.visible = true;
				if(MQ)MQ.visible = true;
				if(LQ)LQ.visible = true;
				break;
			}
		}
		
		private function setDegreeQuality(e:MouseEvent):void
		{
			switch (e.target.name)
			{
			case "AutoQ_mc": 
				qualityDegree = 0;
				autoQ.gotoAndStop(2);
				LQ.gotoAndStop(1);
				MQ.gotoAndStop(1);
				HQ.gotoAndStop(1);
				break;
			case "HQ_mc": 
				qualityDegree = 1;
				HQ.gotoAndStop(2);
				autoQ.gotoAndStop(1);
				LQ.gotoAndStop(1);
				MQ.gotoAndStop(1);
				break;
			case "MQ_mc": 
				qualityDegree = 2;
				MQ.gotoAndStop(2);
				HQ.gotoAndStop(1);
				autoQ.gotoAndStop(1);
				LQ.gotoAndStop(1);
				break;
			case "LQ_mc": 
				qualityDegree = 3;
				LQ.gotoAndStop(2);
				MQ.gotoAndStop(1);
				HQ.gotoAndStop(1);
				autoQ.gotoAndStop(1);
				break;
			}
			
			if (box_vid2)
				box_vid2.loadVideoWithQuality(qualityDegree);
		}
		
		/**Controll mouse up on back ground*/
		protected function mouseUpEventControll(event:MouseEvent):void
		{
			if (getTimer() - mouseDownTime < mouseUpMinimomTime)
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
			
			if (this.visible)
			{
				if (event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.HOME)
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
			if (saveButtonFunction != null)
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
			for (var i = 0; images != null && i < images.length; i++)
			{
				images[i].cansel();
			}
			box_flat.hide();
			box_pano.hide();
			box_binary.hide();
			box_stageWeb.hide();
			box_shp.hide();
			if (box_vid2)
			{
				box_vid2.close();
				box_vid2.visible = false;
			}
			if (box_vid)
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
			
			if (nextMC)
			{
				nextMC.removeEventListener(MouseEvent.CLICK, nextImage);
				prevMC.removeEventListener(MouseEvent.CLICK, prevImage);
			}
			
			if (rtf)
			{
				nextMC = Obj.get("next_mc", this);
				prevMC = Obj.get("prev_mc", this);
			}
			else
			{
				nextMC = Obj.get("prev_mc", this);
				prevMC = Obj.get("next_mc", this);
			}
			
			prevMC.buttonMode = nextMC.buttonMode = closeMC.buttonMode = true;
			
			nextMC.addEventListener(MouseEvent.CLICK, nextImage);
			prevMC.addEventListener(MouseEvent.CLICK, prevImage);
			
			this.x = newSize.x;
			this.y = newSize.y;
			
			imageSize = new Rectangle(0, bannerMC.height, newSize.width, newSize.height - bannerMC.height);
			
			bannerMC.x = 0;
			//closeMC.y = nextMC.y = prevMC.y = bannerMC.y = titleMC.y = 0 ;
			closeMC.x = newSize.width - closeMC.width;
			downloadMC.x = closeMC.x - downloadMC.width;
			downloadMC.visible = (saveButtonFunction != null);
			if (showTitleInFullLine)
			{
				titleMC.x = 0;
			}
			else
			{
				titleMC.x = Math.max(prevMC.x + prevMC.width, nextMC.x + nextMC.width);
			}
			preLoderMC.x = imageSize.width / 2;
			preLoderMC.y = imageSize.y + imageSize.height / 2;
			precentMC.x = 0;
			precentMC.y = newSize.height;
			
			backMC.width = newSize.width;
			backMC.height = newSize.height;
			
			this.graphics.clear();
			this.graphics.beginFill(0, 1);
			var maxW:Number = Math.max(newSize.width, newSize.height);
			this.graphics.drawRect(-maxW, -maxW, maxW * 3, maxW * 3);
			
			if (showTitleInFullLine)
			{
				titleMC.width = newSize.width;
			}
			else
			{
				titleMC.width = newSize.width - (closeMC.width + prevMC.x + prevMC.width + downloadMC.width);
			}
			bannerMC.width = newSize.width;
			
			box_flat.setUp(imageSize);
			box_pano.setUp(imageSize);
			box_binary.setUp(imageSize);
			box_stageWeb.setUp(imageSize);
			box_shp.setUp(imageSize);
			if (box_vid)
				box_vid.setUp(imageSize);
			/*if(box_vid2)
			   box_vid2 = new DistriqtMediaPlayer(imageSize.width,imageSize.height);*/
			
			MouseDrag.setUp(stage);
			
			if (rtf)
			{
				MouseDrag.removeFunction(mouseDragId);
				mouseDragId = MouseDrag.addFunctions(mouseDragedRight, mouseDraggedLeft, newSize);
			}
			else
			{
				MouseDrag.removeFunction(mouseDragId);
				mouseDragId = MouseDrag.addFunctions(mouseDraggedLeft, mouseDragedRight, newSize);
			}
		}
		
		private function mouseDraggedLeft()
		{
			if (this.visible && nextMC.visible && mouseSwipEnambed())
			{
				nextMC.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		private function mouseSwipEnambed():Boolean
		{
			var imageItem:ImageFile = images[currentImage];
			return this.mouseEnabled && imageItem.type != ImageFile.TYPE_PANORAMA && imageItem.type != ImageFile.TYPE_SPHERE;
		}
		
		private function mouseDragedRight()
		{
			if (this.visible && prevMC.visible && mouseSwipEnambed())
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
			if (closeFunction != null)
			{
				closeFunction();
			}
			clearTimeout(timeOutId);
			hideAll();
			
			if (images != null && images.length > currentImage)
			{
				images[currentImage].cansel();
			}
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			AnimData.fadeOut(this, onHide);
			
			if (stageVideo != null)
			{
				stageVideo.unLoad()
			}
			
			if(autoQ)autoQ.gotoAndStop(2);
			if(LQ)LQ.gotoAndStop(1);
			if(MQ)MQ.gotoAndStop(1);
			if(HQ)HQ.gotoAndStop(1);
		}
		
		private function onHide():void
		{
			this.visible = false;
		}
		
		public function show(Images:Vector.<ImageFile>, index:uint = 0, onClosed:Function = null):void
		{
			closeFunction = onClosed;
			images = Images.concat();
			if (images.length == 0)
			{
				titleMC.setUp(noImageTitle, true, true);
			}
			
			currentImage = index;
			totalImages = images.length;
			this.mouseChildren = true;
			this.mouseEnabled = true;
			this.visible = true;
			AnimData.fadeIn(this);
			
			manageCurrentImage();
		}
		
		protected function prevImage(event:MouseEvent):void
		{
			manageCurrentImage(currentImage - 1);
		}
		
		protected function nextImage(event:MouseEvent):void
		{
			manageCurrentImage(currentImage + 1);
		}
		
		private function manageCurrentImage(imageIndex:int = -1):void
		{
			
			if (imageIndex != -1)
			{
				currentImage = Math.min(totalImages - 1, Math.max(0, imageIndex));
			}
			
			clearTimeout(timeOutId);
			
			hideAll();
			prevMC.visible = true;
			nextMC.visible = true;
			if (currentImage <= 0)
			{
				prevMC.visible = false;
			}
			if (currentImage >= totalImages - 1)
			{
				nextMC.visible = false;
			}
			loadImage(images[currentImage]);
		}
		
		private function loadImage(imageItem:ImageFile):void
		{
			
			titleMC.setUp(imageItem.title, true, true);
			if (imageItem.storeOffline)
			{
				trace("Download image first");
				preLoderMC.visible = true;
				precentMC.visible = true;
				precentMC.width = 0;
				imageItem.addEventListener(URLSaverEvent.LOAD_COMPLETE, imageDownloaded);
				imageItem.addEventListener(URLSaverEvent.NO_INTERNET, noInternet);
				imageItem.addEventListener(URLSaverEvent.LOADING, showPrecent);
				imageItem.download();
			}
			else
			{
				preLoderMC.visible = false;
				precentMC.visible = false;
				showReadyImage(imageItem);
			}
		}
		
		protected function showPrecent(event:URLSaverEvent):void
		{
			trace("donwloading");
			
			precentMC.width = event.precent * backMC.width;
		}
		
		protected function noInternet(event:Event):void
		{
			
			titleMC.setUp(noNetTitle, true, true);
		
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
			showQuailyBtn(0);
			preLoderMC.visible = false;
			precentMC.visible = false;
			trace("show this image");
			downloadMC.visible = (saveButtonFunction != null);
			switch (imageItem.type)
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
				downloadMC.visible = false;
				showQuailyBtn(imageItem.qualityCount());
				if (DevicePrefrence.isItPC || !DistriqtMediaPlayer.isSupports)
				{
					if (DevicePrefrence.isIOS() || imageItem.target.toLocaleLowerCase().indexOf('.flv') == -1)
					{
						stageVideo = new StageVideo(imageSize.width, imageSize.height)
						this.addChild(stageVideo)
						stageVideo.x = imageSize.x
						stageVideo.y = imageSize.y
						stageVideo.loadThiwVideo(imageItem.target);
						
					}
					else if (box_vid)
					{
						box_vid.setUp(imageSize);
						box_vid.show(imageItem.target);
					}
				}
				else
				{
					if (box_vid2)
					{
						box_vid2.close();
						Obj.remove(box_vid2);
						box_vid2 = null;
					}
					box_vid2 = new DistriqtMediaPlayer(imageSize.width, imageSize.height);
					box_vid2.x = imageSize.x;
					box_vid2.y = imageSize.y;
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
			case ImageFile.TYPE_WEB: 
				box_stageWeb.show(imageItem.target);
				break;
			
			default: 
				trace("This image is unknown");
				break;
			}
		}
		
		public static function set checkBandWidth(value:Boolean):void
		{
			DistriqtMediaPlayer.checkBandWidth = true;
		}
		
		public static function saveCurrentImageToGallery():void
		{
			var currentTargetFileByte:ByteArray = ME.images[ME.currentImage].targetBytes;
			if (currentTargetFileByte == null)
			{
				currentTargetFileByte = FileManager.loadFile(new File(ME.images[ME.currentImage].target));
			}
			
			if (DevicePrefrence.isItPC)
			{
				FileManager.seveFile(File.desktopDirectory.resolvePath('SavedFileFrom' + DevicePrefrence.appName + '.jpg'), currentTargetFileByte, true, onImageSaved);
			}
			else
			{
				DeviceImage.saveImageToGallery(currentTargetFileByte, onImageSaved);
			}
		}
		
		private static function onImageSaved():void
		{
			AnimData.fadeOut(ME.downloadMC, showDownloadAgain, 0.334);
			function showDownloadAgain():void
			{
				AnimData.fadeIn(ME.downloadMC, showDownloadAgain, 0.2);
			}
		}
		
		/**Returns true if the DarkBox was opened*/
		public static function isOpen():Boolean
		{
			return ME.visible;
		}
		
		/**set Distriqt id to activate native PDF and Media player*/
		public static function setDistriqtId(distriqtId:String):void
		{
			DistriqtMediaPlayer.setId(distriqtId);
			DistriqtPDFReader.setUp(distriqtId);
		}
	}
}