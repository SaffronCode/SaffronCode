package nativeClasses.advert
{
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.adverts.AdView;
	import com.distriqt.extension.adverts.AdSize;
	import com.distriqt.extension.adverts.builders.AdRequestBuilder;
	import com.distriqt.extension.adverts.events.AdViewEvent;
	import contents.alert.Alert;
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.events.InterstitialAdEvent;
	import com.distriqt.extension.adverts.InterstitialAd;

	public class AdvertsDistriqt
	{
		private static var satUp:Boolean = false ;

		private static var interstitial:InterstitialAd ;

		public static function isSupported():Boolean
		{
			return Adverts.isSupported;
		}

		public static function setUp(ANDROID_ACCOUNT_ID:String=null,IOS_ACCOUNT_ID:String=null):void
		{
			if (Adverts.isSupported) {
                var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
                if (result != ConnectionResult.SUCCESS) 
				{
                    if (GoogleApiAvailability.instance.isUserRecoverableError(result)) 
					{
                        GoogleApiAvailability.instance.showErrorDialog(result);
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
                    Adverts.service.initialisePlatform(AdvertPlatform.PLATFORM_ADMOB, ANDROID_ACCOUNT_ID);
                } 
				else if(DevicePrefrence.isIOS() && IOS_ACCOUNT_ID!=null)
				{
					satUp = true ;
                    Adverts.service.initialisePlatform(AdvertPlatform.PLATFORM_ADMOB, IOS_ACCOUNT_ID);
                }
            }
		}



		/**
		 * Sample unitId:
		 * "ca-app-pub-3940256099942544/6300978111"
		 * @param unitId 
		 */
		public static function showAdvert(unitId:String):void
		{
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
			var adView:AdView = Adverts.service.createAdView();
			/**AUTO_HEIGHT : int = -2
			BANNER : AdSize
			FLUID : AdSize
			FULL_BANNER : AdSize
			FULL_WIDTH : int = -1
			LARGE_BANNER : AdSize
			LEADERBOARD : AdSize
			MEDIUM_RECTANGLE : AdSize
			SEARCH : AdSize
			SMART_BANNER : AdSize
			WIDE_SKYSCRAPER */

			adView.setAdSize( AdSize.FULL_BANNER );
			adView.setAdUnitId( unitId );
			adView.addEventListener( AdViewEvent.LOADED, loadedHandler );
			adView.addEventListener( AdViewEvent.ERROR, errorHandler );
			adView.load( new AdRequestBuilder().build() );


			function loadedHandler( event:AdViewEvent ):void
			{
				// Ad loaded and ready to be displayed
				adView.show();
			}

			function errorHandler( event:AdViewEvent ):void
			{
				// Load error occurred. The errorCode will contain more information
				trace( "Error" + event.errorCode );
			}
			adView.load( new AdRequestBuilder().build() );
		}



		private static var showInterstitialIfReady:Boolean=true,
							anInterstitialBannerWaitingToShow:Boolean=false;

		/**
		 * Sample UnitId : 
		 * "ca-app-pub-3940256099942544/1033173712"
		 * @param unitId 
		 */
		public static function fullScreenBanner(unitId:String,showWhenLoaded:Boolean=true):void
		{
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
			if (Adverts.service.interstitials.isSupported)
			{
				if(interstitial==null)
				{
					interstitial = Adverts.service.interstitials.createInterstitialAd();
					interstitial.setAdUnitId( unitId );

					interstitial.addEventListener( InterstitialAdEvent.LOADED, loadedHandler );
					interstitial.addEventListener( InterstitialAdEvent.ERROR, errorHandler );
				}

				if(showInterstitialIfReady && anInterstitialBannerWaitingToShow)
				{
					loadedHandler(null);
				}
				else
				{
					anInterstitialBannerWaitingToShow = false ;
					interstitial.load( new AdRequestBuilder().build() );
				}

			}
			else
			{
				trace("interstitials is not supported");
			}
		}
		
				private static function loadedHandler( event:InterstitialAdEvent ):void
				{
					// interstitial loaded and ready to be displayed
					if(showInterstitialIfReady)
						interstitial.show();
					else
						anInterstitialBannerWaitingToShow = true ;
				}

				private static function errorHandler( event:InterstitialAdEvent ):void
				{
					// Load error occurred. The errorCode will contain more information
					anInterstitialBannerWaitingToShow = false ;
					trace( "Error" + event.errorCode );
				}
	}
}