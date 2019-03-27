package
{
	import restDoaService.RestDoaServiceCaller;
	
	public class GetComments extends RestDoaServiceCaller
	{
		public var data:* ;
		
		/***/
		public function GetComments(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('//api/PicContestApi/GetComments', data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, true);
		}
		
		public function load(FromRecord:String,LanguageBaseId:String,ObjectId:String,PageSize:String,ReferenceId:String,UserId:String):void
		{
			super.loadParam({FromRecord:FromRecord,LanguageBaseId:LanguageBaseId,ObjectId:ObjectId,PageSize:PageSize,ReferenceId:ReferenceId,UserId:UserId});
		}
	}
}