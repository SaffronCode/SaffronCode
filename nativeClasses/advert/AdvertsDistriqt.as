package nativeClasses.advert
{
	
	import contents.alert.Alert;

	public class AdvertsDistriqt
	{
		/**com.distriqt.extension.adverts.Adverts*/
		private static var AdvertsClass:Class ;
		/**com.distriqt.extension.playservices.base.GoogleApiAvailability*/
		private static var GoogleApiAvailabilityClass:Class ;
		/**com.distriqt.extension.playservices.base.ConnectionResult*/
		private static var ConnectionResultClass:Class ;
		/**com.distriqt.extension.adverts.AdView*/
		private static var AdViewClass:Class ;
		/**com.distriqt.extension.adverts.AdSize*/
		private static var AdSizeClass:Class ;
		/**com.distriqt.extension.adverts.builders.AdRequestBuilder*/
		private static var AdRequestBuilderClass:Class ;
		/**com.distriqt.extension.adverts.events.AdViewEvent*/
		private static var AdViewEventClass:Class ;
		/**com.distriqt.extension.adverts.AdvertPlatform*/
		private static var AdvertPlatformClass:Class ;
		/**com.distriqt.extension.adverts.events.InterstitialAdEvent*/
		private static var InterstitialAdEventClass:Class ;
		/**com.distriqt.extension.adverts.InterstitialAd*/
		private static var InterstitialAdClass:Class ;
		/**com.distriqt.extension.adverts.AdViewParams*/
		private static var AdViewParamsClass:Class ;


		public static const AUTO_HEIGHT : String = "AUTO_HEIGHT",
							BANNER : String = "BANNER",
							FLUID : String = "FLUID",
							FULL_BANNER : String = "FULL_BANNER",
							FULL_WIDTH : String = "FULL_WIDTH",
							LARGE_BANNER : String = "LARGE_BANNER",
							LEADERBOARD : String = "LEADERBOARD",
							MEDIUM_RECTANGLE : String = "MEDIUM_RECTANGLE",
							SEARCH : String = "SEARCH",
							SMART_BANNER : String = "SMART_BANNER",
							WIDE_SKYSCRAPER:String = "WIDE_SKYSCRAPER";

		private static var satUp:Boolean = false ;

		private static var interstitial:* ;

		private static function init():void
		{
			if(AdvertsClass==null)
			{
				AdvertsClass = Obj.generateClass("com.distriqt.extension.adverts.Adverts");
				GoogleApiAvailabilityClass = Obj.generateClass("com.distriqt.extension.playservices.base.GoogleApiAvailability");
				ConnectionResultClass = Obj.generateClass("com.distriqt.extension.playservices.base.ConnectionResult");
				AdViewClass = Obj.generateClass("com.distriqt.extension.adverts.AdView");
				AdSizeClass = Obj.generateClass("com.distriqt.extension.adverts.AdSize");
				AdRequestBuilderClass = Obj.generateClass("com.distriqt.extension.adverts.builders.AdRequestBuilder");
				AdViewEventClass = Obj.generateClass("com.distriqt.extension.adverts.events.AdViewEvent");
				AdvertPlatformClass = Obj.generateClass("com.distriqt.extension.adverts.AdvertPlatform");
				InterstitialAdEventClass = Obj.generateClass("com.distriqt.extension.adverts.events.InterstitialAdEvent");
				InterstitialAdClass = Obj.generateClass("com.distriqt.extension.adverts.InterstitialAd");
				AdViewParamsClass = Obj.generateClass("com.distriqt.extension.adverts.AdViewParams");
			}
		}
		

		public static function isSupported():Boolean
		{
			init();
			return AdvertsClass!=null && (AdvertsClass as Object).isSupported;
		}

		public static function setUp(ANDROID_ACCOUNT_ID:String=null,IOS_ACCOUNT_ID:String=null):void
		{
			if(!isSupported())
			{
				return ;
			}
			if ((AdvertsClass as Object).isSupported) {
                var result:int = (GoogleApiAvailabilityClass as Object).instance.isGooglePlayServicesAvailable();
                if (result != (ConnectionResultClass as Object).SUCCESS) 
				{
                    if ((GoogleApiAvailabilityClass as Object).instance.isUserRecoverableError(result)) 
					{
                        (GoogleApiAvailabilityClass as Object).instance.showErrorDialog(result);
                    } else {
                        trace("Google Play Services aren't available on this device");
                    }
                } 
				else 
				{
                    trace("Google Play Services are Available");
                }

                if (DevicePrefrence.isAndroid() && ANDROID_ACCOUNT_ID!=null) 
				{
					satUp = true ;
                    (AdvertsClass as Object).service.initialisePlatform((AdvertPlatformClass as Object).PLATFORM_ADMOB, ANDROID_ACCOUNT_ID);
                } 
				else if(DevicePrefrence.isIOS() && IOS_ACCOUNT_ID!=null)
				{
					satUp = true ;
                    (AdvertsClass as Object).service.initialisePlatform((AdvertPlatformClass as Object).PLATFORM_ADMOB, IOS_ACCOUNT_ID);
                }
            }
		}



		/**
		 * Sample unitId:
		 * "ca-app-pub-3940256099942544/6300978111"
		 * @param unitId 
		 */
		public static function showAdvert(unitIdAndroid:String="ca-app-pub-3940256099942544/6300978111",
			unitIdiOS:String="ca-app-pub-3940256099942544/6300978111",
			bannerSize:String = AdvertsDistriqt.FULL_WIDTH,
			alignX:int = 0 ,alignY:int=0):void
		{
			init();
			if(!isSupported())
			{
				trace("AdMob is not supported here");
				return ;
			}
			if(satUp==false)
			{
				Alert.show("AdMob is not setUp() yet");
				return ;
			}
			var adView:* = (AdvertsClass as Object).service.createAdView();
			
			var asSize:* ;
			switch(bannerSize)
			{
				case WIDE_SKYSCRAPER:
					asSize = (AdSizeClass as Object).WIDE_SKYSCRAPER;
					break;
				case SMART_BANNER:
					asSize = (AdSizeClass as Object).SMART_BANNER;
					break;
				case SEARCH:
					asSize = (AdSizeClass as Object).SEARCH;
					break;
				case MEDIUM_RECTANGLE:
					asSize = (AdSizeClass as Object).MEDIUM_RECTANGLE;
					break;
				case LEADERBOARD:
					asSize = (AdSizeClass as Object).LEADERBOARD;
					break;
				case LARGE_BANNER:
					asSize = (AdSizeClass as Object).LARGE_BANNER;
					break;
				case FULL_WIDTH:
					asSize = (AdSizeClass as Object).FULL_WIDTH;
					break;
				case FULL_BANNER:
					asSize = (AdSizeClass as Object).FULL_BANNER;
					break;
				case AUTO_HEIGHT:
					asSize = (AdSizeClass as Object).AUTO_HEIGHT;
					break;
				case BANNER:
					asSize = (AdSizeClass as Object).BANNER;
					break;
				case FLUID:
					asSize = (AdSizeClass as Object).FLUID;
					break;
			}

			adView.setAdSize( (AdSizeClass as Object).FULL_BANNER );
			if(DevicePrefrence.isAndroid())
				adView.setAdUnitId( unitIdAndroid );
			else
				adView.setAdUnitId( unitIdiOS );
				
			adView.addEventListener( (AdViewEventClass as Class).LOADED, loadedHandler );
			adView.addEventListener( (AdViewEventClass as Class).ERROR, errorHandler );
			

			//position
			var params:* = new AdViewParamsClass();
			switch(alignX)
			{
				case -1:
					params.horizontalAlign = (AdViewParamsClass as Object).ALIGN_LEFT;
					break;
				case 1:
					params.horizontalAlign = (AdViewParamsClass as Object).ALIGN_RIGHT;
					break;
				default:
					params.horizontalAlign = (AdViewParamsClass as Object).ALIGN_CENTER;
					break;
			}
			switch(alignY)
			{
				case -1:
					params.verticalAlign = (AdViewParamsClass as Object).ALIGN_TOP;
					break;
				case 1:
					params.verticalAlign = (AdViewParamsClass as Object).ALIGN_BOTTOM;
					break;
				default:
					params.verticalAlign = (AdViewParamsClass as Object).ALIGN_CENTER;
					break;
			}

			adView.setViewParams( params );

			function loadedHandler( event:* ):void
			{
				// Ad loaded and ready to be displayed
				adView.show();
			}

			function errorHandler( event:* ):void
			{
				// Load error occurred. The errorCode will contain more information
				trace( "Error" + event.errorCode );
			}
			adView.load( (new AdRequestBuilderClass() as Object).build() );
		}



		private static var showInterstitialIfReady:Boolean=true,
							anInterstitialBannerWaitingToShow:Boolean=false;

		/**
		 * Sample UnitId : 
		 * "ca-app-pub-3940256099942544/1033173712"
		 * @param unitId 
		 */
		public static function fullScreenBanner(unitIdAndroid:String,unitIdiOS:String,showWhenLoaded:Boolean=true):void
		{
			init();
			if(!isSupported())
			{
				trace("AdMob is not supported here");
				return ;
			}
			if(satUp==false)
			{
				Alert.show("AdMob is not setUp() yet");
				return ;
			}
			showInterstitialIfReady = showWhenLoaded ;
			if ((AdvertsClass as Object).service.interstitials.isSupported)
			{
				if(interstitial==null)
				{
					interstitial = (AdvertsClass as Object).service.interstitials.createInterstitialAd();
					interstitial.setAdUnitId( DevicePrefrence.isAndroid()?unitIdAndroid:unitIdiOS );

					interstitial.addEventListener( (InterstitialAdEventClass as Object).LOADED, loadedHandler );
					interstitial.addEventListener( (InterstitialAdEventClass as Object).ERROR, errorHandler );
				}

				if(showInterstitialIfReady && anInterstitialBannerWaitingToShow)
				{
					loadedHandler(null);
				}
				else
				{
					anInterstitialBannerWaitingToShow = false ;
					interstitial.load( (new AdRequestBuilderClass() as Object).build() );
				}

			}
			else
			{
				trace("interstitials is not supported");
			}
		}
		
				private static function loadedHandler( event:* ):void
				{
					// interstitial loaded and ready to be displayed
					if(showInterstitialIfReady)
					{
						interstitial.show();
						anInterstitialBannerWaitingToShow = false ;
					}
					else
						anInterstitialBannerWaitingToShow = true ;
				}

				private static function errorHandler( event:* ):void
				{
					// Load error occurred. The errorCode will contain more information
					anInterstitialBannerWaitingToShow = false ;
					trace( "Error" + event.errorCode );
				}
	}
}