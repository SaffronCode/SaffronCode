package appManager.displayContent
	//appManager.displayContent.SliderThumbnail
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	/**I'm ready*/
	[Event(name="complete", type="flash.events.Event")]
	public class SliderThumbnail extends MovieClip 
	{
		private static const animSpeed:uint = 10 ;
		
		private var myImageArea:LightImage ;
		
		internal var X0:Number,Y0:Number,Scale0:Number,Alpha0:Number;
		
		internal var myIndex:uint ;
		
		internal var isReady:Boolean = false ;
		private var myPreloader:MovieClip;
		
		public function SliderThumbnail(X:Number=NaN,Y:Number=NaN,Scale:Number=NaN,Alpha:Number=NaN)
		{
			super();
			
			if(!isNaN(X))
			{
				this.x = X0 = X ;
				this.y = Y0 = Y ;
				this.scaleX = this.scaleY = Scale0 = Scale ;
				this.alpha = Alpha0 = Alpha ;
			}
			
			myImageArea = Obj.findThisClass(LightImage,this,true);
			
			this.addEventListener(Event.ENTER_FRAME,animate);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,animate);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Animate the icons*/
		protected function animate(event:Event):void
		{
			this.x += (X0-this.x)/animSpeed ;
			this.y += (Y0-this.y)/animSpeed ;
			this.scaleX += (Scale0-this.scaleX)/animSpeed ;
			this.scaleY = this.scaleX ;
			this.alpha += (Alpha0-this.alpha)/animSpeed ;
		}
		
		/**The image is loaded*/
		protected function imageReady(event:Event):void
		{
			isReady = true ;
			Obj.remove(myPreloader);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function setUp(image:*,index:uint,preLoaderObject:MovieClip):void
		{
			myIndex = index ;
			
			preLoaderObject.x = 0;
			preLoaderObject.y = 0;
			this.addChild(preLoaderObject);
			
			myPreloader = preLoaderObject ;
			
			if(image is String)
			{
				myImageArea.addEventListener(Event.COMPLETE,imageReady);
				myImageArea.setUp(image,false,0,0,0,0,true);
			}
			else if(image is BitmapData)
			{
				myImageArea.setUpBitmapData(image);
				imageReady(null);
			}
			else if(image is ByteArray)
			{
				myImageArea.setUpBytes(image);
				imageReady(null);
			}
			else
			{
				throw "What is this : "+image ;
			}
		}
	}
}