package nativeClasses.pushNotification
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.pushnotifications.AuthorisationStatus;
	import com.distriqt.extension.pushnotifications.PushNotifications;
	import com.distriqt.extension.pushnotifications.Service;
	import com.distriqt.extension.pushnotifications.builders.ActionBuilder;
	import com.distriqt.extension.pushnotifications.builders.CategoryBuilder;
	import com.distriqt.extension.pushnotifications.builders.ChannelBuilder;
	import com.distriqt.extension.pushnotifications.events.AuthorisationEvent;
	import com.distriqt.extension.pushnotifications.events.RegistrationEvent;
	
	/**
	 * ...
	 * @author Younes Mashayekhi
	 */
	public class DistriqtPushNotification
	{
		private static var deviceToken:String;
		
		public function DistriqtPushNotification()
		{
		
		}
		
		public static function setup(onResult:Function = null):void
		{
			try
			{
				Core.init();
				if (PushNotifications.isSupported)
				{
					if (PushNotifications.service.isServiceSupported(Service.FCM))
					{
						var service:Service = new Service(Service.FCM, "");
						service.sandboxMode = false;
						service.enableNotificationsWhenActive = true;
						
						service.categories.push(new CategoryBuilder().setIdentifier("MESSAGE_CATEGORY").addAction(new ActionBuilder().setTitle("OK").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).addAction(new ActionBuilder().setTitle("Cancel").setDestructive(true).setShouldCancelOnAction(true).setIdentifier("CANCEL_APP_BTN").build()).build());
						
						service.channels.push(new ChannelBuilder().setId("app_channel").setName("App Channel").build());
						
						PushNotifications.service.addEventListener(RegistrationEvent.REGISTERING, registeringHandler);
						PushNotifications.service.addEventListener(RegistrationEvent.REGISTER_SUCCESS, registerSuccessHandler);
						PushNotifications.service.addEventListener(RegistrationEvent.CHANGED, registrationChangedHandler);
						PushNotifications.service.addEventListener(RegistrationEvent.REGISTER_FAILED, registerFailedHandler);
						PushNotifications.service.addEventListener(RegistrationEvent.ERROR, errorHandler);
						PushNotifications.service.addEventListener(AuthorisationEvent.CHANGED, authorisationChangedHandler);
						PushNotifications.service.setup(service);
						requestAuthorisation();
						
						function registeringHandler(event:RegistrationEvent):void
						{
							trace("Registration started");
						}
						
						function registerSuccessHandler(event:RegistrationEvent):void
						{
							trace("Registration succeeded with ID: " + event.data);
							deviceToken = event.data;
							onResult(event.data);
						}
						
						function registrationChangedHandler(event:RegistrationEvent):void
						{
							trace("Registration ID has changed: " + event.data);
							deviceToken = event.data;
							onResult(event.data);
						}
						
						function registerFailedHandler(event:RegistrationEvent):void
						{
							trace("Registration failed");
							onResult("Registration failed");
						}
						
						function errorHandler(event:RegistrationEvent):void
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
		
		private static function authorisationChangedHandler(e:AuthorisationEvent):void
		{
			requestAuthorisation();
		}
		
		private static function requestAuthorisation(e:* = null):void
		{
			switch (PushNotifications.service.authorisationStatus())
			{
			case AuthorisationStatus.AUTHORISED: 
				// This device has been authorised. 
				// You can register this device and expect: 
				//  - registration success/failed event, and;  
				//  - notifications to be displayed 
				PushNotifications.service.register();
				break;
			
			case AuthorisationStatus.NOT_DETERMINED: 
				// You are yet to ask for authorisation to display notifications 
				// At this point you should consider your strategy to get your user to authorise 
				// notifications by explaining what the application will provide 
				PushNotifications.service.requestAuthorisation();
				break;
			
			case AuthorisationStatus.DENIED: 
				// The user has disabled notifications 
				// Advise your user of the lack of notifications as you see fit 
				
				// For example: You can redirect to the settings page on iOS 
				if (PushNotifications.service.canOpenDeviceSettings)
				{
					//PushNotifications.service.openDeviceSettings();
				}
				break;
			}
		}
	
	}

}