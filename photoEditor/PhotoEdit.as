package photoEditor
{
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.CameraRoll;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class PhotoEdit extends MovieClip
	{
		private var backMC:MovieClip ;
		
		private static var onDone:Function ;
		
		internal static var ME:PhotoEdit ;
		
		//public static var image:BitmapData ;
		
		private static var imageIndex:uint ;
		
		private static var _mainRectangle:Rectangle ;
		
		private static var imageHistory:Vector.<BitmapData>;
		
		private var editorButtons:EditorToolbar ;
		
		/**PreviewImages*/
		private static var previewPage:PhotoPrevew ;
		
		/**This will make application to save each edited images on gallery*/
		private static var AutoSaveOnDevice:Boolean ;
		
		private static var selectedToolOnStartUp:String ;
		
		internal static function get mainRectangle():Rectangle
		{
			return _mainRectangle.clone();
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
			// TODO Auto-generated method stub
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
		
		private function setUp(pageRectangle:Rectangle):void
		{
			trace("pageRectangle : "+pageRectangle);
			this.x = pageRectangle.x; 
			this.y = pageRectangle.y; 
			backMC.width = pageRectangle.width;
			backMC.height = pageRectangle.height;
			editorButtons.y = pageRectangle.height ;
			editorButtons.x = 0 ;
			
			
			_mainRectangle = new Rectangle(0,0,pageRectangle.width,pageRectangle.height-editorButtons.height); ;
			
			editorButtons.setUp(_mainRectangle.clone());
		}
		
		/**Show the editor*/
		private function enable():void
		{
			this.visible = true ;
			this.mouseEnabled = this.mouseChildren = true ;
			AnimData.fadeIn(this);
		}
		
		/**Disable editor prevew*/
		private function disable(instanceDisabling:Boolean=false):void
		{
			this.mouseEnabled = this.mouseChildren = false ;
			this.visible = false ;
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
			this.visible = false;
		}
		
		/**Open the editor page.<br>
		 * Acceptable types are : BitmapData, File and ByteArray<br><br>
		 * 
		 * defaultTool had to be the tool icon name such as pen_tools_mc*/
		public static function Edit(image:*,onEdited:Function,defaultTool:String=''):void
		{
			selectedToolOnStartUp = defaultTool ;
			onDone = onEdited ;
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
			// TODO Auto Generated method stub
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
			onDone();
			ME.disable();
		}
		
		/**Returns true if undo function works*/
		internal static function undo():Boolean
		{
			// TODO Auto Generated method stub
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
			// TODO Auto Generated method stub
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
	}
}