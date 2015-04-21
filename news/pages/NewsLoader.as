package news.pages
	//news.pages.NewsLoader
{
	import appManager.event.AppEventContent;
	
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import news.NewsToContent;
	
	public class NewsLoader extends MovieClip implements DisplayPageInterface
	{
		private var preLoaderMC:MovieClip,
					noInternetMC:MovieClip;
		
		public function NewsLoader()
		{
			super();
			
			preLoaderMC = Obj.get("preLoader_mc",this);
			noInternetMC = Obj.get("no_internet_mc",this);
		}
		
		public function setUp(pageData:PageData):void
		{
			noInternetMC.visible = false ;
			preLoaderMC.visible = true ;
			NewsToContent.generateNewsList(onNewsListLoaded)
		}
		
		private function onNewsListLoaded(stat:Boolean = true)
		{
			if(stat)
			{
				trace("open news list page");
				this.dispatchEvent(new AppEventContent(NewsToContent.newsListLink))
			}
			else
			{
				noInternet();
			}
		}
		
		
		/*private function onNewsLoaded()
		{
			trace("NewsToContent.newContentLink : "+NewsToContent.newContentLink.id);
			this.dispatchEvent(new AppEventContent(NewsToContent.newContentLink))
		}*/
		
		private function noInternet()
		{
			noInternetMC.visible =true ;
			preLoaderMC.visible = false ;
		}
	}
}