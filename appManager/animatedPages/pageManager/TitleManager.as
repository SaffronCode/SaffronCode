package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.TitleManager
{
	import appManager.displayContentElemets.TitleText;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TitleManager extends MovieClip
	{
		public static var currentEvent:AppEvent = new AppEvent();
		
		public var toEvent:AppEvent = new AppEvent() ;
		
		//protected var pageContainer:PageContainer ;
		
		private var myTitle:TitleText ;
		
		public function TitleManager()
		{
			super();
			
			//pageContainer = Obj.findThisClass(PageContainer,this,true) as PageContainer;
			myTitle = Obj.findThisClass(TitleText,this,true) as TitleText;
			
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
			
			//Have to change like pageContainer
			if(toEvent.myType == AppEvent.home || toEvent.myID!=currentEvent.myID || toEvent.myType == AppEvent.refresh)
			{
				this.prevFrame() ;
				if(this.currentFrame == 1)
				{
					//pageContainer.setUp();
					myTitle.setUp('');
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
						if( toEvent.myType != AppEvent.refresh )
						{
							currentEvent = toEvent ;
						}
						else
						{
							toEvent = currentEvent ;
						}
						//pageContainer.setUp(currentEvent);
						if(currentEvent is AppEventContent)
						{
							myTitle.setUp((currentEvent as AppEventContent).pageData.title);
						}
						else
						{
							myTitle.setUp('');
						}
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