package otherPlatforms.oneSignal
{
	import flash.net.URLRequestHeader;
	
	import restDoaService.RestDoaServiceCaller;
	
	public class OneSignal extends RestDoaServiceCaller
	{
		public var data:OneSignalResult = new OneSignalResult();
		
		private static var App_ID:String,
					REST_API_Key:String;
		
		public function OneSignal()
		{
			super("https://onesignal.com/api/v1/notifications", data, false, false, null,false);
		}
		
		public static function setUp(_App_ID:String,_REST_API_Key:String):void
		{
			App_ID = _App_ID ;
			REST_API_Key = _REST_API_Key ;
		}
		
		override protected function addHeader():void
		{
			super.addHeader();
			var newHeader:URLRequestHeader = new URLRequestHeader('Authorization','Basic '+REST_API_Key);
			pureRequest.requestHeaders.push(newHeader);
		}
		
		public function load(Message:String,Title:String=null,openThisURL:String=null,sendToiOSUsers:Boolean=true,sendToAndroidUsers:Boolean=true):void
		{
			if(REST_API_Key==null)
				throw "You should call the OneSignal.setUp function first.\n\n\n\n" ;
			
			super.loadParam({
					app_id:App_ID,
					included_segments:["All"],
					isIos:sendToiOSUsers,
					isAndroid:sendToAndroidUsers,
					url:openThisURL,
					contents:{en: Message},
					headings:(Title==null)?null:{em:Title}
				}
			);
		}
	}
}