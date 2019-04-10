package nativeClasses.pushNotification
{
	/*import com.distriqt.extension.core.Core;
	   import com.distriqt.extension.pushnotifications.AuthorisationStatus;
	   import com.distriqt.extension.pushnotifications.PushNotifications;
	   import com.distriqt.extension.pushnotifications.Service;
	   import com.distriqt.extension.pushnotifications.builders.ActionBuilder;
	   import com.distriqt.extension.pushnotifications.builders.CategoryBuilder;
	   import com.distriqt.extension.pushnotifications.builders.ChannelBuilder;
	   import com.distriqt.extension.pushnotifications.events.AuthorisationEvent;
	   import com.distriqt.extension.pushnotifications.events.RegistrationEvent;*/
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Younes Mashayekhi
	 */
	public class DistriqtPushNotification
	{
		public static var deviceToken:String;
		public static var CoreClass:Class;
		public static var AuthorisationStatusClass:Class;
		public static var PushNotificationsClass:Class;
		public static var ServiceClass:Class;
		public static var ActionBuilderClass:Class;
		public static var CategoryBuilderClass:Class;
		public static var ChannelBuilderClass:Class;
		public static var AuthorisationEventClass:Class;
		public static var RegistrationEventClass:Class;
		
		public function DistriqtPushNotification()
		{
		
		}
		
		public static function loadClasses():void
		{
			if (PushNotificationsClass == null)
			{
				try
				{
					CoreClass = getDefinitionByName("com.distriqt.extension.core.Core") as Class;
					AuthorisationStatusClass = getDefinitionByName("com.distriqt.extension.pushnotifications.AuthorisationStatus") as Class;
					PushNotificationsClass = getDefinitionByName("com.distriqt.extension.pushnotifications.PushNotifications") as Class;
					ServiceClass = getDefinitionByName("com.distriqt.extension.pushnotifications.Service") as Class;
					ActionBuilderClass = getDefinitionByName("com.distriqt.extension.pushnotifications.builders.ActionBuilder") as Class;
					CategoryBuilderClass = getDefinitionByName("com.distriqt.extension.pushnotifications.builders.CategoryBuilder") as Class;
					ChannelBuilderClass = getDefinitionByName("com.distriqt.extension.pushnotifications.builders.ChannelBuilder") as Class;
					AuthorisationEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.AuthorisationEvent") as Class;
					RegistrationEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.RegistrationEvent") as Class;
				}
				catch (e)
				{
					trace('Add \n\n\t<extensionID>com.distriqt.PushNotification</extensionID>\n\t<extensionID>com.distriqt.Core</extensionID>\n\n to your project xmls');// and below permitions to the <application> tag : \n\n<activity \n\n\tandroid:name="com.distriqt.extension.share.activities.ShareActivity" \n\n\tandroid:theme="@android:style/Theme.Translucent.NoTitleBar" />\n\n\t\n\n<provider\n\n\tandroid:name="android.support.v4.content.FileProvider"\n\n\tandroid:authorities="air.'+DevicePrefrence.appID+'"\n\n\tandroid:grantUriPermissions="true"\n\n\tandroid:exported="false">\n\n\t<meta-data\n\n\t\tandroid:name="android.support.FILE_PROVIDER_PATHS"\n\n\t\tandroid:resource="@xml/distriqt_paths" />\n\n</provider>';
				}
			}
		}
		
		public static function isSupport():Boolean
		{
			if (PushNotificationsClass == null || PushNotificationsClass.isSupported == false)
				return false
			else
				return true;
		}
		
		public static function setup(onResult:Function = null):void
		{
			loadClasses();
			
			if (PushNotificationsClass == null)
			{
				return;
			}
			try
			{
				(CoreClass as Object).init();
				if (PushNotificationsClass.isSupported)
				{
					if (PushNotificationsClass.service.isServiceSupported((ServiceClass as Object).FCM))
					{
						var service:* = new ServiceClass((ServiceClass as Object).FCM, "");
						service.sandboxMode = false;
						service.enableNotificationsWhenActive = true;
						
						service.categories.push(new CategoryBuilderClass().setIdentifier("MESSAGE_CATEGORY").addAction(new ActionBuilderClass().setTitle("OK").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).addAction(new ActionBuilderClass().setTitle("Cancel").setDestructive(true).setShouldCancelOnAction(true).setIdentifier("CANCEL_APP_BTN").build()).build());
						
						service.channels.push(new ChannelBuilderClass().setId("app_channel").setName("App Channel").build());
						
						PushNotificationsClass.service.addEventListener(RegistrationEventClass.REGISTERING, registeringHandler);
						PushNotificationsClass.service.addEventListener(RegistrationEventClass.REGISTER_SUCCESS, registerSuccessHandler);
						PushNotificationsClass.service.addEventListener(RegistrationEventClass.CHANGED, registrationChangedHandler);
						PushNotificationsClass.service.addEventListener(RegistrationEventClass.REGISTER_FAILED, registerFailedHandler);
						PushNotificationsClass.service.addEventListener(RegistrationEventClass.ERROR, errorHandler);
						PushNotificationsClass.service.addEventListener(AuthorisationEventClass.CHANGED, authorisationChangedHandler);
						PushNotificationsClass.service.setup(service);
						requestAuthorisation();
						
						function registeringHandler(event:*):void
						{
							trace("Registration started");
						}
						
						function registerSuccessHandler(event:*):void
						{
							trace("Registration succeeded with ID: " + event.data);
							deviceToken = event.data;
							onResult(event.data);
						}
						
						function registrationChangedHandler(event:*):void
						{
							trace("Registration ID has changed: " + event.data);
							deviceToken = event.data;
							onResult(event.data);
						}
						
						function registerFailedHandler(event:*):void
						{
							trace("Registration failed");
							onResult("Registration failed");
						}
						
						function errorHandler(event:*):void
						{
							trace("Registration error: " + event.data);
							onResult("Registration error");
						}
						
					}
					else
					{
						trace("fcm notification is not support");
						onResult("FCM Not Support");
					}
				}
				else
				{
					trace("notification is not support");
					onResult("windows Debug");
				}
			}
			catch (e:Error)
			{
				trace("ERROR:" + e.message);
				onResult("error occured");
			}
		}
		
		private static function authorisationChangedHandler(e:*):void
		{
			requestAuthorisation();
		}
		
		private static function requestAuthorisation(e:* = null):void
		{
			switch (PushNotificationsClass.service.authorisationStatus())
			{
			case AuthorisationStatusClass.AUTHORISED: 
				// This device has been authorised. 
				// You can register this device and expect: 
				//  - registration success/failed event, and;  
				//  - notifications to be displayed 
				PushNotificationsClass.service.register();
				break;
			
			case AuthorisationStatusClass.NOT_DETERMINED: 
				// You are yet to ask for authorisation to display notifications 
				// At this point you should consider your strategy to get your user to authorise 
				// notifications by explaining what the application will provide 
				PushNotificationsClass.service.requestAuthorisation();
				break;
			
			case AuthorisationStatusClass.DENIED: 
				// The user has disabled notifications 
				// Advise your user of the lack of notifications as you see fit 
				
				// For example: You can redirect to the settings page on iOS 
				if (PushNotificationsClass.service.canOpenDeviceSettings)
				{
					//PushNotifications.service.openDeviceSettings();
				}
				break;
			}
		}
	
	}

}