package
{
	import restDoaService.RestDoaServiceCaller;
	
	public class RegisterQuetion extends RestDoaServiceCaller
	{
		public var data:* ;
		
		/***/
		public function RegisterQuetion(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('/api/PicContestApi//RegisterQuetion', data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, false);
		}
		
		public function load():void
		{
			super.loadParam();
		}
	}
}