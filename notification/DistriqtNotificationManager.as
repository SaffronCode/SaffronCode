package notification
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.pushnotifications.AuthorisationStatus;
	import com.distriqt.extension.pushnotifications.PushNotifications;
	import com.distriqt.extension.pushnotifications.Service;
	import com.distriqt.extension.pushnotifications.events.AuthorisationEvent;
	import com.distriqt.extension.pushnotifications.events.PushNotificationEvent;
	import com.distriqt.extension.pushnotifications.events.RegistrationEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**Notification tocken ready*/
	[Event(name="TOKEN_REGISTER_COMPELETED", type="notification.NotificationEvent")]
	/**Notification receved*/
	[Event(name="NOTIFICATION", type="notification.NotificationEvent")]
	//[Event(name="FOREGROUND_NOTIFICATION", type="notification.NotificationEvent")]
	public class DistriqtNotificationManager extends EventDispatcher
	{

		/**This is one signal notification token*/
		public var token:String;
		public function DistriqtNotificationManager(ONESIGNAL_APP_ID_p:String='',DISTRIQT_ID:String='')
		{
			super();
			trace("*********Distriqt notification")
			try
			{
				Core.init();
				PushNotifications.init( DISTRIQT_ID );
				if (PushNotifications.isSupported)
				{
					var service:Service = new Service( Service.ONESIGNAL, ONESIGNAL_APP_ID_p );
					service.enableNotificationsWhenActive = true;
					
					PushNotifications.service.setup( service );
					
					trace('notification sat up completly');
					autorization();
				}
				else
				{
					trace("!!! Push is not supporting here");
				}
			}
			catch (e:Error)
			{
				trace("DistriqtNotificationManager Error : "+ e );
			}
		}
		
		protected function autorization():void
		{
			try
			{
				trace("autorization starts : "+PushNotifications.service.authorisationStatus());
				checkAuthorisation();
			}
			catch(e:Error)
			{
				trace("Error!! "+e.message);
			}
		}
		
		private function checkAuthorisation():void 
		{
			switch (PushNotifications.service.authorisationStatus())
			{
				case AuthorisationStatus.AUTHORISED:
					trace(" This device has been authorised.");
					// You can register this device and expect:
					//	- registration success/failed event, and; 
					// 	- notifications to be displayed
					registerNotifications();
					break;
				
				case AuthorisationStatus.NOT_DETERMINED:
					trace(" You are yet to ask for authorisation to display notifications");
					// At this point you should consider your strategy to get your user to authorise
					// notifications by explaining what the application will provide
					PushNotifications.service.addEventListener( AuthorisationEvent.CHANGED, authorisationChangedHandler );
					PushNotifications.service.requestAuthorisation();
					break;
				
				case AuthorisationStatus.DENIED:
					trace("  The user has disabled notifications");
					// Advise your user of the lack of notifications as you see fit
					
					// For example: You can redirect to the settings page on iOS
					if (PushNotifications.service.canOpenDeviceSettings)
					{
						PushNotifications.service.openDeviceSettings();
					}
					break;
			}
		}
		
		private function registerNotifications():void 
		{
			trace("Register notification");
			//PushNotifications.service.addEventListener( PushNotificationEvent.NOTIFICATION, notificationHandler );
			PushNotifications.service.addEventListener( PushNotificationEvent.NOTIFICATION_SELECTED, notificationHandler );
			PushNotifications.service.addEventListener( RegistrationEvent.REGISTER_SUCCESS, registerSuccessHandler );
			
			PushNotifications.service.addEventListener( RegistrationEvent.ERROR, proplem);
			PushNotifications.service.addEventListener( RegistrationEvent.REGISTER_FAILED, proplem );
			PushNotifications.service.addEventListener( RegistrationEvent.UNREGISTERED, proplem );
			try
			{
				PushNotifications.service.register();
			}
			catch(e:Error)
			{
				trace("Error 2 ! : "+e.message);
			}
		}
		
		private function proplem(e:RegistrationEvent):void
		{
			trace("*** Distriqt notification error : "+e);
		}
		
		private function registerSuccessHandler( event:RegistrationEvent ):void
		{
			token = PushNotifications.service.getServiceToken();
			trace( "Registration succeeded with ID: " + token  );
			this.dispatchEvent(new NotificationEvent (NotificationEvent.TOKEN_REGISTER_COMPELETED,makePNEventManager()))
		}
		
		private function makePNEventManager():PNEventManager
		{
			var item:PNEventManager = new PNEventManager();
			item.token = token ;
			return item;
		}
		
		private function notificationHandler( event:PushNotificationEvent ):void
		{
			trace( "Notification: ["+event.type+"] state="+event.applicationState+" startup="+event.startup );
			trace( event.payload );
			var recevedObjecg:Object = JSON.parse(event.payload);
			var additionalData:Object = recevedObjecg.additionalData ;
			
			this.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFICATION,null,true,false,additionalData))
		}
		
		private function authorisationChangedHandler( event:AuthorisationEvent ):void
		{
			trace(" Check the authorisation state again (as above)");
			PushNotifications.service.removeEventListener( AuthorisationEvent.CHANGED, authorisationChangedHandler );
			checkAuthorisation();
		}
	}
}