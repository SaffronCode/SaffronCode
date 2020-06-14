package nativeClasses.playServices
{
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	
	import flash.utils.setTimeout;
	
	public class PlayServices
	{
		public static function ControllDevicePlayService():void
		{
			if(DevicePrefrence.isAndroid())
			{
				SaffronLogger.log("********* ControllDevicePlayService *******");
				var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
				if (result != ConnectionResult.SUCCESS)
				{
					SaffronLogger.log("******* User needs play service ******");
					if (GoogleApiAvailability.instance.isUserRecoverableError( result ))
					{
						setTimeout(function(){
							SaffronLogger.log("c○○○ Show dialog : "+result);
							GoogleApiAvailability.instance.attemptResolution( result )
						},5000);
					}
					else
					{
						SaffronLogger.log( "Google Play Services aren't available on this device" );
					}
				}
				else
				{
					SaffronLogger.log( "Google Play Services are Available" );
				}
			}
		}
	}
}