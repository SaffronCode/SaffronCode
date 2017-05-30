package nativeClasses.sms
{
	//import com.doitflash.air.extensions.sms.SMS;
	//import com.doitflash.air.extensions.sms.SMSEvent;
	
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;
	
	//import com.doitflash.air.extensions.sms.SMS;
	
	public class SMSHandlerNative
	{
		/**com.doitflash.air.extensions.sms.SMS*/
		private static var smsClass:Class ;
		
		/**com.doitflash.air.extensions.sms.SMSEvent*/
		private static var smsEventObject:Class ;
		
		private static var sms:Object ;
		
		private static const smsid:String = '468456456';
		
		private static var onDone:Function,
							onFaild:Function ;
		
		public static function setUp():void
		{
			if(sms==null)
			{
				try
				{
					smsClass == getDefinitionByName("com.doitflash.air.extensions.sms.SMS") as Class;
					smsEventObject == getDefinitionByName("com.doitflash.air.extensions.sms.SMSEvent") as Class;
					sms = new smsClass();
				}
				catch(e)
				{
					smsClass = null ;
					trace("com.doitflash.air.extensions.sms.SMS is not imported");
				}
			}
		}
		
		public static function sendMessage(phoneNumber:String,body:String,onDoneFunction:Function,onFaildFunction:Function):void
		{
			setUp();
			
			onDone = onDoneFunction ;
			onFaild = onFaildFunction ;
			
			if(sms)
			{
				sms.addEventListener((smsEventObject as Object).SEND_ERROR,sendingFaild);
				sms.addEventListener((smsEventObject as Object).DELIVERY_FAILED,sendingFaild);
				sms.addEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
				sms.addEventListener((smsEventObject as Object).SMS_RECEIVED,controllReceivedSMS);
				sms.addEventListener((smsEventObject as Object).NEW_RECEIVED_SMS,controllReceivedSMS);
				sms.addEventListener((smsEventObject as Object).NEW_PERIOD_SMS,controllReceivedSMS);
				
				sms.sendSms(phoneNumber,body,smsid);
			}
		}
		
		protected static function listenToAnswer(event:*):void
		{
			trace("SmS snet..."+JSON.stringify(event.param,null,' '));
			trace("SMSs1 are : "+JSON.stringify(sms.smsArray));
			sms.removeEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			
			onDone();
		}
		
		protected static function controllReceivedSMS(event:*):void
		{
			trace("SMSs2 are : "+JSON.stringify(sms.smsArrayAfterId));
			//clearInterval(intervalId);
			trace("receved sms is : "+JSON.stringify(event.param,null,' '));
		}
		
		/**Add all listeners to detect sms is sent successfully*/
		private static function setListeners():void
		{
			
		}
		
		/**Remove all listeners*/
		private static function removeListeners():void
		{
			sms.removeEventListener((smsEventObject as Object).SEND_ERROR,sendingFaild);
			sms.removeEventListener((smsEventObject as Object).DELIVERY_FAILED,sendingFaild);
			sms.removeEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			sms.removeEventListener((smsEventObject as Object).SMS_RECEIVED,controllReceivedSMS);
		}
		
		protected static function sendingFaild(event:Event):void
		{
			trace("Sending fails");
			removeListeners();
			onFaild();
		}
}