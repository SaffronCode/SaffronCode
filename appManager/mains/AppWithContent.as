package appManager.mains
{
	import appManager.animatedPages.pageManager.PageManager;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.event.PageControllEvent;
	
	import contents.Contents;
	import contents.ContentsEvent;
	import contents.History;
	import contents.PageData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import sliderMenu.SliderManager;
	
	import stageManager.StageManager;
	
	public class AppWithContent extends App
	{
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		private static var _contentRect:Rectangle = new Rectangle() ;
		
		private static var ME:AppWithContent ;
		
		/**Preventor variables*/
		private var preventorFunction:Function,
					preventorPage:DisplayObject,
					preventedEvent:AppEvent,
					prventedPageWasLastPage:Boolean;
		
		/**This is the contentManager rectangle size. it will generate from the content w and h on the home xml tag*/
		public static function get contentRect():Rectangle
		{
			trace("AppWithContent.contentRect() >> Expired and moved to Config class");
			
			var contentResizedRect:Rectangle = _contentRect.clone();
			contentResizedRect.height+=StageManager.stageDelta.height ;
			contentResizedRect.width+=StageManager.stageDelta.width ;
			trace("StageManager.stageDelta.height : "+StageManager.stageDelta.height);
			trace("_contentRect : "+_contentRect+" vs "+contentResizedRect);
			return contentResizedRect.clone();
		}
		
		/**AutoLanguageConvertion will enabled just when supportsMutilanguage was true*/
		public function AppWithContent(supportsMultiLanguage:Boolean=false,autoLanguageConvertEnabled:Boolean=true,animagePageContents:Boolean=false,autoChangeMusics:Boolean=false,skipAllAnimations:Boolean=false,manageStageManager:Boolean=false,loadConfig:Boolean=false)
		{
			super(autoChangeMusics,skipAllAnimations);
			
			ME = this ;
			
			if(animagePageContents)
			{
				PageManager.activatePageAnimation();
			}
			
			stopIntro();
			//Multilanguage support added to current version.
			Contents.setUp(startApp,supportsMultiLanguage,autoLanguageConvertEnabled,this.stage,loadConfig);
			
			
			
			if(manageStageManager)
			{
				trace("Contents.config.debugStageHeight : "+Contents.config.debugStageHeight);
				StageManager.setUp(stage,Contents.config.debugStageWidth,Contents.config.debugStageHeight);
				Contents.config.stageOrgRect = StageManager.stageOldRect ;
				Contents.config.stageRect = StageManager.stageRect ;
				trace("**** : "+StageManager.stageRect);
			}
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
			
			this.addEventListener(PageControllEvent.PREVENT_PAGE_CHANGING,preventPageChanging);
			this.addEventListener(PageControllEvent.LET_PAGE_CHANGE,letThePreventedAppEventRelease);
			
			if(skipAllAnimations || Contents.config.skipAnimations)
			{
				skipIntro();
				skipAnimations = true ;
			}
		}
		
		
		/**Permition from the pages released*/
		protected function letThePreventedAppEventRelease(event:PageControllEvent):void
		{
			// TODO Auto-generated method stub
			preventorFunction = null ;
			preventorPage = null ;
			var preventedEventCash:AppEvent = preventedEvent ;
			preventedEvent = null ;
			if(prventedPageWasLastPage)
			{
				History.lastPage();
			}
			prventedPageWasLastPage = false ;
			
			if(preventedEventCash!=null)
			{
				trace("Prevented page event is released");
				managePages(preventedEventCash);
			}
			else
			{
				trace("No AppEvent was prevented to be release");
			}
		}
		
		/**Preventor set*/
		protected function preventPageChanging(event:PageControllEvent):void
		{
			// TODO Auto-generated method stub
			trace("Permition sat");
			preventorFunction = event.permitionReceiver ;
			preventorPage = event.preventerPage ;
		}
		
		
		/**Returns true if App need permition to change its page*/
		private function haveToGetPermition(event:AppEvent):Boolean
		{
			preventedEvent = event ;
			if(permitionRequiredToChangePage())
			{
				trace("The page changing needs a permition");
				if(preventorFunction.length>0)
				{
					preventorFunction(preventedEvent);
				}
				else
				{
					preventorFunction();
				}
				return true ;
			}
			//trace("No permition needed : "+preventorFunction+' , '+preventorPage+' , '+preventorPage.stage)
			preventorFunction = null ;
			preventorPage = null ;
			preventedEvent = null ;
			prventedPageWasLastPage = false ;
			return false ;
		}
		
		/**Returns true if you have to get permition to change the page*/
		public static function permitionRequiredToChangePage():Boolean
		{
			return ME.preventorFunction!=null && ME.preventorPage!=null && ME.preventorPage.stage !=null ;
		}
		
		protected function activateStageManager(debugWidth:Number=0,debugHeight:Number=0,listenToStageRotation:Boolean=true):void
		{
			StageManager.setUp(stage,debugWidth,debugHeight,listenToStageRotation);
		}
		
		override protected function managePages(event:AppEvent):Boolean
		{
			SliderManager.hide();
			if(haveToGetPermition(event))
			{
				prventedPageWasLastPage = History.undoLastPageHisotry();
				return false;
			}
			if(event is AppEventContent)
			{
				var event2:AppEventContent = event as AppEventContent ;
				if(!event2.SkipHistory)
				{
					trace("History changed");
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