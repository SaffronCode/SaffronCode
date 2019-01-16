package otherPlatforms.tablighan
{
	import restDoaService.RestDoaServiceCaller;
	
	public class TablighanAPI extends RestDoaServiceCaller
	{
		public var data:Vector.<TablighanAPIRespond> = new Vector.<TablighanAPIRespond>() ;
		
		/***/
		public function TablighanAPI(offlineDataIsOK_v:Boolean=false, instantOfflineData_v:Boolean=false)
		{
			
			super('http://api.tablighon.com/api/feed_v2/GetFromApp', data, offlineDataIsOK_v, instantOfflineData_v, null, true);
			
			//http://185.83.208.175:9099/api/feed/GetFromApp
			//http://api.tablighon.com/api/feed_v2/GetFromApp?hostid=C752B970-9F21-4AC5-A75C-B78D7B3A7DF7
		}
		
		public function load(hostid:String):void
		{
			super.loadParam({hostid:hostid,Individual:true});
		}
	}
}