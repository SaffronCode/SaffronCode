package appManager.displayContentElemets
	//appManager.displayContentElemets.ImageBox
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import netManager.ImageLoader;
	
	public class ImageBox extends Image
	{
		private var W:Number ;
		private var H:Number ;
		
		/**private var loader:Loader ;
		
		Load this item in the area
		private var loadIn:Boolean;*/
		
		private var imageLoader:ImageLoader ;
		
		//Switched with URL
		//private var myURL:String ;
		
		private static var stageRect:Rectangle ;
		private static var preClass:Class;
		
		/**set to show preLoader*/
		public static function setPreLoader(preLoaderClass:Class)
		{
			preClass = preLoaderClass ;
		}
		
		/**If you set a stage rectangle , all images wait to com in the stage area then it will load*/
		public static function setStageRectangle(stageRectangle:Rectangle)
		{
			stageRect = stageRectangle.clone() ;
		}
		
		public function ImageBox()
		{
			super();
			
			W = this.width ;
			H = this.height ;
			
			this.scaleY = this.scaleX = 1 ;
			
			this.removeChildren();
			
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,W,H);
		}
		
		override public function setUp(imageURL:String,loadInThisArea:Boolean = true ,imageW:Number=0,imageH:Number=0,X:Number=0,Y:Number=0)
		{
			trace("Image box calls");
			trace("load this image : "+imageURL+' > loadInThisArea: '+loadInThisArea);
			
			if(imageW==0)
			{
				imageW = W ;
			}
			
			if(imageH == 0)
			{
				imageH = H ;
			}
			
			imageLoader = new ImageLoader(imageW,imageH,loadInThisArea);
			this.addChild(imageLoader);
			
			URL = imageURL ;
			
			
			
			checkStage();
		}
		
		private function checkStage(e=null):void
		{
			// TODO Auto Generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,checkStage);
			if(this.stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,checkStage);
			}
			else
			{
				this.addEventListener(Event.ENTER_FRAME,checkPose);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			}
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ENTER_FRAME,checkPose);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			
		}
		
		protected function checkPose(event:Event):void
		{
			// TODO Auto-generated method stub
			if(this.stage != null)
			{
				var po:Rectangle = this.getBounds(this.stage) ;
				if(stageRect == null || po.intersects(stageRect))
				{
					loadMe();
					unLoad(null);
				}
			}
		}
		
		private function loadMe():void
		{
			// TODO Auto Generated method stub
			imageLoader.load(URL);
		}
		
	}
}