package contents.displayElements
	//contents.displayElements.ContentNameDispatcher
{
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	import contents.History;
	import contents.LinkData;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ContentNameDispatcher extends MovieClip
	{
		public static const backButtonDispatcher:String = "backButtonDispatcher";
		
		protected var defaultLevel:int = 1 ;
		
		protected var refresh:Boolean = false ;
		
		private var isInHistory:Boolean = false ;
		
		private var maxDepthToSearchOnHistory:uint = uint.MAX_VALUE ;

		protected var forceToActLikeBack:Boolean = false ;
		
		public function ContentNameDispatcher(defaultLinkLevel:Number = NaN, maxDepthToSearchOnHistory:uint = 0 )
		{
			super();
			
			if (maxDepthToSearchOnHistory > 0)
			{
				this.maxDepthToSearchOnHistory = maxDepthToSearchOnHistory ;
			}
			
			if(!isNaN(defaultLinkLevel))
			{
				defaultLevel = defaultLinkLevel ;
			}
			
			this.buttonMode = true ;
			//this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK,generateLink);
			
			if(this.totalFrames>1 && this.alpha>0)
			{
				controlHistoryAgain(null);
				if(isInHistory)
				{
					this.gotoAndStop(this.totalFrames-1);
				}
				else 
				{
					this.gotoAndStop(1);
				}
				this.addEventListener(Event.ENTER_FRAME,animate);
				History.historyDispatcher.addEventListener(Event.CHANGE,controlHistoryAgain);
			}
			else
			{
				this.stop();
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Control if the button was on history*/
		protected function controlHistoryAgain(event:Event):void
		{
			if(defaultLevel==0)
			{
				isInHistory = History.isCurrentPageNamed(this.name);
			}
			else
			{
				isInHistory = History.isHistoryContainsThePageNamed(this.name,maxDepthToSearchOnHistory);
			}
		}
		
		/**The dispatcher removed*/
		protected function unLoad(event:Event):void
		{
			History.historyDispatcher.removeEventListener(Event.CHANGE,controlHistoryAgain);
			this.removeEventListener(Event.ENTER_FRAME,animate);
		}
		
		/**Go to next frames if this page was in history*/
		protected function animate(event:Event):void
		{
			if(isInHistory)
			{
				this.nextFrame();
			}
			else
			{
				this.prevFrame();
			}
		}
		
		/***/
		protected function generateLink(e:MouseEvent)
		{
			var ev:AppEventContent ;
			if(this.name == backButtonDispatcher || forceToActLikeBack)
			{
				ev = AppEventContent.lastPage();
				trace("ev  : "+ev.myType);
			}
			else if(this.name.indexOf('instan')==-1)
			{
				var link:LinkData = new LinkData();
				//level was 0 , but it sas cause of problem on back event dispatching , there is no page at level of 0 , page
				//on level zero is main menu
				//Controll if this is a Home button, make link level to 0.
				if(this.name == Contents.homeID)
				{
					link.level = 0 ;
				}
				else
				{
					link.level = defaultLevel ;
				}
				link.id = this.name ;
				
				if(Contents.langEnabled)
				{
					var controller:String = Contents.lang.t[link.id];
					if(controller!=null)
						link.id = controller ;
				}
					
				ev = new AppEventContent(link,false,refresh);
			}
			
			if(ev!=null)
			{
				this.dispatchEvent(ev);
			}
		}
	}
}