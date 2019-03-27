package
{
	import restDoaService.RestDoaServiceCaller;
	
	public class UpdateUserPhoto extends RestDoaServiceCaller
	{
		public var data:* ;
		
		/***/
		public function UpdateUserPhoto(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('/api/PicContestApi/UpdateUserPhoto', data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, false);
		}
		
		public function load(UserId:String,UserPhoto:String):void
		{
			super.loadParam({UserId:UserId,UserPhoto:UserPhoto});
		}
	}
}