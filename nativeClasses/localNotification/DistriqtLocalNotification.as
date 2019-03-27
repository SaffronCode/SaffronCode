package nativeClasses.localNotification
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.notifications.AuthorisationStatus;
	import com.distriqt.extension.notifications.Notifications;
	import com.distriqt.extension.notifications.Service;
	import com.distriqt.extension.notifications.builders.ActionBuilder;
	import com.distriqt.extension.notifications.builders.CategoryBuilder;
	import com.distriqt.extension.notifications.builders.ChannelBuilder;
	import com.distriqt.extension.notifications.builders.NotificationBuilder;
	import com.distriqt.extension.notifications.events.AuthorisationEvent;
	import com.distriqt.extension.notifications.events.NotificationEvent;
	import flash.utils.setInterval;

	
	/**
	 * ...
	 * @author Younes Mashayekhi
	 */
	public class DistriqtLocalNotification
	{
		public static var showForground:Boolean = false;
		private static var service:Service;
		private static var wakeUpIntervalId:uint;
		private static const resetNotification:uint = 60 * 1000;
		public static const MessageID:int = 1;
		public static const PreventCloseID:int = 2;
		private static var _bodyMessage:String = "";
		private static var _titleMessage:String = "";
		private static var _vibrateMessage:Boolean;
		public function DistriqtLocalNotification()
		{
			
		}
		
		public static function setDistriqtID(distriqtID)
		{
			Core.init();
			Notifications.init(distriqtID);
			setup();
		}
		
		private static function setup():void
		{
			try
			{
				trace("isSupported = " + Notifications.isSupported);
				
				if (Notifications.isSupported)
				{
					trace("version notification     = " + Notifications.service.version);
					Notifications.service.addEventListener(NotificationEvent.NOTIFICATION, notifications_notificationHandler);
					Notifications.service.addEventListener(NotificationEvent.NOTIFICATION_SELECTED, notifications_notificationHandler);
					Notifications.service.addEventListener(AuthorisationEvent.CHANGED, requestAuthorisation);
					
					service = new Service();
					
					service.categories.push(new CategoryBuilder().setIdentifier("MESSAGE_CATEGORY").addAction(new ActionBuilder().setTitle("OK").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).addAction(new ActionBuilder().setTitle("Cancel").setDestructive(true).setShouldCancelOnAction(true).setIdentifier("CANCEL_APP_BTN").build()).build());
					
					service.categories.push(new CategoryBuilder().setIdentifier("PREVENT_SLEEEP").addAction(new ActionBuilder().setTitle("Open").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).build());
					
					service.channels.push(new ChannelBuilder().setId(DevicePrefrence.appName + "_channel").setName(DevicePrefrence.appName + " Channel").build());
					
					Notifications.service.setup(service);
					
					requestAuthorisation();
					
					trace("Press to send a notification");
				}
				else
				{
					trace("Notifications not supported");
				}
			}
			catch (e:Error)
			{
				trace("ERROR:" + e.message);
			}
		}
		
		private static function notifications_notificationHandler(event:NotificationEvent):void
		{
			trace(event.type + "::[" + event.id + "]::" + event.payload);
		}
		
		public static function cancelNotification(_notificationId:int):void
		{
			if (Notifications.isSupported)
			{
				trace("cancelNotification(): cancel:" + _notificationId);
				Notifications.service.cancel(_notificationId);
			}
		}
		
		public static function cancelAllNotifications():void
		{
			if (Notifications.isSupported)
			{
				trace("cancelNotification(): cancelAll()");
				Notifications.service.cancelAll();
			}
		}
		
		public static function sendMessage(title:String, body:String, forground:Boolean=true,vibrate:Boolean = true)
		{
			if (Notifications.isSupported)
			{
				service.enableNotificationsWhenActive = forground;
				Notifications.service.notify(new NotificationBuilder().setId(MessageID).setAlert(DevicePrefrence.appName).setTitle(title).setBody(body).setCategory("MESSAGE_CATEGORY").enableVibration(vibrate).build());
			}
		}
		
		public static function preventClose(title:String="Application is closed!", body:String="Please open the application", forground:Boolean = true, vibrate:Boolean = false)
		{
			if (Notifications.isSupported)
			{
				_titleMessage = title;
				_bodyMessage = body;
				_vibrateMessage = vibrate;
				service.enableNotificationsWhenActive = forground;
				wakeUpIntervalId = setInterval(removeEarlierWakeUpNotificationAndAddNewNotification, resetNotification / 3);
				removeEarlierWakeUpNotificationAndAddNewNotification();
			}
		}
		
		public static function setBadgeNumber(number:uint)
		{
			if (Notifications.isSupported)
			{
				Notifications.service.setBadgeNumber(number);
			}
		}
		
		private static function removeEarlierWakeUpNotificationAndAddNewNotification():void
		{
			cancelNotification(PreventCloseID);
			Notifications.service.notify(new NotificationBuilder().setId(PreventCloseID).setAlert(DevicePrefrence.appName).setTitle(_titleMessage).setBody(_bodyMessage).setCategory("PREVENT_SLEEEP").enableVibration(_vibrateMessage).setFireDate(new Date((new Date()).time + resetNotification)).build());
		}
		
		private static function requestAuthorisation(e:* = null):void
		{
			switch (Notifications.service.authorisationStatus())
			{
			case AuthorisationStatus.AUTHORISED: 
				// This device has been authorised. 
				// You can register this device and expect: 
				//  - registration success/failed event, and;  
				//  - notifications to be displayed 
				Notifications.service.register();
				break;
			
			case AuthorisationStatus.NOT_DETERMINED: 
				// You are yet to ask for authorisation to display notifications 
				// At this point you should consider your strategy to get your user to authorise 
				// notifications by explaining what the application will provide 
				Notifications.service.requestAuthorisation();
				break;
			
			case AuthorisationStatus.DENIED: 
				// The user has disabled notifications 
				// Advise your user of the lack of notifications as you see fit 
				
				// For example: You can redirect to the settings page on iOS 
				if (Notifications.service.canOpenDeviceSettings)
				{
					//Notifications.service.openDeviceSettings();
				}
				break;
			}
		}
		
	}

}