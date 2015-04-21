package news.webCallers
{
	import webService.types.WebServiceParser;
	import webService.webCallers.WebServiceCaller;
	
	import news.types.GetNews;
	
	public class GetNewsReq extends WebServiceCaller
	{
		public var data:Vector.<GetNews>;
		
		public function GetNewsReq( offlineDataIsOK_v:Boolean=true, justLoadOfline_v:Boolean=false)
		{
			super("GetNews", offlineDataIsOK_v, justLoadOfline_v);
		}
		
		/**	NewsId:
			Title:
			NewsTypeBaseId:
			Hashtags:
			Context:
			LanguageBaseId:
			FromRec:
			PageSize: */
		public function load(LanguageBaseId:String='1',
							 NewsId:String='0',
							 Title:String = '',
							 NewsTypeBaseId:String='0',
							 Hashtags:String='',
							 Context:String='',
							 FromRec:String='0',
							 PageSize:String='20000')
		{
			super.loadParams(NewsId,Title,NewsTypeBaseId,Hashtags,Context,LanguageBaseId,FromRec,PageSize);
		}
		
		override protected function manageData(pureData:String):Boolean
		{
			trace("ArGetNewsticle loaded : "+pureData) ;
			var cash:Array = WebServiceParser.pars(pureData,GetNews) ;
			data = new Vector.<GetNews>() ;
			for(var i = 0 ; i<cash.length ; i++)
			{
				data.push(cash[i]);
			}
			trace("news : "+data.length);
			return true ;
		}
	}
}