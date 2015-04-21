package news
{
	import contents.Contents;
	import contents.ImageData;
	import contents.LinkData;
	import contents.PageData;
	
	import flash.events.Event;
	
	import news.webCallers.GetNewsReq;
	

	public class NewsToContent
	{
		public static var pageW:Number = 1024,
						pageH:Number = 768;
		
		public static var imageW:Number = 1024/2,
							imageH:Number = 768/2;
		
		
		public static const id_newsPageId:String = "newsPageList",
							id_newsLoader:String = "newsPage_",
							id_newsPageContent:String = "newsContent";
		
		private static var 		onDone:Function,
								onNewLoaded:Function,
								onFail:Function;
		
		private static var newsListLoader:GetNewsReq = new GetNewsReq();
			
		
		public static function get newContentLink():LinkData
		{
			var newLink:LinkData = new LinkData();
			newLink.id = id_newsPageContent;
			newLink.level = 2 ;
			return newLink ;
		}
		public static function get newsListLink():LinkData
		{
			var newLink:LinkData = new LinkData();
			newLink.id = id_newsPageId;
			newLink.level = 1 ;
			return newLink ;
		}
		
		public static function generateNewsList(OnDone:Function)
		{
			onDone = OnDone ;
			newsListLoader.addEventListener(Event.COMPLETE,newsLoaded);
			newsListLoader.addEventListener(Event.UNLOAD,noInternet);
			newsListLoader.load(Contents.lang.t.LanguageBaseId);
		}
		
		protected static function newsLoaded(event:Event):void
		{
			trace("news loaded");
			// TODO Auto-generated method stub
			var newsPageData:PageData = Contents.getPage(id_newsPageId).clone();
			newsPageData.links1 = new Vector.<LinkData>();
			
			for(var i = 0 ; i<newsListLoader.data.length ; i++)
			{
				var newsLink:LinkData = new LinkData();
				newsLink.id = id_newsLoader+newsListLoader.data[i].NewsId ;
				newsLink.name = newsListLoader.data[i].Title ;
				newsLink.level = 2 ;
				var newsLoader:PageData = Contents.getPage(id_newsLoader,true).clone();
				newsLoader.id = newsLink.id ;
				
				newsPageData.links1.push(newsLink);
				Contents.addSinglePageData(newsLoader);
				
				var newsPage:PageData = Contents.getPage(id_newsPageContent,true).clone();
				newsPage.id = newsLink.id ;
				newsPage.title = newsLink.name;
				newsPage.content = newsListLoader.data[i].Context ;
				newsPage.contentW = pageW-imageW-10;
				newsPage.images.push(createImage(newsListLoader.data[i].FileName1,0));
				newsPage.images.push(createImage(newsListLoader.data[i].FileName2,1));
				newsPage.images.push(createImage(newsListLoader.data[i].FileName3,2));
				trace("news page is : "+newsPage.export());
				Contents.addSinglePageData(newsPage);
			}
			trace("news page is : "+newsPageData.export());
			Contents.addSinglePageData(newsPageData);
			
			onDone(true);
		}
		
		
		private static function createImage(imageBaseName:String,index:uint):ImageData
		{
			var imageData:ImageData = new ImageData();
			imageData.targURL = Constants.articleImageURL+imageBaseName+Constants.jpg ;
			imageData.width = imageW;
			imageData.x = pageW-imageW;
			imageData.y = imageH*index ;
			
			return imageData ;
		}
		
		protected static function noInternet(event:Event):void
		{
			trace("no internet connection");
			// TODO Auto-generated method stub
			onDone(false);
		}
		
	}
}