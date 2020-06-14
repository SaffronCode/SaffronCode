package nativeClasses {

    /*import com.distriqt.extension.share.applications.Application;

       import com.distriqt.extension.share.applications.ApplicationOptions;
       import com.distriqt.extension.share.applications.Intent;*/
    //import contents.alert.Alert;
    // import com.distriqt.extension.share.events.ApplicationEvent;
    // import com.distriqt.extension.share.Share;
    //	import com.distriqt.extension.share.applications.Application;
    //	import com.distriqt.extension.share.applications.ApplicationOptions;

    import flash.display.BitmapData;
    import flash.filesystem.File;
    import flash.utils.getDefinitionByName;
    import contents.alert.Alert;

    public class Sharing {
        private var shareClass:Class, shareOptionClass:Class, shareEventClass:Class;

        private var _isSupports:Boolean = false;

        private var _isClassesLoaded:Boolean = false;

        /**import com.distriqt.extension.share.applications.Application;*/
        private var ApplicationClass:Class;
        /**import com.distriqt.extension.share.applications.ApplicationOptions;*/
        private var ApplicationOptionsClass:Class;
        /**com.distriqt.extension.share.applications.Intent*/
        private var IntentClass:Class;

        /** import com.distriqt.extension.share.events.ApplicationEvent*/
        private var ApplicationEventClass:Class;

        private var _addStoreMarket:Boolean = true;

        /**You have to call setUp function first*/
        public function isSupports():Boolean {
            return _isSupports;
        }

        public function isNativeLoaded():Boolean {
            return _isClassesLoaded;
        }

        /**Share this text*/
        public function shareText(str:String, downloadLinkLable:String = '', imageBirmapData:BitmapData = null):void {
            var sharedString:String;
            if (_addStoreMarket == true)
                sharedString = str + '\n\n' + DevicePrefrence.appName + '\n' + downloadLinkLable + '\n' + ((DevicePrefrence.downloadLink_iOS == '') ? '' : 'Apple Store: ' + DevicePrefrence.downloadLink_iOS + '\n\n') + ((DevicePrefrence.downloadLink_playStore == '') ? '' : 'Android Play Store: ' + DevicePrefrence.downloadLink_playStore + '\n\n') + ((DevicePrefrence.downloadLink_cafeBazar == '') ? '' : 'کافه بازار: ' + DevicePrefrence.downloadLink_cafeBazar + '\n\n') + ((DevicePrefrence.downloadLink_myketStore == '') ? '' : 'مایکت: ' + DevicePrefrence.downloadLink_myketStore);
            else
                sharedString = str + '\n\n' + downloadLinkLable;
            SaffronLogger.log("•distriqt• sharedString : " + sharedString);
            if (isSupports()) {
                var options:* = new shareOptionClass();
                options.title = "Share with ...";
                options.showOpenIn = true;
                SaffronLogger.log("•distriqt• Call the share function");
                shareClass.service.share(sharedString, imageBirmapData, '', options);
            } else {
                SaffronLogger.log("•distriqt• Share is not support here");
            }
        }

        /**Share this text*/
        public function openFile(yourFile:File, fileName:String = ''):String {
            fileName = fileName == '' ? yourFile.name : fileName;

            if (isSupports()) {
                var options:* = new shareOptionClass();
                options.title = "Open with ...";
                options.showOpenIn = true;
                //'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                shareClass.service.showOpenIn(yourFile.nativePath, fileName, null, options);
                return 'Open done';
            } else {
                return "Open file not support";
            }
        }

        /**You have to call Setup function to make it work*/
        public function Sharing() {
        }

        /**If your code was wrong, it will throw an error*/
        public function setUp(APP_KEY:String = ""):void {
            DevicePrefrence.createDownloadLink();
            try {
                shareClass = getDefinitionByName("com.distriqt.extension.share.Share") as Class;
                shareOptionClass = getDefinitionByName("com.distriqt.extension.share.ShareOptions") as Class;
                shareEventClass = getDefinitionByName("com.distriqt.extension.share.events.ShareEvent") as Class;
                IntentClass = getDefinitionByName("com.distriqt.extension.share.applications.Intent") as Class;
                ApplicationClass = getDefinitionByName("com.distriqt.extension.share.applications.Application") as Class;
                ApplicationOptionsClass = getDefinitionByName("com.distriqt.extension.share.applications.ApplicationOptions") as Class;
                ApplicationEventClass = getDefinitionByName("com.distriqt.extension.share.events.ApplicationEvent") as Class

                if (shareClass != null) {
                    _isClassesLoaded = true;
                }
            } catch (e) {
                SaffronLogger.log('Add \n\n\t<extensionID>com.distriqt.Share</extensionID>\n\t<extensionID>com.distriqt.Core</extensionID>\n\n to your project xmls'); // and below permitions to the <application> tag : \n\n<activity \n\n\tandroid:name="com.distriqt.extension.share.activities.ShareActivity" \n\n\tandroid:theme="@android:style/Theme.Translucent.NoTitleBar" />\n\n\t\n\n<provider\n\n\tandroid:name="android.support.v4.content.FileProvider"\n\n\tandroid:authorities="air.'+DevicePrefrence.appID+'"\n\n\tandroid:grantUriPermissions="true"\n\n\tandroid:exported="false">\n\n\t<meta-data\n\n\t\tandroid:name="android.support.FILE_PROVIDER_PATHS"\n\n\t\tandroid:resource="@xml/distriqt_paths" />\n\n</provider>';
            }
            try {
                SaffronLogger.log("•distriqt• Set the Share key : " + APP_KEY);

                (getDefinitionByName("com.distriqt.extension.core.Core") as Object).init(APP_KEY);
                (shareClass as Object).init(APP_KEY);

                shareClass.service.addEventListener(shareEventClass.COMPLETE, share_shareHandler, false, 0, true);
                shareClass.service.addEventListener(shareEventClass.CANCELLED, share_shareHandler, false, 0, true);
                shareClass.service.addEventListener(shareEventClass.FAILED, share_shareHandler, false, 0, true);
                shareClass.service.addEventListener(shareEventClass.CLOSED, share_shareHandler, false, 0, true);

                if (shareClass.isSupported) {
                    //	Functionality here
                    SaffronLogger.log("•distriqt• Share is support");
                    _isSupports = true;
                } else {
                    SaffronLogger.log("•distriqt• Share is not supports");
                    _isSupports = false;
                }

                    // Copy the application packaged files to an accessible location (only needed on Android but works on both)	
                /*var packagedAssets:File = File.applicationDirectory.resolvePath( "assets" );
                   var accessibleAssets:File = File.applicationStorageDirectory.resolvePath( "assets" );
                   if (accessibleAssets.exists)
                   accessibleAssets.deleteDirectory(true);
                   if(packagedAssets.exists)
                   packagedAssets.copyTo( accessibleAssets, true );*/
            } catch (e:Error) {
                // Check if your APP_KEY is correct
                SaffronLogger.log("The district app id is wrong!! get a new one for this id (" + DevicePrefrence.appID + ") from : airnativeextensions.com/user/2299/applications\n\n\n" + e);
                _isSupports = false;
            }
        }

        private function share_shareHandler(event:*):void {
            SaffronLogger.log(event.type + "::" + event.activityType + "::" + event.error);
        }

        /*public function openApp(PackageName:String,Url:URLVariables)
           {
           if (shareClass.isSupported)
           {
           var app:* = new ApplicationClass(PackageName,"");

           if (shareClass.service.applications.isInstalled(app))
           {
           var options:* = new ApplicationOptionsClass();
           //options.action = ApplicationOptions.ACTION_SEND;
           //options.data = "http://instagram.com/_u/distriqt";
           options.parameters = Url.toString();
           shareClass.service.applications.launch(app,options);
           }
           }
           }*/

        /**https://distriqt.github.io/ANE-Share/u.Launch%20Applications*/
        public function openApp(PackageName:String, Type:String = "*/*", Extras:Object = null, URL:String = '', Intent:String = 'ACTION_MAIN', Parameters:String = ''):void {
            if (_isSupports) {
                var app:* = new ApplicationClass(PackageName, URL);
                if (shareClass.service.applications.isInstalled(app)) {
                    var options:* = new ApplicationOptionsClass();
                    switch (Intent) {
                        case "ACTION_MAIN":
                            options.action = ApplicationOptionsClass.ACTION_MAIN;
                            break;
                        case "ACTION_SEND":
                            options.action = ApplicationOptionsClass.ACTION_SEND;
                            break;
                        case "ACTION_SENDTO":
                            options.action = ApplicationOptionsClass.ACTION_SENDTO;
                            break;
                        case "ACTION_VIEW":
                            options.action = ApplicationOptionsClass.ACTION_VIEW;
                            break;
                    }
                    //Any extras you wish to send to the application. Common examples are "text", "subject", see the Android documentation for more: http://developer.android.com/reference/android/content/Intent.html
                    options.data = Extras;
                    //This is passed as the type of the intent to start on Android. This can be used to set the mime type of the data passed to the intent.
                    options.type = Type;

                    options.parameters = Parameters;

                    shareClass.service.applications.launch(app, options);
                }
            }
        }

        public function existApp(PackageName:String):Boolean {
            if (_isSupports) {
                var app:* = new ApplicationClass(PackageName, "");
                if (shareClass.service.applications.isInstalled(app)) {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }

        /**open and send data to an intetnt of applicatios
         * @param intent  like com.bpmellat.merchant
         * @param extras send object data to chnage as json file(like {PaymentData: JSON.stringify(extras)})
         * */
        public function openIntent(intentAddress:String, extras:Object = null, onResult:Function = null):* {
            if (IntentClass == null) {
                SaffronLogger.log("********************\nopenIntent Error!!!\n You should call the setUp method first");
                return false;
            }

            var intent:* = new IntentClass(intentAddress);
            intent.extras = extras;
            if (onResult != null)
                shareClass.service.applications.addEventListener(ApplicationEventClass.ACTIVITY_RESULT, activityResultHandler);

            function activityResultHandler(event:*):void {
                if (event.data)
                    onResult(event.data);
            }

            return shareClass.service.applications.startActivity(intent);
        }


        public function set addStoreMarket(addStore:Boolean):void {
            _addStoreMarket = addStore
        }

    }
}
