package nativeClasses.localNotification
{
	import com.juankpro.ane.localnotif.LocalNotifierSubscribeOptions;
	import com.juankpro.ane.localnotif.Notification;
	import com.juankpro.ane.localnotif.NotificationAction;
	import com.juankpro.ane.localnotif.NotificationCategory;
	import com.juankpro.ane.localnotif.NotificationEvent;
	import com.juankpro.ane.localnotif.NotificationIconType;
	import com.juankpro.ane.localnotif.NotificationManager;
	import com.juankpro.ane.localnotif.NotificationPriority;
	import com.juankpro.ane.localnotif.TextInputNotificationAction;
	import contents.alert.Alert;
	import flash.desktop.NativeApplication;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class LocalNotificationJK
	{
		private static var notificationManager:NotificationManager;
		/**Set a wake up notification every ... miliseconds*/
		private static const resetNotification:uint = 60 * 1000;
		private static const NOTIFICATION_IS_CLOSE:String = "NOTIFICATION_IS_CLOSE";
		private static const NOTIFICATION_MESSAGE:String = "NOTIFICATION_MESSAGE";
		
		private static var wakeUpIntervalId:uint;
		
		private static var WakeMessage:String;
		//private static var notification:Notification;
		
		private static var satUpOnce:Boolean = false;
		
		//public static var showNotification:Boolean = false;
		
		private static var readyFunctionsQue:Vector.<Function> = new Vector.<Function>()
		
		private static function setUp(onReady:Function = null):void
		{
			if (satUpOnce)
			{
				if (onReady != null)
				{
					onReady();
				}
				return;
			}
			
			if (onReady != null)
			{
				readyFunctionsQue.push(onReady);
			}
			
			if (NotificationManager.isSupported)
			{
				NativeApplication.nativeApplication.executeInBackground = true;
				if (notificationManager == null)
				{
					notificationManager = new NotificationManager();
					var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
					options.notificationStyles = NotificationManager.supportedNotificationStyles;
					//notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
					notificationManager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED, function(e)
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
				callAllReadies()
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
			trace("Notif2:" + WakeMessage);
			if(notificationManager)
				notificationManager.cancel(NOTIFICATION_IS_CLOSE);
			var notification:Notification = new Notification();
			notification.title = DevicePrefrence.appName;
			notification.body = WakeMessage;
			notification.fireDate = new Date((new Date()).time + resetNotification);
			notification.numberAnnotation = 0;
			notification.priority = NotificationPriority.HIGH;
			notification.showInForeground = false;
			notification.allowWhileIdle = true;
			if(notificationManager)
				notificationManager.notifyUser(NOTIFICATION_IS_CLOSE, notification);
		}
		
		public static function sendNotification(message:String):void
		{
			setUp(function()
			{
				cancelCustomNotification();
				
				var notification:Notification = new Notification();
				notification.title = DevicePrefrence.appName;
				notification.body = message;
				notification.fireDate = new Date(new Date().time+1000);
				notification.numberAnnotation = 0;
				notification.priority = NotificationPriority.MAX;
				notification.showInForeground = true;
				notification.allowWhileIdle = true;
				notification.hasAction = true;
				if(notificationManager!=null)
				notificationManager.notifyUser(NOTIFICATION_MESSAGE, notification);
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