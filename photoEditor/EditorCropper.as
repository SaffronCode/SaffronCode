package photoEditor
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class EditorCropper extends EditorDefault
	{
		private var rf:Rectangle,
					rs:Rectangle ;
					
		private var maskColor:uint = 0x000000,
					maskAlpha:Number = 0.8,
					lineTh:Number = 4,
					lineColor:uint = 0xffffff;
					
		private var maskAreaMC:MovieClip ;
		
		private var fingerArea:Number = 30 ;
		
		/**user is draging crop area*/
		private var cropActive:Boolean = false,
					mousePose:Point;
		
		/**-1:left or top, 0:in , 1:right or down*/
		private var mousePoseX:int,
					mousePoseY:int;
		
		public function EditorCropper()
		{
			super();
			
			maskAreaMC = new MovieClip();
			this.addChild(maskAreaMC);
			
			rf = fullImageAreaRect.clone();
			drawEditor(imageRect);
			
			controllStage();
		}
		
		private function controllStage(e:*=null):void
		{
			
			if(this.stage!=null)
			{
				activateCropper();
				this.removeEventListener(Event.ADDED_TO_STAGE,controllStage);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStage);
			}
		}
		
		private function activateCropper():void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,controllMousePose);
			stage.addEventListener(MouseEvent.MOUSE_UP,canselCropping);
			this.addEventListener(Event.ENTER_FRAME,showCropArea);
		}
		
		protected function showCropArea(event:Event):void
		{
			
			if(!cropActive)
			{
				return ;
			}
			
			var newRect:Rectangle = rs.clone();
			mousePose;
			var mousePoseNow:Point = new Point(this.mouseX,this.mouseY);
			var deltaMouse:Point = new Point(mousePoseNow.x-mousePose.x,mousePoseNow.y-mousePose.y);
			
			switch(mousePoseX)
			{
				case(-1):
					newRect.left+=deltaMouse.x;
					break;
				/*case(0):
					newRect.left+=deltaMouse.x;
					newRect.right+=deltaMouse.x;
					break;*/
				case(1):
					newRect.right+=deltaMouse.x;
					break;
			}
			
			switch(mousePoseY)
			{
				case(-1):
					newRect.top+=deltaMouse.y;
					break;
				/*case(0):
					newRect.top+=deltaMouse.y;
					newRect.bottom+=deltaMouse.y;
					break;*/
				case(1):
					newRect.bottom+=deltaMouse.y;
					break;
			}
			
			if(mousePoseY==0 && mousePoseX==0)
			{
				newRect.top+=deltaMouse.y;
				newRect.bottom+=deltaMouse.y;
				newRect.left+=deltaMouse.x;
				newRect.right+=deltaMouse.x;
			}
			
			if(newRect.width<0)
			{
				newRect.left = newRect.right+newRect.left;
				newRect.right = newRect.left-newRect.right;
				newRect.left = newRect.left-newRect.right;
				
				if(mousePoseX>0)
				{
					mousePoseX = -1;
				}
				else
				{
					mousePoseX = 1 ;
				}
			}
			
			if(newRect.height<0)
			{
				newRect.top = newRect.bottom+newRect.top;
				newRect.bottom = newRect.top-newRect.bottom;
				newRect.top = newRect.top-newRect.bottom;
				
				if(mousePoseY>0)
				{
					mousePoseY = -1;
				}
				else
				{
					mousePoseY = 1 ;
				}
			}
			
			mousePose = mousePoseNow ;
			
			drawEditor(newRect);
		}
		
		protected function canselCropping(event:MouseEvent):void
		{
			
			cropActive = false 
		}
		
		protected function controllMousePose(event:MouseEvent):void
		{
			
			//Activate draw editor
			cropActive = true;
			//Set the mouse position to use on drawEditor class
			if(this.mouseX<rs.left+fingerArea)
			{
				mousePoseX = -1;
			}
			else if(this.mouseX<rs.right-fingerArea)
			{
				mousePoseX = 0 ;
			}
			else
			{
				mousePoseX = 1;
			}
			
			//Set the mouse position to use on drawEditor class
			if(this.mouseY<rs.top+fingerArea)
			{
				mousePoseY = -1;
			}
			else if(this.mouseY<rs.bottom-fingerArea)
			{
				mousePoseY = 0 ;
			}
			else
			{
				mousePoseY = 1;
			}
			
			//trace("mousePoseY : "+mousePoseY);
			//trace("mousePoseX : "+mousePoseX);
			
			//Set the last mouse pose
			mousePose = new Point(this.mouseX,this.mouseY);
		}
		
		protected function unLoad(event:Event):void
		{
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,controllMousePose);
			stage.removeEventListener(MouseEvent.MOUSE_UP,canselCropping);
			this.removeEventListener(Event.ENTER_FRAME,showCropArea);
		}
		
		private function drawEditor(rect:Rectangle):void
		{
			if(rs!=null && rs.equals(rect))
			{
				return ;
			}
			rs = rect ;
			
			maskAreaMC.graphics.clear();
			maskAreaMC.graphics.beginFill(maskColor,maskAlpha);
			
			maskAreaMC.graphics.moveTo(rf.left,rf.top);
			maskAreaMC.graphics.lineTo(rf.right,rf.top);
			maskAreaMC.graphics.lineTo(rf.right,rf.bottom);
			maskAreaMC.graphics.lineTo(rf.left,rf.bottom);
			maskAreaMC.graphics.lineTo(rf.left,rf.top);
			
			maskAreaMC.graphics.lineStyle(lineTh,lineColor,1,false,'normal',CapsStyle.NONE,JointStyle.MITER);
			
			maskAreaMC.graphics.moveTo(rs.left,rs.top);
			maskAreaMC.graphics.lineTo(rs.right,rs.top);
			maskAreaMC.graphics.lineTo(rs.right,rs.bottom);
			maskAreaMC.graphics.lineTo(rs.left,rs.bottom);
			maskAreaMC.graphics.lineTo(rs.left,rs.top);
			
			maskAreaMC.graphics.beginFill(0,0);
			maskAreaMC.graphics.drawRect(rf.x,rf.y,rf.width,rf.height);
		}
		
		override internal function saveAndClose():void
		{
			PhotoEdit.updateImage(PhotoEdit.getImage(rs));
			trace("Save the cropped image");
			super.saveAndClose();
		}
	}
}