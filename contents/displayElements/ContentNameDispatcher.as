package contents.displayElements
	//contents.displayElements.ContentNameDispatcher
{
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	import contents.LinkData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ContentNameDispatcher extends MovieClip
	{
		public static const backButtonDispatcher:String = "backButtonDispatcher";
		
		public function ContentNameDispatcher()
		{
			super();
			
			this.buttonMode = true ;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK,generateLink);
		}
		
		/***/
		private function generateLink(e:MouseEvent)
		{
			var ev:AppEventContent ;
			if(this.name == backButtonDispatcher)
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
					link.level = 1 ;
				}
				link.id = this.name ;
					
				ev = new AppEventContent(link,false);
			}
			
			if(ev!=null)
			{
				this.dispatchEvent(ev);
			}
		}
	}
}