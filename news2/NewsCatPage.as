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
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import maskan.elements.PreLoader;
	import maskan.projects.webCallers.GetBases;
	import maskan.projects.types.TBase;
	
	public class NewsCatPage extends MovieClip implements DisplayPageInterface
	{
		private var myPageData:PageData ;
		
		private var searchMC:MovieClip,
					dynamicLink:DynamicLinks,
					searchAreaTF:TextField,
					searchBackMC:MovieClip,
					
					myPreLoader:PreLoader ;
		
		public function NewsCatPage()
		{
			super();
			
			searchBackMC = Obj.get("search_back_mc",this);
			searchBackMC.stop();
			
			dynamicLink = Obj.findThisClass(DynamicLinks,this);
			dynamicLink.addEventListener(AppEvent.PAGE_CHANGES,controllSelectedLink);
			
			searchMC = Obj.get("search_mc",this);
			searchAreaTF = Obj.get("txt_txt",this);
			searchAreaTF.text = '' ;
			
			myPreLoader = new PreLoader();
			this.addChild(myPreLoader);
			myPreLoader.x = this.width/2;
			myPreLoader.y = this.height/2;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			NewsManager.cansel();
		}
		
		protected function controllSelectedLink(ev:AppEventContent):void
		{
			// TODO Auto-generated method stub
			ev.stopImmediatePropagation();
			openNewsListLoader(ev.linkData.id,'',ev.linkData.name);
		}
		
		public function setUp(pageData:PageData):void
		{
			myPageData = pageData ;
			
			FarsiInputCorrection.setUp(searchAreaTF);
			searchMC.addEventListener(MouseEvent.CLICK,searchTheNews);
			
			startLoadTheNews();
		}
		
		private function startLoadTheNews():void
		{
			// TODO Auto Generated method stub
			/*NewsManager.service_getNewsCat = new GetBases();
			
			NewsManager.service_getNewsCat.addEventListener(Event.COMPLETE,listLoaded);
			NewsManager.service_getNewsCat.addEventListener(Event.CHANGE,listLoaded);
			NewsManager.service_getNewsCat.addEventListener(Event.UNLOAD,noInternetConnection);*/
			
			NewsManager.getNewsCat(listLoaded,noInternetConnection);//service_getNewsCat.load('11');
		}
		
		protected function noInternetConnection():void
		{
			Hints.noInternet();
		}
		
		/**Categories loaded*/
		protected function listLoaded():void
		{
			myPreLoader.visible = false ;
			dynamicLink.visible = true ;
			
			var linksPageData:PageData = new PageData();
			linksPageData.links1 = NewsManager.newsCategories ;
			
			dynamicLink.setUp(linksPageData);
		}
		
		protected function searchTheNews(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(searchAreaTF.text == '')
			{
				trace("Nothing to search");
			}
			else
			{
				openNewsListLoader('',searchAreaTF.text);
			}
		}
		
		private function openNewsListLoader(newsID:String='',searchParam:String='',title:String=''):void
		{
			if(newsID=='')
			{
				newsID = '0';
			}
			// TODO Auto Generated method stub
			NewsManager.searchParam = searchParam ;
			NewsManager.newsId = newsID ;
			
			var newsLink:LinkData = myPageData.links2[0].clone() ;
			var newsListPage:PageData = Contents.getPage(newsLink.id);
			if(title!='')
			{
				newsListPage.title = title ;
			}
			else
			{
				//This link data name has to be Jostejo allways.
				newsListPage.title = newsLink.name+'('+searchParam+')' ;
			}
			Contents.addSinglePageData(newsListPage);
			
			trace("Open this page : "+newsLink.export());
			
			this.dispatchEvent(new AppEventContent(newsLink));
		}
	}
}