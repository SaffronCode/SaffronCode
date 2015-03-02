package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.PageContainer
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.system.System;
	
	public class PageContainer extends MovieClip
	{
		private var currentPage:MovieClip ;
		
		public function PageContainer()
		{
			super();
			stop();
		}
		
		public function setUp(myEvent:AppEvent=null)
		{
			if(currentPage != null)
			{
				trace("delete current page");
				this.removeChild(currentPage);
				currentPage = null ;
				System.gc();
				System.gc();
			}
			if(myEvent == null)
			{
				return ;
			}
			var pageClassType:Class ;
			pageClassType = Obj.generateClass(myEvent.myType);
			
			trace("myEvent.myType : "+myEvent.myType);
			
			
			if(pageClassType != null)
			{
				try
				{
					currentPage = new pageClassType();
				}
				catch(e)
				{
					trace("Page is not generated");
					return;
				}
				trace("*** currentPage added to stage");
				this.addChild(currentPage);
				
				if(myEvent is AppEventContent)
				{
					if(currentPage.hasOwnProperty('setUp'))
					{
						trace("This page can get values");
						(currentPage as DisplayPageInterface).setUp((myEvent as AppEventContent).pageData);
					}
					else
					{
						trace("Static page calls");
					}
				}
				else
				{
					trace("static application page");
				}
			}
		}
	}
}