package nativeClasses.map
{
	//import com.distriqt.extension.nativemaps.AuthorisationStatus;
	//import com.distriqt.extension.nativemaps.NativeMaps;
	//import com.distriqt.extension.nativemaps.events.NativeMapEvent;
	//import com.distriqt.extension.nativemaps.objects.CustomMarkerIcon;
	//import com.distriqt.extension.nativemaps.objects.LatLng;
	//import com.distriqt.extension.nativemaps.objects.MapMarker;
	//import com.distriqt.extension.nativemaps.objects.MapType;

	import com.mteamapp.StringFunctions;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import stageManager.StageManager;
	import flash.display.StageScaleMode;
	import contents.alert.Alert;
	import com.distriqt.extension.nativemaps.NativeMaps;
	import com.distriqt.extension.nativemaps.objects.MapStyleOptions;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import com.distriqt.extension.nativemaps.events.NativeMapBitmapEvent;
	import com.distriqt.extension.nativemaps.events.NativeMapEvent;
	import com.distriqt.extension.nativemaps.objects.MapMarker;
	import com.distriqt.extension.nativemaps.objects.LatLng;
	import com.distriqt.extension.nativemaps.objects.CustomMarkerIcon;
	import flash.utils.getTimer;
	import flash.geom.Point;
	
	public class DistriqtGoogleMap extends Sprite
	{
		/**com.distriqt.extension.nativemaps.AuthorisationStatus*/
		private static var AuthorisationStatusClass:Class ;
		/**com.distriqt.extension.nativemaps.NativeMaps*/
		private static var NativeMapsClass:Class ;
		/**com.distriqt.extension.nativemaps.events.NativeMapEvent*/
		private static var NativeMapEventClass:Class ;
		/**com.distriqt.extension.nativemaps.objects.CustomMarkerIcon*/
		private static var CustomMarkerIconClass:Class ;
		/**com.distriqt.extension.nativemaps.objects.LatLng*/
		private static var LatLngClass:Class ;
		/**com.distriqt.extension.nativemaps.objects.MapMarker*/
		private static var MapMarkerClass:Class ;
		/**import com.distriqt.extension.nativemaps.objects.MapStyleOptions*/
		private static var MapStyleOptionsClass:Class;
		/**com.distriqt.extension.nativemaps.objects.MapType*/
		private static var MapTypeClass:Class ;
		
		private static var isSupports:Boolean = false ;
		
		private static var mapInitialized:Boolean = false ;

		public static var debuggingExtraDeltaH:Number = -5 ;

		private var map_style:String,
					user_location:Boolean ;

		private var forceToHideMap:Boolean = false ;
		
		private static var 	scl:Number = 0,
							statusBarSize:Number=0,

							deltaX:Number,
							deltaY:Number;
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		private var mapCreated:Boolean = false ;
		
		private var mapIsShowing:Boolean = false ;
		
		/**myMarkers is an array of MapMarker*/
		private var myMarkers:Vector.<Object>,
					myIcons:Vector.<MapIcon>;
		
		private var mapCretedOnStage:Boolean;

		private var center:Object;
		
		private var firstZoomLevel:Number = -1 ;

		private var catchedBitmapData:BitmapData,
					catchedBitmap:Bitmap ;

		private static var counter:uint ;
		
		public static function setUp(GoogleAPIKey:String=null,DistriqtId:String=null):void
		{
			//SaffronLogger.log('*********GoogleAPIKey*******'+GoogleAPIKey);
			
			try
			{
				AuthorisationStatusClass = getDefinitionByName("com.distriqt.extension.nativemaps.AuthorisationStatus") as Class ;
				NativeMapsClass = NativeMaps;//getDefinitionByName("com.distriqt.extension.nativemaps.NativeMaps") as Class ;
				NativeMapEventClass = getDefinitionByName("com.distriqt.extension.nativemaps.events.NativeMapEvent") as Class ;
				CustomMarkerIconClass = getDefinitionByName("com.distriqt.extension.nativemaps.objects.CustomMarkerIcon") as Class ;
				LatLngClass = getDefinitionByName("com.distriqt.extension.nativemaps.objects.LatLng") as Class ;
				MapMarkerClass = getDefinitionByName("com.distriqt.extension.nativemaps.objects.MapMarker") as Class ;
				MapStyleOptionsClass = getDefinitionByName("com.distriqt.extension.nativemaps.objects.MapStyleOptions") as Class;
				MapTypeClass = getDefinitionByName("com.distriqt.extension.nativemaps.objects.MapType") as Class ;
				
				
				if ((NativeMapsClass as Object).isSupported)
				{
					isSupports = true ;
				}
			}
			catch (e:Error)
			{
				SaffronLogger.log("e>>>"+ e );
				isSupports = false ;
			}
			
			if(isSupports)
			{
				setTimeout(initializeMap,0);
			}
		}
		
		private static function initializeMap():void
		{
			var autoriseStatus:String = (NativeMapsClass as Object).service.authorisationStatus();
			SaffronLogger.log("*********************autoriseStatus*******************"+autoriseStatus);
			switch (autoriseStatus)
			{
				case (AuthorisationStatusClass as Object).ALWAYS:
				case (AuthorisationStatusClass as Object).IN_USE:
					SaffronLogger.log( "User allowed access: " + (NativeMapsClass as Object).service.authorisationStatus() );
					break;
				
				case (AuthorisationStatusClass as Object).NOT_DETERMINED:
				case (AuthorisationStatusClass as Object).SHOULD_EXPLAIN:
					SaffronLogger.log("--requestAuthorisation");
					(NativeMapsClass as Object).service.requestAuthorisation( (AuthorisationStatusClass as Object).IN_USE );
					break;
				
				case (AuthorisationStatusClass as Object).RESTRICTED:
				case (AuthorisationStatusClass as Object).DENIED:
				case (AuthorisationStatusClass as Object).UNKNOWN:
				default:
					SaffronLogger.log( "Request access to location services." );
					if((NativeMapsClass as Object).service.requestAuthorisation.length>0)
					{
						(NativeMapsClass as Object).service.requestAuthorisation( (AuthorisationStatusClass as Object).IN_USE );
					}
					else
					{
						(NativeMapsClass as Object).service.requestAuthorisation();
					}
					break;
			}
			
			if(!mapInitialized)
			{
				mapInitialized = true ;
				SaffronLogger.log("prepareViewOrder");
				(NativeMapsClass as Object).service.prepareViewOrder();
				SaffronLogger.log("prepareViewOrder done");
			}
		}
		
		/**Some times you have to create this class after a delay, We didn't found why till now...*/
		public function DistriqtGoogleMap(Width:Number,Height:Number)
		{
			counter++;
			super();
			dispatcher.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			unload();

			catchedBitmap = new Bitmap();
			this.addChild(catchedBitmap);
			
			this.graphics.beginFill(0x222222,0);
			this.graphics.drawRect(0,0,Width,Height);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unload);
			dispatcher.addEventListener(Event.REMOVED_FROM_STAGE,removeMeBecauseSomeOneElseComes);
		}
		
		protected function removeMeBecauseSomeOneElseComes(event:Event):void
		{
			Obj.remove(this);
		}

		public function userCanSelecAPoint():void
		{
			
		}
		
		public function setMap(centerLat:Number=NaN,centerLon:Number=NaN,icons:Vector.<MapIcon>=null,zoomLevel:Number=-1,mapStyleJSON:String=null,showUserLocation:Boolean=false):void
		{
			map_style = mapStyleJSON ;
			user_location = showUserLocation ;
			//unload();
			SaffronLogger.log("AuthorisationStatus.ALWAYS : "+(AuthorisationStatusClass as Object).ALWAYS);
			SaffronLogger.log("AuthorisationStatus.DENIED : "+(AuthorisationStatusClass as Object).DENIED);
			SaffronLogger.log("AuthorisationStatus.IN_USE : "+(AuthorisationStatusClass as Object).IN_USE);
			SaffronLogger.log("AuthorisationStatus.NOT_DETERMINED : "+(AuthorisationStatusClass as Object).NOT_DETERMINED);
			SaffronLogger.log("AuthorisationStatus.RESTRICTED : "+(AuthorisationStatusClass as Object).RESTRICTED);
			SaffronLogger.log("AuthorisationStatus.SHOULD_EXPLAIN : "+(AuthorisationStatusClass as Object).SHOULD_EXPLAIN);
			SaffronLogger.log("AuthorisationStatus.UNKNOWN : "+(AuthorisationStatusClass as Object).UNKNOWN);
			
			SaffronLogger.log("----");
			
			SaffronLogger.log("MapType.MAP_TYPE_HYBRID : "+(MapTypeClass as Object).MAP_TYPE_HYBRID);
			SaffronLogger.log("MapType.MAP_TYPE_NONE : "+MapTypeClass.MAP_TYPE_NONE);
			SaffronLogger.log("MapType.MAP_TYPE_NORMAL : "+(MapTypeClass as Object).MAP_TYPE_NORMAL);
			SaffronLogger.log("MapType.MAP_TYPE_SATELLITE : "+(MapTypeClass as Object).MAP_TYPE_SATELLITE);
			SaffronLogger.log("MapType.MAP_TYPE_TERRAIN : "+(MapTypeClass as Object).MAP_TYPE_TERRAIN);
			
			SaffronLogger.log("-------");
			myMarkers = new Vector.<Object>();
			myIcons = new Vector.<MapIcon>();
			if(icons!=null)
			{
				myIcons = icons ;
			}
			mapCretedOnStage = false ;
			
			
			if ((NativeMapsClass as Object).isSupported)
			{
				var rect:Rectangle;
				rect = createViewPort();
				SaffronLogger.log("Create map : "+rect);
				
				if(!isNaN(centerLat) && !isNaN(centerLon))
				{
					center = new LatLngClass(centerLat,centerLon);
				}
				firstZoomLevel = zoomLevel ;
				SaffronLogger.log("...listenning...");
				(NativeMapsClass as Object).service.addEventListener( (NativeMapEventClass as Object).MAP_CREATED, mapCreatedHandler );
				(NativeMapsClass as Object).service.addEventListener( NativeMapBitmapEvent.READY , updateCapturedBitmap);
				SaffronLogger.log("---Creating...");
				NativeMaps.service.createMap( rect, (MapTypeClass as Object).MAP_TYPE_NORMAL);
				
				SaffronLogger.log("Create map done");
				mapCreated = true ;
				mapIsShowing = true ;
			}
			this.addEventListener(Event.ENTER_FRAME,repose,false,10000);
		}

		private var centerMarker:MapMarker,
					centerMarkerPosition:LatLng,
					centerMarkerIcon:CustomMarkerIcon ;

		public function setAPinOnCenter(iconBitmap:BitmapData,centerName:String):void
		{
			const iconName:String = centerName;

			centerMarkerIcon = new CustomMarkerIcon( iconName )
					.setImage( iconBitmap )
    				.setCenterOffset( iconBitmap.width/-2, -iconBitmap.height );

			centerMarkerPosition = NativeMaps.service.getCentre();

			centerMarker = new MapMarker(centerName,centerMarkerPosition,centerName,'',0,false,false,true,false,iconName);
		}

		private function updateCenterMarker():void
		{
			if(centerMarker==null || centerMarkerIcon==null)
			{
				return ;
			}

			NativeMaps.service.addCustomMarkerIcon(centerMarkerIcon);
			NativeMaps.service.addMarker( centerMarker );
		}

		private function updateCapturedBitmap(e:NativeMapBitmapEvent):void
		{
			var mapToBitmapData:BitmapData = e.bitmapData ;
			catchedBitmap.bitmapData = e.bitmapData;
		}
		
		public function unload(e:*=null):void
		{
			if(mapCreated)
			{
				(NativeMapsClass as Object).service.destroyMap();
				(NativeMapsClass as Object).service.removeEventListener( (NativeMapEventClass as Object).MAP_CREATED, mapCreatedHandler );
				SaffronLogger.log('map*************'+NativeMapsClass);
				SaffronLogger.log('event***********'+NativeMapEventClass)
			}
			dispatcher.removeEventListener(Event.REMOVED_FROM_STAGE,removeMeBecauseSomeOneElseComes);
			
			this.removeEventListener(Event.ENTER_FRAME,repose);
			NativeMaps.service.dispose();
		}
		
		private function mapCreatedHandler(e:*):void
		{
			mapCretedOnStage = true ;
			if(center!=null)
				setCenter(center.lat,center.lon,firstZoomLevel);
			else
				setCenter(0,0,firstZoomLevel);

				
			setMapStyle();

			NativeMaps.service.showUserLocation(user_location);

			updateMarkers();
			updateCenterMarker();
		}

		private function setMapStyle():void
		{
			if(map_style!=null)
			{
				/*forceToHideMap = true ;
				repose(null);
				(NativeMapsClass as Object).service.addEventListener( (NativeMapEvent).MAP_RENDER_COMPLETE, showMapAgain );*/
				var styleOption:MapStyleOptions = new MapStyleOptions(map_style);
				NativeMaps.service.setMapStyle(styleOption);
			}
		}

			private function showMapAgain(e:*):void
			{
				(NativeMapsClass as Object).service.removeEventListener( (NativeMapEvent).MAP_RENDER_COMPLETE, showMapAgain );
				forceToHideMap = false ;
			}
		
		
		public function setCenter(lat:Number,lon:Number,zoomLevel:Number=-1,animationDuration:uint=2000):void
		{
			SaffronLogger.log("******* first center is : "+lat,lon,zoomLevel);
			center = new LatLngClass(lat,lon);
			firstZoomLevel = zoomLevel ;
			(NativeMapsClass as Object).service.setCentre(center,zoomLevel,animationDuration!=0,animationDuration)
		}
		
		private function createViewPort():Rectangle
		{
			catchedBitmap.width = 1 ;
			catchedBitmap.height = 1 ;
			var rect:Rectangle = this.getBounds(stage);
			//SaffronLogger.log("****Create view port");
			if(scl==0)
			{
				var stageRect:Rectangle = StageManager.stageRect ;
				SaffronLogger.log("stageRect : "+stageRect);
				var sclX:Number ;
				var sclY:Number ;
				deltaX = 0 ;
				deltaY = 0 ;
				

					SaffronLogger.log("+++default size detection")
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
				stage.scaleMode = StageScaleMode.NO_SCALE;
				var stageHeightUnderStatusBar:Number = stage.stageHeight ;
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				statusBarSize = (stage.fullScreenHeight-stageHeightUnderStatusBar);
				//Alert.show("statusBarSize:"+statusBarSize+", scl:"+scl);
				statusBarSize = Math.ceil(statusBarSize/scl);
				//Alert.show("statusBarSize2:"+statusBarSize);
				statusBarSize+=debuggingExtraDeltaH;
			}

			catchedBitmap.scaleX = catchedBitmap.scaleY = 1/scl ;
			
			//SaffronLogger.log("Old rect : " +rect);
			//SaffronLogger.log("scl : "+scl);
			SaffronLogger.log("deltaX : "+deltaX);
			SaffronLogger.log("deltaY : "+deltaY);
			
			rect.x*=scl;
			rect.y*=scl;
			rect.x += deltaX/2;
			rect.y += deltaY/2;
			rect.width*=scl;
			rect.height*=scl;
			
			rect.x = round(rect.x);
			rect.y = round(rect.y)-statusBarSize;
			rect.width = round(rect.width);
			rect.height = round(rect.height);
			
			//SaffronLogger.log("new rect : " +rect);
			
			if(rect.x<0)
			{
				if(-rect.x<rect.width)
				{
					rect.width += rect.x ;
					rect.x = 0 ;
				}
				else
				{
					rect = null ;
				}
			}
			
			if(rect!=null && rect.y<0)
			{
				if(-rect.y<rect.height)
				{
					rect.height += rect.y ;
					rect.y = 0 ;
				}
				else
				{
					rect = null ;
				}
			}
			
			return rect;
		}
		
		private function round(num:Number):Number
		{
			return Math.round(num);
		}
		
		protected function repose(event:Event):void
		{
			var rect:Rectangle = createViewPort();
			//SaffronLogger.log("Repose : "+rect);
			if(rect)
				(NativeMapsClass as Object).service.setLayout(rect.width,rect.height,rect.x,rect.y);
			
			//SaffronLogger.log("map place is : "+rect);
			
			if(forceToHideMap ==false && rect!=null && Obj.isAccesibleByMouse(this))
			{
				//SaffronLogger.log("Show map!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				if(!mapIsShowing)
				{
					//SaffronLogger.log("!!!!!!!!!!!!!!!!!show!!!!!!!!!!!!");
					(NativeMapsClass as Object).service.showMap();
					mapIsShowing = true ;
					//catchedBitmap.visible = false ;
				}
			}
			else
			{
				//SaffronLogger.log("Hide the map!!!");
				if(mapIsShowing)
				{
					//SaffronLogger.log("!!!!!!!!!!!!!!!hide!!!!!!!!!!!!!!!");
					(NativeMapsClass as Object).service.hideMap();
					NativeMaps.service.requestMapBitmapData();
					mapIsShowing = false ;
					catchedBitmap.visible = true ;
				}
			}

			if(centerMarker!=null)
			{
				var cent:LatLng = NativeMaps.service.getCentre() ;
				if(centerMarkerPosition==null)
				{
					centerMarkerPosition = cent ;
				}
				centerMarkerPosition.lat = centerMarkerPosition.lat+(cent.lat-centerMarkerPosition.lat)/2;
				centerMarkerPosition.lon = centerMarkerPosition.lon+(cent.lon-centerMarkerPosition.lon)/2;
				centerMarker.setPosition(centerMarkerPosition);
				NativeMaps.service.updateMarker(centerMarker);
			}
		}

		public function centerPosition():Point
		{
			var cent:LatLng = NativeMaps.service.getCentre() ;
			if(cent!=null)
				return new Point(cent.lat,cent.lon);
			return new Point(0,0);
		}
		
		public function addMarker(markerName:String,lat:Number,lon:Number,markerTitle:String,markerInfo:String,color:uint=0,enableInfoWindow:Boolean=true,animated:Boolean=true,showInfoButton:Boolean=true,iconId:String=''):void
		{
			SaffronLogger.log("****************Map marker Added : ",lat,lon,markerName,'iconId : '+iconId);
			var myMarker:Object = new MapMarkerClass(markerName,new LatLngClass(lat,lon),markerTitle,markerInfo,color,false,enableInfoWindow,animated,showInfoButton,iconId)
			myMarkers.push(myMarker);
			if(mapCretedOnStage)
			{
				updateMarkers();
			}
		}
		
		public function style(style:String):void
		{
			var mapStyle:Object = new MapStyleOptionsClass(style);
			
		}
		
		private function updateMarkers():void
		{
			(NativeMapsClass as Object).service.clearMap();
			
			var i:int ;
			var isDuplicated:Boolean = false ;
			for(i = 0 ; i<myIcons.length ; i++)
			{
				for(var j = 0 ; j<(NativeMapsClass as Object).service.customMarkerIcons.length ; j++)
				{
					if((NativeMapsClass as Object).service.customMarkerIcons[j].id == myIcons[i].Id)
					{
						isDuplicated = true ;
						break;
					}
				}
				if(!isDuplicated)
				{
					(NativeMapsClass as Object).service.addCustomMarkerIcon(new CustomMarkerIconClass(myIcons[i].Id,myIcons[i].bitmapData,2));
				}
			}
			for(i = 0 ; i<myMarkers.length ; i++)
			{
				(NativeMapsClass as Object).service.addMarker(myMarkers[i]);
			}
		}
	}
}