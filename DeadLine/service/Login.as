package
{
	import restDoaService.RestDoaServiceCaller;
	
	public class Login extends RestDoaServiceCaller
	{
		public var data:* ;
		
		/***/
		public function Login(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('/api/PicContestApi/Login', data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, true);
		}
		
		public function load(Password:String,UserName:String):void
		{
			super.loadParam({Password:Password,UserName:UserName});
		}
	}
}