package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.MenuManager
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.event.MenuEvent;
	import appManager.mains.App;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MenuManager extends MovieClip
	{
		/**External pages will anitmate themselves*/
		internal static var animateInternalPages:Boolean = false ;
		
		public static function activatePageAnimation():void
		{
			
			animateInternalPages = true ;
		}
		
		private var myCurrentEvent:AppEventContent = new AppEventContent(null) ;
		
		public var toEvent:AppEventContent = new AppEventContent(null) ;
		
		protected var menuContainer:MenuContainer ;
		
		public function MenuManager()
		{
			super();
			
			menuContainer = Obj.findThisClass(MenuContainer,this,true) as MenuContainer;
			this.stop();
			this.addEventListener(Event.ENTER_FRAME,anim);
		}
		
		
		/**change the page event*/
		public function setUp(newEvent:AppEventContent):void
		{
			toEvent = newEvent ;
			if(toEvent==null)
			{
				toEvent = new AppEventContent(null);
			}
			anim(null);
		}
		
		protected function anim(event:Event):void
		{
			
			var animIsOver:Boolean = false;
			if(/*toEvent.myType == AppEvent.home || */toEvent.pageData.menuType!=myCurrentEvent.pageData.menuType /*|| toEvent.myType == AppEvent.refresh || toEvent.reload*/)
			{
				this.dispatchEvent(new MenuEvent(MenuEvent.MENU_DELETED,null,true));
				
				if(animateInternalPages && menuContainer.hadSelfAnim())
				{
					animIsOver = menuContainer.prev();
				}
				else
				{
					if(App.skipAnimations)
					{
						this.gotoAndStop(1);
					}
					this.prevFrame() ;
					animIsOver = (this.currentFrame == 1) ;
				}
				if(animIsOver)
				{
					this.gotoAndStop(1);
					menuContainer.setUp();
					toEvent.reload = false ;
					if(toEvent.myType == AppEvent.home)
					{
						//this.visible = false ;
						if( myCurrentEvent != toEvent  )
						{
							myCurrentEvent = toEvent ;
						}
					}
					else
					{
						if( toEvent.myType != AppEvent.refresh )
						{
							myCurrentEvent = toEvent ;
						}
						else
						{
							toEvent = myCurrentEvent ;
						}
						menuContainer.setUp(myCurrentEvent);
					}
				}
			}
			else if(menuContainer.thisPageHasMenu)
			{
				//this.visible = true ;
				if(animateInternalPages && menuContainer.hadSelfAnim())
				{
					this.gotoAndStop(this.totalFrames);
					animIsOver = menuContainer.next();
				}
				else
				{
					if(App.skipAnimations)
					{
						this.gotoAndStop(this.totalFrames);
					}
					this.nextFrame();
					animIsOver = (this.currentFrame == this.totalFrames)
				}
				
				if(animIsOver)
				{
					menuContainer.dispatchPageReadyEventOnceForPage();
				}
			}
		}
	}
}	