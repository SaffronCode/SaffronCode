package photoEditor
{
	import drawPad.Paper;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class EditorPencil extends EditorDefault
	{
		private var myPaper:Paper ;
		
		private var paperContainer:MovieClip;
		
		private var toolbarContainer:MovieClip,
					toolbarScroller:ScrollMT,
					toolbarContainer2:MovieClip,
					toolbarScroller2:ScrollMT;
					
		private var secondToolbarRect:Rectangle ; 
					
		private var tools:Vector.<MovieClip> ;
		
		private var sizes:Vector.<MovieClip> ;
		
		private const penName:String = "pen_",
						rubberName:String = "rub",
						toolsSizeName:String = "size_";
		
		private var resetMC:MovieClip ;
		
		/**The item name will tell the tool color, and the index name cn be pen_ or rub*/
		private var selectedTool:MovieClip ;
		
		private var penThickness:Number = 10,
					rubberThickness:Number = 20;
		
		public function EditorPencil()
		{
			super();
			
			paperContainer = Obj.get("container_mc",this);
			paperContainer.removeChildren();
			toolbarContainer = Obj.get("toolbar_mc",this);
			
			toolbarContainer2 = Obj.get("toolbar2_mc",this);
			
			manageTools();
			
			resetMC = Obj.get("reset_mc",toolbarContainer2);
			resetMC.buttonMode = true ;
			resetMC.gotoAndStop(1);
			resetMC.addEventListener(MouseEvent.CLICK,resetPaper);
			
			
			
			SaffronLogger.log("toolbarRect : "+toolbarRect);
			
			secondToolbarRect = new Rectangle(0,fullScreenAreaRect.height-this.height,fullImageAreaRect.width,toolbarContainer2.height);
			
			SaffronLogger.log("secondToolbarRect : "+secondToolbarRect);
			
			fullImageAreaRect.height-=secondToolbarRect.height ;
			//Debug lines 
				//fullScreenRect.height = 50 ;
			
				
			
			toolbarScroller = new ScrollMT(toolbarContainer,toolbarRect,null,false,true,false);
			toolbarScroller2 = new ScrollMT(toolbarContainer2,secondToolbarRect,null,false,true);
			/*this.graphics.beginFill(0xff0000,0.5);
			this.graphics.drawRect(imageRect.x,imageRect.y,imageRect.width,imageRect.height);*/
			
			
			
			
			if(imageRect.height>fullImageAreaRect.height)
			{
				SaffronLogger.log("imageRect.x was : "+imageRect.x);
				imageRect.x=(fullImageAreaRect.width-((fullImageAreaRect.height/imageRect.height)*imageRect.width))/2;
				imageRect.height = fullImageAreaRect.height ;
				SaffronLogger.log("imageRect.x is : "+imageRect.x);
				PhotoEdit.removePhotoPrevew();
			}
			
			var paperRect:Rectangle = imageRect.clone();
			paperRect.x = paperRect.y = 0 ;
			//Debug line
				//paperRect.width = 200 ;
				//paperRect.height = 10 ;
			
			SaffronLogger.log("paperRect is "+paperRect);
			
			myPaper = new Paper(0x00000000,imageFullBitmapData,null,paperRect);
			myPaper.x = imageRect.x ;
			myPaper.y = imageRect.y ;
			
			paperContainer.addChild(myPaper);
			
			myPaper.addEventListener(MouseEvent.MOUSE_DOWN,startDrawing);
			
			toolbarContainer.addEventListener(MouseEvent.CLICK,changeTool);
			
			selectedTool = Obj.get("pen_00000",toolbarContainer);
			selectedTool.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//complete the image editor
			
			manageStage();
		}
		
		private function manageStage(e:*=null):void
		{
			
			if(this.stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,manageStage);
			}
			else
			{
				this.removeEventListener(Event.ADDED_TO_STAGE,manageStage);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,resetResetButton);
			}
		}
		
		protected function unLoad(event:Event):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,resetResetButton);
		}
		
		protected function resetResetButton(event:MouseEvent):void
		{
			
			if(!resetMC.hitTestPoint(stage.mouseX,stage.mouseY))
			{
				resetMC.gotoAndStop(1);
			}
		}
		
		protected function resetPaper(event:MouseEvent):void
		{
			
			if(resetMC.currentFrame == 1)
			{
				resetMC.gotoAndStop(2);
			}
			else
			{
				myPaper.clear();
				resetMC.gotoAndStop(1);
			}
		}
		
		private function manageTools():void
		{
			tools = new Vector.<MovieClip>();
			
			var i:int;
			for(i = 0 ; i<toolbarContainer.numChildren ; i++)
			{
				var item:MovieClip = toolbarContainer.getChildAt(i) as MovieClip ;
				item.mouseChildren = false ;
				item.buttonMode = true ;
				item.stop();
				
				tools.push(item);
			}
			
			sizes = new Vector.<MovieClip>();
			for(i = 0 ; i<toolbarContainer2.numChildren ; i++)
			{
				var tool:MovieClip = toolbarContainer2.getChildAt(i) as MovieClip;
				tool.mouseChildren = false ;
				tool.buttonMode = true ;
				tool.stop();
				if(tool.name.indexOf(toolsSizeName)!=-1)
				{
					var toolSize:Number = uint(tool.name.split(toolsSizeName).join(''));
					if(toolSize == penThickness)
					{
						tool.gotoAndStop(2);
					}
					sizes.push(tool);
					tool.addEventListener(MouseEvent.CLICK,sizeChanged);
				}
			}
		}
		
		protected function sizeChanged(event:MouseEvent):void
		{
			
			var tool:MovieClip = event.currentTarget as MovieClip ;
			var toolSize:Number = uint(tool.name.split(toolsSizeName).join(''));
			
			for(var i = 0 ; i<sizes.length ; i++)
			{
				sizes[i].gotoAndStop(1);
			}
			
			if(toolSize!=0)
			{
				penThickness = toolSize ;
				tool.gotoAndStop(2);
			}
			
		}
		
		protected function changeTool(event:MouseEvent):void
		{
			selectedTool = null ;
			
			for(var i = 0 ; i<tools.length ; i++)
			{
				if(event.target == tools[i])
				{
					tools[i].gotoAndStop(2);
					selectedTool = event.target as MovieClip;
				}
				else
				{
					tools[i].gotoAndStop(1);
				}
			}
		}
		
		protected function startDrawing(event:MouseEvent):void
		{
			
			if(selectedTool==null)
			{
				SaffronLogger.log("No tools selected on EdotorPencil");
				return;
			}
			if(!imageRect.contains(mouseX,mouseY))
			{
				return ;
			}
			stopDrawing(null);
			
			if(selectedTool.name.indexOf(penName)!=-1)
			{
				SaffronLogger.log("selectedTool.name : "+selectedTool.name);
				SaffronLogger.log("selectedTool.name.split(penName).join('') : "+selectedTool.name.split(penName).join(''));
				var color:uint = uint(parseInt(selectedTool.name.split(penName).join(''),16));
				SaffronLogger.log("Pen color is : "+color);
				myPaper.startDraw(color,penThickness,myPaper.mouseX,myPaper.mouseY);
			}
			else
			{
				myPaper.startDraw(0,rubberThickness,myPaper.mouseX,myPaper.mouseY,imageFullBitmapData,true);
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,setThesePoints);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopDrawing);
		}
		
		protected function setThesePoints(event:MouseEvent):void
		{
			
			myPaper.lineTo(myPaper.mouseX,myPaper.mouseY);
		}
		
		/**stop drawing and cansel listeners*/
		protected function stopDrawing(event:MouseEvent):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,setThesePoints);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopDrawing);
			myPaper.stopDraw();
		}
		
		override internal function saveAndClose():void
		{
			//myPaper.exportBitmap(true,true,1);
			myPaper.x = 0 ;
			myPaper.y = 0 ;
			PhotoEdit.updateImage(myPaper.exportBitmap(false,true,0).bitmapData);
			super.saveAndClose();
		}
		
		override internal function close():void
		{
			myPaper.x = 0 ;
			myPaper.y = 0 ;
			PhotoEdit.updateImage(myPaper.exportBitmap(false,true,0).bitmapData);
			PhotoEdit.undo();
			super.close();
		}
	}
}