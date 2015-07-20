package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.PageManager
{
	import appManager.event.AppEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
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
			// TODO Auto Generated method stub
			animateInternalPages = true ;
		}
		
		private var myCurrentEvent:AppEvent = new AppEvent() ;
		
		public var toEvent:AppEvent = new AppEvent() ;
		
		protected var pageContainer:PageContainer ;
		
		public function PageManager()
		{
			super();
			
			pageContainer = Obj.findThisClass(PageContainer,this,true) as PageContainer;
			
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
			// TODO Auto-generated method stub
			var animIsOver:Boolean = false;
			if(toEvent.myType == AppEvent.home || toEvent.myID!=myCurrentEvent.myID || toEvent.myType == AppEvent.refresh || toEvent.reload)
			{
				if(animateInternalPages && pageContainer.hadSelfAnim())
				{
					animIsOver = pageContainer.prev();
				}
				else
				{
					this.prevFrame() ;
					animIsOver = (this.currentFrame == 1) ;
				}
				if(animIsOver)
				{
					this.gotoAndStop(1);
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
						}
						pageContainer.setUp(myCurrentEvent);
					}
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
					this.nextFrame();
				}
			}
		}
	}
}