package nativeClasses.pushNotification {
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
    import contents.alert.Alert;

    //import com.distriqt.extension.pushnotifications.events.PushNotificationEvent;
    //import com.distriqt.extension.pushnotifications.events.PushNotificationGroupEvent;
    /**
     * ...
     * @author Younes Mashayekhi
     */
    public class DistriqtPushNotification {
        public static var deviceToken:String;
        private static var CoreClass:Class;
        private static var AuthorisationStatusClass:Class;
        private static var PushNotificationsClass:Class;
        private static var ServiceClass:Class;
        private static var ActionBuilderClass:Class;
        private static var CategoryBuilderClass:Class;
        private static var ChannelBuilderClass:Class;
        private static var AuthorisationEventClass:Class;
        private static var RegistrationEventClass:Class;
        private static var InAppMessagingEventClass:Class;
        /**com.distriqt.extension.pushnotifications.events.PushNotificationEvent */
        private static var PushNotificationEventClass:Class;
        /**com.distriqt.extension.pushnotifications.events.PushNotificationGroupEvent */
        private static var PushNotificationGroupEventClass:Class;


        private static var NotifReceived:Function;
        private static var InAppMsgRecevied:Function;

        public function DistriqtPushNotification() {

        }

        private static function loadClasses():void {
            if (PushNotificationsClass == null) {
                try {
                    CoreClass = getDefinitionByName("com.distriqt.extension.core.Core") as Class;
                    AuthorisationStatusClass = getDefinitionByName("com.distriqt.extension.pushnotifications.AuthorisationStatus") as Class;
                    PushNotificationsClass = getDefinitionByName("com.distriqt.extension.pushnotifications.PushNotifications") as Class;
                    ServiceClass = getDefinitionByName("com.distriqt.extension.pushnotifications.Service") as Class;
                    ActionBuilderClass = getDefinitionByName("com.distriqt.extension.pushnotifications.builders.ActionBuilder") as Class;
                    CategoryBuilderClass = getDefinitionByName("com.distriqt.extension.pushnotifications.builders.CategoryBuilder") as Class;
                    ChannelBuilderClass = getDefinitionByName("com.distriqt.extension.pushnotifications.builders.ChannelBuilder") as Class;
                    AuthorisationEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.AuthorisationEvent") as Class;
                    RegistrationEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.RegistrationEvent") as Class;
                    PushNotificationEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.PushNotificationEvent") as Class;
                    PushNotificationGroupEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.PushNotificationGroupEvent") as Class;
                    InAppMessagingEventClass = getDefinitionByName("com.distriqt.extension.pushnotifications.events.InAppMessagingEvent") as Class;
                    SaffronLogger.log("RegistrationEventClass : " + RegistrationEventClass);
                } catch (e) {
                    SaffronLogger.log('Add \n\n\t<extensionID>com.distriqt.PushNotification</extensionID>\n\t<extensionID>com.distriqt.Core</extensionID>\n\n to your project xmls'); // and below permitions to the <application> tag : \n\n<activity \n\n\tandroid:name="com.distriqt.extension.share.activities.ShareActivity" \n\n\tandroid:theme="@android:style/Theme.Translucent.NoTitleBar" />\n\n\t\n\n<provider\n\n\tandroid:name="android.support.v4.content.FileProvider"\n\n\tandroid:authorities="air.'+DevicePrefrence.appID+'"\n\n\tandroid:grantUriPermissions="true"\n\n\tandroid:exported="false">\n\n\t<meta-data\n\n\t\tandroid:name="android.support.FILE_PROVIDER_PATHS"\n\n\t\tandroid:resource="@xml/distriqt_paths" />\n\n</provider>';
                }
            }
        }

        public static function isSupport():Boolean {
            loadClasses();
            if (PushNotificationsClass == null || PushNotificationsClass.isSupported == false)
                return false
            else
                return true;
        }

        /**
         * You can receive server data on onNotifReceived & onInAppMsgRecevied function as a String
         * @param onResult
         * @param onNotifReceived
         * @param onInAppMsgRecevied
         */
        public static function setup(onResult:Function = null, onNotifReceived:Function = null, onInAppMsgRecevied:Function = null):void {
            NotifReceived = onNotifReceived;
            InAppMsgRecevied = onInAppMsgRecevied;
            var PushNotifications:Object;
            loadClasses();
            if (onResult == null) {
                onResult = function(text:String):void {
                    //show registration ID :
                    SaffronLogger.log(text);
                }
            }
            if (PushNotificationsClass == null) {
                SaffronLogger.log("push notification is null");
                deviceToken = "windowsDebug";
                onResult(deviceToken);
                return;
            }
            try {
                (CoreClass as Object).init();
                if (PushNotificationsClass.isSupported) {
                    SaffronLogger.log("Push Notification supported")
                    if ((PushNotificationsClass as Object).service.isServiceSupported((ServiceClass as Object).FCM)) {
                        var service:* = new ServiceClass((ServiceClass as Object).FCM, "");
                        service.sandboxMode = true; // false it in production mode!!!
                        service.setNotificationsWhenActive(true);
                        service.categories.push(new CategoryBuilderClass().setIdentifier("MESSAGE_CATEGORY").addAction(new ActionBuilderClass().setTitle("OK").setWillLaunchApplication(true).setIdentifier("OPEN_APP_BTN").build()).addAction(new ActionBuilderClass().setTitle("Cancel").setDestructive(true).setShouldCancelOnAction(true).setIdentifier("CANCEL_APP_BTN").build()).build());
                        service.channels.push(new ChannelBuilderClass().setId("app_channel").setName("App Channel").build());
                        (PushNotificationsClass as Object).service.addEventListener((RegistrationEventClass as Object).REGISTERING, registeringHandler);
                        (PushNotificationsClass as Object).service.addEventListener((RegistrationEventClass as Object).REGISTER_SUCCESS, registerSuccessHandler);
                        (PushNotificationsClass as Object).service.addEventListener((RegistrationEventClass as Object).CHANGED, registrationChangedHandler);
                        (PushNotificationsClass as Object).service.addEventListener((RegistrationEventClass as Object).REGISTER_FAILED, registerFailedHandler);
                        (PushNotificationsClass as Object).service.addEventListener((RegistrationEventClass as Object).ERROR, errorHandler);
                        (PushNotificationsClass as Object).service.addEventListener((AuthorisationEventClass as Object).CHANGED, authorisationChangedHandler);
                        (PushNotificationsClass as Object).service.addEventListener((PushNotificationEventClass as Object).NOTIFICATION, notificationHandler);
                        (PushNotificationsClass as Object).service.addEventListener((PushNotificationEventClass as Object).NOTIFICATION_SELECTED, notificationHandler);
                        (PushNotificationsClass as Object).service.addEventListener((PushNotificationEventClass as Object).ACTION, actionHandler);
                        (PushNotificationsClass as Object).service.addEventListener((PushNotificationGroupEventClass as Class).GROUP_SELECTED, groupSelectedHandler);
                        (PushNotificationsClass as Object).service.setup(service);
                        requestAuthorisation();
                        function registeringHandler(event:*):void {
                            SaffronLogger.log("Registration started");
                        }

                        function registerSuccessHandler(event:*):void {
                            SaffronLogger.log("Registration succeeded with ID: " + event.data);
                            deviceToken = event.data;
                            onResult(event.data);
                        }

                        function registrationChangedHandler(event:*):void {
                            SaffronLogger.log("Registration ID has changed: " + event.data);
                            deviceToken = event.data;
                            onResult(event.data);
                        }

                        function registerFailedHandler(event:*):void {
                            SaffronLogger.log("Registration failed");
                            // onResult("Registration failed");
                        }

                        function errorHandler(event:*):void {
                            SaffronLogger.log("Registration error: " + event.data);
                            // onResult("Registration error");
                        }

                    } else {
                        SaffronLogger.log("fcm notification is not support");
                            // onResult("FCM Not Support");
                    }
                } else {
                    SaffronLogger.log("notification is not support");
                        // onResult("windows Debug");
                }
            } catch (e:Error) {
                SaffronLogger.log("ERROR:" + e.message);
                    // onResult("error occured");
            }
        }


        private static function notificationHandler(event:*):void {
            SaffronLogger.log("Notification: [" + event.type + "] state=" + event.applicationState + " startup=" + event.startup);
            SaffronLogger.log(event.payload); //{"google.delivered_priority":"high","TypeId":"2","google.ttl":2419200,"google.original_priority":"high","Id":"2096"}
            SaffronLogger.log(">>Complete data : " + JSON.stringify(event));
            if (NotifReceived != null) {
                if (JSON.stringify(event.payload).length > 0) {
                    NotifReceived(event.payload);
                } else {
                    NotifReceived();
                }
            }
        }

        private static function actionHandler(event:*):void {
            SaffronLogger.log("Action: [" + event.type + "] identifier=" + event.identifier + " state=" + event.applicationState + " startup=" + event.startup);
            SaffronLogger.log(event.payload);
            SaffronLogger.log(">>Complete data : " + JSON.stringify(event));
        }

        private static function groupSelectedHandler(event:*):void {
            SaffronLogger.log("Group Selected: [" + event.type + "] groupKey=" + event.groupKey + " state=" + event.applicationState + " startup=" + event.startup);
            for each (var payload:String in event.payloads) {
                SaffronLogger.log("PAYLOAD: " + payload);
            }
            SaffronLogger.log(">>Complete data : " + JSON.stringify(event));
        }

        public static function setupInAppMessaging():void {
            // call this function after a few second after setup pushnotification
            if (PushNotificationsClass == null) {
                //windowsDebug;
                return;
            }
            if ((PushNotificationsClass as Object).service.inAppMessaging.isSupported) {
                (PushNotificationsClass as Object).service.inAppMessaging.addEventListener((InAppMessagingEventClass as Object).SELECTED, inappmessaging_selectedHandler);
                 Alert.show("InAppMessaging SUPPORTED")
            } else {
                Alert.show("InAppMessaging NOT SUPPORTED")
            }
        }

        public static function setTriggerForInAppMessaging(key:String, value:String = ""):void {
            //at first,you must call setupInAppMessaging method
            if (PushNotificationsClass == null) {
                //windowsDebug;
                return;
            }
            (PushNotificationsClass as Object).service.inAppMessaging.addTrigger(key, value);
        }

        private static function inappmessaging_selectedHandler(event:*):void {
            if (InAppMsgRecevied != null) {
                if (JSON.stringify(event.data).length > 0) {
                    InAppMsgRecevied(JSON.stringify(event.data));
                } else {
                    InAppMsgRecevied();
                }
            }
        }
        
        private static function authorisationChangedHandler(e:*):void {
            requestAuthorisation();
        }

        private static function requestAuthorisation(e:* = null):void {
            switch ((PushNotificationsClass as Object).service.authorisationStatus()) {
                case (AuthorisationStatusClass as Object).AUTHORISED:
                    // This device has been authorised. 
                    // You can register this device and expect: 
                    //  - registration success/failed event, and;  
                    //  - notifications to be displayed 
                    (PushNotificationsClass as Object).service.register();
                    break;

                case (AuthorisationStatusClass as Object).NOT_DETERMINED:
                    // You are yet to ask for authorisation to display notifications 
                    // At this point you should consider your strategy to get your user to authorise 
                    // notifications by explaining what the application will provide 
                    (PushNotificationsClass as Object).service.requestAuthorisation();
                    break;

                case (AuthorisationStatusClass as Object).DENIED:
                    // The user has disabled notifications 
                    // Advise your user of the lack of notifications as you see fit 

                    // For example: You can redirect to the settings page on iOS 
                    if ((PushNotificationsClass as Object).service.canOpenDeviceSettings) {
                        //PushNotifications.service.openDeviceSettings();
                    }
                    break;
            }
        }

    }

}
