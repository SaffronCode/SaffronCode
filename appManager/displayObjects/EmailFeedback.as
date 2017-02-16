package appManager.displayObjects
{
	import flash.desktop.NativeApplication;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;

	/**mailto:someone@example.com?subject=This%20is%20the%20subject&cc=someone_else@example.com&body=This%20is%20the%20body*/
	public class EmailFeedback
	{
		private static var devicePrefrence:String ;
		
		private static function setUp()
		{
			if(devicePrefrence==null)
			{
				devicePrefrence = " \n\n\r\r\r\r\r\r"+String('['+DevicePrefrence.appName+DevicePrefrence.appVersion+'-'+new Date().toString()+'-'+JSON.stringify(Capabilities)+']').split('"').join('').split('&').join('').split('?').join('').split('{').join('').split('}').join('').split(' ').join('');
			}
		}
		
		public static function sendFeedbackTo(mailAdress:String,Subject:String="Feedback"):void
		{
			setUp();
			trace("devicePrefrence : "+devicePrefrence);
			navigateToURL(new URLRequest("mailto:"+mailAdress+"?subject="+Subject+"&body="+devicePrefrence));
		}
	}
}