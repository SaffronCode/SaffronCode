package otherPlatforms.tablighan
{
	import restDoaService.RestDoaServiceCaller;
	
	public class TablighanAPI extends RestDoaServiceCaller
	{
		public var data:Vector.<TablighanAPIRespond> = new Vector.<TablighanAPIRespond>() ;
		
		/***/
		public function TablighanAPI(offlineDataIsOK_v:Boolean=false, instantOfflineData_v:Boolean=false)
		{
			super('http://185.83.208.175:9099/api/feed/GetFromApp', data, offlineDataIsOK_v, instantOfflineData_v, null, true);
		}
		
		public function load(hostid:String):void
		{
			super.loadParam({hostid:hostid});
		}
	}
}