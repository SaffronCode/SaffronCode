package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.PageManager
{
	import appManager.event.AppEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PageManager extends MovieClip
	{
		public var currentEvent:AppEvent = new AppEvent();
		
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
			if(toEvent.myType == AppEvent.home || toEvent.myID!=currentEvent.myID)
			{
				this.prevFrame() ;
				if(this.currentFrame == 1)
				{
					pageContainer.setUp();
					if(toEvent.myType == AppEvent.home)
					{
						//this.visible = false ;
						if(currentEvent != toEvent )
						{
							currentEvent = toEvent;
						}
					}
					else
					{
						currentEvent = toEvent ;
						pageContainer.setUp(currentEvent);
					}
				}
				
			}
			else 
			{
				//this.visible = true ;
				this.nextFrame();
			}
		}
	}
}