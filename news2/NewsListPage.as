package news2
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	import contents.LinkData;
	import contents.PageData;
	import contents.displayPages.DynamicLinks;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import maskan.elements.PreLoader;
	
	public class NewsListPage extends MovieClip implements DisplayPageInterface
	{
		private var myPageData:PageData ,
					nextPageLink:LinkData ;
		
		private var dynamicLinks:DynamicLinks,
					myPreLoader:PreLoader ;
		
		public function NewsListPage()
		{
			super();
			
			myPreLoader = new PreLoader() ;
			myPreLoader.x = this.width/2 ;
			myPreLoader.y = this.height/2 ;
			this.addChild(myPreLoader);
			
			dynamicLinks = Obj.findThisClass(DynamicLinks,this);
			dynamicLinks.addEventListener(AppEvent.PAGE_CHANGES,controllSelectedLink);
		}
		
		protected function controllSelectedLink(ev:AppEventContent):void
		{
			// TODO Auto-generated method stub
			ev.stopImmediatePropagation();
			
			var newsContentPage:PageData = Contents.getPage(nextPageLink.id);
			newsContentPage = NewsManager.updateThisPageForNewWithThisId(newsContentPage,ev.linkData.id);
			Contents.addSinglePageData(newsContentPage);
			
			this.dispatchEvent(new AppEventContent(nextPageLink));
		}
		
		public function setUp(pageData:PageData):void
		{
			myPageData = pageData ;
			nextPageLink = myPageData.links2[0].clone();
			
			NewsManager.getNewsList(onNewsListLoaded,noInternetConnection)
		}
		
		private function onNewsListLoaded():void
		{
			var linksPageList:PageData = new PageData();
			linksPageList.links1 = NewsManager.newsList ;
			if(NewsManager.newsList.length>0)
			{
				myPreLoader.visible = false ;
				dynamicLinks.visible = true ;
				dynamicLinks.setUp(linksPageList);
			}
			else
			{
				Hints.hint(Contents.lang.t.no_news_here,myPageData.title);
				this.dispatchEvent(AppEventContent.lastPage());
			}
		}
		
		private function noInternetConnection():void
		{
			trace("Connection fails on newsListPage");
			this.dispatchEvent(AppEventContent.lastPage());
			Hints.noInternet();
		}
	}
}