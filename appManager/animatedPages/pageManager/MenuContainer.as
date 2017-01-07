package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.MenuContainer
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.event.MenuEvent;
	import appManager.event.PageControllEvent;
	import appManager.mains.App;
	import appManager.mains.AppWithContent;
	
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.system.System;

	public class MenuContainer extends MovieClip
	{
		private var currentMenu:MovieClip,
					middleFrame:uint,
					finishFrame:uint;
		
		private var pageReadyDispatched:Boolean ;
		
		private var scrollerMC:ScrollMT ;
		
		/**Controll this variable befor fadeIn the menu*/
		internal var thisPageHasMenu:Boolean ;
		
		public function MenuContainer()
		{
			super();
			stop();
		}
		
		
		public function setUp(myEvent:AppEvent=null)
		{
			if(currentMenu != null)
			{
				trace("delete current page");
				this.removeChild(currentMenu);
				if(scrollerMC)
				{
					scrollerMC.unLoad();
					scrollerMC = null ;
				}
				currentMenu = null ;
				middleFrame = 0 ;
				finishFrame = 0 ;
				System.gc();
				System.gc();
				
				this.dispatchEvent(new MenuEvent(MenuEvent.MENU_DELETED,null,true));
			}
			if(myEvent == null)
			{
				return ;
			}
			var currentPageData:PageData = (myEvent as AppEventContent).pageData ;
			var pageClassType:Class ;
			pageClassType = Obj.generateClass(currentPageData.menuType);
			
			trace("Menu type : "+currentPageData.menuType+' >>>>> '+pageClassType);
			
			
			if(pageClassType != null)
			{
				try
				{
					currentMenu = new pageClassType();
					pageReadyDispatched = false ;
					var framesList:Array = currentMenu.currentLabels;
					if(framesList.length > 0)
					{
						middleFrame = (framesList[0] as FrameLabel).frame ;
					}
					else if(currentMenu.totalFrames>1)
					{
						middleFrame = currentMenu.totalFrames ;
					}
					finishFrame = currentMenu.totalFrames ;
					thisPageHasMenu = true ;
				}
				catch(e)
				{
					trace("Page is not generated : "+e);
					thisPageHasMenu = false ;
					return;
				}
				trace("*** currentPage added to stage");
				this.addChild(currentMenu);
				
				/*if(currentPageData.scrollAble)
				{
					var targetArea:Rectangle ;
					var autoSizeDetector:Boolean = true ;
					if(currentPageData.scrollWidth!=0 && currentPageData.scrollHeight!=0)
					{
						targetArea = new Rectangle(0,0,currentPageData.scrollWidth,currentPageData.scrollHeight);
						autoSizeDetector = false ;
					}
					
					//auto size detector on horizontal >< position had bug, if you set it true, the scroll will lock anyway
					scrollerMC = new ScrollMT(currentMenu,AppWithContent.contentRect,targetArea,autoSizeDetector,false,currentPageData.scrollEffect,false);
				}*/
				
				if(myEvent is AppEventContent)
				{
					if(currentMenu.hasOwnProperty('setUp'))
					{
						trace("This menu can get values");
						(currentMenu as DisplayPageInterface).setUp(currentPageData);
					}
					else
					{
						trace("Static menu calls");
					}
				}
				else
				{
					trace("static application menu");
				}
				
				this.dispatchEvent(new MenuEvent(MenuEvent.MENU_READY,currentMenu,true));
			}
			else
			{
				thisPageHasMenu = false ;
			}
		}
		
		/**returns true if current MovieClip had its own animation*/
		public function hadSelfAnim():Boolean
		{
			return middleFrame!=0;
		}
		
		/**returns true if the animation is over*/
		public function next():Boolean
		{
			if(currentMenu)
			{
				if(App.skipAnimations)
				{
					currentMenu.gotoAndStop(middleFrame);
				}
				if(currentMenu.currentFrame<middleFrame)
				{
					currentMenu.nextFrame();
					return false;
				}
				else if(currentMenu.currentFrame>middleFrame)
				{
					currentMenu.prevFrame();
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
			if(currentMenu)
			{
				if(middleFrame<finishFrame)
				{
					if(App.skipAnimations)
					{
						currentMenu.gotoAndStop(finishFrame);
					}
					if(currentMenu.currentFrame<finishFrame)
					{
						currentMenu.nextFrame();
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
						currentMenu.gotoAndStop(1);
					}
					if(currentMenu.currentFrame>1)
					{
						currentMenu.prevFrame();
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
			if(currentMenu)
			{
				return currentMenu.totalFrames;
			}
			else
			{
				return super.totalFrames;
			}
		}
		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			if(currentMenu)
			{
				currentMenu.gotoAndStop(frame);
			}
			else
			{
				super.gotoAndStop(frame,scene);
			}
		}
		
		public function dispatchPageReadyEventOnceForPage():void
		{
			
			if(currentMenu!=null && !pageReadyDispatched)
			{
				pageReadyDispatched = true ;
				trace("Dispatch page ready event");
				currentMenu.dispatchEvent(new PageControllEvent(PageControllEvent.PAGE_ANIMATION_READY));
			}
		}
	}
}
