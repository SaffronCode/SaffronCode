package nativeClasses.sms
{
	//import com.doitflash.air.extensions.sms.SMS;
	//import com.doitflash.air.extensions.sms.SMSEvent;
	
	import dataManager.GlobalStorage;
	
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;
	
	//import com.doitflash.air.extensions.sms.SMS;
	
	public class SMSHandlerNative
	{
		public static var dispatcher:SMSDispatcher = new SMSDispatcher();
		
		/**com.doitflash.air.extensions.sms.SMS*/
		private static var smsClass:Class ;
		
		/**com.doitflash.air.extensions.sms.SMSEvent*/
		private static var smsEventObject:Class ;
		
		private static var sms:Object ;
		
		private static const smsid:String = '468456456';
		

		private static var lastSMSId:uint;
		
		private static const id_lastsms_id:String = "id_lastsms_id3" ;
		
		private static var 	_smsArray:Array = [] ,
							_conversationArray:Array = [] ;
		
		private static var lastSMSLoaded:Boolean;
		private static var smsListenerIntervalId:uint;
		private static var listenToNewSMSafterready:Boolean;
		
		public static function setUp():void
		{
			lastSMSId = uint(GlobalStorage.load(id_lastsms_id));
			if(sms==null && DevicePrefrence.isAndroid())
			{
				try
				{
					smsClass = getDefinitionByName("com.doitflash.air.extensions.sms.SMS") as Class;
					smsEventObject = getDefinitionByName("com.doitflash.air.extensions.sms.SMSEvent") as Class;
					sms = new smsClass();
				}
				catch(e)
				{
					smsClass = null ;
					SaffronLogger.log("com.doitflash.air.extensions.sms.SMS is not imported : "+e);
				}
				if(smsClass!=null)
				{
					getLastRecevedMessage();
				}
			}
		}
		
		/**Get last message id*/
		private static function getLastRecevedMessage():void
		{
			//sms.addEventListener(SMSEvent.ALL_SMS, allSms);
			SaffronLogger.log("lastSMSId : "+lastSMSId);
			sms.addEventListener((smsEventObject as Object).NEW_PERIOD_SMS, allSmsPeriod);
			sms.getSmsAfterId(lastSMSId);
		}	
		
		
			private static function allSmsPeriod(e:*):void
			{
				var arr:Array = e.param;
				SaffronLogger.log("All sms Period loaded1 : "+JSON.stringify(arr,null,' '));
				
				if(arr!=null)
				{
					if(arr.length>0)
					{
						lastSMSId = arr[0].id ;
						GlobalStorage.save(id_lastsms_id,lastSMSId);
						SaffronLogger.log(">>>> change last sms id to load : "+lastSMSId);
						sms.getSmsAfterId(lastSMSId);
					}
					else
					{
						SaffronLogger.log("-No new SMS");
						lastSMSLoaded = true ;
						sms.removeEventListener((smsEventObject as Object).NEW_PERIOD_SMS, allSmsPeriod);
						
						if(listenToNewSMSafterready)
						{
							listenToGetMessage();
						}
					}
				}
			}	
		
	///////////////////////////////////////////////////////////////////////////////////////
		
		/**Be ready to get message. listen to the dispatcher to catch events*/
		public static function listenToGetMessage():void
		{
			setUp();
			if(sms==null)
			{
				SaffronLogger.log("SMS native is not supports on this device");
				return ;
			}
			SaffronLogger.log(">>>lastSMSLoaded : "+lastSMSLoaded);
			
			if(lastSMSLoaded)
			{
				//Remove last sms loader listener
				sms.removeEventListener((smsEventObject as Object).NEW_PERIOD_SMS, allSmsPeriod);
				
				sms.addEventListener((smsEventObject as Object).NEW_PERIOD_SMS, receivedSMS);
				clearInterval(smsListenerIntervalId);
				smsListenerIntervalId = setInterval(loadLastSMSes,1000);
			}
			else
			{
				listenToNewSMSafterready = true ;
			}
		}
		
		/**Request smses after last sms id*/
		private static function loadLastSMSes():void
		{
			//SaffronLogger.log("....load sms after "+lastSMSId);
			sms.getSmsAfterId(lastSMSId);
		}
		
		
			/**Controll and dispatch event if new sms receved*/
			private static function receivedSMS(e:*):void
			{
				var arr:Array = e.param;
				//SaffronLogger.log("All sms Period loaded2 : "+JSON.stringify(arr,null,' '));
				
				if(arr!=null)
				{
					if(arr.length>0)
					{
						lastSMSId = arr[0].id ;
						GlobalStorage.save(id_lastsms_id,lastSMSId);
						SaffronLogger.log(">>>> change last sms id to load2 : "+lastSMSId);
						
						for(var i:int ; i<arr.length ; i++)
						{
							var recevedSMS:SMSObject = new SMSObject(arr[i]);
							dispatcher.dispatchEvent(new SMSEvents(SMSEvents.NEW_SMS,recevedSMS));
						}
					}
				}
			}
		
		/**Cansel listenning to smses*/
		public static function canselListenToGetMessage():void
		{
			if(sms==null)
			{
				SaffronLogger.log("SMS native is not supports on this device");
				return ;
			}
			
			listenToNewSMSafterready = false ;
			
			SaffronLogger.log("Cansel listening to sms");
			sms.removeEventListener((smsEventObject as Object).NEW_PERIOD_SMS, receivedSMS);
			clearInterval(smsListenerIntervalId);
		}
		
	///////////////////////////////////////////////////////////////////////////////////////
		
		/**Listen to the events on dispatcher for geting status*/
		public static function sendMessage(phoneNumber:String,body:String):void
		{
			setUp();
			
			if(sms==null)
			{
				SaffronLogger.log("SMS native is not supports on this device");
				return ;
			}
			
			sms.addEventListener((smsEventObject as Object).SEND_ERROR,sendingFaild);
			sms.addEventListener((smsEventObject as Object).DELIVERY_FAILED,sendingFaild);
			sms.addEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			
			sms.sendSms(phoneNumber,body,smsid);
		}
		
		protected static function listenToAnswer(event:*):void
		{
			SaffronLogger.log("SmS snet..."+JSON.stringify(event.param,null,' '));
			SaffronLogger.log("SMSs1 are : "+JSON.stringify(sms.smsArray));
			sms.removeEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			
			dispatcher.dispatchEvent(new SMSEvents(SMSEvents.SMS_NOT_SENT));
		}
		
		protected static function sendingFaild(event:Event):void
		{
			SaffronLogger.log("Sending fails");
			sms.removeEventListener((smsEventObject as Object).SEND_ERROR,sendingFaild);
			sms.removeEventListener((smsEventObject as Object).DELIVERY_FAILED,sendingFaild);
			sms.removeEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			
			dispatcher.dispatchEvent(new SMSEvents(SMSEvents.SMS_SENT));
		}
		
	////////////////////////////////////////////////////////////Delete
		
		/**Delete this sms*/
		public static function deleteSMS(smsId:uint):void
		{
			if(sms==null)
			{
				SaffronLogger.log("SMS native is not supports on this device");
				return ;
			}
			SaffronLogger.log("Delete this sms");
			sms.deleteSmsById(smsId);
		}
		
	}
}