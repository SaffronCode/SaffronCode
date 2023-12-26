package photoEditor
	//photoEditor.StampList
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class StampList extends EditorDefault
	{
		/**This is a two framed animation. the second frame is for deactiveated remove button*/
		private var button_remove:MovieClip ;
		
		private var stampsMC:MovieClip ;
		
		private static var stampFile:Vector.<File> ;
		
		/**Stamp container list. all stamps will add here*/
		private var stampContainer:MovieClip ;
		
		/**Stamp inner container. contains stamps */
		private var stampInnerContainer:Sprite ;
		
		/**This is the stamp item that is on move*/
		private var onTouchItem:StampItem ;
		
		
		public function StampList()
		{
			super();
			
			stampContainer = Obj.get("stamp_container_mc",this);
			
			button_remove = Obj.get("remove_mc",this);
			stampsMC = Obj.get("stampList_mc",this);
			
			stampsMC.removeChildren();
			stampContainer.removeChildren();
			
			stampInnerContainer = new Sprite();
			
			for(var i:* = 0 ; i<stampFile.length ; i++)
			{
				var newItems:StampButton = new StampButton();
				newItems.load(stampFile[i]);
				stampsMC.addChild(newItems);
				newItems.x = i*(newItems.width+10);
				newItems.addEventListener(MouseEvent.CLICK,addMyStamp);
			}
			
			SaffronLogger.log("toolbarRect: "+toolbarRect);
			
			
			var stampsArea:Rectangle = toolbarRect.clone();
			stampsArea.x += stampsMC.x ;
			button_remove.x += toolbarRect.x ;
			button_remove.y = toolbarRect.y ;
			button_remove.gotoAndStop(2);
			button_remove.addEventListener(MouseEvent.ROLL_OVER,getReadyToRemove);
			button_remove.addEventListener(MouseEvent.ROLL_OUT,deffaultFrameForRemover);
			button_remove.addEventListener(MouseEvent.MOUSE_UP,removeIfSomthingSelects);
			
			SaffronLogger.log("stampsArea : "+stampsArea);
			
			new ScrollMT(stampsMC,stampsArea,null,false,true);
			
			var imageBitmap:Bitmap = new Bitmap(imageFullBitmapData);
			stampContainer.addChild(imageBitmap);
			stampContainer.addChild(stampInnerContainer);
			
			stampContainer.width = fullImageAreaRect.width ;
			stampContainer.height = fullImageAreaRect.height ;
			stampContainer.scaleX = stampContainer.scaleY = Math.min(stampContainer.scaleX,stampContainer.scaleY);
			
			stampContainer.x = (fullImageAreaRect.width-stampContainer.width)/2;
			stampContainer.y = (fullImageAreaRect.height-stampContainer.height)/2;
			
			stampInnerContainer.mouseEnabled = false ;
			resetGestures();
			stampInnerContainer.addEventListener(MouseEvent.MOUSE_DOWN,startDragStamp);
			controllStage();
			
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		private function resetGestures():void
		{
			SaffronLogger.log("Reset");
			stampInnerContainer.removeEventListener(TransformGestureEvent.GESTURE_PAN,panThem);
			stampInnerContainer.removeEventListener(TransformGestureEvent.GESTURE_ROTATE,panThem);
			stampInnerContainer.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,panThem);
			
			stampInnerContainer.addEventListener(TransformGestureEvent.GESTURE_PAN,panThem);
			stampInnerContainer.addEventListener(TransformGestureEvent.GESTURE_ROTATE,panThem);
			stampInnerContainer.addEventListener(TransformGestureEvent.GESTURE_ZOOM,panThem);
		}
		
		/**Nothing to do*/
		protected function deffaultFrameForRemover(event:MouseEvent):void
		{
			button_remove.gotoAndStop(2);
		}
		
		protected function unLoad(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragAll);
		}
		
		/**Remvoe item*/
		protected function removeIfSomthingSelects(event:MouseEvent):void
		{
			if(onTouchItem)
			{
				Obj.remove(onTouchItem);
				onTouchItem = null ;
			}
		}
		
		/**Controll the remove button*/
		protected function getReadyToRemove(event:MouseEvent):void
		{
			if(onTouchItem)
			{
				button_remove.gotoAndStop(1);
			}
		}
		
		/**Controll stage to stopDrag function*/
		private function controllStage(e:*=null):void
		{
			if(this.stage==null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStage);
			}
			else
			{
				stage.addEventListener(MouseEvent.MOUSE_UP,stopDragAll);
			}
		}
		
		/**Stop drags*/
		protected function stopDragAll(event:MouseEvent):void
		{
			onTouchItem = null ;
			button_remove.gotoAndStop(2);
			for(var i:* = 0 ; i<stampInnerContainer.numChildren ; i++)
			{
				(stampInnerContainer.getChildAt(i) as MovieClip).stopDrag();
			}
		}
		
		/**Start mouse drag*/
		protected function startDragStamp(event:MouseEvent):void
		{
			var targ:StampItem = event.target as StampItem ;
			if(targ!=stampContainer)
			{
				onTouchItem = targ ;
				targ.parent.addChild(targ);
				targ.startDrag();
			}
		}
		
		/**Gesure*/
		protected function panThem(event:TransformGestureEvent):void
		{
			var targ:StampItem = event.target as StampItem ;
			//var touchPoint:Point = targ.localToGlobal(new Point(event.localX,event.localY));
			
			//targ = stampInnerContainer.getObjectsUnderPoint(touchPoint) as StampItem;
			
			if(targ!=stampContainer)
			{
				if(event.phase == GesturePhase.BEGIN)
				{
					targ.firstPoint = new Point(event.localX,event.localY);
					stopDragAll(null);
				}
				var newPoint:Point = targ.localToGlobal(new Point(event.localX-targ.firstPoint.x,event.localY-targ.firstPoint.y));
				newPoint = stampInnerContainer.globalToLocal(newPoint);
				targ.x = newPoint.x ;
				targ.y = newPoint.y ;
				targ.rotation += event.rotation ;
				targ.scaleX *= Math.max(event.scaleX,event.scaleY) ;
				targ.scaleY = targ.scaleX ;
				
				event.updateAfterEvent();
				
				if(event.phase == GesturePhase.END)
				{
					resetGestures();
				}
			}
		}
		
		/**Add a stamp to the stage*/
		protected function addMyStamp(event:MouseEvent):void
		{
			SaffronLogger.log("Stamp clicked");
			var stampItem:StampButton = event.currentTarget as StampButton;
			
			var newStamp:StampItem = new StampItem();
			stampInnerContainer.addChild(newStamp);
			newStamp.setUp(stampItem.myFile.url,true,-1,-1);
			
			newStamp.x = stampContainer.width/2/stampContainer.scaleX;
			newStamp.y = stampContainer.height/2/stampContainer.scaleX;
			
			newStamp.mouseChildren = false ;
		}
		
		
		public static function addStamps(stampFiles:Vector.<File>):void
		{
			stampFile = stampFiles ;
		}
		
		
	///////////////////////////////////
		
		override internal function saveAndClose():void
		{
			//myPaper.exportBitmap(true,true,1);
			stampContainer.scaleX = stampContainer.scaleY = 1 ;
			var newBitmap:BitmapData = new BitmapData(stampContainer.width,stampContainer.height);
			newBitmap.draw(stampContainer);
			PhotoEdit.updateImage(newBitmap);
			super.saveAndClose();
		}
	}
}