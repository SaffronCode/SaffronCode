package photoEditor
	//photoEditor.StampList
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
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
		
		
		public function StampList()
		{
			super();
			
			stampContainer = Obj.get("stamp_container_mc",this);
			
			button_remove = Obj.get("remove_mc",this);
			stampsMC = Obj.get("stampList_mc",this);
			
			stampsMC.removeChildren();
			stampContainer.removeChildren();
			
			stampInnerContainer = new Sprite();
			stampInnerContainer.graphics.beginFill(0xff0000,0.5);
			stampInnerContainer.graphics.drawRect(0,0,400,400);
			
			for(var i = 0 ; i<stampFile.length ; i++)
			{
				var newItems:StampButton = new StampButton();
				newItems.load(stampFile[i]);
				stampsMC.addChild(newItems);
				newItems.x = i*(newItems.width+10);
				newItems.addEventListener(MouseEvent.CLICK,addMyStamp);
			}
			
			trace("toolbarRect: "+toolbarRect);
			
			
			var stampsArea:Rectangle = toolbarRect.clone();
			stampsArea.x += stampsMC.x ;
			button_remove.x += toolbarRect.x ;
			button_remove.y = toolbarRect.y ;
			button_remove.gotoAndStop(2);
			
			trace("stampsArea : "+stampsArea);
			
			new ScrollMT(stampsMC,stampsArea,null,false,true);
			
			var imageBitmap:Bitmap = new Bitmap(imageFullBitmapData);
			stampContainer.addChild(imageBitmap);
			stampContainer.addChild(stampInnerContainer);
			
			stampContainer.width = fullImageAreaRect.width ;
			stampContainer.height = fullImageAreaRect.height ;
			stampContainer.scaleX = stampContainer.scaleY = Math.min(stampContainer.scaleX,stampContainer.scaleY);
			
			stampContainer.x = (fullImageAreaRect.width-stampContainer.width)/2;
			stampContainer.y = (fullImageAreaRect.height-stampContainer.height)/2;
		}
		
		protected function addMyStamp(event:MouseEvent):void
		{
			trace("Stamp clicked");
			var stampItem:StampButton = event.currentTarget as StampButton;
			
			var newStamp:LightImage = new LightImage();
			stampInnerContainer.addChild(newStamp);
			newStamp.setUp(stampItem.myFile.url,true,-1,-1);
			
			newStamp.x = stampContainer.width/2;
			newStamp.y = stampContainer.height/2;
		}
		
		public static function addStamps(stampFiles:Vector.<File>):void
		{
			stampFile = stampFiles ;
		}
	}
}