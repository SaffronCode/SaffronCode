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

	public class AdvertsDistriqt
	{
		public static function isSupported():Boolean
		{
			return Adverts.isSupported;
		}

		private static function controlGooglePlayService():void
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
					trace( "Google Play Services aren't available on this device" );
				}
			}
			else
			{
				trace( "Google Play Services are Available" );
			}
		}

		public static function showAdvert():void
		{
			Alert.show("Show adverts now");
			Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, "ca-app-pub-7960976491848372~7008260662" );
			//Adverts.service.getAdvertisingId();


//interstitial = Adverts.service.interstitials.createInterstitialAd();
//interstitial.setAdUnitId( "ca-app-pub-3940256099942544/1033173712" );

			var adView:AdView = Adverts.service.createAdView();
			adView.setAdSize( AdSize.SMART_BANNER );
			adView.setAdUnitId( "ca-app-pub-7960976491848372/4730130424" );
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
				Alert.show( "Error" + event. );
			}
			adView.load( new AdRequestBuilder().build() );
		}
		
	}
}