package nativeClasses.map
{
	import com.distriqt.extension.nativemaps.AuthorisationStatus;
	import com.distriqt.extension.nativemaps.NativeMaps;
	import com.distriqt.extension.nativemaps.events.NativeMapEvent;
	import com.distriqt.extension.nativemaps.objects.CustomMarkerIcon;
	import com.distriqt.extension.nativemaps.objects.LatLng;
	import com.distriqt.extension.nativemaps.objects.MapMarker;
	import com.distriqt.extension.nativemaps.objects.MapType;
	import com.mteamapp.StringFunctions;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import stageManager.StageManager;
	
	public class DistriqtGoogleMap extends Sprite
	{
		private static var api_key:String ;
		
		private static var isSupports:Boolean = false ;
		
		private static var mapInitialized:Boolean = false ;
		
		private static var 	scl:Number = 0,
							deltaX:Number,
							deltaY:Number;
		
		private var mapCreated:Boolean = false ;
		
		private var mapIsShowing:Boolean = false ;
		
		private var myMarkers:Vector.<MapMarker>,
					myIcons:Vector.<MapIcon>;
		
		private var mapCretedOnStage:Boolean;
		
		public static function setUp(GoogleAPIKey:String,DistriqtId:String):void
		{
			api_key = GoogleAPIKey ;
			
			var hintText:String = ("*******************\n\n\n\n\nYou have to add below ane files to your project : \n	com.distriqt.androidsupport.V4.ane\n" +
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
			if(DevicePrefrence.isItPC && descriptString.indexOf("com.google.android.providers.gsf.permission.READ_GSERVICES")==-1)
			{
				throw hintText ;
			}
			else
			{
				trace(hintText);
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
			
			if(isSupports)
			{
				setTimeout(initializeMap,0);
			}
		}
		
		private static function initializeMap():void
		{
			var autoriseStatus:String = NativeMaps.service.authorisationStatus();
			trace("*********************autoriseStatus*******************"+autoriseStatus);
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
					if(NativeMaps.service.requestAuthorisation.length>0)
					{
						NativeMaps.service.requestAuthorisation( AuthorisationStatus.IN_USE );
					}
					else
					{
						NativeMaps.service.requestAuthorisation();
					}
					break;
			}
			
			if(!mapInitialized)
			{
				mapInitialized = true ;
				trace("prepareViewOrder");
				NativeMaps.service.prepareViewOrder();
				trace("prepareViewOrder done");
			}
		}
		
		public function DistriqtGoogleMap(Width:Number,Height:Number)
		{
			super();
			unload();
			
			this.graphics.beginFill(0x222222,0);
			this.graphics.drawRect(0,0,Width,Height);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unload);
		}
		
		public function setMap(centerLat:Number=NaN,centerLon:Number=NaN,icons:Vector.<MapIcon>=null):void
		{
			//unload();
			trace("AuthorisationStatus.ALWAYS : "+AuthorisationStatus.ALWAYS);
			trace("AuthorisationStatus.DENIED : "+AuthorisationStatus.DENIED);
			trace("AuthorisationStatus.IN_USE : "+AuthorisationStatus.IN_USE);
			trace("AuthorisationStatus.NOT_DETERMINED : "+AuthorisationStatus.NOT_DETERMINED);
			trace("AuthorisationStatus.RESTRICTED : "+AuthorisationStatus.RESTRICTED);
			trace("AuthorisationStatus.SHOULD_EXPLAIN : "+AuthorisationStatus.SHOULD_EXPLAIN);
			trace("AuthorisationStatus.UNKNOWN : "+AuthorisationStatus.UNKNOWN);
			
			trace("----");
			
			trace("MapType.MAP_TYPE_HYBRID : "+MapType.MAP_TYPE_HYBRID);
			trace("MapType.MAP_TYPE_NONE : "+MapType.MAP_TYPE_NONE);
			trace("MapType.MAP_TYPE_NORMAL : "+MapType.MAP_TYPE_NORMAL);
			trace("MapType.MAP_TYPE_SATELLITE : "+MapType.MAP_TYPE_SATELLITE);
			trace("MapType.MAP_TYPE_TERRAIN : "+MapType.MAP_TYPE_TERRAIN);
			
			trace("-------");
			myMarkers = new Vector.<MapMarker>();
			myIcons = new Vector.<MapIcon>();
			if(icons!=null)
			{
				myIcons = icons ;
			}
			mapCretedOnStage = false ;
			if(api_key==null)
			{
				throw "You should set the DistriqtGoogleMap.setUp(..) first";
			}
			
			
			if (NativeMaps.isSupported)
			{
				var rect:Rectangle;
				rect = createViewPort();
				trace("Create map : "+rect);
				var center:LatLng
				if(!isNaN(centerLat) && !isNaN(centerLon))
				{
					center = new LatLng(centerLat,centerLon);
				}
				NativeMaps.service.addEventListener( NativeMapEvent.MAP_CREATED, mapCreatedHandler );
				NativeMaps.service.createMap( rect, MapType.MAP_TYPE_NORMAL,center);
				
				trace("Create map done");
				mapCreated = true ;
				mapIsShowing = true ;
				this.addEventListener(Event.ENTER_FRAME,repose);
			}

		}
		
		public function unload(e:*=null):void
		{
			if(mapCreated)
			{
				NativeMaps.service.destroyMap();
			}
			NativeMaps.service.removeEventListener( NativeMapEvent.MAP_CREATED, mapCreatedHandler );
			this.removeEventListener(Event.ENTER_FRAME,repose);
		}
		
		private function mapCreatedHandler(e:NativeMapEvent):void
		{
			mapCretedOnStage = true ;
			updateMarkers();
		}
		
		private function createViewPort():Rectangle
		{
			var rect:Rectangle = this.getBounds(stage);
			//trace("****Create view port");
			if(scl==0)
			{
				var stageRect:Rectangle = StageManager.stageRect ;
				trace("stageRect : "+stageRect);
				var sclX:Number ;
				var sclY:Number ;
				deltaX = 0 ;
				deltaY = 0 ;
				var _fullScreenWidth:Number,
					_fullScreenHeight:Number;
				if(stageRect.width==0)
				{
					trace("+++default size detection")
					sclX = (stage.fullScreenWidth/stage.stageWidth);
					sclY = (stage.fullScreenHeight/stage.stageHeight);
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
				else
				{
					trace("+++advvanced size detection");
					_fullScreenWidth = stageRect.width*StageManager.stageScaleFactor() ;
					_fullScreenHeight = stageRect.height*StageManager.stageScaleFactor() ;
					sclX = (_fullScreenWidth/stage.stageWidth);
					sclY = (_fullScreenHeight/stage.stageHeight);
					trace("sclX : "+sclX);
					trace("sclY : "+sclY);
					if(sclX<=sclY)
					{
						scl = sclX ;
						deltaY = _fullScreenHeight-(stage.stageHeight)*scl ;
					}
					else
					{
						scl = sclY ;
						deltaX = _fullScreenWidth-(stage.stageWidth)*scl ;
					}
					trace("deltaX : "+deltaX);
					trace("deltaY : "+deltaY);
					trace("scl : "+scl);
				}
			}
			
			//trace("Old rect : " +rect);
			//trace("scl : "+scl);
			//trace("deltaX : "+deltaX);
			//trace("deltaY : "+deltaY);
			
			rect.x*=scl;
			rect.y*=scl;
			rect.x += deltaX/2;
			rect.y += deltaY/2;
			rect.width*=scl;
			rect.height*=scl;
			
			rect.x = round(rect.x);
			rect.y = round(rect.y);
			rect.width = round(rect.width);
			rect.height = round(rect.height);
			
			//trace("new rect : " +rect);
			
			return rect;
		}
		
		private function round(num:Number):Number
		{
			return Math.round(num);
		}
		
		protected function repose(event:Event):void
		{
			var rect:Rectangle = createViewPort();
			//trace("Repose : "+rect);
			NativeMaps.service.setLayout(rect.width,rect.height,rect.x,rect.y);
			
			if(Obj.isAccesibleByMouse(this))
			{
				if(!mapIsShowing)
				{
					NativeMaps.service.showMap();
					mapIsShowing = true ;
				}
			}
			else
			{
				if(mapIsShowing)
				{
					NativeMaps.service.hideMap();
				}
			}
		}
		
		public function addMarker(markerName:String,lat:Number,lon:Number,markerTitle:String,markerInfo:String,color:uint=0,enableInfoWindow=true,animated:Boolean=true,showInfoButton:Boolean=true,iconId:String=''):void
		{
			trace("****************Map marker Added : ",lat,lon,markerName,'iconId : '+iconId);
			var myMarker:MapMarker = new MapMarker(markerName,new LatLng(lat,lon),markerTitle,markerInfo,color,false,enableInfoWindow,animated,showInfoButton,iconId)
			myMarkers.push(myMarker);
			if(mapCretedOnStage)
			{
				updateMarkers();
			}
		}
		
		private function updateMarkers():void
		{
			NativeMaps.service.clearMap();
			
			var i:int ;
			var isDuplicated:Boolean = false ;
			for(i = 0 ; i<myIcons.length ; i++)
			{
				for(var j = 0 ; j<NativeMaps.service.customMarkerIcons.length ; j++)
				{
					if(NativeMaps.service.customMarkerIcons[i].id == myIcons[i].Id)
					{
						isDuplicated = true ;
						break;
					}
				}
				if(!isDuplicated)
				{
					NativeMaps.service.addCustomMarkerIcon(new CustomMarkerIcon(myIcons[i].Id,myIcons[i].bitmapData,2));
				}
			}
			for(i = 0 ; i<myMarkers.length ; i++)
			{
				NativeMaps.service.addMarker(myMarkers[i]);
			}
		}
	}
}