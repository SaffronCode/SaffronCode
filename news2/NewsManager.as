package news2
{
	import contents.ImageData;
	import contents.LinkData;
	import contents.PageData;
	
	import flash.events.Event;
	
	import maskan.projects.webCallers.GetBases;
	import maskan.projects.types.TBase;
	
	import news2.types.VNews;
	import news2.webCaller.GetNews;

	internal class NewsManager
	{
		public static var ImageFolderURL:String = Constants.appDomain+'/UploadImages/News/';
		
		public static var ImageThumbnailFolderURL:String = Constants.appDomain+'/UploadImages/News/thumb/';
		
		public static const imageType:String = ".jpg";
		
		
		/**ids are the BaseID for each news categorie and it has no page for. so you have to re generate the selected link to lead to PageNews*/
		public static var newsCategories:Vector.<LinkData> = new Vector.<LinkData>();
		/**This will create by newsRawList and ids are not the real page id and they are selected news id.*/
		public static var newsList:Vector.<LinkData> = new Vector.<LinkData>();
		
		/**raw loaded news. you can create page data or link data from these values*/
		private static var newsRawList:Vector.<VNews> = new Vector.<VNews>();
		
		
		public static var searchParam:String,
							newsId:String;
							
		private static var onDone:Function,onConnectionFails:Function;
							
		/**Base id is : 11*/
		private static var service_getNewsCat:GetBases = new GetBases();
		
		public static var service_loadNewsList:GetNews = new GetNews();
		
		public static function cansel():void
		{
			onDone = new Function();
			onConnectionFails = new Function();
		}
		
		public static function getNewsCat(OnDone:Function,OnConnectionFails:Function):void
		{
			onDone = OnDone ;
			onConnectionFails = OnConnectionFails ;
			
			service_getNewsCat = new GetBases();
			
			service_getNewsCat.addEventListener(Event.COMPLETE,listLoaded);
			service_getNewsCat.addEventListener(Event.CHANGE,listLoaded);
			service_getNewsCat.addEventListener(Event.UNLOAD,noInternetConnection);
			
			service_getNewsCat.load('11');
			
		}
		
		protected static function noInternetConnection(event:Event):void
		{
			// TODO Auto-generated method stub
			onConnectionFails();
		}
		
		/**News categories loaded or updated*/
		protected static function listLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			newsCategories = new Vector.<LinkData>();
			for(var i = 0 ; i<NewsManager.service_getNewsCat.data.length ; i++)
			{
				var item:TBase = NewsManager.service_getNewsCat.data[i] ;
				var catLink:LinkData = new  LinkData();
				catLink.name = item.Title ;
				catLink.id = item.BaseId ;
				
				newsCategories.push(catLink);
			}
			
			onDone();
		}
		
		
		
	/////////////////////////////////////////////Get news List
		
		/***/
		public static function getNewsList(OnDone:Function,OnConnectionFails:Function):void
		{
			onDone = OnDone ;
			onConnectionFails = OnConnectionFails ;
			
			service_loadNewsList = new GetNews();

			service_loadNewsList.addEventListener(Event.COMPLETE,newsLoaded);
			service_loadNewsList.addEventListener(Event.CHANGE,newsLoaded);
			service_loadNewsList.addEventListener(Event.UNLOAD,noInternetConnection);
			
			service_loadNewsList.load(newsId,searchParam,'','',0,100000);
		}
		
		/**news list loaded or updated*/
		private static function newsLoaded(e:Event):void
		{
			trace("**** News loaded or updated");
			newsRawList = new Vector.<VNews>();
			newsRawList = service_loadNewsList.data.concat();
			//Create news links
			newsList = new Vector.<LinkData>();
			for(var i = 0 ; i<newsRawList.length ; i++)
			{
				var newLink:LinkData = new LinkData();
				newLink.name = newsRawList[i].Title ;
				newLink.id = newsRawList[i].NewsId ;
				if(newsRawList[i].FileName1!='')
				{
					newLink.iconURL = ImageThumbnailFolderURL+newsRawList[i].FileName1+imageType ;
				}
				
				newsList.push(newLink);
			}
			
			onDone();
		}
		
	////////////////////////////////////////////
		/**This will regenerate the content for news page*/
		public static function updateThisPageForNewWithThisId(basePageData:PageData,newId:String):PageData
		{
			var foundedItemIndex:int = -1 ;
			for(var i = 0 ; i<newsRawList.length ; i++)
			{
				if(newId == newsRawList[i].NewsId)
				{
					foundedItemIndex = i ;
					break ;
				}
			}
			if(foundedItemIndex!=-1)
			{
				var item:VNews = newsRawList[foundedItemIndex];
				basePageData.title = item.NewsTypeBaseTitle+'/'+item.Title;
				
				basePageData.content = item.Context ;
				
				basePageData.images = new Vector.<ImageData>();
				var newImage:ImageData;
				newImage = createImageData(item.FileName1);
				if(newImage!=null)
					basePageData.images.push(newImage);
				newImage = createImageData(item.FileName2);
				if(newImage!=null)
					basePageData.images.push(newImage);
				newImage = createImageData(item.FileName3);
				if(newImage!=null)
					basePageData.images.push(newImage);
			}
			else
			{
				//reset basePageData
				basePageData.title = '';
				basePageData.content = '';
				basePageData.images = new Vector.<ImageData>();
			}
			return basePageData ;
		}
		
		/**Create imageData if imageName != ''*/
		private static function createImageData(imageName:String):ImageData
		{
			if(imageName=='')
			{
				return null ;
			}
			var newImage:ImageData = new ImageData();
			newImage.targURL = ImageFolderURL+imageName+imageType ;
			return newImage ;
		}
	}
}