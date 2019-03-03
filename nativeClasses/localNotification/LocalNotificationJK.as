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
		private static const resetNotification:uint = 10 * 1000;
		private static const NOTIFICATION_CODE:String = "NOTIFICATION_CODE_001";
		
		private static var wakeUpIntervalId:uint;
		
		private static var WakeMessage:String;
		
		private static function setUp(onReady:Function=null):void
		{
			if (NotificationManager.isSupported)
			{
				NativeApplication.nativeApplication.executeInBackground = true;
				if (notificationManager == null)
				{
					notificationManager = new NotificationManager();
					var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions();
					options.notificationStyles = NotificationManager.supportedNotificationStyles;
					
					notificationManager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED, function(e){
						if (onReady != null)
						{
							onReady();
						}
					});
					notificationManager.subscribe(options);
				}
				else
				{
					if (onReady != null)
					{
						onReady();
					}
				}
			}
		}
		public static function preventApplicationClose(wakeUpMessage:String):void
		{
			clearInterval(wakeUpIntervalId);
			WakeMessage = wakeUpMessage;
			setUp(function(){
				wakeUpIntervalId = setInterval(removeEarlierWakeUpNotificationAndAddNewNotification, resetNotification / 2);
				removeEarlierWakeUpNotificationAndAddNewNotification();
			});
		}
		
			private static function removeEarlierWakeUpNotificationAndAddNewNotification():void
			{

				notificationManager.cancel(NOTIFICATION_CODE);
				var notification:Notification = new Notification();
				notification.title = DevicePrefrence.appName;
				notification.body = WakeMessage;
				notification.fireDate = new Date((new Date()).time + resetNotification);
				notification.numberAnnotation = 0;
				notification.priority = NotificationPriority.HIGH;
				notification.showInForeground = false;
				notification.allowWhileIdle = true;

				notificationManager.notifyUser(NOTIFICATION_CODE, notification);
			}
	
	}

}