package nativeClasses.localNotification
{
	/*import com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions;
	import com.juankpro.ane.localnotif.Notification;
	import com.juankpro.ane.localnotif.NotificationAction;
	import com.juankpro.ane.localnotif.NotificationCategory;
	import com.juankpro.ane.localnotif.NotificationEvent;
	import com.juankpro.ane.localnotif.NotificationIconType;
	import com.juankpro.ane.localnotif.NotificationManager;
	import com.juankpro.ane.localnotif.NotificationPriority;
	import com.juankpro.ane.localnotif.TextInputNotificationAction;*/
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.setInterval;
	
	import notification.NotificationEvent;
	import notification.NotificationManager;
	
	public class LocalNotificationJK
	{
		/**com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions*/
		private static var LocalNotifierSubscribeOptionsClass:Class;
		/**com.juankpro.ane.localnotif.Notification*/
		private static var NotificationClass:Class;
		/**com.juankpro.ane.localnotif.NotificationAction*/
		private static var NotificationActionClass:Class;
		/**com.juankpro.ane.localnotif.NotificationCategory*/
		private static var NotificationCategoryClass:Class;
		/**com.juankpro.ane.localnotif.NotificationEvent*/
		private static var NotificationEventClass:Class;
		/**com.juankpro.ane.localnotif.NotificationIconType*/
		private static var NotificationIconTypeClass:Class;
		/**com.juankpro.ane.localnotif.NotificationManager;*/
		private static var NotificationManagerClass:Class;
		/**com.juankpro.ane.localnotif.NotificationPriority*/
		private static var NotificationPriorityClass:Class;
		/**com.juankpro.ane.localnotif.TextInputNotificationAction*/
		private static var TextInputNotificationActionClass:Class;
		
		
		/**NotificationManager*/
		private static var notificationManager:Object;
		/**Set a wake up notification every ... miliseconds*/
		private static const resetNotification:uint = 60 * 1000;
		private static const NOTIFICATION_IS_CLOSE:String = "NOTIFICATION_IS_CLOSE";
		private static const NOTIFICATION_MESSAGE:String = "NOTIFICATION_MESSAGE";
		
		private static var wakeUpIntervalId:uint;
		
		private static var WakeMessage:String;
		//private static var notification:Notification;
		
		private static var satUpOnce:Boolean = false;
		
		//public static var showNotification:Boolean = false;
		
		private static var readyFunctionsQue:Vector.<Function> = new Vector.<Function>();
		
		private static function loadClasses():void
		{
			if(LocalNotifierSubscribeOptionsClass!=null)
			{
				return ;
			}
			try
			{
				LocalNotifierSubscribeOptionsClass = getDefinitionByName("com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions") as Class ;
				NotificationClass = getDefinitionByName("com.juankpro.ane.localnotif.Notification") as Class ;
				NotificationActionClass = getDefinitionByName("com.juankpro.ane.localnotif.NotificationAction") as Class ;
				NotificationCategoryClass = getDefinitionByName("com.juankpro.ane.localnotif.NotificationCategory") as Class ;
				NotificationEventClass = getDefinitionByName("com.juankpro.ane.localnotif.NotificationEvent") as Class ;
				NotificationIconTypeClass = getDefinitionByName("com.juankpro.ane.localnotif.NotificationIconType") as Class ;
				NotificationManagerClass = getDefinitionByName("com.juankpro.ane.localnotif.NotificationManager") as Class ;
				NotificationPriorityClass = getDefinitionByName("com.juankpro.ane.localnotif.NotificationPriority") as Class ;
				TextInputNotificationActionClass = getDefinitionByName("com.juankpro.ane.localnotif.TextInputNotificationAction") as Class ;
			}catch(e){
				LocalNotifierSubscribeOptionsClass = null ;
			}
		}
		
		/**Return true if this component is supporting*/
		public static function isSupport():Boolean
		{
			loadClasses();
			return NotificationManagerClass != null && (NotificationManagerClass as Object).isSupported ;
		}
		
		private static function setUp(onReady:Function = null):void
		{
			if (satUpOnce)
			{
				if (onReady != null && isSupport())
				{
					onReady();
				}
				return;
			}
			
			loadClasses();
			
			if (onReady != null)
			{
				readyFunctionsQue.push(onReady);
			}
			trace("isSupport() : " + isSupport());
			if (isSupport())
			{
				//NativeApplication.nativeApplication.executeInBackground = true;
				if (notificationManager == null)
				{
					notificationManager = new NotificationManagerClass();
					var options:Object = new LocalNotifierSubscribeOptionsClass();
					options.notificationStyles = (NotificationManagerClass as Object).supportedNotificationStyles;
					//notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
					notificationManager.addEventListener((NotificationEventClass as Object).SETTINGS_SUBSCRIBED, function(e)
					{
						satUpOnce = true;
						callAllReadies()
					});
					notificationManager.subscribe(options);
				}
				else
				{
					satUpOnce = true;
					callAllReadies()
				}
			}
			else
			{
				trace("!!!!!!!!!!!!!!! Notification is not supporting here !!!!!!!!!!!!!!!!!");
				
				satUpOnce = true;
				//callAllReadies()
			}
		}
		
		//private static function notificationActionHandler(e:NotificationEvent):void 
		//{
			//Alert.show("A");
			//showNotification = false;
		//}
		
		private static function callAllReadies():void
		{
			for (var i:int = 0; i < readyFunctionsQue.length; i++)
			{
				readyFunctionsQue[i]();
			}
			readyFunctionsQue = new Vector.<Function>();
		}
		
		public static function preventApplicationClose(wakeUpMessage:String):void
		{
			loadClasses();
			clearInterval(wakeUpIntervalId);
			WakeMessage = wakeUpMessage;
			setUp(function()
			{
				wakeUpIntervalId = setInterval(removeEarlierWakeUpNotificationAndAddNewNotification, resetNotification / 3);
				removeEarlierWakeUpNotificationAndAddNewNotification();
			});
		}
		
		private static function removeEarlierWakeUpNotificationAndAddNewNotification():void
		{
			loadClasses();
			trace("Notif2:" + WakeMessage);
			if(notificationManager)
				notificationManager.cancel(NOTIFICATION_IS_CLOSE);
			var notificati:Object = new NotificationClass();
			notificati.title = DevicePrefrence.appName;
			notificati.body = WakeMessage;
			notificati.fireDate = new Date((new Date()).time + resetNotification);
			notificati.numberAnnotation = 0;
			notificati.priority = (NotificationPriorityClass as Object).HIGH;
			notificati.showInForeground = false;
			notificati.allowWhileIdle = true;
			if(notificationManager)
				notificationManager.notifyUser(NOTIFICATION_IS_CLOSE, notificati);
		}
		
		public static function sendNotification(message:String):void
		{
			setUp(function()
			{
				cancelCustomNotification();
				
				var notificati:Object = new NotificationClass();
				notificati.title = DevicePrefrence.appName;
				notificati.body = message;
				notificati.fireDate = new Date(new Date().time+1000);
				notificati.numberAnnotation = 0;
				notificati.priority = (NotificationPriorityClass as Object).MAX;
				notificati.showInForeground = true;
				notificati.allowWhileIdle = true;
				notificati.hasAction = true;
				if(notificationManager!=null)
				notificationManager.notifyUser(NOTIFICATION_MESSAGE, notificati);
				//showNotification = true;
				trace("**** Please send notification");
			})
		}
		
		/**Cancel custom notification*/
		public static function cancelCustomNotification():void
		{
			trace("Cancel cutsom notificaiton");
			setUp(function(){if(notificationManager!=null)notificationManager.cancel(NOTIFICATION_MESSAGE)});
		}
	
	}

}