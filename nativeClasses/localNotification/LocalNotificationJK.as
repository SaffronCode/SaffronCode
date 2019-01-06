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
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Younes Mashayekhi
	 */
	public class LocalNotificationJK
	{
		/**Set a wake up notification every ... miliseconds*/
		private static const resetNotification:uint = 20 * 1000;
		private static const NOTIFICATION_CODE:String = "NOTIFICATION_CODE_001";
		
		private static var wakeUpIntervalId:uint;
		
		private static var WakeMessage:String;
		
		private static function setUp():void
		{
			//TODO set up the local notification if not sat up earlier
			if (NotificationManager.isSupported && notificationManager==null)
			{
				notificationManager = new NotificationManager();
				//var options:LocalNotifierSubscribeOptions = new LocalNotifierSubscribeOptions(createCategories());
				//options.notificationStyles = NotificationManager.supportedNotificationStyles;
				
				//notificationManager.addEventListener(NotificationEvent.SETTINGS_SUBSCRIBED, settingsSubscribedHandler);
				//notificationManager.subscribe(options);
			}
		}
		
		/*private function createCategories():Vector.<NotificationCategory>
		   {
		   return Vector.<NotificationCategory>([createCategory("category", Vector.<NotificationAction>([createAction(NotificationIconType.DOCUMENT, "okAction", "OK", true), createTextInputAction(NotificationIconType.ALERT, "cancelAction", "Cancel", "Fight!", "Ready..."), createAction(NotificationIconType.FLAG, "resetAction", "Reset"), createAction(NotificationIconType.INFO, "alertAction", "Alert")]))]);
		   }*/
		
		/*	private function createAction(icon:String, identifier:String, title:String, isBackground:Boolean = false):NotificationAction
		   {
		   return setupAction(new NotificationAction(), icon, identifier, title, isBackground);
		   }*/
		
		/*private function createTextInputAction(icon:String, identifier:String, title:String, buttonTitle:String, placeholder:String, isBackground:Boolean = false):TextInputNotificationAction
		   {
		   var action:TextInputNotificationAction = setupAction(new TextInputNotificationAction(), icon, identifier, title, isBackground) as TextInputNotificationAction;
		   action.textInputButtonTitle = buttonTitle;
		   action.textInputPlaceholder = placeholder;
		   return action;
		   }*/
		
		/*private function createCategory(identifier:String, actions:Vector.<NotificationAction>):NotificationCategory
		   {
		   var category:NotificationCategory = new NotificationCategory();
		   category.identifier = identifier;
		   category.actions = actions;
		   category.useCustomDismissAction = true;
		   return category;
		   }*/
		
		/*private function setupAction(action:NotificationAction, icon:String, identifier:String, title:String, isBackground:Boolean = false):NotificationAction
		   {
		   action.identifier = identifier;
		   action.title = title;
		   action.icon = icon;
		   action.isBackground = isBackground;
		   return action;
		   }*/
		
		public static function preventApplicationClose(wakeUpMessage:String):void
		{
			setUp();
			clearInterval(wakeUpIntervalId);
			wakeUpIntervalId = setInterval(removeEarlierWakeUpNotificationAndAddNewNotification, resetNotification / 2)
			WakeMessage = wakeUpMessage;
		}
		
		private static function removeEarlierWakeUpNotificationAndAddNewNotification():void
		{
			//TODO Clear earlier wakeup notification
			
			
			notificationManager.cancel(NOTIFICATION_CODE);
			
			//TODO Add new wakeup notification for next resetNotification milisecond
			//resetNotification ;
			//WakeMessage ;
			
			var notification:Notification = new Notification();
			notification.title = DevicePrefrence.appName;
			notification.body = WakeMessage;
			notification.actionLabel = "Rumble";
			notification.soundName = "";
			notification.fireDate = new Date((new Date()).time + resetNotification);
			notification.numberAnnotation = 1;
			notification.actionData = {sampleData: "Hello World!"};
			notification.iconType = "ic_stat_notify_dog_icon";
			notification.launchImage = "";
			notification.tickerText = "test ticker ";
			notification.priority = NotificationPriority.HIGH;
			notification.showInForeground = false;
			notification.category = "category";
			
			notificationManager.notifyUser(NOTIFICATION_CODE, notification);
		}
	
	}

}