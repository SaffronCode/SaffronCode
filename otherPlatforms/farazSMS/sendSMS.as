package otherPlatforms.farazSMS
{
	import restDoaService.RestDoaServiceCaller;
	
	public class sendSMS extends RestDoaServiceCaller
	{
		/***/
		public function sendSMS()
		{
			super('http://37.130.202.188/class/sms/webservice/send_url.php', null, false,false,null, true);
		}
		
		public function load(msg:String,to:String,uname:String,pass:String,from:String="+98100020400"):void
		{
			super.loadParam({from:from,msg:msg,pass:pass,to:to,uname:uname});
		}
	}
}