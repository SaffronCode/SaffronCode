package nativeClasses.localNotification
{
	import flash.utils.setInterval;

	
	/**
	 * ...
	 * @author Younes Mashayekhi
	 */
	public class DistriqtLocalNotification
	{
		/*import com.distriqt.extension.core.Core;*/
		private static var CoreClass:Class;
		/*com.distriqt.extension.notifications.AuthorisationStatus */
		private static var AuthorisationStatusClass:Class;
		/**com.distriqt.extension.notifications.Notifications */
		private static var NotificationsClass:Class;
		/**com.distriqt.extension.notifications.Service */
		private static var ServiceClass:Class;
		/**com.distriqt.extension.notifications.builders.ActionBuilder */
		private static var ActionBuilderClass:Class;
		/**com.distriqt.extension.notifications.builders.CategoryBuilder */
		private static var CategoryBuilderClass:Class;
		/**com.distriqt.extension.notifications.builders.ChannelBuilder */
		private static var ChannelBuilderClass:Class;
		/**com.distriqt.extension.notifications.builders.NotificationBuilder*/
		private static var NotificationBuilderClass:Class;
		/**com.distriqt.extension.notifications.events.AuthorisationEvent*/
		private static var AuthorisationEventClass:Class;
		/**com.distriqt.extension.notifications.events.NotificationEvent*/
		private static var NotificationEventClass:Class;

		public static var showForground:Boolean = false;
		private static var service:*;
		private static var wakeUpIntervalId:uint;
		private static const resetNotification:uint = 60 * 1000;
		public static const MessageID:int = 1;
		public static const PreventCloseID:int = 2;
		private static var _bodyMessage:String = "";
		private static var _titleMessage:String = "";
		private static var _vibrateMessage:Boolean;

		private static var _supports:* ;

		private static function init():void
		{
			if(_supports==null)
			{
				
				CoreClass = Obj.generateClass('com.distriqt.extension.core.Core');
				AuthorisationStatusClass = Obj.generateClass("com.distriqt.extension.notifications.AuthorisationStatus");
				NotificationsClass = Obj.generateClass("com.distriqt.extension.notifications.Notifications");
				ServiceClass = Obj.generateClass("com.distriqt.extension.notifications.Service");
				ActionBuilderClass = Obj.generateClass("com.distriqt.extension.notifications.builders.ActionBuilder");
				CategoryBuilderClass = Obj.generateClass("com.distriqt.extension.notifications.builders.CategoryBuilder");
				ChannelBuilderClass = Obj.generateClass("com.distriqt.extension.notifications.builders.ChannelBuilder");
				NotificationBuilderClass = Obj.generateClass("com.distriqt.extension.notifications.builders.NotificationBuilder");
				AuthorisationEventClass = Obj.generateClass("com.distriqt.extension.notifications.events.AuthorisationEvent");
				NotificationEventClass = Obj.generateClass("com.distriqt.extension.notifications.events.NotificationEvent");

				trace("CoreClass:"+CoreClass,
				"AuthorisationStatusClass:"+AuthorisationStatusClass,
				"NotificationsClass:"+NotificationsClass,
				"ServiceClass:"+ServiceClass,
				"ActionBuilderClass:"+ActionBuilderClass,
				"CategoryBuilderClass:"+CategoryBuilderClass,
				"ChannelBuilderClass:"+ChannelBuilderClass,
				"NotificationBuilderClass:"+NotificationBuilderClass,
				"AuthorisationEventClass:"+AuthorisationEventClass,
				"NotificationEventClass:"+NotificationEventClass)

				_supports = CoreClass!=null ;
			}
		}

		public static function isSupported():Boolean
		{
			init();
			return _supports==true && (NotificationsClass as Object).isSupported;
		}

		public function DistriqtLocalNotification()
		{
			super();
			init();
		}
		
		public static function setUp():void
		{
			init();
			if(!isSupported())
			{
				trace("Localnotifications are not supporting here");
				return;
			}
			(CoreClass as Object).init();
			try
			{
				SaffronLogger.log("isSupported = " + (NotificationsClass as Object).isSupported);

				
				
				SaffronLogger.log("version notification     = " + (NotificationsClass as Object).service.version);
				(NotificationsClass as Object).service.addEventListener((NotificationEventClass as Object).NOTIFICATION, notifications_notificationHandler);
				(NotificationsClass as Object).service.addEventListener((NotificationEventClass as Object).NOTIFICATION_SELECTED, notifications_notificationHandler);
				(NotificationsClass as Object).service.addEventListener((AuthorisationEventClass as Object).CHANGED, requestAuthorisation);
				
				service = new ServiceClass();
				
				service.categories.push(new CategoryBuilderClass().setIdentifier("MESSAGE_CATEGORY").addAction(new ActionBuilderClass().setTitle("OK").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).addAction(new ActionBuilderClass().setTitle("Cancel").setDestructive(true).setShouldCancelOnAction(true).setIdentifier("CANCEL_APP_BTN").build()).build());
				
				service.categories.push(new CategoryBuilderClass().setIdentifier("OPEN_CATEGORY").addAction(new ActionBuilderClass().setTitle("Open App").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").setShouldCancelOnAction(true).build()).build());

				service.categories.push(new CategoryBuilderClass().setIdentifier("PREVENT_SLEEEP").addAction(new ActionBuilderClass().setTitle("Open").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).build());
				
				service.channels.push(new ChannelBuilderClass().setId(DevicePrefrence.appName + "_channel").setName(DevicePrefrence.appName + " Channel").build());
				
				(NotificationsClass as Object).service.setup(service);
				
				requestAuthorisation();
				
				SaffronLogger.log("Press to send a notification");
				
			}
			catch (e:Error)
			{
				SaffronLogger.log("ERROR:" + e.message);
			}
		}
		
		private static function notifications_notificationHandler(event:*):void
		{
			SaffronLogger.log(event.type + "::[" + event.id + "]::" + event.payload);
		}
		
		public static function cancelNotification(_notificationId:int):void
		{
			if (isSupported())
			{
				SaffronLogger.log("cancelNotification(): cancel:" + _notificationId);
				(NotificationsClass as Object).service.cancel(_notificationId);
			}
		}
		
		public static function cancelAllNotifications():void
		{
			init();
			SaffronLogger.log("cancelNotification(): cancelAll()");
			if (isSupported())
			{
				(NotificationsClass as Object).service.cancelAll();
			}
		}
		
		public static function sendMessage(title:String, body:String,date:Date=null,forground:Boolean=true,vibrate:Boolean = true,category:String="MESSAGE_CATEGORY",newMessageId:int = MessageID):void
		{
			init();
			if (isSupported())
			{
				service.enableNotificationsWhenActive = forground;
				if(date==null)
					(NotificationsClass as Object).service.notify(new NotificationBuilderClass().setId(newMessageId).setAlert(DevicePrefrence.appName).setTitle(title).setBody(body).setCategory(category).enableVibration(vibrate).build());
				else
				{
					date = new Date(date.time);
					(NotificationsClass as Object).service.notify(new NotificationBuilderClass().setId(newMessageId).setAlert(DevicePrefrence.appName).setTitle(title).setBody(body).setCategory(category).enableVibration(vibrate).setFireDate(date).build())
				}
			}
		}
		
		public static function preventClose(title:String="Application is closed!", body:String="Please open the application", forground:Boolean = true, vibrate:Boolean = false):void
		{
			init();
			if (isSupported())
			{
				_titleMessage = title;
				_bodyMessage = body;
				_vibrateMessage = vibrate;
				service.enableNotificationsWhenActive = forground;
				wakeUpIntervalId = setInterval(removeEarlierWakeUpNotificationAndAddNewNotification, resetNotification / 3);
				removeEarlierWakeUpNotificationAndAddNewNotification();
			}
		}
		
		public static function setBadgeNumber(number:uint):void
		{
			init();
			if (isSupported())
			{
				(NotificationsClass as Object).service.setBadgeNumber(number);
			}
		}
		
		private static function removeEarlierWakeUpNotificationAndAddNewNotification():void
		{
			cancelNotification(PreventCloseID);
			(NotificationsClass as Object).service.notify(new NotificationBuilderClass().setId(PreventCloseID).setAlert(DevicePrefrence.appName).setTitle(_titleMessage).setBody(_bodyMessage).setCategory("PREVENT_SLEEEP").enableVibration(_vibrateMessage).setFireDate(new Date((new Date()).time + resetNotification)).build());
		}
		
		private static function requestAuthorisation(e:* = null):void
		{
			init();
			switch ((NotificationsClass as Object).service.authorisationStatus())
			{
			case (AuthorisationStatusClass as Object).AUTHORISED: 
				// This device has been authorised. 
				// You can register this device and expect: 
				//  - registration success/failed event, and;  
				//  - notifications to be displayed 
				(NotificationsClass as Object).service.register();
				break;
			
			case (AuthorisationStatusClass as Object).NOT_DETERMINED: 
				// You are yet to ask for authorisation to display notifications 
				// At this point you should consider your strategy to get your user to authorise 
				// notifications by explaining what the application will provide 
				(NotificationsClass as Object).service.requestAuthorisation();
				break;
			
			case AuthorisationStatusClass
			.DENIED: 
				// The user has disabled notifications 
				// Advise your user of the lack of notifications as you see fit 
				
				// For example: You can redirect to the settings page on iOS 
				if ((NotificationsClass as Object).service.canOpenDeviceSettings)
				{
					//Notifications.service.openDeviceSettings();
				}
				break;
			}
		}
		
	}

}