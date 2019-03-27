package DeadLine.service
{
	import DeadLine.types.GetUserRegDateRespond;
	
	import flash.net.URLRequestHeader;
	
	import restDoaService.RestDoaServiceCaller;
	
	public class GetUserRegDate extends RestDoaServiceCaller
	{
		public var data:GetUserRegDateRespond = new GetUserRegDateRespond() ;
		
		/***/
		public function GetUserRegDate(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('/api/PicContestApi/V2/GetUserRegDate', data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, true);
		}
		
		public function load(UserId:String):void
		{
			super.loadParam({UserId:UserId});
		}
		override protected function addHeader():void
		{
			super.addHeader();
			var newHeader:URLRequestHeader = new URLRequestHeader('HeaderToken','b6c48337-0331-4bb0-ac6e-aa6e5b66fb54');
			pureRequest.requestHeaders.push(newHeader)
		}
	}
}