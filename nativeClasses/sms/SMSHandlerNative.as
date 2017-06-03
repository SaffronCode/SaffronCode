package nativeClasses.sms
{
	//import com.doitflash.air.extensions.sms.SMS;
	//import com.doitflash.air.extensions.sms.SMSEvent;
	
	import com.doitflash.air.extensions.sms.SMS;
	import com.doitflash.air.extensions.sms.SMSEvent;
	
	import dataManager.GlobalStorage;
	
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
		
		private static var sms:SMS ;
		
		private static const smsid:String = '468456456';
		
		private static var 	onDone:Function,
							onFaild:Function,
							
							onMessageReceived:Function;

		private static var lastSMSId:uint;
		
		private static const id_lastsms_id:String = "id_lastsms_id2" ;
		
		private static var 	_smsArray:Array = [] ,
							_conversationArray:Array = [] ;
							private static var lastSMSLoaded:Boolean;
							private static var smsListenerIntervalId:uint;
		
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
					trace("com.doitflash.air.extensions.sms.SMS is not imported : "+e);
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
			trace("lastSMSId : "+lastSMSId);
			sms.addEventListener(SMSEvent.NEW_PERIOD_SMS, allSmsPeriod);
			sms.getSmsAfterId(lastSMSId);
		}	
		
		
			/*private static function allSms(e:SMSEvent):void
			{
				sms.removeEventListener(SMSEvent.ALL_SMS, allSms);
				sms.removeEventListener(SMSEvent.NEW_PERIOD_SMS, allSmsPeriod);
				_smsArray = e.param;
				_conversationArray = sms.conversation(8);
				trace("--_conversationArray : "+_conversationArray);
				trace("--_smsArray : "+_smsArray);
				trace("received all SMS");
				if(_smsArray!=null && _smsArray.length>0)
				{
					trace("****************Get the last id and dispose sms");
				}
			}*/
			
			private static function allSmsPeriod(e:SMSEvent):void
			{
				var arr:Array = e.param;
				trace("All sms Period loaded1 : "+JSON.stringify(arr,null,' '));
				
				if(arr!=null)
				{
					if(arr.length>0)
					{
						lastSMSId = arr[0].id ;
						GlobalStorage.save(id_lastsms_id,lastSMSId);
						trace(">>>> change last sms id to load : "+lastSMSId);
						sms.getSmsAfterId(lastSMSId);
					}
					else
					{
						trace("-No new SMS");
						lastSMSLoaded = true ;
						sms.removeEventListener(SMSEvent.NEW_PERIOD_SMS, allSmsPeriod);
					}
				}
			}	
		
	///////////////////////////////////////////////////////////////////////////////////////
		
		/**Be ready to get message*/
		public static function listenToGetMessage(onGet:Function,myNumberToListen:uint=785180):void
		{
			if(sms==null)
			{
				trace("SMS native is not supports on this device");
				return ;
			}
			trace(">>>lastSMSLoaded : "+lastSMSLoaded);
			onMessageReceived = onGet ;
			
			if(lastSMSLoaded)
			{
				trace("Remove last sms loader listener");
				sms.removeEventListener(SMSEvent.NEW_PERIOD_SMS, allSmsPeriod);
			}
			sms.addEventListener(SMSEvent.NEW_PERIOD_SMS, receivedSMS);
			clearInterval(smsListenerIntervalId);
			smsListenerIntervalId = setInterval(loadLastSMSes,1000);
		}
		
		/**Request smses after last sms id*/
		private static function loadLastSMSes():void
		{
			trace("....load sms after "+lastSMSId);
			sms.getSmsAfterId(lastSMSId);
		}
		
		
			/**Controll and dispatch event if new sms receved*/
			private static function receivedSMS(e:SMSEvent):void
			{
				var arr:Array = e.param;
				trace("All sms Period loaded2 : "+JSON.stringify(arr,null,' '));
				
				if(arr!=null)
				{
					if(arr.length>0)
					{
						lastSMSId = arr[0].id ;
						GlobalStorage.save(id_lastsms_id,lastSMSId);
						trace(">>>> change last sms id to load2 : "+lastSMSId);
						
						for(var i:int ; i<arr.length ; i++)
						{
							if(onMessageReceived.length>0)
							{
								trace(">> tell the caller that new sms is receved");
								onMessageReceived(new SMSObject(arr[i]));
							}
							else
							{
								trace("Your onMessage receive cant get parameter");
								onMessageReceived();
							}
						}
					}
				}
			}
		
		public static function canselListenToGetMessage():void
		{
			if(sms==null)
			{
				trace("SMS native is not supports on this device");
				return ;
			}
			
			trace("Cansel listening to sms");
			sms.removeEventListener(SMSEvent.NEW_PERIOD_SMS, receivedSMS);
			clearInterval(smsListenerIntervalId);
			onMessageReceived = null ;
		}
		
		/**SMS received- if you whant to cansel listening to it, call CanselListenToGetMessage()*/
		protected static function controllReceivedSMS(event:*):void
		{
			trace("SMSs2 are : "+JSON.stringify(sms.smsArrayAfterId));
			//clearInterval(intervalId);
			trace("receved sms is : "+JSON.stringify(event.param,null,' '));
			onMessageReceived();//Dont delete this functin, more sms may come to
		}
	
	///////////////////////////////////////////////////////////////////////////////////////
		
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
				
				sms.sendSms(phoneNumber,body,smsid);
			}
		}
		
		protected static function listenToAnswer(event:*):void
		{
			trace("SmS snet..."+JSON.stringify(event.param,null,' '));
			trace("SMSs1 are : "+JSON.stringify(sms.smsArray));
			sms.removeEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			
			onFaild = null ;
			calAndDeletFunction(onDone) ;
		}
		
		protected static function sendingFaild(event:Event):void
		{
			trace("Sending fails");
			sms.removeEventListener((smsEventObject as Object).SEND_ERROR,sendingFaild);
			sms.removeEventListener((smsEventObject as Object).DELIVERY_FAILED,sendingFaild);
			sms.removeEventListener((smsEventObject as Object).SEND_SUCCESS,listenToAnswer);
			onDone = null ;
			calAndDeletFunction(onFaild);
		}
		
	////////////////////////////////////////////////////////////
		
		/**Call and delete this function*/
		private static function calAndDeletFunction(func:Function,params:String=null):void
		{
			var cashedFunc:Function = func ;
			func = null ;
			if(params!=null && cashedFunc.length>0)
			{
				cashedFunc(params);
			}
			else
			{
				cashedFunc();
			}
		}
	}
}