package news2.webCaller
{
	import news2.types.VNews;
	
	import webService.types.WebServiceParser;
	import webService.webCallers.WebServiceCaller;
	
	public class GetNews extends WebServiceCaller
	{
		public var data:Vector.<VNews>;
		
		public function GetNews(offlineDataIsOK_v:Boolean=true, justLoadOfline_v:Boolean=true)
		{
			var maximomOfflineData:Date = new Date();
			maximomOfflineData.minutes--;
			super("GetNews", offlineDataIsOK_v, justLoadOfline_v, maximomOfflineData);
		}
		
		
		public function load(NewsTypeBaseId='0',Title='',Hashtags='',Context='',FromRecord='0',PageSize='1')
		{
			super.loadParams(Title,NewsTypeBaseId,Hashtags,Context,FromRecord,PageSize);
		}
		
		override protected function manageData(pureData:String):Boolean
		{
			data = new Vector.<VNews>();
			var cahsedData:Array = WebServiceParser.pars(pureData,VNews);
			for(var i = 0 ; i<cahsedData.length ; i++)
			{
				data.push(cahsedData[i]);
			}
			//trace("Receved date is : "+JSON.stringify(data));
			return true;
		}
	}
}