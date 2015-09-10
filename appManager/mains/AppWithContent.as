package appManager.mains
{
	import appManager.animatedPages.pageManager.PageManager;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	import contents.ContentsEvent;
	import contents.History;
	import contents.PageData;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import stageManager.StageManager;
	
	public class AppWithContent extends App
	{
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		private static var _contentRect:Rectangle = new Rectangle() ;
		
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		public static function get contentRect():Rectangle
		{
			var contentResizedRect:Rectangle = _contentRect.clone();
			contentResizedRect.height+=StageManager.stageDelta.height ;
			contentResizedRect.width+=StageManager.stageDelta.width ;
			trace("StageManager.stageDelta.height : "+StageManager.stageDelta.height);
			trace("_contentRect : "+_contentRect+" vs "+contentResizedRect);
			return contentResizedRect.clone();
		}
		
		/**AutoLanguageConvertion will enabled just when supportsMutilanguage was true*/
		public function AppWithContent(supportsMultiLanguage:Boolean=false,autoLanguageConvertEnabled:Boolean=true,animagePageContents:Boolean=false,autoChangeMusics:Boolean=false)
		{
			super(autoChangeMusics);
			
			if(animagePageContents)
			{
				PageManager.activatePageAnimation();
			}
			
			stopIntro();
			//Multilanguage support added to current version.
			Contents.setUp(startApp,supportsMultiLanguage,autoLanguageConvertEnabled,this.stage);
			
			//Create the contentPage rectangle by contentW and contentH values on homePage data to use on scrolled pages
			var homePageData:PageData = Contents.homePage ;
			if(isNaN(homePageData.contentW))
			{
				homePageData.contentW = stage.stageWidth ;
			}
			if(isNaN(homePageData.contentH))
			{
				homePageData.contentH = stage.stageHeight ;
			}
			_contentRect = new Rectangle(0,0,homePageData.contentW,homePageData.contentH);
			trace("Content page rectangle is ( You can change this value by adding w and h attributes to the home.content value on data.xml : "+_contentRect);
		}
		
		protected function activateStageManager(debugWidth:Number=0,debugHeight:Number=0,listenToStageRotation:Boolean=true):void
		{
			StageManager.setUp(stage,debugWidth,debugHeight,listenToStageRotation);
		}
		
		override protected function managePages(event:AppEvent):Boolean
		{
			if(event is AppEventContent)
			{
				var event2:AppEventContent = event as AppEventContent ;
				if(!event2.SkipHistory)
				{
					History.pushHistory((event as AppEventContent).linkData);
				}
			}
			return super.managePages(event);
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
		}
	}
}