package appManager.animatedPages.pageManager
	//appManager.animatedPages.pageManager.PageContainer
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.system.System;
	
	public class PageContainer extends MovieClip
	{
		private var currentPage:MovieClip,
					middleFrame:uint,
					finishFrame:uint;
		
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
				middleFrame = 0 ;
				finishFrame = 0 ;
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
				}
				catch(e)
				{
					trace("Page is not generated : "+e);
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
	}
}