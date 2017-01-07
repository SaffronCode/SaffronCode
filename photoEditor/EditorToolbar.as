package photoEditor
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class EditorToolbar extends MovieClip
	{
		private var toolsContainerMC:MovieClip ;
		
		private var scrollerMC:ScrollMT ;
		
		internal var button_exit:MovieClip,
					button_save:MovieClip,
					button_undo:MovieClip,
					button_crop:MovieClip,
					button_redo:MovieClip,
					button_pen:MovieClip,
					button_rotate:MovieClip,
					
					button_stamp:MovieClip,
					
					button_rotate_left:MovieClip;

		private var H:Number;
		
		private var currentEditor:EditorDefault ;
		
		private var imageFullAreaRect:Rectangle;
		
		private static var toolbarRectangle:Rectangle ;
		
		internal static function toolbarRectArea():Rectangle
		{
			return toolbarRectangle.clone();
		}
					
		
		public function EditorToolbar()
		{
			super();
			
			H = super.height
			
			toolsContainerMC = Obj.get("tools_mc",this);
			
			button_exit = Obj.get("exit_mc",this);
			button_save = Obj.get("save_mc",this);
			button_rotate = Obj.get("rotate_mc",toolsContainerMC);
			button_rotate_left = Obj.get("rotate_left_mc",toolsContainerMC);
			button_pen = Obj.get("pen_tools_mc",toolsContainerMC);
			button_undo = Obj.get("undo_mc",toolsContainerMC);
			button_redo = Obj.get("redo_mc",toolsContainerMC);
			button_crop = Obj.get("crop_mc",toolsContainerMC);
			button_stamp = Obj.get("stamp_tools_mc",toolsContainerMC);
			
			button_exit.addEventListener(MouseEvent.CLICK,close);
			button_save.addEventListener(MouseEvent.CLICK,save);
			button_undo.addEventListener(MouseEvent.CLICK,undoLastJob);
			button_redo.addEventListener(MouseEvent.CLICK,redoNextJob);
			
			button_crop.addEventListener(MouseEvent.CLICK,openCropEditor);
			button_pen.addEventListener(MouseEvent.CLICK,openPencilArchive);
			if(button_stamp)
			{
				button_stamp.addEventListener(MouseEvent.CLICK,openStampList);
				button_stamp.visible = false ;
			}
			
			
			button_rotate.addEventListener(MouseEvent.CLICK,rotateImage);
			button_rotate_left.addEventListener(MouseEvent.CLICK,rotateLeftImage);
		}
		
		protected function rotateImage(event:MouseEvent):void
		{
			
			rotateImageIn(90)
		}
		
		protected function rotateLeftImage(event:MouseEvent):void
		{
			
			rotateImageIn(-90)
		}
		
			/**Rotate the image*/
			private function rotateImageIn(radian:Number):void
			{
				var sampleBitmap:BitmapData = PhotoEdit.image ;
				var copiedBitmap:BitmapData = new BitmapData(sampleBitmap.width,sampleBitmap.height);
				var matrix:Matrix = new Matrix(1,0,0,1);
				copiedBitmap.draw(sampleBitmap,matrix);
				PhotoEdit.updateImage(BitmapEffects.rotateBitmapData(copiedBitmap,radian));
				copiedBitmap.dispose();
			}
		
		private function save(e:MouseEvent):void
		{
			if(currentEditor!=null)
			{
				currentEditor.saveAndClose();
				currentEditor = null;
				toolsContainerMC.visible = true ;
			}
			else
			{
				PhotoEdit.save(e);
			}
		}
		
		private function close(e:MouseEvent):void
		{
			trace("currentEditor : "+currentEditor);
			if(currentEditor!=null)
			{
				currentEditor.close();
				currentEditor = null;
				toolsContainerMC.visible = true ;
			}
			else
			{
				PhotoEdit.close(e);
			}
		}
		
		
		
		private function openStampList(event:MouseEvent):void
		{
			trace("Add stamp list");
			addEditorToStage(new StampList());
		}
		
		private function openPencilArchive(e:MouseEvent):void
		{
			trace("Open pencile archive");
			addEditorToStage(new EditorPencil());
		}
		
		private function openCropEditor(e:MouseEvent):void
		{
			trace("Open crop editor");
			addEditorToStage(new EditorCropper());
		}
		
		private function addEditorToStage(editor:EditorDefault):void
		{
			toolsContainerMC.visible = false ;
			currentEditor = editor ;
			currentEditor.y = 0-(H+imageFullAreaRect.height);
			currentEditor.x = 0 ;
			
			trace("Add to "+this+' and the name is : '+this.name);
			
			this.addChild(currentEditor);
			this.addChild(button_exit);
			this.addChild(button_save);
		}
		
		override public function get height():Number
		{
			return H ;
		}
		
		protected function redoNextJob(event:MouseEvent):void
		{
			
			PhotoEdit.redo();
		}
		
		protected function undoLastJob(event:MouseEvent):void
		{
			
			PhotoEdit.undo();
		}
		
		public function setUp(stageRectangle:Rectangle):void
		{
			
			imageFullAreaRect = stageRectangle.clone() ;
			if(scrollerMC==null)
			{
				var scrollRectangle:Rectangle = new Rectangle(toolsContainerMC.x,
					toolsContainerMC.y,
					stageRectangle.width-toolsContainerMC.x,
					toolsContainerMC.height); 
				
				toolbarRectangle = scrollRectangle.clone();
				
				scrollerMC = new ScrollMT(toolsContainerMC,
					toolbarRectangle,
					null,false,true);
			}
		}
		
		/**Select the tool with this name*/
		public function select(selectedToolOnStartUp:String):void
		{
			
			var selectedToolsList:Array = Obj.getAllChilds(selectedToolOnStartUp,this) ;
			if(selectedToolsList.length>0 && selectedToolsList[0]!=null)
			{
				var selectedItem:DisplayObject = selectedToolsList[0];
				selectedItem.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
				selectedItem.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
	}
}