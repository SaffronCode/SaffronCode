package nativeClasses
{
	
	import com.distriqt.extension.share.applications.Application;
	import com.distriqt.extension.share.applications.ApplicationOptions;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.net.URLVariables;
	import flash.utils.getDefinitionByName;

	public class Sharing
	{
		private var shareClass:Class,
					shareOptionClass:Class,
					shareEventClass:Class;
		
		private var _isSupports:Boolean = false ;
		
		private var _isClassesLoaded:Boolean = false ;
		
		
		/**You have to call setUp function first*/
		public function isSupports():Boolean
		{
			return _isSupports; 
		}
		
		public function isNativeLoaded():Boolean
		{
			return _isClassesLoaded ;
		}
		
		/**Share this text*/
		public function shareText(str:String,downloadLinkLable:String='',imageBirmapData:BitmapData=null):void
		{
			var sharedString:String = str+'\n\n'+DevicePrefrence.appName+'\n'+downloadLinkLable+'\n'
				+((DevicePrefrence.downloadLink_iOS=='')?'':'Apple Store: '+DevicePrefrence.downloadLink_iOS+'\n\n')
				+((DevicePrefrence.downloadLink_playStore=='')?'':'Android Play Store: '+DevicePrefrence.downloadLink_playStore+'\n\n')
				+((DevicePrefrence.downloadLink_cafeBazar=='')?'':'کافه بازار: '+DevicePrefrence.downloadLink_cafeBazar+'\n\n')
				+((DevicePrefrence.downloadLink_myketStore=='')?'':'مایکت: '+DevicePrefrence.downloadLink_myketStore);
			trace("•distriqt• sharedString : "+sharedString);
			if(isSupports())
			{
				var options:* = new shareOptionClass();
				options.title = "Share with ...";
				options.showOpenIn = true;
				trace("•distriqt• Call the share function");
				shareClass.service.share(sharedString,imageBirmapData,'',options);
			}
			else
			{
				trace("•distriqt• Share is not support here");
			}
		}
		
		/**Share this text*/
		public function openFile(yourFile:File,fileName:String=''):String
		{
			fileName = fileName==''?yourFile.name:fileName ;
			
			if(isSupports())
			{
				var options:* = new shareOptionClass();
				options.title = "Open with ...";
				options.showOpenIn = true;
				//'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
				shareClass.service.showOpenIn(yourFile.nativePath,fileName,null,options);
				return 'Open done' ;
			}
			else
			{
				return "Open file not support" ;
			}
		}
		
		/**You have to call Setup function to make it work*/
		public function Sharing()
		{
		}
		
		/**If your code was wrong, it will throw an error*/
		public function setUp(APP_KEY:String):void
		{
			DevicePrefrence.createDownloadLink();
			try
			{
				shareClass = getDefinitionByName("com.distriqt.extension.share.Share") as Class ;
				shareOptionClass = getDefinitionByName("com.distriqt.extension.share.ShareOptions") as Class ;
				shareEventClass = getDefinitionByName("com.distriqt.extension.share.events.ShareEvent") as Class ;
				
				if(shareClass!=null)
				{
					_isClassesLoaded = true ;
				}
			}
			catch(e)
			{
				trace('Add \n\n\t<extensionID>com.distriqt.Share</extensionID>\n\t<extensionID>com.distriqt.Core</extensionID>\n\n to your project xmls');// and below permitions to the <application> tag : \n\n<activity \n\n\tandroid:name="com.distriqt.extension.share.activities.ShareActivity" \n\n\tandroid:theme="@android:style/Theme.Translucent.NoTitleBar" />\n\n\t\n\n<provider\n\n\tandroid:name="android.support.v4.content.FileProvider"\n\n\tandroid:authorities="air.'+DevicePrefrence.appID+'"\n\n\tandroid:grantUriPermissions="true"\n\n\tandroid:exported="false">\n\n\t<meta-data\n\n\t\tandroid:name="android.support.FILE_PROVIDER_PATHS"\n\n\t\tandroid:resource="@xml/distriqt_paths" />\n\n</provider>';
			}
			try
			{
				trace("•distriqt• Set the Share key : "+APP_KEY);
				
				(getDefinitionByName("com.distriqt.extension.core.Core") as Object).init(APP_KEY);
				(shareClass as Object).init( APP_KEY );
				
				shareClass.service.addEventListener( shareEventClass.COMPLETE,	share_shareHandler, false, 0, true );
				shareClass.service.addEventListener( shareEventClass.CANCELLED,	share_shareHandler, false, 0, true );
				shareClass.service.addEventListener( shareEventClass.FAILED,  	share_shareHandler, false, 0, true );
				shareClass.service.addEventListener( shareEventClass.CLOSED,  	share_shareHandler, false, 0, true );
				
				if (shareClass.isSupported)
				{
					//	Functionality here
					trace("•distriqt• Share is support");
					_isSupports = true ;
				}
				else
				{
					trace("•distriqt• Share is not supports");
					_isSupports = false ;
				}
				
				// Copy the application packaged files to an accessible location (only needed on Android but works on both)	
				/*var packagedAssets:File = File.applicationDirectory.resolvePath( "assets" );
				var accessibleAssets:File = File.applicationStorageDirectory.resolvePath( "assets" );
				if (accessibleAssets.exists) 
					accessibleAssets.deleteDirectory(true);
				if(packagedAssets.exists)
					packagedAssets.copyTo( accessibleAssets, true );*/
			}
			catch (e:Error)
			{
				// Check if your APP_KEY is correct
				trace("The district app id is wrong!! get a new one for this id ("+DevicePrefrence.appID+") from : airnativeextensions.com/user/2299/applications\n\n\n"+e) ;
				_isSupports = false ;
			}
		}
		
		
		
		
		private function share_shareHandler( event:* ):void
		{
			trace( event.type + "::" + event.activityType + "::" + event.error );
		}
		
		public function openApp(PackageName:String,Url:URLVariables)
		{
			if (shareClass.isSupported)
			{
				var app:Application = new Application(PackageName,"");
					
					if (shareClass.service.applications.isInstalled(app))
					{
						var options:ApplicationOptions = new ApplicationOptions();
						//options.action = ApplicationOptions.ACTION_SEND;
						//options.data = "http://instagram.com/_u/distriqt";
						options.parameters = Url.toString();
						shareClass.service.applications.launch(app,options);
					}
				}
		}
	}
}