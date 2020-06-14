package contents.displayPages
	//contents.displayPages.StaticSWFLoader
{
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	public class StaticSWFLoader extends MovieClip implements DisplayPageInterface
	{
		private var W:Number,
					H:Number;
					
		private var swfContainer:MovieClip;//,
					//swfMask:MovieClip;•
					
		private var loader:Loader ; 
		
		public function StaticSWFLoader()
		{
			super();
			W = this.width ;
			H = this.height ;
			this.removeChildren();
			
			swfContainer = new MovieClip();
				//swfMask = new MovieClip();
			this.addChild(swfContainer);
				//Debug line ↓
					//swfContainer.buttonMode = true ; // not efected
				//swfMask.graphics.beginFill(0,1);
				//swfMask.graphics.drawRect(0,0,W,H);
				//this.addChild(swfMask);
			//•Mask is not ok for buttons !! 94/02/01
				//swfContainer.mask = swfMask ;
		}
		
		public function setUp(pageData:PageData):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,contentLoaded);
			var loaderContex:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
				//Debug line ↓
					//loaderContex.allowCodeImport = true ; // not efected
			SaffronLogger.log("SWF target is : "+pageData.imageTarget);
			loader.load(new URLRequest(pageData.imageTarget),loaderContex);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			
			try
			{
				loader.close();
			}
			catch(e){};
			loader.unloadAndStop();
		}
		
		protected function contentLoaded(event:Event):void
		{
			
			var insertedItem:MovieClip = loader.content as MovieClip ;
			insertedItem.addEventListener(Event.ADDED,preventBubble);
			insertedItem.addEventListener(Event.ADDED_TO_STAGE,preventBubble);
			swfContainer.addChild(insertedItem);
		}
		
		/**Language manager wil manage all content after they added to stage, if the contents had dynamic
		 * texts as links, that will prevent them from working. so this function will not allow for
		 * bubbling of ADDED and ADDED_TO_STAGE events.*/
		private function preventBubble(e:Event)
		{
			e.stopImmediatePropagation();
		}
	}
}