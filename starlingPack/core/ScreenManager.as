package starlingPack.core
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;

	[Event(name="resize", type="flash.events.Event")]
	/**
	 * Add this function to the Flash main:
	 *  private function manageStageSize(e:Event):void
     {
         trace("ScreenManager.scaleFactor : "+ScreenManager.scaleFactor)
		 root.scaleX = root.scaleY = ScreenManager.scaleFactor ;
		 root.x = ScreenManager.deltaXOnScaleFactor();
		 root.y = ScreenManager.deltaYOnScaleFactor();

 			//To change the view port of the staling
         starling.viewPort = new Rectangle(0,0,ScreenManager.stageWidth,ScreenManager.stageHeight);
         starling.stage.stageWidth = ScreenManager.stageWidth ;
         starling.stage.stageHeight = ScreenManager.stageHeight ;
     }

	 and this to starling main :


     protected function controllSize(event:Event):void
     {
     		//To change the starling content size
         this.scaleX = this.scaleY = ScreenManager.scaleFactor ;
         this.x = ScreenManager.deltaXOnScaleFactor() ;
         this.y = ScreenManager.deltaYOnScaleFactor() ;
     }


	 on

     ScreenManager.eventDispatcher.addEventListener(Event.RESIZE,controllSize);
	 *
	 * */
	public class ScreenManager extends EventDispatcher {
        /**You can catch all events on this variable*/
        public static const eventDispatcher:ScreenManager = new ScreenManager();

        /**This is the default screedDPI*/
        public static const defaultDPI:Number = 72;


        /**This is the application stage*/
        private static var stage:Stage;


        private static var _flashW:Number, _flashH:Number;

        private static var _stageWidth:Number, _stageHeight:Number;

        /**Stored screenDPI*/
        private static var _screenDPI:Number;

        /**Resized position of stage*/
        private static var scaleFactorX:Number, scaleFactorY:Number;


        private static var deltaX:Number, deltaY:Number;

        /**You can store roots list here and make them manage x and y and scale automaticaly*/
        private static var roots:Array;

        public function ScreenManager() {
            super();
        }

        override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            this.dispatchEvent(new Event(Event.RESIZE));
		}

		public static function get flashH():Number
		{
			return _flashH;
		}

		/**Original stage widh and height will store here*/
		public static function get flashW():Number
		{
			return _flashW;
		}

		/**Seting up the screenManager.*/
		public static function setUp(myStage:Stage,flashWidth:Number,flashHeight:Number,fakeDPI:Number=NaN,rootsListToManageAutomaticly:Array=null):void
		{
			stage = myStage ;
			stage.addEventListener(Event.RESIZE,stageResized);
			
			roots = rootsListToManageAutomaticly ;
			
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			stage.align = StageAlign.TOP_LEFT ;
			
			if(isNaN(fakeDPI))
			{
				_screenDPI = Capabilities.screenDPI ;
			}
			else
			{
				_screenDPI = fakeDPI ;
			}
			
			_flashW = flashWidth ;
			_flashH = flashHeight ;
			
			stageResized(null);
		}
		
		/**Stage resized. chane all of your variables*/
		protected static function stageResized(event:Event):void
		{
			_stageWidth = stage.stageWidth ;
			_stageHeight = stage.stageHeight ;
			
			scaleFactorX = _stageWidth/_flashW;
			scaleFactorY = _stageHeight/_flashH;
			
			deltaX = _stageWidth-_flashW;
			deltaY = _stageHeight-_flashH;
			
			if(roots)
			{
				for(var i:int = 0 ; i<roots.length ; i++)
				{
					trace("roots[i] : "+roots[i]);
					roots[i].scaleX = roots[i].scaleY = scaleFactor ;
					roots[i].x = deltaXOnScaleFactor();
					roots[i].y = deltaYOnScaleFactor();
				}
			}
			
			eventDispatcher.dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**Returns the scaleFactor to resize objects on the defrent stage sizes. but it depends on screenDPI.<br>
		 * This is still on beta testing.*/
		public static function get scaleFactorBasedOnDPI():Number
		{
			return Math.min(scaleFactorX,scaleFactorY)*(_screenDPI/defaultDPI);
		}
		
		/**Returns the scale factor*/
		public static function get scaleFactor():Number
		{
			return Math.min(scaleFactorX,scaleFactorY);
		}
		
		/**Returns the max scale factor*/
		public static function get scaleFactorMax():Number
		{
			return Math.max(scaleFactorX,scaleFactorY);
		}
		
		
		/**This will return you a X based on the scaleFactor*/
		public static function Xstrech(X0:Number):Number
		{
			return X0*scaleFactorX ;
		}
		
		/**This will return you a Y based on the scaleFactor*/
		public static function Ystrech(Y0:Number):Number
		{
			return Y0*scaleFactorY ;
		}
		
		/**Returns the new X and add deltaStage on it
		public static function XaddDeltaOnScale(X0):Number
		{
			trace("deltaX : "+deltaX);
			var firstPosePrecent:Number = X0/flashW ;
			return X0+(deltaX/2)*scaleFactorX;
		}*/
		
		/**Returns the new Y and add deltaStage on it
		public static function YaddDeltaScale(Y0):Number
		{
			return Y0+(deltaY/2)*scaleFactorY;
		}*/
		
		/**Delta x based on resized object on scale factor*/
		public static function deltaXOnScaleFactor():Number
		{
			return (_stageWidth-_flashW*scaleFactor)/2;
		}
		
		/**Delta y based on resized object on scale factor*/
		public static function deltaYOnScaleFactor():Number
		{
			return (_stageHeight-_flashH*scaleFactor)/2;
		}

		/**This will returns the stage.width of main swf*/
		public static function stageWidthFlash():Number
		{
			return _flashW ;
		}

		/**This will returns the stage.height of main swf*/
		public static function stageHeightFlash():Number
		{
			return _flashH ;
		}

		
		
		
		/**Real stage widh and height*/
		public static function get stageHeight():Number
		{
			return _stageHeight;
		}
		
		public static function stageHeightOnScale():Number
		{
			return _stageHeight/scaleFactor ;
		}
		
		/**Real stage widh and height*/
		public static function get stageWidth():Number
		{
			return _stageWidth;
		}
		
		public static function stageWidthOnScale():Number
		{
			return _stageWidth/scaleFactor ;
		}
		
		
		
		
		
		/**This is the screenDPI. but I donw know how should I use it.*/
		public static function get screenDPI():Number
		{
			return _screenDPI;
		}
	}
}