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
					
		private var swfContainer:MovieClip,
					swfMask:MovieClip;
					
		private var loader:Loader ; 
		
		public function StaticSWFLoader()
		{
			super();
			W = this.width ;
			H = this.height ;
			this.removeChildren();
			
			swfContainer = new MovieClip();
			swfMask = new MovieClip();
			this.addChild(swfContainer);
			swfMask.graphics.beginFill(0,1);
			swfMask.graphics.drawRect(0,0,W,H);
			this.addChild(swfMask);
			swfContainer.mask = swfMask ;
		}
		
		public function setUp(pageData:PageData):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,contentLoaded);
			var loaderContex:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			loader.load(new URLRequest(pageData.content),loaderContex);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			try
			{
				loader.close();
			}
			catch(e){};
			loader.unloadAndStop();
		}
		
		protected function contentLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			swfContainer.addChild(loader.content as MovieClip);
		}
	}
}