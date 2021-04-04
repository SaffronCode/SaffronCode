package dynamicFrame
{
import contents.alert.Alert;

import flash.desktop.NativeApplication;
import flash.display.CapsStyle;
import flash.display.DisplayObject;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
	
	public class FrameGenerator
	{
		private static const defaultColor:uint = 0xF0583B ;

		private static const radius:Number = 5 ;

		public static function createFrame(stage:Stage,color:int=-1,passRootClassToAddBackground:Sprite=null,fullScreen:Boolean=false):void
		{
			if(color==-1)
				color = defaultColor ;
			var margin:uint = 1 ;
			var extarTopMargin:uint = 0 ;
			var roundLevel:uint = 0 ;
			var frame:Sprite = new Sprite();
			stage.addChild(frame);
			frame.graphics.beginFill(color);

			var scale:Number = Math.max((stage.stageWidth/stage.fullScreenWidth),(stage.stageHeight/stage.fullScreenHeight));
			var customWidth:Number = stage.fullScreenWidth*scale;
			var customHeight:Number = stage.fullScreenHeight*scale;

			var appWidth:Number = !fullScreen?stage.stageWidth:customWidth ;
			var appHeight:Number = !fullScreen?stage.stageHeight:customHeight ;


			var frameX0:Number = fullScreen?-(customWidth-stage.stageWidth)/2:0 ;
			var frameY0:Number = fullScreen?-(customHeight-stage.stageHeight)/2:0 ;

			frame.graphics.drawRoundRect(frameX0,frameY0,appWidth,appHeight,roundLevel);
			//(stage.root as Sprite).graphics.beginFill(stage.color);
			//(stage.root as Sprite).graphics.drawRoundRect(0,0,appWidth,appHeight,roundLevel);
			frame.graphics.drawRoundRect(margin+frameX0,margin+extarTopMargin+frameY0,appWidth-margin*2,appHeight-margin*2-extarTopMargin,roundLevel);

			if(passRootClassToAddBackground!=null)
			{
                passRootClassToAddBackground.graphics.beginFill(stage.color&0x00ffffff);
                passRootClassToAddBackground.graphics.drawRoundRect(frameX0,frameY0,appWidth,appHeight,5,5);
			}
			
			var exitbuttonW:Number = 50 ;
			var exitbuttonH:Number = 20 ;
			var exitCrossW:Number = 10 ;
			var crossThikness:Number = 4 ;
			
			var exitButton:Sprite = new Sprite();
			exitButton.graphics.beginFill(color);
			exitButton.graphics.drawRoundRectComplex(0,0,exitbuttonW,exitbuttonH,0,0,radius,radius);
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
			
			exitButton.x = frame.width-exitButton.width-roundLevel+frameX0 ;
			frame.addChild(exitButton);
			
			
			
			var minimizeButton:Sprite = new Sprite();
			minimizeButton.graphics.beginFill(color);
			minimizeButton.graphics.drawRoundRectComplex(0,0,exitbuttonW,exitbuttonH,0,0,radius,radius);
			minimizeButton.graphics.endFill();
			
			minimizeButton.graphics.lineStyle(crossThikness,0xffffff,1,false,LineScaleMode.NORMAL,CapsStyle.NONE);
			x0 = (exitbuttonW-exitCrossW)/2;
			y0 = (exitbuttonH-exitCrossW)/2;
			minimizeButton.graphics.moveTo(x0+exitCrossW,y0+exitCrossW/2);
			minimizeButton.graphics.lineTo(x0,y0+exitCrossW/2);
			minimizeButton.buttonMode = true ;
			minimizeButton.addEventListener(MouseEvent.CLICK,function(){stage.nativeWindow.minimize();});
			
			minimizeButton.x = frame.width-minimizeButton.width*2+frameX0;
			frame.addChild(minimizeButton);

			
			//positioning the stage
			if(!fullScreen)
			{
				var dragLocked:Boolean = false ;
				stage.addEventListener(MouseEvent.MOUSE_DOWN,startDragStage);
				stage.addEventListener(ScrollMTEvent.TOUCHED_TO_SCROLL,function(e){dragLocked=true;});
				stage.addEventListener(MouseEvent.MOUSE_UP,function(e){dragLocked=false;});
				
				function startDragStage(e:MouseEvent):void
				{
					var clickedItem:Sprite = e.target as Sprite ;
					if(e.target is TextField || dragLocked)
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
						if(NativeApplication.nativeApplication.activeWindow==null)
							return;
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
}