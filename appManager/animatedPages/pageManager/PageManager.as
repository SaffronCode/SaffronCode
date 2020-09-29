package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.PageManager
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	import appManager.mains.App;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class PageManager extends MovieClip
	{
		/*public static function get currentEvent():AppEvent
		{
			return myCurrentEvent;
		}*/
		/**External pages will anitmate themselves*/
		internal static var animateInternalPages:Boolean = false ;
		
		public static function activatePageAnimation():void
		{
			
			animateInternalPages = true ;
		}
		
		private var myCurrentEvent:AppEvent = new AppEvent() ;
		
		public var toEvent:AppEvent = new AppEvent() ;
		
		protected var pageContainer:PageContainer ;
		/**This flag prevents page to set up twice*/
		private var waitingToLoad:Boolean = false ;
		
		public function PageManager()
		{
			super();
			
			pageContainer = Obj.findThisClass(PageContainer,this,true) as PageContainer;
			if(pageContainer==null)
			{
				throw "You have to add appManager.animatedPages.pageManager.PageContainer in the PageManager movieClip";
			}
			
			this.stop();
			//this.visible = false;
			
			this.addEventListener(Event.ENTER_FRAME,anim);
		}
		
		/**change the page event*/
		public function setUp(newEvent:AppEvent)
		{
			toEvent = newEvent ;
		}
		
		protected function anim(event:Event):void
		{
			
			var animIsOver:Boolean = false;
			if(toEvent.myType == AppEvent.home || toEvent.myID!=myCurrentEvent.myID || toEvent.myType == AppEvent.refresh || toEvent.reload)
			{
				if(animateInternalPages && pageContainer.hadSelfAnim())
				{
					animIsOver = pageContainer.prev();
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
				if(animIsOver && !waitingToLoad)
				{
					this.gotoAndStop(1);
					waitingToLoad = true ;
					setTimeout(setUpThePageContainer,20);
				}
				
			}
			else 
			{
				//this.visible = true ;
				if(animateInternalPages && pageContainer.hadSelfAnim())
				{
					this.gotoAndStop(this.totalFrames);
					animIsOver = pageContainer.next();
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
					pageContainer.dispatchPageReadyEventOnceForPage();
				}
			}
		}
		
		private function setUpThePageContainer():void
		{
			pageContainer.setUp();
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
					if(myCurrentEvent is AppEventContent)
						(myCurrentEvent as AppEventContent).updateMyPageData();
				}
				pageContainer.setUp(myCurrentEvent);
			}
			waitingToLoad = false ;
		}
		
		public function activateSwapBack():void
		{
			pageContainer.activateSwapBack();
		}
	}
}