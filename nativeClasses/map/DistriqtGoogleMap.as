package nativeClasses.map
{
	import com.distriqt.extension.nativemaps.AuthorisationStatus;
	import com.distriqt.extension.nativemaps.NativeMaps;
	import com.distriqt.extension.nativemaps.objects.MapType;
	import com.mteamapp.StringFunctions;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class DistriqtGoogleMap extends Sprite
	{
		private static var api_key:String ;
		
		private static var isSupports:Boolean = false ;
		
		private static var mapInitialized:Boolean = false ;
		
		private static var 	scl:Number = 0,
							deltaX:Number,
							deltaY:Number;
		
		private var mapCreated:Boolean = false ;
		
		private var I:int ;
		
		public static function setUp(GoogleAPIKey:String,DistriqtId:String):void
		{
			api_key = GoogleAPIKey ;
			
			trace("*******************\n\n\n\n\nYou have to add below ane files to your project : \n	com.distriqt.androidsupport.V4.ane\n" +
				"com.distriqt.Core.ane\n" +
				//"com.distriqt.GooglePlayServices.ane\n" +
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
				'\t<uses-permission android:name="air.'+DevicePrefrence.appID+'.permission.MAPS_RECEIVE" android:protectionLevel="signature"/>\n' +
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
					
					var autoriseStatus:String = NativeMaps.service.authorisationStatus();
					trace("autoriseStatus : "+autoriseStatus);
					switch (autoriseStatus)
					{
						case AuthorisationStatus.ALWAYS:
						case AuthorisationStatus.IN_USE:
							trace( "User allowed access: " + NativeMaps.service.authorisationStatus() );
							break;
						
						case AuthorisationStatus.NOT_DETERMINED:
						case AuthorisationStatus.SHOULD_EXPLAIN:
							trace("--requestAuthorisation");
							NativeMaps.service.requestAuthorisation( AuthorisationStatus.IN_USE );
							break;
						
						case AuthorisationStatus.RESTRICTED:
						case AuthorisationStatus.DENIED:
						case AuthorisationStatus.UNKNOWN:
						default:
							trace( "Request access to location services." );
							NativeMaps.service.requestAuthorisation( AuthorisationStatus.DENIED );
							break;
					}
				}
			}
			catch (e:Error)
			{
				trace("e>>>"+ e );
				isSupports = false ;
			}
		}
		
		public function DistriqtGoogleMap(Width:Number,Height:Number)
		{
			super();
			
			this.graphics.beginFill(0x222222);
			this.graphics.drawRect(0,0,Width,Height);
		}
		
		public function setMap():void
		{
			unload();
			trace("AuthorisationStatus.ALWAYS : "+AuthorisationStatus.ALWAYS);
			trace("AuthorisationStatus.DENIED : "+AuthorisationStatus.DENIED);
			trace("AuthorisationStatus.IN_USE : "+AuthorisationStatus.IN_USE);
			trace("AuthorisationStatus.NOT_DETERMINED : "+AuthorisationStatus.NOT_DETERMINED);
			trace("AuthorisationStatus.RESTRICTED : "+AuthorisationStatus.RESTRICTED);
			trace("AuthorisationStatus.SHOULD_EXPLAIN : "+AuthorisationStatus.SHOULD_EXPLAIN);
			trace("AuthorisationStatus.UNKNOWN : "+AuthorisationStatus.UNKNOWN);
			
			
			trace("MapType.MAP_TYPE_HYBRID : "+MapType.MAP_TYPE_HYBRID);
			trace("MapType.MAP_TYPE_NONE : "+MapType.MAP_TYPE_NONE);
			trace("MapType.MAP_TYPE_NORMAL : "+MapType.MAP_TYPE_NORMAL);
			trace("MapType.MAP_TYPE_SATELLITE : "+MapType.MAP_TYPE_SATELLITE);
			trace("MapType.MAP_TYPE_TERRAIN : "+MapType.MAP_TYPE_TERRAIN);
			
			if(api_key==null)
			{
				throw "You should set the DistriqtGoogleMap.setUp(..) first";
			}
			
			
			if (NativeMaps.isSupported)
			{
				if(!mapInitialized)
				{
					mapInitialized = true ;
					trace("prepareViewOrder");
					NativeMaps.service.prepareViewOrder();
					trace("prepareViewOrder done");
				}
				var rect:Rectangle;
				rect = createViewPort();
				trace("Create map");
				NativeMaps.service.createMap( rect, MapType.MAP_TYPE_NORMAL );
				trace("Create map done");
				mapCreated = true ;
				this.addEventListener(Event.ENTER_FRAME,repose);
			}

		}
		
		private function unload():void
		{
			if(mapCreated)
			{
				//NativeMaps.service.dispose();
			}
			this.removeEventListener(Event.ENTER_FRAME,repose);
		}
		
		private function createViewPort():Rectangle
		{
			var rect:Rectangle = this.getBounds(stage);
			
			if(scl==0)
			{
				
				var sclX:Number = (stage.fullScreenWidth/stage.stageWidth) ;
				var sclY:Number = (stage.fullScreenHeight/stage.stageHeight) ;
				
				deltaX = 0 ;
				deltaY = 0 ;
				if(sclX<=sclY)
				{
					scl = sclX ;
					deltaY = stage.fullScreenHeight-(stage.stageHeight)*scl ;
				}
				else
				{
					scl = sclY ;
					deltaX = stage.fullScreenWidth-(stage.stageWidth)*scl ;
				}
			}
			
			rect.x*=scl;
			rect.y*=scl;
			rect.x += deltaX/2;
			rect.y += deltaY/2;
			rect.width*=scl;
			rect.height*=scl;
			return rect;
		}
		
		protected function repose(event:Event):void
		{
			var rect:Rectangle = createViewPort();
			trace("Repose : "+rect);
			//NativeMaps.service.setLayout(rect.width,rect.height,rect.x,rect.y);
			I++;
		}
	}
}