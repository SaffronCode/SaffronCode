package nativeClasses.map
{
	import com.distriqt.extension.nativemaps.NativeMaps;
	import com.mteamapp.StringFunctions;
	
	import flash.display.Sprite;
	
	public class DistriqtGoogleMap extends Sprite
	{
		private static var api_key:String ;
		
		private static var isSupports:Boolean = false ;
		
		public static function setUp(GoogleAPIKey:String,DistriqtId:String):void
		{
			api_key = GoogleAPIKey ;
			
			trace("*******************\n\n\n\n\nYou have to add below ane files to your project : \n	com.distriqt.androidsupport.V4.ane\n" +
				"com.distriqt.Core.ane\n" +
				"com.distriqt.GooglePlayServices.ane\n" +
				"com.distriqt.NativeMaps.ane\n" +
				"com.distriqt.playservices.Base.ane\n" +
				"com.distriqt.playservices.Maps.ane\n\n\n" +
				"And aloso controll your permission on Android manifest:\n\n" +
				'<manifest android:installLocation="auto">\n' +
				'\t<uses-sdk android:minSdkVersion="12" android:targetSdkVersion="24" />\n' +
				'\t<uses-permission android:name="android.permission.INTERNET"/>\n' +
				'\t<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>\n' +
				'\t<uses-permission android:name="android.permission.READ_PHONE_STATE"/>\n' +
				'\t<uses-permission android:name="android.permission.DISABLE_KEYGUARD"/>\n' +
				'\t<uses-permission android:name="android.permission.WAKE_LOCK"/>\n' +
				'\t<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>\n' +
				'\t<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>\n' +
				'\t<uses-permission android:name="com.google.android.providers.gsf.permission.READ_GSERVICES"/>\n' +
				'\t<uses-permission android:name="'+DevicePrefrence.appID+'.permission.MAPS_RECEIVE" android:protectionLevel="signature"/>\n' +
				'\t<uses-feature android:glEsVersion="0x00020000" android:required="true"/>\n' +
				'\t<application>\n' +
				'\t\t<meta-data android:name="com.google.android.geo.API_KEY" android:value="'+api_key+'" />\n' +
				'\t\t<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />\n' +
				'\t\t<activity android:name="com.distriqt.extension.nativemaps.permissions.AuthorisationActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar" />\n' +
				'\t</application>\n' +
				'</manifest>\n\n\n\n\n\n\n' +
				"*******************");
			
			var descriptString:String = StringFunctions.clearSpacesAndTabs(DevicePrefrence.appDescriptor.toString()) ; 
			if(descriptString.indexOf("permission.MAPS_RECEIVE")!=-1 && descriptString.indexOf(DevicePrefrence.appID+".permission.MAPS_RECEIVE")==-1)
			{
				throw "Your Manifest is absolutly wrong!! controll the example";
			}
			
			try
			{
				NativeMaps.init( DistriqtId );
				if (NativeMaps.isSupported)
				{
					isSupports = true ;
				}
			}
			catch (e:Error)
			{
				trace("e>>>"+ e );
				isSupports = false ;
			}
		}
		
		public function DistriqtGoogleMap()
		{
			super();
		}
	}
}