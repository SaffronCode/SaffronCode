package dynamicFrame
{
	import flash.desktop.NativeApplication;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class FrameGenerator
	{
		public static function createFrame(stage:Stage,color:uint=0xF0583B):void
		{
			var margin:uint = 1 ;
			var extarTopMargin:uint = 0 ;
			var roundLevel:uint = 5 ;
			var frame:Sprite = new Sprite();
			stage.addChild(frame);
			frame.graphics.beginFill(color);
			frame.graphics.drawRoundRect(0,0,stage.stageWidth,stage.stageHeight,roundLevel);
			//(stage.root as Sprite).graphics.beginFill(stage.color);
			//(stage.root as Sprite).graphics.drawRoundRect(0,0,stage.stageWidth,stage.stageHeight,roundLevel);
			frame.graphics.drawRoundRect(margin,margin+extarTopMargin,stage.stageWidth-margin*2,stage.stageHeight-margin*2-extarTopMargin,roundLevel);
			
			
			var exitbuttonW:Number = 50 ;
			var exitbuttonH:Number = 20 ;
			var exitCrossW:Number = 10 ;
			var crossThikness:Number = 4 ;
			
			var exitButton:Sprite = new Sprite();
			exitButton.graphics.beginFill(color);
			exitButton.graphics.drawRoundRectComplex(0,0,exitbuttonW,exitbuttonH,0,0,5,5);
			exitButton.graphics.endFill();
			
			exitButton.graphics.lineStyle(crossThikness,0xffffff,1,false,LineScaleMode.NORMAL,CapsStyle.NONE);
			var x0:Number = (exitbuttonW-exitCrossW)/2 ;
			var y0:Number = (exitbuttonH-exitCrossW)/2 ;
			exitButton.graphics.moveTo(x0,y0);
			exitButton.graphics.lineTo(x0+exitCrossW,y0+exitCrossW);
			exitButton.graphics.moveTo(x0+exitCrossW,y0);
			exitButton.graphics.lineTo(x0,y0+exitCrossW);
			exitButton.buttonMode = true ;
			exitButton.addEventListener(MouseEvent.CLICK,function(){NativeApplication.nativeApplication.exit();});
			
			exitButton.x = frame.width-exitButton.width-roundLevel ;
			frame.addChild(exitButton);

			
			//positioning the stage
			stage.addEventListener(MouseEvent.MOUSE_DOWN,startDragStage);
			
			function startDragStage(e:MouseEvent):void
			{
				var clickedItem:Sprite = e.target as Sprite ;
				if(e.target is TextField)
				{
					return ;
				}
				while(clickedItem!=null && !(clickedItem is Stage))
				{
					if(clickedItem.buttonMode == true || clickedItem.hasEventListener(MouseEvent.CLICK))
					{
						return ;
					}
					clickedItem = clickedItem.parent as Sprite ;
				}
				var MouseX0:Number = e.stageX ;
				var MouseY0:Number = e.stageY ;
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE,moveStagePlace);
				
				function moveStagePlace(e:MouseEvent):void
				{
					var deltaX:Number = e.stageX-MouseX0 ;
					var deltaY:Number = e.stageY-MouseY0 ;
					NativeApplication.nativeApplication.activeWindow.x += deltaX ;
					NativeApplication.nativeApplication.activeWindow.y += deltaY ;
				}
				stage.addEventListener(MouseEvent.MOUSE_UP,function(e){
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveStagePlace);
				});
			}
		}
	}
}