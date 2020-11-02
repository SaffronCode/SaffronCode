package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.PageContainer
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.event.MenuEvent;
	import appManager.event.PageControllEvent;
	import appManager.mains.App;
	import appManager.mains.AppWithContent;
	
	import contents.Contents;
	import contents.History;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	
	import popForm.PopMenu;
	
	import sliderMenu.SliderManager;
	
	public class PageContainer extends MovieClip
	{
		private var currentPage:MovieClip,
					middleFrame:uint,
					finishFrame:uint;
					
		private var pageReadyDispatched:Boolean ;
					
		private var scrollerMC:ScrollMT ;
		
		public function PageContainer()
		{
			super();
			stop();
		}
		
		public function setUp(myEvent:AppEvent=null)
		{
			if(currentPage != null)
			{
				SaffronLogger.log("delete current page");
				this.removeChild(currentPage);
				if(scrollerMC)
				{
					scrollerMC.unLoad();
					scrollerMC = null ;
				}
				currentPage = null ;
				middleFrame = 0 ;
				finishFrame = 0 ;
				System.gc();
				//System.gc();
				(this.root).removeEventListener(MenuEvent.MENU_READY,menuIsReady);
			}
			if(myEvent == null)
			{
				return ;
			}
			var currentPageData:PageData = (myEvent as AppEventContent).pageData ;
			var pageClassType:Class ;
			pageClassType = Obj.generateClass(myEvent.myType);
			
			SaffronLogger.log("myEvent.myType : "+myEvent.myType);
			
			
			if(pageClassType != null)
			{
				/*try
				{*/
					currentPage = new pageClassType();
					pageReadyDispatched = false ;
					var framesList:Array = currentPage.currentLabels;
					if(framesList.length > 0)
					{
						middleFrame = (framesList[0] as FrameLabel).frame ;
					}
					else if(currentPage.totalFrames>1)
					{
						middleFrame = currentPage.totalFrames ;
					}
					finishFrame = currentPage.totalFrames ;
				/*}
				catch(e)
				{
					SaffronLogger.log("Page is not generated : "+e);
					return;
				}*/
				SaffronLogger.log("*** currentPage added to stage");
				this.addChild(currentPage);
				
				if(currentPageData.scrollAble)
				{
					var targetArea:Rectangle ;
					var autoSizeDetector:Boolean = true ;
					if(currentPageData.scrollWidth!=0 && currentPageData.scrollHeight!=0)
					{
						targetArea = new Rectangle(0,0,currentPageData.scrollWidth,currentPageData.scrollHeight);
						autoSizeDetector = false ;
					}
					
					//auto size detector on horizontal >< position had bug, if you set it true, the scroll will lock anyway
					scrollerMC = new ScrollMT(currentPage,Contents.config.pageRectXY0,targetArea,autoSizeDetector,false/*autoSizeDetector*/,currentPageData.scrollEffect,false);
				}
				
				if(myEvent is AppEventContent)
				{
					if(currentPage.hasOwnProperty('setUp'))
					{
						SaffronLogger.log("This page can get values");
						try
						{
							(currentPage as DisplayPageInterface).setUp(currentPageData);
						}
						catch(e:Error)
						{
							if(DevicePrefrence.isDebuggingMode())
							{
								throw e;
							}
							else
							{
								var errorText:String = "**********************************************\n\n\n\n\n\n\n\nError happens :\n"+e.message+'\n'+e.getStackTrace()+"\n\n\n\n\n\n\n\n********************************************" ;
								SaffronLogger.log(errorText);
								if(!SaffronLogger.traceIsActive())
									trace(errorText);
							}
						}
					}
					else
					{
						SaffronLogger.log("Static page calls");
					}
				}
				else
				{
					SaffronLogger.log("static application page");
				}
				
				if(App.currentMenu!=null)
				{
					currentPage.dispatchEvent(new MenuEvent(MenuEvent.MENU_READY,App.currentMenu));
				}
				else
				{
					(this.root).addEventListener(MenuEvent.MENU_READY,menuIsReady);
				}
			}
		}
		
		protected function menuIsReady(event:Event):void
		{
			
			currentPage.dispatchEvent(new MenuEvent(MenuEvent.MENU_READY,App.currentMenu));
		}
		
		/**returns true if current MovieClip had its own animation*/
		public function hadSelfAnim():Boolean
		{
			return middleFrame!=0;
		}
		
		/**returns true if the animation is over*/
		public function next():Boolean
		{
			if(currentPage)
			{
				if(App.skipAnimations)
				{
					currentPage.gotoAndStop(middleFrame);
				}
				if(currentPage.currentFrame<middleFrame)
				{
					currentPage.nextFrame();
					return false;
				}
				else if(currentPage.currentFrame>middleFrame)
				{
					currentPage.prevFrame();
					return false ;
				}
				else
				{
					return true ;
				}
			}
			return true ;
		}
		
		/**returns true if the animation is over*/
		public function prev():Boolean
		{
			if(currentPage)
			{
				if(middleFrame<finishFrame)
				{
					if(App.skipAnimations)
					{
						currentPage.gotoAndStop(finishFrame);
					}
					if(currentPage.currentFrame<finishFrame)
					{
						currentPage.nextFrame();
						return false ;
					}
					else
					{
						return true ;
					}
				}
				else
				{
					if(App.skipAnimations)
					{
						currentPage.gotoAndStop(1);
					}
					if(currentPage.currentFrame>1)
					{
						currentPage.prevFrame();
						return false ;
					}
					else
					{
						return true ;
					}
				}
			}
			return true;
		}
		
		
		override public function get totalFrames():int
		{
			if(currentPage)
			{
				return currentPage.totalFrames;
			}
			else
			{
				return super.totalFrames;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			if(currentPage)
			{
				currentPage.gotoAndStop(frame);
			}
			else
			{
				super.gotoAndStop(frame,scene);
			}
		}
		
		public function dispatchPageReadyEventOnceForPage():void
		{
			
			if(currentPage!=null && !pageReadyDispatched)
			{
				pageReadyDispatched = true ;
				SaffronLogger.log("Dispatch page ready event");
				currentPage.dispatchEvent(new PageControllEvent(PageControllEvent.PAGE_ANIMATION_READY));
			}
		}
		
		public function activateSwapBack():void
		{
			MouseDrag.setUp(stage);
			MouseDrag.addFunctions(new Function(),backEvent,Contents.config.pageRect);
		}
		
		private function backEvent():void
		{
			if(History.backAvailable() && !SliderManager.isOpen() && !PopMenu.isOpen)
			{
				this.dispatchEvent(History.lastPage());
			}
		}
		
	}
}