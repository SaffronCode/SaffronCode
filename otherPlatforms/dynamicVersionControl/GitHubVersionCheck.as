package otherPlatforms.dynamicVersionControl
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;

	public class GitHubVersionCheck
	{
		/**Set an online link for the application manifest like below:<br>
		 * https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/src/AppGenerator-app.xml*/
		public static function compairVersionWithOnline(applicationManifestOnline:String,needToUpdateFunction:Function):void
		{
			var urlLoader:URLLoader = new URLLoader(new URLRequest(applicationManifestOnline+"?"+new Date().time));
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT ;
			urlLoader.addEventListener(Event.COMPLETE,function(e){
				var versionPart:Array = String(urlLoader.data).match(/<versionNumber>.*<\/versionNumber>/gi);
				if(versionPart.length>0)
				{
					versionPart[0] = String(versionPart[0]).split('<versionNumber>').join('').split('</versionNumber>').join('');
					SaffronLogger.log("version loaded : "+versionPart[0]+' > '+(DevicePrefrence.appVersion==versionPart[0]));
					SaffronLogger.log("DevicePrefrence.appVersion : "+DevicePrefrence.appVersion);
					if(!(DevicePrefrence.appVersion==versionPart[0]))
					{
						SaffronLogger.log("Update Needed!");
						needToUpdateFunction();
					}
				}
			});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(e){SaffronLogger.log("Online manifest load faild")});
		}
		
		/**set the installer file from the web to the parameter and wait, it will launch your application installer automaticaly after the download completed.<br>
		 * Online app sample : https://github.com/SaffronCode/Adobe-Air-Assistant/raw/master/build/AppGenerator.air<br>
		 * the downloadProgress will send you the progress precent between 0 to 1.*/
		public static function dowloadInstallerAndLaunch(installerFileURL:String,downloadProgress:Function=null,applicationDowloaded:Function=null):void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(installerFileURL));
			loader.dataFormat = URLLoaderDataFormat.BINARY ;
			
			loader.addEventListener(Event.COMPLETE,loaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR,function(e){});
			
			if(downloadProgress!=null)
			{
				downloadProgress(0);
				loader.addEventListener(ProgressEvent.PROGRESS,progress);
			}
			
			function progress(e:ProgressEvent):void
			{
				downloadProgress(Math.round((e.bytesLoaded/e.bytesTotal)*100));
			}
			
			function loaded(e:Event):void
			{
				var fileTarget:File = File.createTempDirectory().resolvePath(installerFileURL.substring(installerFileURL.lastIndexOf('/')+1)) ;
				FileManager.seveFile(fileTarget,loader.data);
				
				fileTarget.openWithDefaultApplication();
				
				if(applicationDowloaded!=null)
				{
					applicationDowloaded();
				}
				
				setTimeout(function(e){
					NativeApplication.nativeApplication.exit();
				},2000);
			}
				
		}
	}
}