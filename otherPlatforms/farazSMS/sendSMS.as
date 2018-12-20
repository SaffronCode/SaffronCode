package
{
	import restDoaService.RestDoaServiceCaller;
	
	public class sendSMS extends RestDoaServiceCaller
	{
		/***/
		public function sendSMS(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('http://37.130.202.188/class/sms/webservice/send_url.php', null, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, true);
		}
		
		public function load(from:String,msg:String,pass:String,to:String,uname:String):void
		{
			super.loadParam({from:from,msg:msg,pass:pass,to:to,uname:uname});
		}
	}
}