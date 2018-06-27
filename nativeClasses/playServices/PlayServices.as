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
				trace("********* ControllDevicePlayService *******");
				var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
				if (result != ConnectionResult.SUCCESS)
				{
					trace("******* User needs play service ******");
					if (GoogleApiAvailability.instance.isUserRecoverableError( result ))
					{
						setTimeout(function(){
							trace("c○○○ Show dialog : "+result);
							GoogleApiAvailability.instance.attemptResolution( result )
						},5000);
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
		}
	}
}