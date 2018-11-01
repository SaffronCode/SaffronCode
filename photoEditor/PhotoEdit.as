package photoEditor
{
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.CameraRoll;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
	import sliderMenu.SliderManager;
	
	import stageManager.StageManager;
	import stageManager.StageManagerEvent;
	
	public class PhotoEdit extends MovieClip
	{
		private var backMC:MovieClip ;
		
		private static var onDone:Function ;
		private static var onCanceeld:Function ;
		
		internal static var ME:PhotoEdit ;
		
		//public static var image:BitmapData ;
		
		private static var imageIndex:uint ;
		
		/**Image area rectangle*/
		private static var _mainRectangle:Rectangle ;
		
		/**Full screen page rectangle*/
		private static var _pageRectangle:Rectangle;
		
		private static var imageHistory:Vector.<BitmapData>;
		
		private static var editorButtons:EditorToolbar ;
		
		/**PreviewImages*/
		private static var previewPage:PhotoPrevew ;
		
		/**This will make application to save each edited images on gallery*/
		private static var AutoSaveOnDevice:Boolean ;
		
		private static var selectedToolOnStartUp:String ;
		
		internal static function get mainRectangle():Rectangle
		{
			return _mainRectangle.clone();
		}
		
		internal static function get PageRectangle():Rectangle
		{
			return _pageRectangle.clone() ;
		}
		
		public static function get image():BitmapData
		{
			if(imageHistory==null || imageHistory.length == 0)
			{
				return null;
			}
			else
			{
				return imageHistory[imageIndex].clone();
			}
		}
		
		
		public function PhotoEdit()
		{
			super();
			ME = this ;
			
			disable(true);
			
			editorButtons = Obj.get("button_mc",this);
			backMC = Obj.get("back_mc",this);
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,blockBack,false,1000000);
		}
		
		protected function blockBack(event:KeyboardEvent):void
		{
			
			if(this.visible)
			{
				if(event.keyCode == Keyboard.BACK)
				{
					event.stopImmediatePropagation();
					event.preventDefault();
					close();
				}
			}
		}		
		
		
		public static function setUp(pageRectangle:Rectangle,autoSaveOnDevice:Boolean=true):void
		{
			AutoSaveOnDevice = autoSaveOnDevice ;
			if(ME)
			{
				ME.setUp(pageRectangle);
				StageManager.eventDispatcher.removeEventListener(StageManagerEvent.STAGE_RESIZED,updateMySize);
				StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED,updateMySize);
			}
			else
			{
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
				trace("PHOTO EDIT IS NOT EXISTS!!!!");
			}
		}
		
		protected static function updateMySize(event:Event):void
		{
			setUp(StageManager.stageRect);
			ME.x = StageManager.stageDelta.width/-2;
			ME.y = StageManager.stageDelta.height/-2;
		}
		
		private function setUp(pageRectangle:Rectangle):void
		{
			trace("pageRectangle : "+pageRectangle);
			this.x = pageRectangle.x; 
			this.y = pageRectangle.y; 
			backMC.width = pageRectangle.width;
			backMC.height = pageRectangle.height;
			editorButtons.y = pageRectangle.height ;
			editorButtons.x = 0 ;
			
			
			_mainRectangle = new Rectangle(0,0,pageRectangle.width,pageRectangle.height-editorButtons.height);
			
			_pageRectangle = pageRectangle ;
			
			editorButtons.setUp(_mainRectangle.clone());
		}
		
		/**Show the editor*/
		private function enable():void
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE ;
			this.visible = true ;
			this.mouseEnabled = this.mouseChildren = true ;
			AnimData.fadeIn(this);
			SliderManager.lock(true);
		}
		
		/**Disable editor prevew*/
		private function disable(instanceDisabling:Boolean=false):void
		{
			this.mouseEnabled = this.mouseChildren = false ;
			this.visible = false ;
			SliderManager.unLock();
			if(instanceDisabling)
			{
				this.alpha = 0 ;
			}
			else
			{
				AnimData.fadeOut(this,inVisibleMe);
			}
		}
		
		private function inVisibleMe():void
		{
			Multitouch.inputMode = MultitouchInputMode.NONE ;
			this.visible = false;
		}
		
		/**Open the editor page.<br>
		 * Acceptable types are : BitmapData, File and ByteArray<br><br>
		 * 
		 * defaultTool had to be the tool icon name such as pen_tools_mc*/
		public static function Edit(image:*,onEdited:Function,defaultTool:String='',onCanceld:Function=null):void
		{
			selectedToolOnStartUp = defaultTool ;
			onDone = onEdited ;
			onCanceeld = onCanceld ;
			if(image is BitmapData)
			{
				ME.StartEditing(image);
				return ;
			}
			
			if(image is String)
			{
				image = new File(image);
			}
			
			if(image is File)
			{
				image = FileManager.loadFile(image as File);
			}
			
			if(image is ByteArray)
			{
				DeviceImage.resizeLoadedImage(showImage,NaN,NaN,image,false);
				
				function showImage()
				{
					ME.StartEditing(DeviceImage.imageBitmapData);
				}
			}
			else if(image is BitmapData)
			{
				ME.StartEditing(image as BitmapData);
			}
		}
		
		protected function StartEditing(imageBitmapData:BitmapData):void
		{
			
			imageIndex = 0 ;
			imageHistory = new Vector.<BitmapData>();
			enable();
			
			if( previewPage!=null && previewPage.parent != null )
			{
				this.removeChild(previewPage);
				previewPage = null ;
			}
			
			updateImage(imageBitmapData);
			editorButtons.select(selectedToolOnStartUp);
		}
		
		internal static function updateImage(imageBitmapData:BitmapData):void
		{
			if(imageIndex<imageHistory.length-1)
			{
				var disposedBitmaps:Vector.<BitmapData> = imageHistory.splice(imageIndex+1,imageHistory.length-imageIndex);
				for(var i = 0 ; i<disposedBitmaps.length ; i++)
				{
					disposedBitmaps[i].dispose();
				}
			}
			imageIndex = imageHistory.length ;
			imageHistory.push(imageBitmapData.clone());
			ME.showCurrentImage();
		}
		
		private static function showCurrentImage():void
		{
			ME.showCurrentImage() ;
		}
		
		private function showCurrentImage():void
		{
			
			if(previewPage!=null)
			{
				previewPage.killMe();
			}
			previewPage = new PhotoPrevew(imageHistory[imageIndex]);
			this.addChild(previewPage);
			this.addChild(editorButtons);
		}
		
		/**Remove the preview*/
		internal static function removePhotoPrevew():void
		{
			previewPage.visible = false ;
		}
		
		/**Show the prevew page again*/
		internal static function resetPhotoPrevew():void
		{
			previewPage.visible = true ;
		}
		
	////////////////////////////////
		
		internal static function save(e:*=null):void
		{
			if(AutoSaveOnDevice && CameraRoll.supportsAddBitmapData)
			{
				var imageSaver:CameraRoll = new CameraRoll();
				imageSaver.addBitmapData(image);
			}
			onDone();
			ME.disable();
		}
		
		internal static function close(e:*=null):void
		{
			for(var i = 0 ; i<imageHistory.length ; i++)
			{
				imageHistory[i].dispose();
			}
			imageHistory = new Vector.<BitmapData>();
			if(ME.mouseEnabled && onCanceeld!=null)
			{
				onCanceeld();
			}
			//onDone(); // do not call onDone() function when user closed the win
			ME.disable();
		}
		
		/**Returns true if undo function works*/
		internal static function undo():Boolean
		{
			
			if(imageIndex>0)
			{
				imageIndex--;
				showCurrentImage();
				return true;
			}
			trace("Undo is not available");
			return false ;
		}
		
		/**Returns true if redo function works*/
		internal static function redo():Boolean
		{
			if(imageIndex<imageHistory.length-1)
			{
				imageIndex++;
				showCurrentImage();
				return true;
			}
			trace("Redo is not available");
			return false;
		}
		
	//////////////////////////////
		internal static function imageAreaRectangle():Rectangle
		{
			return previewPage.imageRect();
		}
		
		internal static function getImage(rs:Rectangle=null):BitmapData
		{
			
			if(rs==null)
			{
				return imageHistory[imageIndex] ;
			}
			else
			{
				return previewPage.crop(rs);
			}
			return null;
		}
		
		public static function addStamps(stampFiles:Vector.<File>):void
		{
			StampList.addStamps(stampFiles);
			editorButtons.button_stamp.visible = true ;
		}
	}
}