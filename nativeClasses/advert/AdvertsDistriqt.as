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
		public static function isSupported():Boolean
		{
			return Adverts.isSupported;
		}

		public static function controlGooglePlayService():void
		{
			var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
			if (result != ConnectionResult.SUCCESS)
			{
				if (GoogleApiAvailability.instance.isUserRecoverableError( result ))
				{
					GoogleApiAvailability.instance.showErrorDialog( result );
				}
				else
				{
					Alert.show( "Google Play Services aren't available on this device" );
				}
			}
			else
			{
				Alert.show( "Google Play Services are Available" );
			}
		}

		public static function sayHelo():void
		{
			Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, "ca-app-pub-7960976491848372~7008260662" );
			Alert.show("initialisePlatform");
		}

		public static function showAdvert():void
		{
			Alert.show("Show adverts now");
			Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, "ca-app-pub-7960976491848372~7008260662" );
			//Adverts.service.getAdvertisingId();


			//interstitial = Adverts.service.interstitials.createInterstitialAd();
			//interstitial.setAdUnitId( "ca-app-pub-3940256099942544/1033173712" );

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
			adView.setAdUnitId( "ca-app-pub-3940256099942544/6300978111" );
			adView.addEventListener( AdViewEvent.LOADED, loadedHandler );
			adView.addEventListener( AdViewEvent.ERROR, errorHandler );
			adView.load( new AdRequestBuilder().build() );


			function loadedHandler( event:AdViewEvent ):void
			{
				// Ad loaded and ready to be displayed
				Alert.show("Adverts is ready")
				adView.show();
			}

			function errorHandler( event:AdViewEvent ):void
			{
				// Load error occurred. The errorCode will contain more information
				Alert.show( "Error" + event.errorCode );
			}
			adView.load( new AdRequestBuilder().build() );
		}


		public static function fullScreenBanner():void
		{
			if (Adverts.service.interstitials.isSupported)
			{
				Alert.show("Show full banner now");
				var interstitial:InterstitialAd = Adverts.service.interstitials.createInterstitialAd();
				interstitial.setAdUnitId( "ca-app-pub-3940256099942544/1033173712" );

				Alert.show("setAdUnitId");
				interstitial.addEventListener( InterstitialAdEvent.LOADED, loadedHandler );
				interstitial.addEventListener( InterstitialAdEvent.ERROR, errorHandler );

				function loadedHandler( event:InterstitialAdEvent ):void
				{
					// interstitial loaded and ready to be displayed
					interstitial.show();
				}

				function errorHandler( event:InterstitialAdEvent ):void
				{
					// Load error occurred. The errorCode will contain more information
					Alert.show( "Error" + event.errorCode );
				}

				interstitial.load( new AdRequestBuilder().build() );
			}
			else
			{
				Alert.show("No supported");
			}
		}
	}
}