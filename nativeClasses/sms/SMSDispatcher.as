package nativeClasses.sms
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**NEW sms received*/
	[Event(name="NEW_SMS", type="nativeClasses.sms.SMSEvents")]
	/**YOur sms sent*/
	[Event(name="SMS_SENT", type="nativeClasses.sms.SMSEvents")]
	/**Your sms not sent*/
	[Event(name="SMS_NOT_SENT", type="nativeClasses.sms.SMSEvents")]
	public class SMSDispatcher extends EventDispatcher
	{
		public function SMSDispatcher()
		{
			super();
		}
	}
}