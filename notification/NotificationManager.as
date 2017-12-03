package notification
{
	import com.mteamapp.StringFunctions;
	
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	


	/**Notification tocken ready*/
	[Event(name="TOKEN_REGISTER_COMPELETED", type="notification.NotificationEvent")]
	/**Notification receved*/
	[Event(name="NOTIFICATION", type="notification.NotificationEvent")]
	public class NotificationManager extends EventDispatcher
	{
		public static var ONESIGNAL_APP_ID:String;
		public static var GCM_PROJECT_NUMBER:String;
		public static var Notification_Event:NotificationManager
		
		public static var token:String ;
		
		private var _timeOutId:uint	
		private static var autoAlertBox:Boolean;
		
		/**com.milkmangames.nativeextensions.events.PNOSEvent*/
		private static var PNOSEventClass:Class ;
		
		/**com.milkmangames.nativeextensions.EasyPush*/
		private static var EasyPushClass:Class ;
		
		/**Dont call this function here !! use setup!!!*/
		public function NotificationManager(ONESIGNAL_APP_ID_p:String='',GCM_PROJECT_NUMBER_p:String='',autoAlerOnNativeBox:Boolean=true)
		{
			super();
			autoAlertBox = autoAlerOnNativeBox ;
			trace("SetUp easy push");
			ONESIGNAL_APP_ID = ONESIGNAL_APP_ID_p ;
			GCM_PROJECT_NUMBER = GCM_PROJECT_NUMBER_p ;
		
			if(ONESIGNAL_APP_ID_p!='' && GCM_PROJECT_NUMBER_p!='')
			{
				EasyPushExample();
			}
			
			if(PNOSEventClass==null)
			{
				PNOSEventClass = Obj.generateClass("com.milkmangames.nativeextensions.events.PNOSEvent") ;
			}
			
			if(EasyPushClass==null)
			{
				EasyPushClass = Obj.generateClass("com.milkmangames.nativeextensions.EasyPush") ;
			}
		}
		
		/**This will returns an instance on NofificatnionManager to cathc its events<br>
		 * there is no need to call this*/
		public static function setup(ONESIGNAL_APP_ID_p:String='',GCM_PROJECT_NUMBER_p:String='',autoAlerOnNativeBox:Boolean=true):NotificationManager
		{
			autoAlertBox = autoAlerOnNativeBox ;
			trace("SetUp easy push");
			Notification_Event = new NotificationManager()
			ONESIGNAL_APP_ID = ONESIGNAL_APP_ID_p
			GCM_PROJECT_NUMBER = GCM_PROJECT_NUMBER_p
		
			NotificationManager.Notification_Event.EasyPushExample();
			return Notification_Event ;
		}
		
		private function EasyPushExample() 
		{		
			
			//Controll permissions↓
			var currentPermissions:String = StringFunctions.clearSpacesAndTabs(DevicePrefrence.appDescriptor) ;
			var requiredPermissionIos:String = "<key>application-identifier</key>\n" +
				"\t<string>??????????."+DevicePrefrence.appID+"</string>\n" +
				"<key>aps-environment</key>\n" +
				"\t<string>development</string><!--\"development\" for adhoc test, \"production\" for Appstore release-->\n" +
				"<key>get-task-allow</key> <true/> <!--Remove this line for Appstore release-->\n" +
				"<key>keychain-access-groups</key>\n" +
				"\t<array>\n" +
				"\t\t<string>??????????."+DevicePrefrence.appID+"</string> <!--Add team id-->\n" +
				"\t</array>";
			if(DevicePrefrence.isItPC && currentPermissions.indexOf("<key>application-identifier</key>")==-1)
			{
				throw "You have to add below permission on <iPhone><Entitlements>  <![CDATA[ \n\n\n"+requiredPermissionIos+'\n\n]]>\n\n' ;
			}
			//control android permission  :  <android> <manifestAdditions><![CDATA[ 
			var neceraryLines:String = '•' ;
			var targetSDK:uint = 22 ;
			var sdkTargetString:String = 'android:targetSdkVersion="' ;
			var minSDK:uint = 9 ;
			var sdkMinTargetString:String = 'android:minSdkVersion="' ;
			var indexOf:int ;
			if((indexOf = currentPermissions.indexOf(sdkMinTargetString))!=-1)
			{
				minSDK = uint(currentPermissions.substring(indexOf+sdkMinTargetString.length,currentPermissions.indexOf('"',indexOf+sdkMinTargetString.length)));
			}
			if((indexOf = currentPermissions.indexOf(sdkTargetString))!=-1)
			{
				targetSDK = uint(currentPermissions.substring(indexOf+sdkTargetString.length,currentPermissions.indexOf('"',indexOf+sdkTargetString.length)));
			}
			var androidPermission:String = neceraryLines+'<manifest android:installLocation="auto">\n' +
				'\t<uses-sdk android:minSdkVersion="'+minSDK+'" android:targetSdkVersion="'+targetSDK+'" />\n' +
				'\t<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>\n' +
				'\t<uses-permission android:name="android.permission.READ_PHONE_STATE"/>\n' +
				'\t<uses-permission android:name="android.permission.INTERNET"/>\n' +
				'\t<uses-permission android:name="android.permission.GET_ACCOUNTS"/>\n' +
				'\t<uses-permission android:name="android.permission.GET_TASKS"/>\n' +
				'\t<uses-permission android:name="android.permission.WAKE_LOCK"/>\n' +
				'\t<uses-permission android:name="android.permission.VIBRATE"/>\n' +
				'\t<permission android:name="air.'+DevicePrefrence.appID+'.permission.C2D_MESSAGE" android:protectionLevel="signature" />\n' +
				'\t<uses-permission android:name="air.'+DevicePrefrence.appID+'.permission.C2D_MESSAGE" />\n' +
				'\t<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />\n' +
				neceraryLines+'\t<application>\n' +
				neceraryLines+'\t\t<receiver android:name="com.milkmangames.extensions.android.push.GCMBroadcastReceiver" android:permission="com.google.android.c2dm.permission.SEND" >\n' +
				neceraryLines+'\t\t\t<intent-filter>\n' +
				'\t\t\t\t<action android:name="com.google.android.c2dm.intent.RECEIVE" />\n' +
				'\t\t\t\t<action android:name="com.google.android.c2dm.intent.REGISTRATION" />\n' +
				'\t\t\t\t<category android:name="air.'+DevicePrefrence.appID+'" />\n' +
				neceraryLines+'\t\t\t</intent-filter>\n' +
				neceraryLines+'\t\t</receiver>\n' +
				'\t\t<service android:name="com.milkmangames.extensions.android.push.GCMIntentService" />\n' +
				neceraryLines+'\t</application>\n' +
				neceraryLines+'</manifest>' ;
			
			var allAndroidPermission:Array = androidPermission.split('\n');
			var leftPermission:String = '' ;
			var androidManifestMustUpdate:Boolean = false ;
			for(var i:int = 0 ; i<allAndroidPermission.length ; i++)
			{
				var isNessesaryToShow:Boolean = isNessesaryLine(allAndroidPermission[i]) ;
				if(currentPermissions.indexOf(StringFunctions.clearSpacesAndTabs(removeNecessaryBoolet(allAndroidPermission[i])))==-1)
				{
					trace("permission not found : "+allAndroidPermission[i]);
					androidManifestMustUpdate = true ;
					leftPermission += removeNecessaryBoolet(allAndroidPermission[i])+'\n' ;
				}
				else if(isNessesaryToShow)
				{
					leftPermission += removeNecessaryBoolet(allAndroidPermission[i])+'\n' ;
				}
				else
				{
					//leftPermission += '-'+allAndroidPermission[i]+'\n' ;
				}
			}
			
			function isNessesaryLine(line:String):Boolean
			{
				return line.indexOf(neceraryLines)!=-1 ;
			}
			
			function removeNecessaryBoolet(line:String):String
			{
				return line.split(neceraryLines).join('') ;
			}
			
			if(DevicePrefrence.isItPC && androidManifestMustUpdate)
			{
				throw "Add bellow permission to <android> <manifestAdditions><![CDATA[\n\n\n"+leftPermission+"\n\n]]>\n\n"; 
			}
			//Controll permissions↑
			
			
			if (EasyPushClass==null || !(EasyPushClass as Object).isSupported())
			{
				log("EasyPush is not supported on this platform (not android or ios!)");
				return;
			}
			if (!(EasyPushClass as Object).areNotificationsAvailable())
			{
				log("Notifications are not available!");
				return;
			}
			
			log("Easy push created")
			
			if (!validateConstants()) return;
		
			setupOneSignal();
			
		}
		private function setupOneSignal():void
		{
			// onesignal mode
			trace('ONESIGNAL_APP_ID :',ONESIGNAL_APP_ID)
			trace('GCM_PROJECT_NUMBER :',GCM_PROJECT_NUMBER)
			log("init OneSignal...");
			try
			{
				(EasyPushClass as Object).initOneSignal(ONESIGNAL_APP_ID, GCM_PROJECT_NUMBER, autoAlertBox);
			}catch(e)
			{
				trace("Esy push >>>> "+e);
			}
			
			log("did init OneSignal.");
			(EasyPushClass as Object).oneSignal.addEventListener((PNOSEventClass as Object).ALERT_DISMISSED,onAlertDismissed);
			(EasyPushClass as Object).oneSignal.addEventListener((PNOSEventClass as Object).FOREGROUND_NOTIFICATION,onForegroundNotification);
			(EasyPushClass as Object).oneSignal.addEventListener((PNOSEventClass as Object).RESUMED_FROM_NOTIFICATION,onNotification);
			(EasyPushClass as Object).oneSignal.addEventListener((PNOSEventClass as Object).TOKEN_REGISTERED,onTokenRegistered);
			(EasyPushClass as Object).oneSignal.addEventListener((PNOSEventClass as Object).TOKEN_REGISTRATION_FAILED,onRegFailed);
			tryeToConnectNotificationRegister()
		}
		private function validateConstants():Boolean
		{
			
			if (ONESIGNAL_APP_ID=='')
			{
				log("You did not put your onesignal id in EasyPushExample.as.");
				return false;
			}
			if (GCM_PROJECT_NUMBER=='')
			{
				log("WARNING: won't work on android until id set in EasyPushExample.as.");
				return true;
			}
			return true;
		}
		/////////////////////event
		//com.milkmangames.nativeextensions.events.PNEvent
		private function onTokenRegistered(e:*):void
		{
			log("token registered:"+e.token);
			token = e.token;
			this.dispatchEvent(new NotificationEvent (NotificationEvent.TOKEN_REGISTER_COMPELETED,pnEvent(e)))
			clearTimeout(_timeOutId)	
		} 
		
		//com.milkmangames.nativeextensions.events.PNEvent
		private function onRegFailed(e:*):void
		{
			log("reg failed: "+e.errorId+"="+e.errorMsg);
			loop()
		}
		private function loop():void
		{
			clearTimeout(_timeOutId)
			_timeOutId = setTimeout(setupOneSignal,5000)
		}
		//com.milkmangames.nativeextensions.events.PNEvent
		private function onAlertDismissed(e:*):void
		{
			log("dismissed alert "+e.alert);
			loop()
		}
		
		//com.milkmangames.nativeextensions.events.PNEvent
		private function onNotification(e:*):void
		{
			log(e.type+"="+e.rawPayload+","+e.badgeValue+","+e.title+" customPayload : "+e.customPayload+" : "+JSON.stringify(e.customPayload,null,' '));	
			this.dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFICATION,pnEvent(e),false,false,e.customPayload))
		}
		
		//com.milkmangames.nativeextensions.events.PNEvent
		private function onForegroundNotification(e:*):void
		{
			log(e.type+"="+e.rawPayload+","+e.badgeValue+","+e.title+" customPayload : "+e.customPayload+" : "+JSON.stringify(e.customPayload,null,' '));	
			this.dispatchEvent(new NotificationEvent(NotificationEvent.FOREGROUND_NOTIFICATION,pnEvent(e),false,false,e.customPayload))
		}
		
		///////////////////end event
		private function log(msg:String):void
		{
			trace("[Push Notificatoni]"+msg);
		}
		
		//com.milkmangames.nativeextensions.events.PNEvent
		private function pnEvent(e:*):PNEventManager
		{
			var _pnEvnet:PNEventManager = new PNEventManager()
			_pnEvnet.alert = e.alert
			_pnEvnet.badgeValue = e.badgeValue
			_pnEvnet.errorId = e.errorId
			_pnEvnet.errorMsg = e.errorMsg
			_pnEvnet.rawPayload = e.rawPayload
			_pnEvnet.customPayload = e.customPayload
			_pnEvnet.title = e.title
			_pnEvnet.token = e.token
			_pnEvnet.type = e.type	
			return _pnEvnet	
		}
		private function tryeToConnectNotificationRegister():void
		{
			this.dispatchEvent(new NotificationEvent(NotificationEvent.TOKEN_REGISTER_START))
		}

	}
}
