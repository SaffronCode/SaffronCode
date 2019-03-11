package drawPad
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	

	public class Paper extends Sprite
	{
		/**List of PenLine s in the stage*/
		
		/*private var historY:Vector.<Number>,
					historX:Vector.<Number>;*/
					
		private var drawingMargin:Number = 2 ;
					
		private var containers:Vector.<Sprite>,
					lents:Vector.<uint>,
					colors:Vector.<uint>;
		
		private var stablePoint:Point = new Point(),
					lastPoint:Point = new Point();
		
		private var Vx:Number = 0,
					Vy:Number = 0,
					Fu:Number = 30,//30,//40,//1.5 for resolution number 1
					Mu:Number = 0.7;//0.4
		
		private const minPointsDelta:Number = 1;
		
		private var myX:Number,
					myY:Number;
		//I was testing the paint resolution
		private var draw:Boolean = false ;
		
		private var resolutions:uint = 10,//10
					autoCaptureResolution:uint = 2;
		
		private var DrawingPlace:Sprite;
		
		private var penPlace:Sprite,
					rubberPlace:Sprite,
					cashedPlace:Sprite,
					drawingContainers:Sprite;

		private var backImage:Bitmap;
		/**Capturing resolution*/
		//private var resolution:uint = 1;
		
		private var captureTimer:Timer,
					captureDilay:uint = 200;
		
		public function Paper(backGroundColor:uint,defaultImage:BitmapData=null,firstDrawnImage:BitmapData=null,backAlignRect:Rectangle=null)
		{
			super();
			setUpCaptureWithDilay();
			
			trace("Hi paper");
			
			drawingContainers = new Sprite();
			
			/*if(defaultImage != null)
			{*/
			backImage = new Bitmap(defaultImage);
			backImage.smoothing = true ;
			this.addChild(backImage);
			
			cashedPlace = new Sprite();
			drawingContainers.addChild(cashedPlace);
			
			
			var lastDrawnBitmap:Bitmap = new Bitmap(firstDrawnImage);
			lastDrawnBitmap.smoothing = true ;
			cashedPlace.addChild(lastDrawnBitmap);
			
			
			
			if(backAlignRect !=null)
			{
				if(backAlignRect.width!=Infinity)
				{
					backImage.width = backAlignRect.width ;
				//Why I didn't aligh the paper with height??
					if(backAlignRect.height!=Infinity)
					{
						backImage.height = backAlignRect.height ;
						backImage.scaleY = backImage.scaleX = Math.min(backImage.scaleY,backImage.scaleX);
					}
					else
					{
						backImage.scaleY = backImage.scaleX ;
					}
					lastDrawnBitmap.scaleX = backImage.scaleX ;
					lastDrawnBitmap.scaleY = backImage.scaleY ;
				}
			}
			
			trace("backImage width is : "+backImage.width);
			
			penPlace = new Sprite();
			drawingContainers.addChild(penPlace);
			/*}
			else
			{
				backImage = new Bitmap();
				DrawingPlace = this ;
			}*/
				
			rubberPlace = new Sprite();
			drawingContainers.addChild(rubberPlace);
			
			this.addChild(drawingContainers);
			
			
			/*historY = new Vector.<Number>();
			historX = new Vector.<Number>();*/
			
			this.addEventListener(Event.ENTER_FRAME,drawLines);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		private function unLoad(event:Event)
		{
			this.removeEventListener(Event.ENTER_FRAME,drawLines);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			cancelCaptureDilay();
		}
		
		public function set backVisible(value:Boolean):void
		{
			backImage.visible = value ;
		}
		
		public function get backVisible():Boolean
		{
			return backImage.visible ;
		}
		
		public function clear():void
		{
			//DrawingPlace.graphics.clear();
			rubberPlace.graphics.clear();
			penPlace.graphics.clear();
			cashedPlace.removeChildren();
			var lastDrawnBitmap:Bitmap = new Bitmap();
			cashedPlace.addChild(lastDrawnBitmap);
			
			/*historY = new Vector.<Number>();
			historX = new Vector.<Number>();*/
			
			draw = false ;
		}
		
		
		private function drawLines(ev:Event=null)
		{
			if(draw)
			{
				for(var i = 0 ; i<resolutions ; i++)
				{
					Vx += (myX-stablePoint.x)/Fu ;
					Vx *= Mu ;
					Vy += (myY-stablePoint.y)/Fu ;
					Vy *= Mu ;
					stablePoint.x += Vx ;
					stablePoint.y += Vy ;
					
					if(lastPoint.subtract(stablePoint).length>minPointsDelta)
					{
						DrawingPlace.graphics.lineTo(stablePoint.x,stablePoint.y);
						//Draw these points here
						lastPoint = stablePoint.clone();
					}
				}
			}
		}
		
		/**Get ready to draw lines<br>
		 * rubber is a drawing with the color of background*/
		public function startDraw(color:uint,thickness:Number,X:Number,Y:Number,bitmapData:BitmapData=null,isRubber:Boolean = false ):void
		{
			cancelCaptureDilay();
			//trace("start drawing to : "+X,Y+' > '+thickness);
			if(isRubber)
			{
				DrawingPlace = rubberPlace ;
			}
			else
			{
				DrawingPlace = penPlace ;
			}
			
			//Settig up a new penLine Object on stage and add it here and set it stand by to draw
			DrawingPlace.graphics.lineStyle(thickness,color,1,false,"stretch",CapsStyle.ROUND,JointStyle.ROUND,3);
			if(bitmapData != null)
			{
				//trace("Rubber color : "+color);
				DrawingPlace.graphics.lineBitmapStyle(bitmapData,new Matrix(backImage.scaleX,0,0,backImage.scaleX),false,true);
			}
			DrawingPlace.graphics.moveTo(X,Y);
			lastPoint = new Point(X,Y);
			stablePoint = lastPoint.clone();
			
			myX = X ;
			myY = Y ;
			
			/*historY.push(myX);
			historX.push(myY);*/
			
			Vx = Vy = 0 ;
			draw = true ;
			
			lineTo(myX+2,myY)
		}
		
		public function lineTo(X:Number,Y:Number)
		{
			//send these parameters to currentPenLine if there is an active one there
			myX = X ;
			myY = Y ;
			
			/*historY.push(myX);
			historX.push(myY);*/
		}
		
		/**Stop the current item to continue draw*/
		public function stopDraw():void
		{
			for(var i = 0 ; i<20 ; i++)
			{
				drawLines();
			}
			//Stop drawing and close currentPenLine to generate its bitmapData instead of vector shapes
			draw = false ;
			
			
			
			if(DrawingPlace == rubberPlace)
			{
				captureAndSaveDrawing();
			}
			else
			{
				trace("call it with dilay");
				captureAndSaveDrawingDilay();
			}
			
			trace("stop drawing");
		}		
		
		public function importBitmap(bitmap:Bitmap)
		{
			var currentDrawnBitmap:Bitmap = bitmap;
			currentDrawnBitmap.smoothing = true ;
			
			rubberPlace.graphics.clear();
			penPlace.graphics.clear();
			cashedPlace.removeChildren();
			
			cashedPlace.addChild(currentDrawnBitmap);
		}
		
		public function exportBitmap(exportMinArea:Boolean,withBackGround:Boolean,resolution:Number=1):Bitmap
		{
			if(resolution==0)
			{
				trace("Paper resolution sat to : "+backImage.scaleX) ;
				resolution = 1/backImage.scaleX ;
			}
			//New Function ↓
			if(captureTimer.running)
			{
				//This means there are some drawing on the paper that dosen't captured yet.
				captureAndSaveDrawing();
			}
			
			var paperRect:Rectangle ;
			//Savve and remove mask layer if there is
			
			var captureThis:Sprite ;
			
			if(withBackGround)
			{
				captureThis = this ;
				trace("Capture me with my background")
			}
			else
			{
				captureThis = drawingContainers ;
			}
			var myMask:DisplayObject = captureThis.mask ;
			captureThis.mask = null 
			
			if(exportMinArea || backImage == null || backImage.bitmapData == null )
			{
				paperRect = captureThis.getBounds(captureThis.parent);
				paperRect.left -= drawingMargin ;
				paperRect.top -= drawingMargin ;
				paperRect.right += drawingMargin ;
				paperRect.bottom += drawingMargin ;
				trace("capture this area : "+paperRect);
			}
			else
			{
				paperRect = backImage.bitmapData.rect ;
				paperRect.x*=backImage.scaleX;
				paperRect.y*=backImage.scaleX;
				paperRect.width*=backImage.scaleX;
				paperRect.height*=backImage.scaleX;
			}
			
			if(DrawingPlace == rubberPlace)
			{
				rubberPlace.blendMode = BlendMode.ERASE ;
			}
			var captured:BitmapData = new BitmapData(paperRect.width*resolution,paperRect.height*resolution,true,0x0);
			captured.draw(captureThis,new Matrix(resolution,0,0,resolution,(0-paperRect.x)*resolution,(0-paperRect.y)*resolution));
			
			var capturedBitmap:Bitmap = new Bitmap(captured);
			capturedBitmap.smoothing = true ;
			
			capturedBitmap.scaleX = capturedBitmap.scaleY = 1/resolution ;
			capturedBitmap.x = paperRect.left;
			capturedBitmap.y = paperRect.top;
			
			//Handle the mask layer ↓
			captureThis.mask = myMask ;
			
			return capturedBitmap ;
		}
		
		/**cancel and delete current open drawing*/
		public function cancelCurrentOpenDraw():void
		{
			canselCurrentOpenDraw();
		}
		/**cancel and delete current open drawing*/
		public function canselCurrentOpenDraw():void
		{
			//Cancel open drawing and delete currentPen line
			//Settig up a new penLine Object on stage and add it here and set it stand by to draw
			if(DrawingPlace!=null)
			{
				DrawingPlace.graphics.clear();
			}
			
			draw = false ;
		}
		
		/**rewind ( undo ) last pixel and re draw curren item again*/
		public function rewind():Boolean
		{
			//return true if hav somthing to rewind
			//rewind las PenLine class , till it's rewind function returns true , then 
			//	delete lastPenLine and start to rewind Other PenLine
			
			//If there is no penLines avaialble , return false as feadback
			return false ;
		}
		
		
	///////////////////////////////////////////
		private function setUpCaptureWithDilay()
		{
			captureTimer = new Timer(captureDilay,1);
			captureTimer.addEventListener(TimerEvent.TIMER_COMPLETE,captureAndSaveDrawing);
		}
		
		private function cancelCaptureDilay():void
		{
			captureTimer.reset();
		}
		
		private function captureAndSaveDrawingDilay():void
		{
			
			captureTimer.start();
		}
		
		private function captureAndSaveDrawing(e:TimerEvent=null):void
		{
			cancelCaptureDilay()
			
			var currentDrawnBitmap:Bitmap = exportBitmap(true,false,autoCaptureResolution);
			
			rubberPlace.graphics.clear();
			penPlace.graphics.clear();
			cashedPlace.removeChildren();
			
			cashedPlace.addChild(currentDrawnBitmap);
			//I habe to store capturedBitmap in the bottomest layer tro prevent drawings get behind it
			
			rubberPlace.blendMode = BlendMode.NORMAL ;
		}
		
		
	}
}