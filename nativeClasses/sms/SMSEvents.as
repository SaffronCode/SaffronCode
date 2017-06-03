package nativeClasses.sms
{
	import flash.events.Event;
	
	public class SMSEvents extends Event
	{
		/**NEW sms received*/
		public static const NEW_SMS:String = "NEW_SMS" ;
		/**YOur sms sent*/
		public static const SMS_SENT:String = "SMS_SENT" ;
		/**Your sms not sent*/
		public static const SMS_NOT_SENT:String = "SMS_NOT_SENT" ;
		
		public var sms:SMSObject ;
		
		public function SMSEvents(type:String,smsItem:SMSObject=null)
		{
			sms = smsItem ;
			super(type);
		}
	}
}